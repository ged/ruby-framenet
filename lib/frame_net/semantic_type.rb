# -*- ruby -*-
#encoding: utf-8

require 'loggability'
require 'libxml'

require 'frame_net' unless defined?( FrameNet )


# A semantic fact about an element in FrameNet.
#
# References:
# - https://framenet.icsi.berkeley.edu/fndrupal/glossary#semantic-type
class FrameNet::SemanticType

	### Construct a SemanticType from the given +node+ (a LibXML::XML::Node for a
	### semType element)
	def self::from_node( node )
		return new( node['ID'], node['name'] )
	end


	### Create a new SemanticType for the specified +id+ and +name+.
	def initialize( id, name )
		@id = Integer( id )
		@name = name.to_sym
	end


	######
	public
	######

	##
	# The SmeanticType's ID in FrameNet
	attr_accessor :id

	##
	# The SemanticType's name in FrameNet
	attr_accessor :name

end # class FrameNet::SemanticType

