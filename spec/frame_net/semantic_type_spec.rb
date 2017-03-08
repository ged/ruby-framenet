#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'frame_net/semantic_type'


describe FrameNet::SemanticType do

	let( :frame_doc ) { FrameNet.load_document('frame/Store.xml') }
	let( :node ) { frame_doc.find_first('//fn:semType') }


	it "can be constructed from a semType node" do
		result = described_class.from_node( node )
		expect( result ).to be_a( described_class )
		expect( result.id ).to eq( node['ID'].to_i )
		expect( result.name ).to eq( node['name'].to_sym )
	end


	it "can be constructed with an ID and a name" do
		result = described_class.new( 153, "Goal" )
		expect( result ).to be_a( described_class )
		expect( result.id ).to eq( 153 )
		expect( result.name ).to eq( :Goal )
	end

end

