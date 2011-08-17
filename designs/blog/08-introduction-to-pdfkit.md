_This is the 8th in a series of posts leading up to [Node.js
Knockout][1] on creating PDFs with Node using [PDFKit][].  This post was
written by [Node Knockout judge][2] and [PDFKit][] author Devon Govett._

[1]: http://nodeknockout.com
[PDFKit]: http://pdfkit.org
[2]: http://nodeknockout.com/people/4e287d9083c1e401000016b9

Introduction to PDFKit
----------------------

Want to generate PDF documents in your Node Knockout app?  Then you
should be using PDFKit to generate them!  PDFKit is a PDF document
generation library for Node that makes creating complex, multi-page,
printable documents easy.  PDFKit supports an HTML5 canvas-like API for
manipulating vector graphics as well as an SVG path parser that makes
including graphics exported from graphics programs like Adobe
Illustrator in your PDF documents much easier.  It also has an advanced
text engine including support for font embedding, image embedding,
annotations and more.

## Installation

The easiest way to install PDFKit is through [npm](http://npmjs.org/).

    npm install pdfkit

## Creating a PDF document

The first thing you'll need to do to create a document in PDFKit is to
require the module and create a PDFDocument instance.

    var PDFDocument = require('pdfkit'),
        doc = new PDFDocument();

The first page of the document is automatically added for us, but you
can add additional pages at any time by calling `doc.addPage()`.  In
this tutorial, we are going to render a vector star at the top of a
page, and include some text below it.

## Vector graphics

To draw our star, much like with the HTML5 Canvas API, we will first
move the imaginary pencil to a point and then draw lines from that point
to other points.  Finally, we fill in the space within the lines with a
red paint color.  We also use something called a winding rule, which
defines how that space is filled.  The default is the `non-zero` winding
rule which fills everything determined to be on the inside of the shape.
The `even-odd` fill rule allows for "holes" in a shape.  For this star,
we'll use the `even-odd` fill rule, but you should experiment with both
rules and see what is right for your project.

Here is the code to draw that star:

    doc.moveTo(300, 75)
       .lineTo(373, 301)
       .lineTo(181, 161)
       .lineTo(419, 161)
       .lineTo(227, 301)
       .fill('red', 'even-odd');

Because PDFKit supports SVG paths, this can be shortened to the
following code:

    doc.path('M 300,75 L 373,301 181,161 419,161 227,301 z')
       .fill('red', 'even-odd');

## Adding some text

PDFKit's text APIs are quite powerful including support for embedding
custom fonts.  By default, any text you add to the page will
automatically wrap within the page margins, and you can change various
settings such as paragraph gaps and indentation, and the text alignment.
PDFKit also supports automatic wrapping of text into columns and
automatically inserts new pages as necessary if you have a long piece of
text.

Here is the code to insert some text that automatically wraps into two
justified columns, with each paragraph indented 20 points and with a gap
of 10 points between each paragraph.

    var loremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam in...';

    doc.y = 320;
    doc.fillColor('black')
       .text(loremIpsum, {
           paragraphGap: 10,
           indent: 20,
           align: 'justify',
           columns: 2
       });

The first thing we do is set the current Y position of the document to
320 points, which moves the text below our star.  Then we set the fill
color of the text to black (because it was set to red before when we
drew the star), and finally render the text, passing in our options.

## Fonts

Now say we wanted to insert a title in a different font.  Luckily,
PDFKit makes embedding custom fonts in a PDF quite simple.  Just after
the call to set the fill color above, a title could be inserted like
this:

    doc.font('fonts/GoodDog.ttf', 35)
       .text('This is the title!', { align: 'center' })
       .font('Helvetica', 12)
       .moveDown();

This first thing this code does is to embed the GoodDog font and set the
font size to 35 points.  Then, we insert the title text, aligning it to
the center of the page.  Then we set the font back to the default
Helvetica, and move down a line.  Then, as before, we would insert the
page text.

## Images

Rendering images in PDFKit documents is really easy.  By default, images
are automatically placed in the text flow of the document, so inserting
an image at the bottom of the last column of our document will be quite
simple.  Passing the `width` option will automatically scale the image
to fit within that size.  There are other options as well, so check out
the [documentation](http://pdfkit.org/docs/images.html) for a complete
rundown.

    doc.image('images/test.jpeg', { width: 225 });

## Outputting the document

There are two ways to output the PDF document: to a file and as a binary
string to be passed as a response to an HTTP request, for example.

Writing to a file is simple, just call the `write` method with your
filename, and optionally, a callback.

    doc.write('out.pdf');

Getting a string representation of the document is just as simple:

    var string = doc.output();

## Conclusion

I hope I've shown you enough to get you interested in PDFKit!  You can
find the PDF document generated from the examples in this tutorial
[here][3], and check out a more advanced programming guide and
documentation at the [PDFKit website][PDFKit].  If you find any bugs, I
will try to fix them as fast as I can, so please [report them][4] as
soon as they are found.  Now, go generate some knockout PDFs!

[3]: http://f.cl.ly/items/3w0Y3Y053m0B1E3u3H0m/example.pdf
[4]: https://github.com/devongovett/pdfkit/issues
