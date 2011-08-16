_This is the 5th in a series of posts leading up to [Node.js
Knockout][1] on pulling it all together using [Node Express
Boilerplate][node-express-boilerplate].  This post was written by
[@mape][3], "solo winner" of [Node.js Knockout 2010][4]._

[1]: http://nodeknockout.com
[node-express-boilerplate]: https://github.com/mape/node-express-boilerplate
[3]: http://twitter.com/mape
[4]: http://2010.nodeknockout.com/

# Taking a walk (with node.js)

![Chill][https://s3.amazonaws.com/2011.nodeknockout.com/chill.png.scaled500.png]

Taking a walk every now and then is good for the body and the mind. But as
with many other endeavors, often the hardest part is taking that first step.

The same goes for ideas and projects - all the boring preparatory work can
potentially delay or altogether squander the best of intentions that otherwise
could lead to a joyful and educational experience.

So why not take a lot of the boring prep work out of your projects by
utilizing [node-express-boilerplate][]?

[node-express-boilerplate][] gives the developer a clean slate to start with
while bundling enough useful features so as to remove all those redundant
tasks that can derail a project before it even really gets started.

## So what does [node-express-boilerplate][] do?

![Express-boiler][https://s3.amazonaws.com/2011.nodeknockout.com/express-boiler.png.scaled500.png]

First of all, it is very easy to understand, allowing you to start using it
right away. There is minimal need to dig around in files just to get a good
idea of how things work. And if you don't like how the boiler plate is set up,
just fork it and change it according to your own personal preferences.

**Features include:**

* Bundling [socket.io][7] and integrating with the [express][8] session
  store so data can be shared
* Providing premade hooks to [authenticate][9] users via
  facebook/twitter/github
* An [assetmanager][10] that concatenates/mangles/compresses your CSS/JS
  assets to be as small and fast to deliver as possible, as well as
  cache busting using MD5 hashes
* Auto updates of the browser (inline/refresh) as soon as
  CSS/JS/template-files are changed in order to remove all those
  annoying "save, tab, refresh" repetitions
* [Notifications][11] to your computer/mobile phone on certain user
  actions (This is something [I][12] relied heavily on last year when he
  was involved in NKO; as soon as a new game was started I knew about it
  and could jump in and interact - nobody enjoys something social if they
  are stuck there alone.)
* Sane defaults in regards to productions/development environments
* Logs errors to [Airbrakeapp.com][13] in order to track any errors
  users are encountering
* Auto matching of urls to templates without having to define a specific
  route (such as, visiting /file-name/ tries to serve file-name.ejs and
  fallbacks to index.ejs - this is helpful for quick static info pages)

[7]: http://socket.io/
[8]: https://github.com/visionmedia/express
[9]: https://github.com/bnoguchi/everyauth
[10]: https://github.com/mape/connect-assetmanager/
[11]: http://notifo.com/
[12]: http://twitter.com/mape
[13]: http://airbrakeapp.com/

## How do I get started? (on Joyent's no.de service)

1. First on your no.de machine

  1. `ssh node@yourname.no.de`
  2. `pkgin update; pkgin install redis`
  3. `svccfg import /opt/local/share/smf/manifest/redis.xml`
  4. `svcadm enable redis`

2. Secondly on your development machine

  1. `git clone http://github.com/mape/node-express-boilerplate myproject`
  2. `cd myproject`
  3. `cp siteConfig.sample.js siteConfig.js`
  4. edit siteConfig.js settings
  5. `scp siteConfig.js node@yourname.no.de:~`
  6. `git remote add joyent node@yourname.no.de:repo`
  7. `git push joyent master`
  8. open `http://yourname.no.de`

So check it out at github ([node-express-boilerplate][]) and drop by
[#node.js on irc][14] for feedback and to let [me][15] know if you run into
any issues.

[14]: http://github.com/mape/node-express-boilerplate
[15]: irc://irc.freenode.net/node.js
