# Here, we'll load whatever needs to handle our application logic
newsController = require('./../../controllers/news.coffee')

module.exports = (app, buildRequestData) ->
  app.get '/api/news', (req, res) ->
    res.contentType('json')
    res.send JSON.stringify(newsController.get())

  app.get '/api/news/:id', (req, res) ->
    res.contentType('json')
    res.send JSON.stringify(newsController.get(req.params.id))

  app.post '/api/news', (req, res) ->
    news = newsController.save(req.body)
    res.contentType('json')
    res.send JSON.stringify(news)

  app.put '/api/news/:id', (req, res) ->
    news = newsController.save(req.body)
    res.contentType('json')
    res.send JSON.stringify(news)

  app.delete '/api/news/:id', (req, res) ->
    deleted = newsController.delete(req.params.id)
    res.contentType('json')
    res.send JSON.stringify(deleted)
