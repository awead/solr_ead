# SolrEad

Blacklight plugin for getting your ead into solr.  Uses the OM (Opinionated Metadata)
gem to extract terms from your ead xml and then indexes them into your solr instance.

Note: This is currently in development/experimentation, but code is always welcome!

## Installation

Add this line to your application's Gemfile:

    gem 'solr_ead'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install solr_ead

## Usage

    Use the included OM terminology, or override it and create your own.

    $ rake solr_ead:index FILE=/path/to/your/ead.xml

    Create your views within Blacklight to display the results.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
