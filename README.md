bard
====

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
* Socket.io for websockets because awesome

There's a lot left to do, and this will forever be a work in progress.

How
---

### Running it

Install node.

`npm install`

`npm start`

### Using it

Create and delete news posts.

### Adding New Things

Accept web requests by adding to src/handlers. I like to keep handlers batched
into files (like api/news, or home), and include them from src/handlers/handlers.coffee,
but you can bake everything into handlers.coffee if you like.

I move all the data manipulation and as much logic as I can into src/controllers.
As you can see in the news api  handlers, I load in the news controller and
add/delete/load from there. Try adding an edit handler!

All the Backbone code is in src/assets/js/app. If you build your handlers right
and create a RESTful API, you'll see it's super easy to use Backbone! Your
templates are available at `window.templates` so you can use the same templates
both server- and client-side to create a progressively enhanced application
right from the beginning.

Notes About Weird Things I Had to Do
------------------------------------

* Custom [consolidate](https://github.com/visionmedia/consolidate.js)
because I needed a specific pull request ([this one](https://github.com/visionmedia/consolidate.js/pull/51))
to support mustache partials
* Mustache template consolidation - I want to pull it into its own thing
eventually, but a script in src/config/environment.coffee runs through, loads all the
templates, and builds a `windnow.templates` hash that contains references to the
templates for client-side rendering in Backbone. All templates are sent down
with the compiled application.js file that Mincer creates.
* Bootstrap custom config - I added an 'import' in src/assets/css/bootstrap/bootstrap.less
to load src/assets/css/variables.less. This way we can upgrade backbone super
easily and keep our config, just don't forget that.

License
-------
MIT licensed. Do whatevs. Build your app right.
