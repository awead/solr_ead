# SolrEad

[![Build Status](https://travis-ci.org/awead/solr_ead.png?branch=master)](https://travis-ci.org/awead/solr_ead)
[![Gem Version](https://badge.fury.io/rb/solr_ead.png)](http://badge.fury.io/rb/solr_ead)

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
    $ rake solr_ead:index_dir DIR=/path/to/your/eads SIMPLE=true
    $ rake solr_ead:index_dir DIR=/path/to/your/eads SOLR_URL=http://127.0.0.1:8983

You can also do this via the command line:

    > indexer = SolrEad::Indexer.new
    > indexer.create(File.new("path/to/your/ead.xml))

## Applications

SolrEad is intended to work at the indexing layer of an application, but it can also work
at the display and presentation layer as well.  You can use the solr fields defined in your OM
terminology for display; however, formatting information such as italics and boldface is
not preserved from the original EAD xml.

For those that need to preserve the formatting of their finding aids, you can use XSLT to
process your EAD for display in your application and use SolrEad to index your finding
aids for searching.

When creating display pages of your finding aids, you can either use "ready-made" html
pages created using XSLT, or create the html when the page is requested.  If you opt for
the latter, you can store the ead xml in a solr field.  To do this, add a new solr field
under the to_solr method of your OM terminology for the ead document:

    Solrizer.insert_field(solr_doc, "xml", self.to_xml, :displayable)

This will create the solr field "xml_ssm" containing the complete ead xml. Then you
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

      # Use the existing terminology
      use_terminology SolrEad::Document

      # And extend it with terms of your own
      extend_terminology do |t|
        ...
      end

      # Or, just define your own from scratch
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
    > indexer = SolrEad::Indexer.new(:document=>CustomDocument)
    > indexer.create(file)

Or index from the rake task 

    $ rake solr_ead:index FILE=path/to/file.xml CUSTOM_DOCUMENT=path/to/custom_document.rb

### Writing a custom component definition

Similar to the custom document definition, you can create a custom component definition for component indexing:

    class CustomComponent < SolrEad::Component
      ...
    end

Call this from the console

    > indexer = SolrEad::Indexer.new(:document=>CustomDocument, :component=>CustomComponent)

Or from the rake task

    $ rake solr_ead:index FILE=path/to/file.xml CUSTOM_DOCUMENT=path/to/custom_document.rb CUSTOM_COMPONENT=path/to/custom_component.rb

### Adding custom methods

Suppose you want to add some custom methods that perform additional manipulations of
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

      use_terminology SolrEad::Document

      def to_solr(solr_doc = Hash.new)
        super(solr_doc)
        Solrizer.insert_field(solr_doc, "field", special_process(self.field), :displayable)
      end

    end

Your solr document will now include the field "field_ssm" that has taken the term
"field" and processed it with the special_process method.

### Solr schema configurations

SolrEad uses Solrizer's default field descriptors to create the names of solr fields.  A complete
listing of these fields is found under 
[Solrizer::DefaultDescriptors](https://github.com/projecthydra/solrizer/blob/master/lib/solrizer/default_descriptors.rb)
but the options that are used here are specifically:

    :displayable
    :stored_sortable
    :type => :integer
    :type => :boolean
    :facetable
    :sortable, :type => :integer
    :searchable

These result in a specific set of dynamic field names that will need to be present in your schema.xml file in
solr.  In order to have these fields index correctly, include the following in your schema.xml file:

    <dynamicField name="*_teim"  type="text_en"   stored="false" indexed="true"  multiValued="true"  />
    <dynamicField name="*_si"    type="string"    stored="false" indexed="true"  multiValued="false" />
    <dynamicField name="*_sim"   type="string"    stored="false" indexed="true"  multiValued="true"  />
    <dynamicField name="*_ssm"   type="string"    stored="true"  indexed="false" multiValued="true"  />
    <dynamicField name="*_ssi"   type="string"    stored="true"  indexed="true"  multiValued="false" />
    <dynamicField name="*_ssim"  type="string"    stored="true"  indexed="true"  multiValued="true"  />
    <dynamicField name="*_dtsi"  type="date"      stored="true"  indexed="true"  multiValued="false" />
    <dynamicField name="*_dtsim" type="date"      stored="true"  indexed="true"  multiValued="true"  />
    <dynamicField name="*_bsi"   type="boolean"   stored="true"  indexed="true"  multiValued="false" />
    <dynamicField name="*_isim"  type="int"       stored="true"  indexed="true"  multiValued="true"  />
    <dynamicField name="*_ii"    type="int"       stored="false" indexed="true"  multiValued="false" />

Note that the type "text_en" is dependent on your particular solr application, but the others should be
included in the default installation.

## Issues

### eadid format

solr_ead uses the <eadid> node to create unique ids for documents.  Consequently, if you're using
a rails app, this id will be a part of the url.  If your eadid has .xml or some other combination
of characters preceded by a period, this will cause Rails to interpret these characters as a 
format, which you don't want.  You may need to edit your eadid nodes if this is the case.

## Contributing

### Testing with Jettywrapper

SolrEad uses jettywrapper to download a solr application for testing.  To get setup for developing
additional features for SolrEad:

    git clone https://github.com/awead/solr_ead
    bundle install
    rake ci

This will download jetty, start it up and run the spec tests. If you have questions or have specific needs, let me know. 
If you have other ideas or solutions, please contribute code!

1. Fork SolrEad
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your code
4. Add tests for your code and make sure it doesn't break existing features
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## Copyright

Copyright (c) 2012 Adam Wead. See LICENSE for details.
