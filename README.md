# ArtiMark

ArtiMark is a simple line-oriented text markup language. It focuses on creating XHTML files for EPUB books.
It is optimized for Japanese text for the present. 

This very early alpha version, so it's not usable at all.
It will be partly usable by the end of 2012.

## Installation

Add this line to your application's Gemfile:

    gem 'arti_mark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arti_mark

## Usage

    require 'arti_mark'

    document = ArtiMark::Document.new(:lang => 'ja')
    document.read(string_or_io)
    put document.result[0] # outputs 1st page of converted XHTML file

Source text looks like this. 

    art {
        h1: header 1
        article comes here. linebreak will produce paragraph.

        blank line will procude div.pgroup.

        d.column {
            this block will produce div.column.
        }
    }


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
