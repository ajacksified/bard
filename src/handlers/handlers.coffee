_ = require("underscore")

module.exports = (app) ->
  buildRequestData = (data) ->
    data ?= {}
    d = new Date()
    _.extend({
        css: app.environment.viewHelpers.stylesheet('app.css')
        scripts: app.environment.viewHelpers.javascript('app.js')
        googleAnalyticsId: app.config.googleAnalyticsId
        renderedAt: d.toString()
      }, data)

  require('./api/news.coffee')(app, buildRequestData)
  require('./home/home.coffee')(app, buildRequestData)

  # if all else fails, load 404
  app.get '/*', (req, res) ->
    if req.is('json')
      res.contentType('json')
      res.send JSON.stringify({ error: "404" })
    else
      res.render 'layouts/layout',
        buildRequestData(
          partials:
            content: '../errors/404'
        )
