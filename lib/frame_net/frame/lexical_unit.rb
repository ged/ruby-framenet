# -*- ruby -*-
#encoding: utf-8

require 'loggability'
require 'time'

require 'frame_net/frame' unless defined?( FrameNet::Frame )


# A Lexical Unit in FrameNet.
#
# References:
# - https://framenet.icsi.berkeley.edu/fndrupal/glossary#lexical-unit
class FrameNet::Frame::LexicalUnit
	extend Loggability


	# Loggability API -- log to the framenet logger
	log_to :framenet


	### Load a LexicalUnit from the XML for the lexical unit with the given +id+.
	def self::load( id )
		path = "lu/lu%d.xml" % [ id.to_i ]
		doc = FrameNet.load_document( path ) or return nil
		return self.from_lu_document( doc )
	end


	### Load any LexicalUnits with the given +name+ (in the form <word>.<pos>) and return them
	### as an Array.
	def self::load_by_name( name )
		xpath = %{//fn:lu[@name="%s"]} % [ name ]
		index = FrameNet.lu_index
		return index.find( xpath ).map do |node|
			self.load( node['ID'] )
		end
	end


	### Extract LexicalUnits from the frame data in the specified +doc+ (a
	### LibXML::XML::Document parsed from frame XML) and return them as an Array.
	def self::from_frame_data( doc )
		return doc.find( '//fn:lexUnit' ).map do |node|
			id = node['ID']
			self.load( id )
		end
	end


	### Create a LexicalUnit from the data in the given +doc+ (a
	### LibXML::XML::Document parsed from lu XML)
	def self::from_lu_document( doc )
		return new do |lu|
			lu.id = doc.root['ID'].to_i
			lu.status = doc.root['Status']
			lu.pos = doc.root['POS']
			lu.name = doc.root['name']
			lu.total_annotated = doc.root['totalAnnotated'].to_i
			lu.frame_name = doc.root['frame'].to_sym
		end
	end



	### Create a new LexicalUnit and yield it to a block if given.
	def initialize
		@id              = nil
		@status          = nil
		@pos             = nil
		@name            = nil
		@total_annotated = 0
		@frame_name      = nil

		@frame           = nil

		yield( self ) if block_given?
	end


	######
	public
	######

	##
	# The LexicalUnit's id
	attr_accessor :id

	##
	# The unit's status in FrameNet
	attr_accessor :status

	##
	# The part of speech the unit represents
	attr_accessor :pos

	##
	# The unit's name
	attr_accessor :name

	##
	# The number of annotated sentences in all corpuses for this unit
	attr_accessor :total_annotated

	##
	# The name of the associated Frame
	attr_accessor :frame_name



	### Return the FrameNet::Frame associated with this lexical unit, loading it if
	### necessary.
	def frame
		raise "No frame_name has been set for this unit!" unless self.frame_name
		return @frame ||= FrameNet[ self.frame_name ]
	end


	### Set the FrameNet::Frame associated with this lexical unit to +new_frame+.
	def frame=( new_frame )
		self.frame_name = new_frame.name.to_sym
	end


	### Return the LexicalUnit as a human-readable string suitable for debugging.
	def inspect
		return %{#<%p:%#016x %s [%d] → |%s|>} % [
			self.class,
			self.object_id * 2,
			self.name,
			self.id || 0,
			self.frame_name
		]
	end

end # class FrameNet::Frame::LexicalUnit

