#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'frame_net/frame/lexical_unit'


describe FrameNet::Frame::LexicalUnit do


	it "can be loaded by ID" do
		result = described_class.load( 21 )
		expect( result ).to be_a( described_class )
		expect( result.id ).to eq( 21 )
		expect( result.name ).to eq( "counterfeit.v" )
	end


	it "can be loaded by name" do
		result = described_class.load_by_name( "legacy.n" )
		expect( result ).to be_an( Array )
		expect( result.length ).to eq( 1 )
		expect( result[0] ).to be_a( described_class )
		expect( result[0].id ).to eq( 18706 )
		expect( result[0].name ).to eq( "legacy.n" )
	end


	it "can be extracted from frame data" do
		frame = FrameNet[ :Coming_to_be ]
		result = described_class.from_frame_data( frame.document )

		expect( result ).to be_a( Array )
		expect( result ).to all( be_a(described_class) )
		expect( result.map(&:frame_name) ).to all( eq(:Coming_to_be) )
	end

end

