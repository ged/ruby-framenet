# -*- ruby -*-
#encoding: utf-8

require 'loggability'
require 'time'

require 'frame_net/frame' unless defined?( FrameNet::Frame )


# A relation between two Frames in FrameNet.
class FrameNet::Frame::Relation
	extend Loggability


	# Loggability API -- log to the framenet logger
	log_to :framenet


	### Load one or more instances from the specified +doc+ (a LibXML::XML::Document
	### parsed from a FrameNet frame).
	def self::from_frame_data( doc )
		return doc.find( '//fn:frameRelation' ).map do |node|
			new do |relation|
				relation.type = node['type']
				relation.frame_ids = node.find( './fn:relatedFrame' ).map {|node| node['ID']}
			end
		end
	end


	### Create a new instance and yield it to the block if one is given.
	def initialize
		@type = nil
		@frame_ids = []

		yield( self ) if block_given?
	end


	######
	public
	######

	##
	# The type of the relation (e.g., "Inherits from", "Is Inherited by")
	attr_accessor :type

	##
	# The IDs of the Frames in this relation with the owning Frame.
	attr_accessor :frame_ids


	### Look up and return the related FrameNet::Frames for this Relation.
	def frames
		return self.frame_ids.map {|id| FrameNet::Frame.load_by_id(id) }
	end


	### Returns +true+ if there are no frames with this relation.
	def empty?
		return self.frame_ids.empty?
	end

end # class FrameNet::Frame::Relation
