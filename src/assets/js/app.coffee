# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require ./lib/console.js
#= require ./lib/underscore-1.3.3.min.js
#= require ./lib/backbone-0.9.2.min.js
#= require_tree ./lib
#= require_tree ./build
#= require ./app/app
#= require_tree ./app/models
#= require_tree ./app/views
#= require_tree ./app/routers
#= require_self

unless window.noboot?
  $ ->
    game = new App.Routers.Router( bootstrap: (window.bootstrap ? null) )

    if Modernizr.history
      Backbone.history.start( pushState: true )
    else
      Backbone.history.start()

