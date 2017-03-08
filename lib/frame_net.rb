# -*- ruby -*-
#encoding: utf-8

require 'rubygems'
require 'pathname'
require 'time'

require 'libxml'
require 'libxml/monkeypatches'

require 'loggability'


# A Ruby interface to FrameNet
module FrameNet
	extend Loggability

	# Package version
	VERSION = '0.0.1'

	# Version control revision
	REVISION = %q$Revision$

	# The Pathname for the library's data directory, taken from the
	# FRAME_NET_DATA_DIR env variable first, then the datadir for the ruby-framenet
	# gem if it is available, then falling back to a local path
	DATA_DIR = begin
		env_data_dir = ENV['FRAME_NET_DATA_DIR']
		gem_data_dir = Gem.datadir('ruby-framenet')
		local_data_dir = Pathname( __FILE__ ).dirname.parent + 'data/ruby-framenet'

		if env_data_dir && File.directory?( env_data_dir )
			Pathname( env_data_dir )
		elsif gem_data_dir && File.directory?( gem_data_dir )
			Pathname( gem_data_dir )
		else
			local_data_dir
		end
	end

	# The strptime format of times used in FrameNet data
	TIME_FORMAT = '%m/%d/%Y %H:%M:%S %Z %a'


	# Loggability API -- Set up a logger for FrameNet classes
	log_as :framenet


	# Load classes under the namespace when they're referred to
	autoload :Frame, 'frame_net/frame'
	autoload :SemanticType, 'frame_net/semantic_type'
	autoload :Definition, 'frame_net/definition'


	### Look up a frame by +name_or_id+ and return it as a FrameNet::Frame.
	def self::[]( name_or_id )
		return FrameNet::Frame.load( name_or_id )
	end


	### Return an Array of FrameNet::Frame::LexicalUnits for the given +name+ (which
	### is of the form: `<morph>.<pos>`)
	def self::lexical_unit( name )
		return FrameNet::Frame::LexicalUnit.load_by_name( name )
	end


	### Return the FrameNet frameIndex data as an LibXML::XML::Document.
	def self::frame_index
		return @frame_index ||= self.load_document( 'frameIndex.xml' )
	end


	### Return the FrameNet lexical unit index data as an LibXML::XML::Document.
	def self::lu_index
		return @lu_index ||= self.load_document( 'luIndex.xml' )
	end


	### Load the document with the specified +path+ as an LibXML::XML::Document. If
	### the +path+ is relative, assume it's relative to the current DATA_DIR.
	def self::load_document( path )
		path = Pathname( path )
		path = DATA_DIR + path if path.relative?

		self.log.debug "Load document: %s" % [ path ]
		return nil unless path.readable?

		doc = LibXML::XML::Document.file( path.to_path )
		doc.root.namespaces.default_prefix = 'fn'

		return doc
	end


	### Attempt to parse the given +string_time+ to a Time, using the format of
	### times in FrameNet data first, then falling back to Time.parse if that fails.
	### If Time.parse fails, its exception is not rescued.
	def self::parse_time( string_time )
		begin
			return Time.strptime( string_time, FrameNet::TIME_FORMAT )
		rescue ArgumentError
		end

		# Let the ArgumentError bubble up
		return Time.parse( string_time )
	end


end # module FrameNet

