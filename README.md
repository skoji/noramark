# ArtiMark

ArtiMark is a simple text markup language. It focuses on creating XHTML files for EPUB books. It is optimized for Japanese text for the present. 

**CAUTION This is very early alpha version, so it's not stable at all. Even the markup syntax will change. **

I hope it will be partly stable by the end of Feburary, 2013

## Installation

Note: This gem is not yet released to rubygems.org.

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

    # line begins with # is a comment.
    # you don't need to indent artimark text.
    art {
        h1: header 1
        article comes here.
        linebreak will produce paragraph.

        blank line will procude div.pgroup.

        d.column {
            This block will produce div.column.
            Inline commands like [l(http://github.com/skoji/arti_mark/){this}] and [s.strong{this}] is available.
        }
    }
    
It is converted to XHTML like this, sorrounded with appropriate html,head and  body tags.

    <article>
    <h1>header 1</h1>
    <div class='pgroup'>
    <p>article comes here.</p>
    <p>linebreak will produce paragraph.</p>
    </div>
    <div class='pgroup'>
    <p>blank line will produce</p>
    </div>
    <div class='column'>
    <div class='pgroup'>
    <p>This block will produce div.column.</p>
    <p>Inline commands like <a href='http://github.com/skoji/arti_mark/'>this</a> and <span class='strong'>this</span> is available.</p>
    </div>
    </div>
    </article>

In a near future version, you will be able to add custom commands.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
