This is the 1st in series of posts leading up to the second annual
[Node.js Knockout](http://nodeknockout.com) about how to use
[node.js](http://nodejs.org).

This post covers how to install node on three popular development
platforms: [Mac](#mac), [Ubuntu](#ubuntu), and [Windows](#windows).

Instructions for other platforms can be found on the
[Node Wiki](https://github.com/joyent/node/wiki/Installation).

<h2 id="mac">Mac</h2>

1. [Install Xcode](http://developer.apple.com/xcode/).
2. [Install Homebrew](https://github.com/mxcl/homebrew/wiki/installation).
3. At the terminal, type: `brew install node`.

That's it! Check it worked with a simple [Hello, World!](#hello) example.

<h2 id="ubuntu">Ubuntu</h2>

    sudo apt-get install python-software-properties
    sudo add-apt-repository ppa:chris-lea/node.js
    sudo apt-get update
    sudo apt-get install nodejs

Then, check it worked with a simple [Hello, World!](#hello) example.

<h2 id="windows">Windows</h2>

While the latest version of node builds on Windows, it is not stable, and
most packages are not yet supported, so it's not recommended for Node.js
Knockout.

Instead you should probably use [Cygwin](http://www.cygwin.com/).

1. [Install cygwin](http://www.mcclean-cooper.com/valentino/cygwin_install/).
2. Use `setup.exe` in the cywin folder to install the following packages:
  * devel &rarr; gcc4-g++
  * devel &rarr; git
  * devel &rarr; make
  * devel &rarr; pkg-config
  * devel &rarr; zlib-devel
  * net &rarr; openssl
  * libs &rarr; openssl-devel
  * python &rarr; python

Open the cygwin command line: `Start > Cygwin > Cygwin Bash Shell`. Then,
download and install node:

    git clone git://github.com/joyent/node.git
    cd node
    git checkout v0.4.10
    mkdir ~/local
    ./configure --prefix=$HOME/local/node
    make
    make install
    echo 'export PATH=$HOME/local/node/bin:$PATH' >> ~/.profile
    echo 'export NODE_PATH=$HOME/local/node:$HOME/local/node/lib/node_modules' >> ~/.profile
    source ~/.profile

<h2 id="hello">Hello, Node.js</h2>

Here's a quick program to make sure everything is up and running correctly.

    #!javascript
    // hello_node.js
    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello Node.js\n');
    }).listen(8124, "127.0.0.1");
    console.log('Server running at http://127.0.0.1:8124/');

Run the command by typing `node hello_node.js` in your terminal.

Now, if you navigate to [http://127.0.0.1:8124/](http://127.0.0.1:8124/)
in your browser, you should see the message.

## Congrats

You've installed node.js.
