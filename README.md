# SolrEad

SolrEad is a gem that indexes your ead documents into Solr.  From there, you can use
other Solr-based applications to search and display your finding aids.  It originated
as some code that I used to index ead into Blacklight, but this gem does not require
you to use Blacklight.  You can use this gem with any Solr-based app.

SolrEad uses OM (Opinionated Metadata) to define terms in your ead xml, then uses
Solrizer to create solr fields from those terms.  An indexer is included that has
basic create, update and delete methods for getting your documents in and out of
solr via the RSolr gem.

The default term definitions are all based on eads created with Archivist's Toolkit,
so whatever conventions AT has in its ead will be manifested here.  However, you are
able to override this definitions with your own to meet any specific local needs.

## Indexing

SolrEad's default way of indexing a single ead document is to create one solr document for the initial
part of the ead and then separate documents for each component node.  You may also elect to
use a simple indexing option which creates only one solr document per ead document.

For more information on indexing, see the documentation for SolrEad::Indexer.

## Installation

Add this line to your application's Gemfile:

    gem 'solr_ead'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install solr_ead

## Usage

    $ rake solr_ead:index FILE=/path/to/your/ead.xml

You can also do this via the command line:

    > indexer = SolrEad::Indexer.new
    > indexer.create(File.new("path/to/your/ead.xml))

### Usage with Blacklight

This code originated in a Blacklight application and some of its default solr fields
reflect a Blacklight-style solr implementation.  For example, certain facet fields
such as subject_topic_facet and title_display will appear in your solr index by
default.  If you are trying out the gem within a default Blacklight installation, you
should be able to index your ead without any modifications.  However, the only fields
that will appear in your search results will be format and title.  In order to make
this into working solution, you'll need to modify both the definitions of documents
and components within SolrEad and configure Blacklight's own display and facet fields
accordingly.

## Customization

Chances are the default definitions are not sufficient for your needs.  If you want to
create your own definitions for documents and components, here's what you can do.

### Writing a custom document defintion

1. Under lib or another directory of your choice, create the file custom_document.rb
2. Edit custom_document.rb

     class CustomDocument < SolrEad::Document

      include OM::XML::Document
      include Solrizer::XML::TerminologyBasedSolrizer
      include SolrEad::OmBehaviors

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

3. From the console, index you ead document using your new definition

    > file = "path/to/ead.xml"
    > indexer = SolrEad::Indexer.new(:document=>"CustomDocument")
    > indexer.create(file)

### Solr schema configurations

SolrEad is designed to work with the solr jetty application that comes with Blacklight.
However, this doesn't prevent you from using your own solr application.  You can
alter the way SolrEad creates its solr fields by creating your own mapper.  See the
ead_mapper.rb file for more info and the solrizer gem for more information on configuring
how SolrEad creates solr fields.

By default, SolrEad will display series and subseries component documents.  You may,
however, want to surpress this from search results.  To do this, add the following
line to your solrconfig.xml file, under the "search" request handler:

    <lst name="appends"><str name="fq">-component_children_b:[TRUE TO *]</str></lst>


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Adam Wead. See LICENSE for details.
