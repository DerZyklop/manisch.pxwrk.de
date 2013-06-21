class ItemView extends pxwrkHelpersForViews

  tagName: 'li'

  className: (->
    counter = 0
    return ->
      counter++
      if counter%2 == 0
        return 'even'
      else
        return 'odd'
  )()

  initialize: ->
    _.bindAll @

    jQuery.ajax
      url: 'site/templates/item.html'
      async: false
      dataType: 'html'
      success: (data) =>
        @template = data
      error: ->
        #@functionLog 'error'

  render: ->
    #_.templateSettings.interpolate : /\{\{(.+?)\}\}/g

    # TODO: Hier muss noch performance optimiert werden. Gendering von viellen elementen dauert noch zu lange.

    jQuery(@el).html( _.template( @template, @model.toJSON() ) )

    @

  unrender: ->
    #@functionLog 'unrender()'
    $(@el).remove()