#!/usr/bin/env rspec -cfd
#encoding: utf-8

require_relative './spec_helper'

require 'rspec'
require 'frame_net'


describe FrameNet do

	it "can return the frame index as an XML document object" do
		result = described_class.frame_index

		expect( result ).to be_a( LibXML::XML::Document )
		expect( result.root.name ).to eq( 'frameIndex' )
	end


	it "memoizes the frame index document" do
		expect( described_class.frame_index ).to equal( described_class.frame_index )
	end


	it "can look up a frame by name" do
		frame = described_class[ :Becoming_aware ]
		expect( frame ).to be_a( FrameNet::Frame )
		expect( frame.name ).to eq( :Becoming_aware )
	end


	it "can look up a frame by ID" do
		frame = described_class[ 20 ]
		expect( frame ).to be_a( FrameNet::Frame )
		expect( frame.id ).to eq( 20 )
	end


	it "can parse the weird time format from the FrameNet XML files" do
		result = described_class.parse_time( "02/26/2008 03:10:55 PST Tue" )
		expect( result ).to eq( Time.new(2008, 2, 26, 3, 10, 55, "-08:00") )
	end


end

