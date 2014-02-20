# ArtiMark

ArtiMark is a simple text markup language. It is designed to create XHTML files for EPUB books. It is optimized for Japanese text for the present. 

**CAUTION This is very early alpha version, so it's not stable at all.**

Reimplemented new version will be released on the end of Feb. 2014. Some syntax will be changed on the new version. The name of the library may change.

## Installation

Add this line to your application's Gemfile:

    gem 'arti_mark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arti_mark

## Usage

    require 'arti_mark'

    document = ArtiMark::Document.new()
    document.convert(string_or_io)
    put document.result[0] # outputs 1st page of converted XHTML file

an example of markup text

    # line begins with # is a comment.
    # you don't need to indent artimark text.

    lang: en
    title: test title
    stylesheets: css/normalize.css, css/main.css

    art {
        h1: header 1
        article comes here.
        linebreak will produce paragraph.

        blank line will procude div.pgroup.

        d.column {
            This block will produce div.column.
            Inline commands like [link(http://github.com/skoji/arti_mark/){this}] and [s.strong{this}] is available.
        }
    }

The converted XHTML file

    <?xml version="1.0" encoding="UTF-8"?>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <head>
    <title> test title</title>
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="css/main.css" />
    </head>
    <body>
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
