#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'frame_net/frame'


describe FrameNet::Frame do

	it "can be constructed with an initialization block" do
		result = described_class.new do |instance|
			instance.id = 32768
			instance.name = :Apotheosis
		end

		expect( result.id ).to eq( 32768 )
		expect( result.name ).to eq( :Apotheosis )
		expect( result.creation_time ).to be_within( 5 ).of( Time.now )
	end


	it "can be loaded by name with a Symbol" do
		result = described_class.load_by_name( :Fear )
		expect( result ).to be_a( described_class )
		expect( result.name ).to eq( :Fear )
	end


	it "can be loaded by name with a String" do
		result = described_class.load( "fear" )
		expect( result ).to be_a( described_class )
		expect( result.name ).to eq( :Fear )
	end


	it "can be loaded from an integer ID" do
		result = described_class.load_by_id( 218 )
		expect( result ).to be_a( described_class )
		expect( result.id ).to eq( 218 )
	end

end

