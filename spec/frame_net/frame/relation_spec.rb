#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'frame_net/frame/relation'


describe FrameNet::Frame::Relation do

	let( :frame_name ) { :Transition_to_a_situation }
	let( :frame_doc ) { FrameNet.load_document("frame/#{frame_name}.xml") }


	it "can be created from a frame XML document" do
		results = described_class.from_frame_data( frame_doc )

		expect( results ).to be_an( Array ).and( all be_a(described_class) )
		expect( results.length ).to eq( frame_doc.find('/fn:frame/fn:frameRelation').length )
	end


	it "can look up its frames" do
		relations = described_class.from_frame_data( frame_doc )
		inherits_from = relations.find {|rel| rel.type == 'Inherits from' }
		expect( inherits_from.frames ).to eq([ FrameNet[:Transition_to_state] ])
	end

end

