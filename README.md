# NoraMark
[<img src="https://secure.travis-ci.org/skoji/noramark.png" />](http://travis-ci.org/skoji/noramark) [![Coverage Status](https://coveralls.io/repos/skoji/noramark/badge.png?branch=master)](https://coveralls.io/r/skoji/noramark?branch=master)
[![Gem Version](https://badge.fury.io/rb/nora_mark.png)](http://badge.fury.io/rb/nora_mark)

NoraMark is a simple and customizable text markup language. It is designed to create XHTML files for EPUB books.

**CAUTION This is very early alpha version, so it's not stable at all, even the markup syntax will change**

In non-beta release version, the syntax will be more stable.

## Requirements

* Ruby 2.0.0 or greater

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

From commandline:

    $ nora2html < text.nora > result.xhtml
    
Note: nora2html replace ``newpage:`` command to ``<hr class="page-break" />`` and output all pages in one xhtml.
Main purpose of ``nora2html`` is to validate your markup.

I am planning to release nora2epub and other external tools.

## Markup

An example of markup text (text is in english, but the paragraph style is japanese)

    # line begins with # is a comment.
    # you don't need to indent noramark text.

    # page/document metadata in YAML frontmatter
    ---
    lang: ja
    title: test title
    stylesheets: [css/normalize.css, css/main.css]
    ---
    
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

```
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">
  <head>
    <title>test title</title>
    <link rel="stylesheet" type="text/css" href="css/normalize.css" />
    <link rel="stylesheet" type="text/css" href="css/main.css" />
  </head>
  <body>
    <article><h1 id='heading_index_1'>header 1</h1>
      <div class='pgroup'><p>article comes here.</p>
        <p>linebreak will produce paragraph.</p>
      </div>
      <div class='pgroup'><p>blank line will procude div.pgroup.</p>
      </div>
      <div class='column'><div class='pgroup'><p>This block will produce div.column.</p>
          <p>Inline commands like <a href='http://github.com/skoji/nora_mark/'>this</a> and <span class='strong'>this</span> is available.</p>
        </div>
      </div>
    </article>
  </body>
</html>
```

Another example of markup text in non-japanese (paragraph style is default)

    # line begins with # is a comment.
    # you don't need to indent noramark text.

    ---
    lang: en
    title: test title
    stylesheets: [ css/normalize.css, css/main.css] 
    ---

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

```
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
```


Another example of markup text

    # Markdown-ish heading will creates section

    ---
    lang: ja
    title: test title
    stylesheets: css/normalize.css, css/main.css
    ---
    
    =: this is the first heading

    This line is in a section.
    This line is in a section.

    ==: this is the second heading

    This section is nested.

    =: this is the third heading

    will terminate lower level section

The converted XHTML file

```
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="en">
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
```
Yet another example of markup text.

    # Markdown-ish heading with explicit setion boundary

    ---
    lang: ja
    title: test title
    stylesheets: css/normalize.css, css/main.css
    ---
    
    =: this is the first heading

    This line is in a section.
    This line is in a section.

    ==: this is the second heading with explicit boundary {

    This section is nested.
    
    }
    
    Here is in the first section again.
    
    =: this is the third heading

    will terminate same level section

The converted XHTML file

```
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">
  <head>
    <title>test title</title>
    <link rel="stylesheet" type="text/css" href="css/normalize.css, css/main.css" />
  </head>
  <body>
    <section><h1 id='heading_index_1'>this is the first heading</h1>
      <div class='pgroup'><p>This line is in a section.</p>
        <p>This line is in a section.</p>
      </div>
      <section><h2 id='heading_index_2'>this is the second heading with explicit boundary</h2>
        <div class='pgroup'><p>This section is nested.</p>
        </div>
      </section>
      <div class='pgroup'><p>Here is in the first section again.</p>
      </div>
    </section>
    <section><h1 id='heading_index_3'>this is the third heading</h1>
      <div class='pgroup'><p>will terminate same level section.</p>
      </div>
    </section>
  </body>
</html>
```

## Customize

Simple Customization Sample

Markup text and the code
```ruby
text =<<EOF
speak(Alice): Alice is speaking.
speak(Bob): and this is Bob.
EOF
 
document = NoraMark::Document.parse(text)
document.add_transformer(generator: :html) do
  modify "speak" do # "speak" is selector for node. :modify is action.
    @node.name = 'p'
    @node.prepend_child inline('span', @node.parameters[0], classes: ['speaker'])
  end
end
puts document.html[0]

```

Rendered XHTML
```
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<title>NoraMark generated document</title>
</head>
<body>
<p><span class='speaker'>Alice</span>Alice is speaking.</p>
<p><span class='speaker'>Bob</span>and this is Bob.</p>
</body>
</html>
```

Another Example

```ruby
text = <<EOF
---
lang: ja
---
 
=: 見出し
 
パラグラフ。
パラグラフ。
EOF
 
document = NoraMark::Document.parse(text)
document.add_transformer(generator: :html) do
  replace({:type => :HeadedSection}) do
    header = block('header',
                   block('div',
                         block("h#{@node.level}", @node.heading),
                         classes: ['hgroup']))
    body = block('div', @node.children, classes:['section-body'])
    block('section', [ header, body ], inherit: true) 
  end
end

puts document.html[0]
```

Result.
```
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja">
<head>
<title>NoraMark generated document</title>
</head>
<body>
<section><header><div class='hgroup'><h1 id='heading_index_1'>見出し</h1>
</div>
</header>
<div class='section-body'><div class='pgroup'><p>パラグラフ。</p>
<p>パラグラフ。</p>
</div>
</div>
</section>
</body>
</html>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
