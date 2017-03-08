# -*- ruby -*-
#encoding: utf-8

require 'loggability'
require 'frame_net/frame' unless defined?( FrameNet::Frame )


# Frame elements of a FrameNet::Frame
#
# References:
# - https://framenet.icsi.berkeley.edu/fndrupal/glossary#frame-element
class FrameNet::Frame::Element

	# The xpath of the FEs of a frame
	XPATH = '//fn:frame/fn:FE'


	### Construct one or more Elements from the FEs of the specified +doc+ (a
	### LibXML::XML::Document parsed from the XML for a frame)
	def self::from_frame_data( doc )
		return doc.find( XPATH ).map {|node| self.from_fe_node(node) }
	end


	### Construct an Element from the given +node+ (a LibXML::XML::Node).
	def self::from_fe_node( node )
		return new do |elem|
			elem.id               = Integer( node['ID'] )
			elem.name             = node['name'].to_sym
			elem.core_type        = node['coreType']
			elem.abbrev           = node['abbrev']
			elem.creation_time    = FrameNet.parse_time( node['cDate'] )
			elem.foreground_color = node['fgColor']
			elem.background_color = node['bgColor']

			if def_node = node.find_first( './fn:definition' )
				elem.definition = FrameNet::Definition.from_node( def_node )
			end

			if st_node = node.find_first( './fn:semType' )
				elem.semantic_type = FrameNet::SemanticType.from_node( st_node )
			end
		end
	end


	### Create a new frame Element. If a block is given, yield the new object to it so
	### its attributes can be set.
	def initialize # :yields: self
		@id               = id
		@name             = name
		@core_type        = core_type

		@abbrev           = nil
		@creation_time    = nil
		@foreground_color = nil
		@background_color = nil

		@definition       = nil
		@semantic_type    = nil

		yield( self ) if block_given?
	end


	######
	public
	######

	##
	# The Element's id
	attr_accessor :id

	##
	# The Element's name
	attr_accessor :name

	##
	# The Element's abbreviation
	attr_accessor :abbrev

	##
	# The Element's creation time as a Time object
	attr_accessor :creation_time
	alias_method :cDate, :creation_time
	alias_method :cDate=, :creation_time=

	##
	# The Element's core type
	attr_accessor :core_type
	alias_method :coreType, :core_type

	##
	# The Element's foreground color when displayed in a visual medium
	attr_accessor :foreground_color
	alias_method :fgColor, :foreground_color
	alias_method :fgColor=, :foreground_color=

	##
	# The Element's background color when displayed in a visual medium
	attr_accessor :background_color
	alias_method :bgColor, :background_color
	alias_method :bgColor=, :background_color=

	##
	# The FrameNet::Definition associated with this Element (if one exists)
	attr_accessor :definition

	##
	# The FrameNet::SemanticType associated with this Element (if one exists)
	attr_accessor :semantic_type


	### Return the Element as a human-readable string suitable for debugging.
	def inspect
		return %{#<%p:%#016x %s%s(%s) [%d] "%s">} % [
			self.class,
			self.object_id * 2,
			self.name || "(Unnamed)",
			self.semantic_type ? ":#{self.semantic_type.name}" : '',
			self.core_type,
			self.id || 0,
			self.definition ? self.definition.stripped_content : '',
		]
	end

end # class FrameNet::Frame::Element

