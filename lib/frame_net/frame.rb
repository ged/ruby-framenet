# -*- ruby -*-
#encoding: utf-8

require 'loggability'

require 'frame_net' unless defined?( FrameNet )


# A Frame in FrameNet.
#
# References:
# - https://framenet.icsi.berkeley.edu/fndrupal/glossary#frame
class FrameNet::Frame
	extend Loggability

	# Autoload subordinate classes
	autoload :Element, 'frame_net/frame/element'
	autoload :Relation, 'frame_net/frame/relation'
	autoload :LexicalUnit, 'frame_net/frame/lexical_unit'


	# Loggability API -- log to the framenet logger
	log_to :framenet


	### Load the frame by +name_or_id+.
	def self::load( name_or_id )
		case name_or_id
		when Numeric
			return FrameNet::Frame.load_by_id( name_or_id )
		when Symbol, String
			return FrameNet::Frame.load_by_name( name_or_id )
		else
			raise ArgumentError, "don't know how to load a frame from a %p" % [ name_or_id.class ]
		end
	end
	class << self; alias_method :[], :load; end


	### Return a LibXML::XML::Document for the data for the frame named +name+.
	def self::document_for( name )
		path = "frame/%s.xml" % [ name.to_s.capitalize ]
		return FrameNet.load_document( path )
	end


	### Load a Frame from the frame XML for the given +name+.
	def self::load_by_name( name )
		self.log.debug "Loading frame named %p" % [ name ]

		doc = self.document_for( name ) or
			raise ArgumentError, "No such frame %p!" % [ name ]

		return new do |frame|
			frame.id = Integer( doc.root['ID'] )
			frame.name = doc.root['name'].to_sym
			frame.creation_time = FrameNet.parse_time( doc.root['cDate'] )
			frame.definition = FrameNet::Definition.from_frame_data( doc )
			frame.elements = FrameNet::Frame::Element.from_frame_data( doc )
			frame.relations = FrameNet::Frame::Relation.from_frame_data( doc )
			frame.lexical_units = FrameNet::Frame::LexicalUnit.from_frame_data( doc )
		end
	end


	### Look up a Frame by its Integer +id+.
	def self::load_by_id( id )
		self.log.debug "Loading frame for ID=%p" % [ id ]
		xpath = %{//fn:frame[@ID=%d]} % [ id ]
		node = FrameNet.frame_index.find_first( xpath ) or return nil
		return self.load_by_name( node['name'] )
	end


	### Create a new Frame with the specified +id+, +name+, and +modification_date+.
	def initialize
		@id            = nil
		@name          = nil
		@creation_time = Time.now
		@definition    = nil
		@elements      = []
		@relations     = []
		@lexical_units = []

		yield( self ) if block_given?
	end


	######
	public
	######

	##
	# The Frame's ID
	attr_accessor :id

	##
	# The Frame's name as a Symbol
	attr_accessor :name

	##
	# The timestamp of when the node was created
	attr_accessor :creation_time
	alias_method :cDate, :creation_time
	alias_method :cDate=, :creation_time

	##
	# The definition of the Frame.
	attr_accessor :definition

	##
	# The frame elements associated with the Frame, as an Array of FrameNet::Frame::Elements.
	attr_accessor :elements

	##
	# The frame relations associated with the Frame, as an Array of FrameNet::Frame::Relations.
	attr_accessor :relations

	##
	# The "lexical units" associated with the frame, as an Array of FrameNet::LexUnits.
	attr_accessor :lexical_units


	### Object equality -- returns +true+ if the receiver repressents the same
	### FrameNet frame as +other_frame+.
	def ==( other_frame )
		return other_frame.is_a?( self.class ) && self.id == other_frame.id
	end
	alias_method :eql?, :==


	### Return the Frame as a human-readable string suitable for debugging.
	def inspect
		return %{#<%p:%#016x "%s" [%d] %d elements, %d relations, %d lexical units>} % [
			self.class,
			self.object_id * 2,
			self.name || "(Unnamed)",
			self.id || 0,
			self.elements.length,
			self.relations.count {|rel| !rel.empty? },
			self.lexical_units.length,
		]
	end


	#
	# Elements
	#

	### Return the Hash of this Frame's FEs keyed by numeric ID.
	def elements_by_id
		return self.elements.each_with_object( {} ) do |el, hash|
			hash[ el.id ] = el
		end
	end


	### Return a Hash of this Frame's FEs grouped by core type.
	def elements_by_core_type
		return self.elements.group_by( &:core_type )
	end


	#
	# Relations
	#

	### Return the FrameNet::Frame::Relations this Frame has as a Hash keyed by the
	### Relation's type as a String.
	def relations_hash
		return self.relations.each_with_object( {} ) do |rel, hash|
			hash[ rel.type ] = rel
		end
	end


	### Return Frames the receiver inherits from.
	def inherits_from
		return self.relations_hash[ "Inherits from" ].frames
	end


	### Return Frames the receiver is inherited by.
	def is_inherited_by
		return self.relations_hash[ "Is Inherited by" ].frames
	end


	### Return Frames in which the receiver is one of several perspectives.
	def perspective_on
		return self.relations_hash[ "Perspective on" ].frames
	end


	### Return Frames which represent different states of affairs of the receiving
	### Frame.
	def is_perspectivized_in
		return self.relations_hash[ "Is Perspectivized in" ].frames
	end


	### Return Frames the receiver uses in some capacity.
	def uses
		return self.relations_hash[ "Uses" ].frames
	end


	### Return Frames the receiver is used by.
	def is_used_by
		return self.relations_hash[ "Is Used by" ].frames
	end


	### Return Frames the receiver is a subframe of.
	def subframe_of
		return self.relations_hash[ "Subframe of" ].frames
	end


	### Return Frames which are a subframe of the receiver.
	def has_subframes
		return self.relations_hash[ "Has Subframe(s)" ].frames
	end
	alias_method :has_subframe, :has_subframes


	### Return Frames the receiver comes before in a series of subframes of another
	### Frame.
	def precedes
		return self.relations_hash[ "Precedes" ].frames
	end


	### Return Frames the receiver comes after in a series of subframes of another
	### Frame.
	def is_preceded_by
		return self.relations_hash[ "Is Preceded by" ].frames
	end


	### Return Frames in which the receiving frame is an inchoative subframe.
	def is_inchoative_of
		return self.relations_hash[ "Is Inchoative of" ].frames
	end


	### Return Frames in which the receiving frame is a causative subframe.
	def is_causative_of
		return self.relations_hash[ "Is Causative of" ].frames
	end


	### Return the other members of a group of Frames which should be compared to
	### the receiving Frame.
	def see_also
		return self.relations_hash[ "See also" ].frames
	end



	#
	# Utilities/Testing
	#

	### Return the XML document that contains the data for the frame (if one exists). Returns
	### +nil+ if the document doesn't exist.
	def document
		return self.class.document_for( self.name )
	end


end # class FrameNet::Frame
