svalbard
===============

Node bootstrap. Server + Client rendering. Mustache and Backbone. Svalbard because it's cool.

Wat
---

Svalbard is a bootstraping framework including all the things I like and think
are useful for building a modern web application:

* Express for quick serving of things
* Mincer for Sprockets-like compilation of assets, including:
  * LESS for CSS preprocessing
  * Coffeescript and Javascript
* Backbone for elegant client-side scripting
* Mustache for server and client rendering, so you don't have to deal with
SEO or accessbility problems, and so you can support any browser with or
without proper Javascript support
* Organization of configuration in one place
* Bootstrap, because that's what you're gonna do anyway to start off

There's a lot left to do, and this will forever be a work in progress.

How
---

Install node.

`npm install`

`npm start`

Notes About Weird Things I Had to Do
------------------------------------

* Custom [consolidate](https://github.com/visionmedia/consolidate.js)
because I needed a specific pull request ([this one](https://github.com/visionmedia/consolidate.js/pull/51))
to support mustache partials
* Mustache template consolidation - I want to pull it into its own thing
eventually, but a script in src/config/environment.coffee runs through, loads all the
templates, and builds a `windnow.templates` hash that contains references to the
templates for client-side rendering in Backbone.
* Bootstrap custom config - I added an 'import' in src/assets/css/bootstrap/bootstrap.less
to load src/assets/css/variables.less. This way we can upgrade backbone super
easily and keep our config, just don't forget that.


License
-------
MIT licensed. Do whatevs. Build your app right.
