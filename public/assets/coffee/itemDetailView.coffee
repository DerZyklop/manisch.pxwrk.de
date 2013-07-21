class ItemDetailView extends pxwrkHelpersForViews

  tagName: 'div'

  id: 'item-detail-view'

  events:
    'click': 'unrender'

  initialize: ->
    _.bindAll @

  render: ->
    contentDiv = jQuery('<div>').addClass('content')

    if @model
      item = '<li>'+_.template( @itemTmpl, @model.toJSON() )+'</li>'
    else
      item = '<li>Ulai! Isch kann die Übersetzung net finde. Da fällt mer härles aach ke linkeresko ei!</li>'

    insights = jQuery('<ul>').html(item)

    insights = insights.before('<div><div class="right">X</div><div class="clearit"></div></div>')

    #.after('<div><br />(Hier kommt später eine Share-Funktion für Facebook und Twitter)<br /><br /></div>')

    jQuery(contentDiv).html(insights)
    jQuery(@el).html(contentDiv)

  show: ->
    @render()

    url = router.getNewUrl()

    if @model
      url += '/item/'+@model.toJSON().id

    router.navigate(url, {trigger: false})

    @$el.css 'display', 'none'
    jQuery('body').append @el
    @$el.fadeIn 200

  unrender: (event) ->
    if event.target.id == 'item-detail-view'
      @$el.fadeOut 200, ->
        @remove()
  
        url = router.getNewUrl()
        router.navigate(url, {trigger: false})
