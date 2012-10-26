newsController = require('./../../controllers/news.coffee')

module.exports = (app, buildRequestData) ->
  app.get '/', (req, res) ->
    res.render 'layouts/layout',
      buildRequestData(
        news: newsController.get(),
        partials:
          content: '../home/index'
      )

  app.post '/news', (req, res) ->
    newsController.save(req.body)
    res.redirect("/")
