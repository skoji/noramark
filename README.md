# NoraMark

NoraMark is a simple text markup language. It is designed to create XHTML files for EPUB books. Its default mode is for Japanese text.

**CAUTION This is very early alpha version, so it's not stable at all, even the markup syntax**
In the next release,  the library name will change from NoraMark to NoraMark.
In NoraMark, the syntax will be more stable.

## Installation

Add this line to your application's Gemfile:

    gem 'nora_mark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nora_mark

## Usage

    require 'nora_mark'

    document = NoraMark::Document.parse(string_or_io)
    put document.html[0] # outputs 1st page of converted XHTML file

An example of markup text (text is in english, but the paragraph style is japanese)

    # line begins with # is a comment.
    # you don't need to indent noramark text.

    lang: ja
    title: test title
    stylesheets: css/normalize.css, css/main.css

    art {
        h1: header 1
        article comes here.
        linebreak will produce paragraph.

        blank line will procude div.pgroup.

        d.column {
            This block will produce div.column.
            Inline commands like [link(http://github.com/skoji/nora_mark/){this}] and [s.strong{this}] is available.
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
    <p>Inline commands like <a href='http://github.com/skoji/nora_mark/'>this</a> and <span class='strong'>this</span> is available.</p>
    </div>
    </div>
    </article>
    </body>
    </html>

Another example of markup text in non-japanese (paragraph style is default)

    # line begins with # is a comment.
    # you don't need to indent noramark text.

    lang: en
    title: test title
    stylesheets: css/normalize.css, css/main.css

    art {
        h1: header 1
        article comes here.
        linebreak will produce br.

        blank line will procude paragraph.

        d.column {
            This block will produce div.column.
            Inline commands like [link(http://github.com/skoji/nora_mark/){this}] and [s.strong{this}] is available.
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
    <p>article comes here.<br />linebreak will produce paragraph.</p>
    <p>blank line will produce paragraph</p>
    <div class='column'>
    <p>This block will produce div.column.<br />Inline commands like <a href='http://github.com/skoji/nora_mark/'>this</a> and <span class='strong'>this</span> is available.</p>
    </div>
    </article>
    </body>
    </html>


Another example of markup text

    # Markdown-ish heading will creates section

    lang: ja
    title: test title
    stylesheets: css/normalize.css, css/main.css
    
    =: this is the first heading

    This line is in a section.
    This line is in a section.

    ==: this is the second heading

    This section is nested.

    =: this is the third heading

    will terminate lower level section

The converted XHTML file

    <?xml version="1.0" encoding="UTF-8"?>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
    <head>
    <title>test title</title>
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="css/main.css" />
    </head>
    <body>
    <section><h1>this is the first heading</h1>
    <div class='pgroup'><p>This line is in a section.</p>
    <p>This line is in a section.</p>
    </div>
    <section><h2>this is the second heading</h2>
    <div class='pgroup'><p>This section is nested.</p>
    </div>
    </section>
    </section>
    <section><h1>this is the third heading</h1>
    <div class='pgroup'><p>will terminate lower level section</p>
    </div>
    </section>
    </body>
    </html>    
    







In a near future version, you will be able to add custom commands.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
