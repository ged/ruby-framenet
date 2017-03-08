#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'frame_net/frame/element'


describe FrameNet::Frame::Element do

	let( :frame_name ) { :Storing }
	let( :frame_doc ) { FrameNet.load_document("frame/#{frame_name}.xml") }


	it "can be created from a frame XML document" do
		result = described_class.from_frame_data( frame_doc )

		expect( result ).to be_an( Array ).and( all be_a(described_class) )
		expect( result.length ).to eq( frame_doc.find('/fn:frame/fn:FE').length )
	end

end

