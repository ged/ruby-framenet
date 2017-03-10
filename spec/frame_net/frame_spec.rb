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


	describe "elements (FEs)" do

		let( :frame ) { described_class.load(:Becoming_aware) }


		it "can return its frame elements keyed by ID" do
			result = frame.elements_by_id

			expect( result ).to be_a( Hash )
			expect( result.keys ).to all( be_a Integer )
			expect( result.values ).to all( be_a FrameNet::Frame::Element )
		end


		it "can return its frame elements grouped by their core type" do
			result = frame.elements_by_core_type

			expect( result ).to be_a( Hash )
			expect( result.keys ).to all( be_a String )
			expect( result.values ).to all( be_a(Array) )
		end

	end


	describe "FE core sets" do

		it "can return the 'core sets' of frame elements that belong to it" do
			frame = described_class.load( :Travel )
			results = frame.core_element_sets

			expect( results ).to be_an( Array ).and( all be_an(Array) ) # array of arrays
			expect( results.length ).to eq( 2 )

			expect( results[0] ).to contain_exactly(
				*frame.elements_by_id.values_at( 9786, 2950, 2948, 2945 )
			)
			expect( results[1] ).to contain_exactly(
				*frame.elements_by_id.values_at( 2952, 2949 )
			)
		end

	end


	describe "relations" do

		it "can return its relations as a Hash keyed by type" do
			frame = described_class.load( :Statement )
			result = frame.relations_hash

			expect( result ).to be_a( Hash )
			expect( result.keys ).to all( be_a String )
			expect( result.values ).to all( be_a FrameNet::Frame::Relation )
		end


		it "provides a convenience method for fetching 'Inherits from' frames" do
			frame = described_class.load( :Cause_to_experience )
			results = frame.inherits_from

			expect( results ).to eq([ described_class.load(:Intentionally_affect) ])
		end


		it "provides a convenience method for fetching 'Is inherited by' frames" do
			frame = described_class.load( :Intentionally_affect )
			results = frame.is_inherited_by

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 47 )
			expect( results ).to include(
				described_class.load( :Attack ),
				described_class.load( :Cause_to_perceive ),
				described_class.load( :Detaching ),
				described_class.load( :Rescuing )
			)
		end


		it "provides a convenience method for fetching 'Perspective on' frames" do
			frame = described_class.load( :Growing_food )
			results = frame.perspective_on

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Agriculture) )
		end


		it "provides a convenience method for fetching 'Is Perspectivized in' frames" do
			frame = described_class.load( :Simultaneity )
			results = frame.is_perspectivized_in

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 2 )
			expect( results ).to include(
				described_class.load(:Temporal_collocation),
				described_class.load(:Location_in_time)
			)
		end


		it "provides a convenience method for fetching 'Uses' frames" do
			frame = described_class.load( :Legal_rulings )
			results = frame.uses

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Communication) )
		end


		it "provides a convenience method for fetching 'Is Used by' frames" do
			frame = described_class.load( :Intentionally_affect )
			results = frame.is_used_by

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 3 )
			expect( results ).to include(
				described_class.load(:Arson),
				described_class.load(:Import_export_scenario),
				described_class.load(:Bungling)
			)
		end


		it "provides a convenience method for fetching 'Subframe of' frames" do
			frame = described_class.load( :Planting )
			results = frame.subframe_of

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Agriculture) )
		end


		it "provides a convenience method for fetching 'Has Subframe(s)' frames" do
			frame = described_class.load( :Travel )
			results = frame.has_subframe

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Setting_out) )
		end



		it "provides a convenience method for fetching 'Precedes' frames" do
			frame = described_class.load( :Aiming )
			results = frame.precedes

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Hit_or_miss) )
		end



		it "provides a convenience method for fetching 'Is Preceded by' frames" do
			frame = described_class.load( :Sleep )
			results = frame.is_preceded_by

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Fall_asleep) )
		end


		it "provides a convenience method for fetching 'Is Inchoative of' frames" do
			frame = described_class.load( :Forming_relationships )
			results = frame.is_inchoative_of

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Personal_relationship) )
		end


		it "provides a convenience method for fetching 'Is Causative of' frames" do
			frame = described_class.load( :Cause_change_of_consistency )
			results = frame.is_causative_of

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Change_of_consistency) )
		end



		it "provides a convenience method for fetching 'See also' frames" do
			frame = described_class.load( :Cure )
			results = frame.see_also

			expect( results ).to be_an( Array )
			expect( results.length ).to eq( 1 )
			expect( results ).to include( described_class.load(:Medical_intervention) )
		end


	end

end

