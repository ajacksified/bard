#= require ./Base

App.Views.Home ||= {}

class App.Views.Home.HomeView extends App.Views.Base.BaseView
  template: window.templates['home/index']

  events:
    'click .delete-news': 'deleteNews'
    'submit #add_news_form': 'addNews'

  initialize: =>
    @render()

  render: =>
    @$el.html(Mustache.render(@template, @getData()))

  getData: => news: @model.toJSON()

  deleteNews: (e) =>
    e.preventDefault()
    data = $(e.target).data()

    news = @model.get(data.newsId)
    news.destroy()
    @render()

  addNews: (e) =>
    e.preventDefault()

    news = new App.Models.News(title: @$el.find("#news_title").val(), body: @$el.find("#news_body").val())
    @model.add(news)
    news.save()

    @render()

