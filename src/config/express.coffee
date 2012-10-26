# a bunch of bootstrapping stuff
express = require('express')
Mincer = require('mincer')
_ = require('underscore')
app = express()
http = require('http')
server = http.createServer(app)
cons = require('./../lib/consolidate')
dir = __dirname + '/../'

app.config = require('./../config/config')
app.environment = require('./environment')(app)

#Load our route handlers separately instead of putting them all here, for cleanliness
handlers = require('./../handlers/handlers.coffee')

module.exports = ->
  port = process.env.PORT || app.config.port || 3333

  app.configure ->
    app.set 'port', port

    app.engine 'mustache', cons.mustache
    app.set 'view engine', 'mustache'
    app.set 'views', dir + app.config.templatePath

    app.use app.config.staticDir, express.static(dir + app.config.staticDir)

    app.use '/assets/', Mincer.Server.createServer(app.environment)
    app.use '/js', express.static(dir + app.config.jsPath)
    app.use '/img', express.static(dir + app.config.imgPath)

    app.use express.bodyParser()
    app.use express.cookieParser()
    app.use express.methodOverride()
    app.use require("get-methodoverride")
    app.use app.router

  handlers(app)

  app.environment.viewHelpers.cacheTemplates((t) -> 
    console.log "Cached templates."

    asset = app.environment.findAsset('app.coffee')
    asset.compile (err, asset) ->
      #noop

    asset = app.environment.findAsset('app.less')
    asset.compile (err, asset) ->
      #noop
      #
  )

  http.createServer(app).listen(app.get('port'), ->
    console.info "Svalbard running on port #{port}"
  )

  return server
