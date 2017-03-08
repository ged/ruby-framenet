# -*- ruby -*-
#encoding: utf-8

require 'loggability'
require 'libxml'

require 'frame_net' unless defined?( FrameNet )


# A marked-up English language definition from various FrameNet elements
class FrameNet::Definition

	### Construct a Definition from the given +node+ (a LibXML::XML::Node for a
	### definition element)
	def self::from_node( node )
		return new do |definition|
			definition.content = node.content
		end
	end


	### Load a definition from a frame XML +document+ (a LibXML::XML::Document
	### parsed from frame XML)
	def self::from_frame_data( document )
		node = document.find_first( '//fn:definition' ) or return nil
		return self.from_node( node )
	end


	### Create a new Definition for the specified +raw_content+.
	def initialize
		@content = nil
		yield( self ) if block_given?
	end


	######
	public
	######

	##
	# The raw (unescaped) content of the definition.
	attr_accessor :content


	### Return the definition's content with the XML stripped.
	def stripped_content
		return self.content.gsub( /<.*?>/, '' ).tr( "\n\t ", ' ' ).strip
	end

end # class FrameNet::Definition

