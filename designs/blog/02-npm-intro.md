_This is the 2nd in series of posts leading up
[Node.js Knockout](http://nodeknockout.com) about how to use
[npm](http://npmjs.org). This post was written by npm author and
[Node.js Knockout judge](http://nodeknockout.com/people/4e2819db6fd024010000192e)
Isaac Schlueter._

npm is a [NodeJS](http://nodejs.org/) package manager.  As its name
would imply, you can use it to install node programs.  Also, if you use
it in development, it makes it easier to specify and link dependencies.

## Installing npm

To install npm in one command, you can do this:

    curl http://npmjs.org/install.sh | sh

Of course, if you're more paranoid than lazy, you can also get the
[latest code](http://github.com/isaacs/npm), check it all out, and when
you're happy there's nothing in there to pwn your machine, issue a `make
install` or `make dev`.

## Getting help: `npm help`

npm has a lot of help documentation about all of its commands.  The `npm
help` command is your best friend.  You can also tack `--help` onto any
npm command to get help on that one command.

## Discovering packages: `npm search` & `npm info`

You probably got npm because you want to install stuff.  That's what
package managers do, they install stuff.

The first step in installing something is discovering what to install.
That's where `npm search` comes in handy. It'll search the package
registry for anything that matches the search term you provide, and
print out a list matching packages, along with descriptions.

    $ npm search memcached
    connect-memcached  Memcached session store for Connect
    kizzy              x-browser LocalStorage API with a memcached interface
    memcache           simple memcache client
    memcached          A fully featured Memcached API client, supporting both single
    nMemcached         A fully featured Memcached client, supporting both single and

`npm info` will get you more details about a package: the
contents of the package.json file. From there, you can usually find all
the information you need to fully evaluate if it is the right package
for you.

## Installing stuff: `npm install`

`npm install blerg` installs the latest version of `blerg`.  You can
also give `install` a tarball, a folder, or a url to a tarball.

This command can do a lot of stuff.  `npm help install` will tell you
more than you ever wanted to know about it.

## Specifying project dependencies: `package.json`

Because so many great npm packages are already written and ready for you
to use, it's pretty rare that to write code that doesn't depend another
package.

While you could just manually install all your dependencies by running
`npm install blerg`, that doesn't really help you remember what packages
you're using, and if you share the repository or try to install it
somewhere else, you'll have to manually install all the packages again.

Instead, you can specify your dependencies in the `package.json` file.

The `package.json` file goes in the root of your project.  It tells npm
how your package is structured, and what to do to install it, and most
importantly, what dependencies it relies on.  Here's what the
[Node.js Knockout `package.json` file looks like](https://github.com/nko2/website/blob/master/package.json).

For projects without dependencies, you only need the `"name"`,
`"version"`, and `"main"` fields  (even for node-waf compiled addons).
However, it's likely you'll also want to specify `"dependencies"` and
`"devDependencies"` in your package.json file. `"dependencies"` lists
the packages that your project relies on in both production and
development. `"devDependencies"` lists the packages, like test suites
and debugging tools, that are only useful in development.

You can easily create a valid `package.json` file with the `npm init`
command.  `npm install blerg --save` will install `blerg` package and
add it as a dependency in your `package.json` file.

Now, if you run `npm install` without any arguments, it will
automatically install your project's dependencies.

One added bonus: when you add a `package.json` file to your project,
your project itself becomes a package, and you can easily publish it
to the npm registry (see below for more info).

## Seeing what's installed: `npm ls`

The `npm ls` command shows what packages you have installed, as a
convenient dependency tree. It will also print out extraneous, missing,
and invalid packages; which is useful for troubleshooting.

`npm help ls` for more info.

## Updating packages: `npm update`

The `update` command does a few things.

1. Search the registry for new versions of all the packages installed.
2. If there's a newer version, then install it.
3. Point dependent packages at the new version, if it satisfies their dependency.
4. Remove the old versions, if no other package names them as a dependency.

So basically, update behaves a lot like a "standard" package manager's
update command, except that it also checks to make sure that the new
version isn't going to break anything before it points stuff at it.

You see, npm keeps you out of dependency hell.

## Development: `npm link`

npm is a development tool, first and foremost.  People sometimes say
"Yeah, I haven't gotten time to check out that package manager stuff
yet.  Maybe I will when my code is more stable."

That's like saying that you're going to start using source control when
your code is done.  It's just silly.  Source control should make your
process *easier*, and if it doesn't, then you're using a broken SCM.
Same for package management.  It should make it easier, and if it
doesn't, then something is wrong.

The link command symlinks a package folder that you are actively
developing into any ohter project that you're working on, so that
changes are automatically reflected.

This is one of the most useful tools for developing programs with node.
Give your thing a name and a version in a `package.json` file.  Specify
a few dependencies and a `main` module.  Then run `npm link`, and go to
town coding it and testing it out in the node repl.  It's great.

npm isn't "for" publishing.  That's just something it can do.  It's
"for" playing.  That's why I wrote it: to play with your code, without
having to remember a dozen different ways to install your stuff, or
having to get you all to structure your code the same way.

It's *supposed* to make the process funner.

## Acquiring Fame: `npm publish`

So, you created a package, and you can install it.  Now you want the
everlasting fame and glory that comes with other people using your code.
There is no better way to ensure your immortality than eventually being
a part of every web app out there, and the best—nay, the ONLY—way to
truly accomplish this is to publish nodejs packages.

First, create a user account with `npm adduser`.  Give it a username,
password, and email address, and it'll create an account on the npm
registry.  (You can also use adduser to authorize a user account on a
new machine, or fix the situation if you break your configs.)

Next, go to the root of your package code, and do `npm publish`.

Now go to the mailing list and tell everyone how much more awesome
they'd be if they used your program.

Seriously.  It's incredibly easy.  If you disagree, please [let me
know](mailto:i@izs.me).

## Dependency Hell Isn't Fun

Most systems have a single root namespace.  That kind of sucks.  If two
different things depend on different versions of the same dependency,
then you've got two options:

1. Statically compile the dependency into the program.
2. Hate life.

Option #2 is Not Fun.  So eff that noise.  That sucks, and is dumb.

Option #1 is less than ideal if you want to be able to abstract out
parts of your program and benefit from updates to the dependencies.

Thankfully, unlike most programming environments, the CommonJS Securable
Module system lets you avoid dependency hell by modifying the
`require.paths` at runtime, so that each package sees the version that
it depends on.

I think that's pretty cool.

## What to do when npm lets you down

npm's pretty young software, and still being actively developed.
Especially if you find yourself using some newer features, occasionally
npm will have a bug.  Or, perhaps equally likely, you'll need npm to do
something that it doesn't yet do, and want to request a feature.

You can post bugs and feature requests on [the issues
page](http://github.com/isaacs/npm/issues).  If you want to ask general
questions, you can ask on [the google
group](http://groups.google.com/group/npm-).

Or, if you're more the instant gratification type, you can come ask
questions in IRC on [the #node.js channel on
freenode.net](irc://irc.freenode.net/#node.js).  If I'm there, I'll try
to help you out, but this community continues to impress me with its
helpfulness.  Noders rock!
