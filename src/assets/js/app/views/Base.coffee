App.Views.Base ||= {}

class App.Views.Base.BaseView extends Backbone.View
  serializeForm: (selector) =>
    return _.reduce($(selector).serializeArray(), (memo, v) ->
      if v.name.indexOf("[]") > 1
        memo[v.name.replace(/\[\]/, '')] ?= []
        memo[v.name.replace(/\[\]/, '')].push(v.value)
      else
        memo[v.name] = v.value

      memo
    , {});

  buildValidation: ($el, selector, rules) ->
    return $el.find(selector).validate(
      errorElement: "span"

      highlight: (el, errorClass) ->
        $(el).parent().addClass(errorClass)

      unhighlight: (el, errorClass) ->
        $(el).parent().removeClass(errorClass)

      rules: rules
    )

  getData: =>
    return @model.toJSON()
