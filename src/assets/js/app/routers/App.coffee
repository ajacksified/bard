class App.Routers.Router extends Backbone.Router
  routes:
    '': 'home'

  initialize: (options) =>
    Backbone.history.on("route", @changeView)

    @bootstrap = options.bootstrap? || {}

    @view = new App.Views.Application.ApplicationView( el: $("body"), account: @account, token: @token )
    @view.bind("changeRoute", @changeRoute)

  changeRoute: (path) =>
    @navigate(path, { trigger: true })

  home: ->
    view = @view

    news = new App.Collections.NewsCollection()
    news.bind("reset", -> view.setView App.Views.Home.HomeView, { model: news })

    news.fetch()

