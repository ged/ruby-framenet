# -*- ruby -*-
#encoding: utf-8

require 'libxml'


# A collection of monkeypatches to LibXML classes, mostly adding useful #inspect
# methods to them.
module LibXML::XML

	class Document

		def inspect
			return "#<%p:%#016x %s:%s [%s]>" % [
				self.class,
				self.object_id * 2,
				self.node_type_name,
				self.root.name,
				self.rb_encoding,
			]
		end

	end


	class Node

		def inspect
			return "#<%p:%#016x %s:%s %p (%s)>" % [
				self.class,
				self.object_id * 2,
				self.node_type_name,
				self.name,
				self.attributes.to_h,
				self.path,
			]
		end

		def node_type_name
			return case self.node_type
				when ELEMENT_NODE
					"element"
				when ATTRIBUTE_NODE
					"attribute"
				when TEXT_NODE
					"text"
				when CDATA_SECTION_NODE
					"cdata section"
				when ENTITY_REF_NODE
					"entity ref"
				when ENTITY_NODE
					"entity"
				when PI_NODE
					"pi"
				when COMMENT_NODE
					"comment"
				when DOCUMENT_NODE
					"document"
				when DOCUMENT_TYPE_NODE
					"document type"
				when DOCUMENT_FRAG_NODE
					"document frag"
				when NOTATION_NODE
					"notation"
				when HTML_DOCUMENT_NODE
					"html document"
				when DTD_NODE
					"dtd"
				when ELEMENT_DECL
					"element decl"
				when ATTRIBUTE_DECL
					"attribute decl"
				when ENTITY_DECL
					"entity decl"
				when NAMESPACE_DECL
					"namespace decl"
				when XINCLUDE_START
					"xinclude start"
				when XINCLUDE_END
					"xinclude end"
				when DOCB_DOCUMENT_NODE
					"docb document"
				else
					nil
				end
		end

	end


	class XPath::Object

		def inspect
			return "#<%p:%#016x %s:%s [%d nodes]>" % [
				self.class,
				self.object_id * 2,
				self.string || "''",
				self.xpath_type_name,
				self.length,
			]
		end

		def xpath_type_name
			return case self.xpath_type
				when LibXML::XML::XPath::UNDEFINED
					"undefined"
				when LibXML::XML::XPath::NODESET
					"nodeset"
				when LibXML::XML::XPath::BOOLEAN
					"boolean"
				when LibXML::XML::XPath::NUMBER
					"number"
				when LibXML::XML::XPath::STRING
					"string"
				when LibXML::XML::XPath::POINT
					"point"
				when LibXML::XML::XPath::RANGE
					"range"
				when LibXML::XML::XPath::LOCATIONSET
					"locationset"
				when LibXML::XML::XPath::USERS
					"users"
				when LibXML::XML::XPath::XSLT_TREE
					"xslt_tree"
				else
					nil
				end
		end

	end

end # module LibXML::XML

