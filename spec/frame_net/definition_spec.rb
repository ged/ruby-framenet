#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'frame_net/definition'


describe FrameNet::Definition do

	let( :document ) { FrameNet.load_document('frame/State.xml') }
	let( :definition_node ) { document.find_first('//fn:definition') }
	let( :definition_content ) do
		"<def-root>An <fen>Entity</fen> persists in a stable situation called "\
		"a <fen>State</fen></def-root>"
	end


	it "can be created from an XML node" do
		result = described_class.from_node( definition_node )
		expect( result ).to be_a( described_class )
		expect( result.content ).to eq( definition_node.content )
	end


	it "can be created with an initialization block" do
		result = described_class.new do |instance|
			instance.content = definition_content
		end

		expect( result ).to be_a( described_class )
		expect( result.content ).to eq( definition_content )
	end


end

