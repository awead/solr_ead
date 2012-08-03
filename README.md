*This is currently in development/experimentation; suggestions welcome!*

# SolrEad

SolrEad is a gem that indexes your ead documents into Solr.  From there, you can use
other Solr-based applications to search and display your finding aids.  It originated
as some code that I used to index ead into Blacklight, but this gem does not require
you to use Blacklight,  it should work with any Solr-based app.

SolrEad uses OM (Opinionated Metadata) to define terms in your ead xml, then uses
Solrizer to create solr fields from those terms.  An indexer is included that has
basic create, update and delete methods for getting your documents in and out of
solr via the RSolr gem.

The default term definitions are all based on ead created with Archivist's Toolkit,
however, you may created your own terminologies based on your specific needs.

## Indexing

SolrEad's default way of indexing an ead is to created on document for the initial
part of the ead and then created separate documents for each component node.  Future
versions will allow to override this and create one solr document for every one ead.

## Installation

Add this line to your application's Gemfile:

    gem 'solr_ead'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install solr_ead

## Usage

This is still a work in-progress, but the basic idea is:

    $ rake solr_ead:index FILE=/path/to/your/ead.xml

You can also do this via the command line:

    > indexer = SolrEad::Indexer.new
    > indexer.create(File.new("path/to/your/ead.xml))

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
