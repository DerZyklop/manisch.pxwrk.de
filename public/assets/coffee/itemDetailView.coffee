class ItemDetailView extends pxwrkHelpersForViews

  tagName: 'div'

  id: 'item-detail-view'

  events:
    'click': 'unrender'

  initialize: ->
    _.bindAll @

    contentDiv = jQuery('<div>').addClass('content')

    url = router.getNewUrl()

    if @model
      item = '<li>'+_.template( @itemTmpl, @model.toJSON() )+'</li>'
      url += '/item/'+@model.toJSON().id
    else
      item = '<li>Ulai! Isch kann die Übersetzung net finde. Da fällt mer härles aach ke linkeresko ei!</li>'

    router.navigate(url)

    insights = jQuery('<ul>').html(item).after('<div><br />(Hier kommt später eine Share-Funktion für Facebook und Twitter)<br /><br /></div>')

    jQuery(contentDiv).html(insights)
    jQuery(@el).html(contentDiv)

  render: ->
    jQuery('body').append @el

  unrender: (event) ->
    if event.target.id == 'item-detail-view'
      @remove()