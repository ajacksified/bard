#= require ./Base

App.Views.Application ||= {}

class App.Views.Application.ApplicationView extends App.Views.Base.BaseView
  events:
    'click a': 'route'

  initialize: (options) =>
    @render()

  render: =>
    #stub

  setView: (view, options) =>
    @view.undelegateEvents() if @view

    options = $.extend({}, { el: $("#container") }, options)
    @view = new view(options)
    @view.bind("changeRoute", (h) => @trigger("changeroute", h))

    @view

  route: (e) =>
    $target = $(e.currentTarget)
    noroute = $target.hasClass("noroute")

    if noroute
      e.preventDefault()
    else
      href = $target.attr("href")

      unless(href[0..3] == 'http' || $target.hasClass("direct"))
        e.preventDefault()
        @trigger("changeRoute", href)
