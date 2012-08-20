# SolrEad

SolrEad is a gem that indexes your ead documents into Solr.  From there, you can use other
Solr-based applications to search and display your finding aids.  It originated as some
code that I used to index ead into Blacklight, but this gem does not require you to use
Blacklight.  You can use this gem with any Solr-based app.

SolrEad uses OM (Opinionated Metadata) to define terms in your ead xml, then uses Solrizer
to create solr fields from those terms.  An indexer is included that has basic create,
update and delete methods for getting your documents in and out of solr via the RSolr gem.

The default term definitions are all based on eads created with Archivist's Toolkit, so
whatever conventions AT has in its ead will be manifested here.  However, you are able to
override this definitions with your own to meet any specific local needs.

## Indexing

SolrEad's default way of indexing a single ead document is to create one solr document for
the initial part of the ead and then separate documents for each component node.  You may
also elect to use a simple indexing option which creates only one solr document per ead
document.

For more information on indexing, see the documentation for SolrEad::Indexer.

## Installation

Add this line to your application's Gemfile:

    gem 'solr_ead'

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install solr_ead

## Usage

    $ rake solr_ead:index FILE=/path/to/your/ead.xml

You can also do this via the command line:

    > indexer = SolrEad::Indexer.new
    > indexer.create(File.new("path/to/your/ead.xml))

### Usage with Blacklight

This code originated in a Blacklight application and some of its default solr fields
reflect a Blacklight-style solr implementation.  For example, certain facet fields such as
subject_topic_facet and title_display will appear in your solr index by default.  If you
are trying out the gem within a default Blacklight installation, you should be able to
index your ead without any modifications.  However, the only fields that will appear in
your search results will be format and title.  In order to make this into working
solution, you'll need to modify both the definitions of documents and components within
SolrEad and configure Blacklight's own display and facet fields accordingly.

## Applications

SolrEad is intended to work at the indexing layer of an application, but it can also work
at the display/presentation layer as well.  You can use the solr fields defined in your OM
terminology for display; however, formatting information such as italics and boldface is
not preserved from the original EAD xml.

For those that need to preserve the formatting of their finding aids, you can use XSLT to
process your EAD for display in your application and use SolrEad to index your finding
aids for searching.

When creating display pages of your finding aids, you can either use "ready-made" html
pages created using XSLT, or create the html when the page is requested.  If you opt for
the latter, you can store the ead xml in a solr field.  To do this, add a new solr field
under the to_solr method of your OM terminology for the ead document:

    solr_doc.merge!({"xml_display" => self.to_xml})

This will create the solr field "xml_display" containing the complete ead xml. Then you
will be able to apply any xslt processing you wish.  Other solutions are possible using
xml from the document as well as the component, depending on the needs of your
application.

## Customization

Chances are the default definitions are not sufficient for your needs.  If you want to
create your own definitions for documents and components, here's what you can do.

### Writing a custom document definition

Under lib or another directory of your choice, create the file custom_document.rb with the
following content:

    class CustomDocument < SolrEad::Document

      set_terminology do |t|
        t.root(:path="ead", :index_as = [:not_searchable])
        t.eadid

        # Add additional term definitions here

      end

      # Optionally, you may tweak other solr fields here.  Otherwise, you can leave this
      # method out of your definition.
      def to_solr(solr_doc = Hash.new)
        super(solr_doc)
      end

    end

From the console, index you ead document using your new definition.

    > file = "path/to/ead.xml"
    > indexer = SolrEad::Indexer.new(:document=>"CustomDocument")
    > indexer.create(file)

### Adding custom methods

Suppose you want to add some custom methods that preform additional manipulations of
your solr fields after they've been pulled from your ead.  You can create a module
for all your specialized methods and add it to your ead document.

    module MyEadBehaviors

      def special_process(field)
        # manipulate your field here
        return field
      end

    end

Then, include your module in your own custom document and call the method during to_solr:

    class CustomDocument < SolrEad::Document

      include MyEadBehaviors

      # terminology goes here...

      def to_solr(solr_doc = Hash.new)
        super(solr_doc)
        solr_doc.merge!({"solr_field" => special_process(self.field_name)})
      end

    end

Your solr document will now include the field "solr_field" that has taken the term
"field_name" and processed it with the special_process method.

### Solr schema configurations

SolrEad is designed to work with the solr jetty application that comes with Blacklight.
However, this doesn't prevent you from using your own solr application.  You can alter the
way SolrEad creates its solr fields by creating your own mapper.  See the ead_mapper.rb
file for more info and the solrizer gem for more information on configuring how SolrEad
creates solr fields.

By default, SolrEad will display series and subseries component documents.  You may,
however, want to surpress this from search results.  To do this, add the following line to
your solrconfig.xml file, under the "search" request handler:

    <lst name="appends"><str name="fq">-component_children_b:[TRUE TO *]</str></lst>

## Contributing

If you have questions or have specific needs, let me know. If you have other ideas or
solutions, please contribute code!

1. Fork SolrEad
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your code
4. Add tests for your code and make sure it doesn't break existing features
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## Copyright

Copyright (c) 2012 Adam Wead. See LICENSE for details.
