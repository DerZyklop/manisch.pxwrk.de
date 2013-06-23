class ItemDetailView extends pxwrkHelpersForViews

  tagName: 'div'

  id: 'item-detail-view'

  initialize: ->
    _.bindAll @

    contentDiv = jQuery('<div>').addClass('content')
    jQuery(@el).html( contentDiv )

    insights = jQuery('<ul>')

    if @model
      jQuery(insights).html('<li>'+_.template( @itemTmpl, @model.toJSON() )+'</li>')
      url = 'cat/'+router.currentCat.get()+'/item/'+@model.toJSON().id
      router.navigate(url)
    else
      jQuery(insights).html('<li>Ulai! Isch kann die Übersetzung net finde. Da fällt mer härles aach ke linkeresko ei!</li>')

    jQuery(contentDiv).html(insights)

#    msg = '<p>Hier ist der Link, falls du dieses Wort mit anderen teilen möchtest: <br />'+location.origin+'/#'+url+'</p>'
#
#    jQuery(contentDiv).append(msg)

  events:
    'click': 'unrender'

  itemDetail: ->
    console.log 'itemDetail()'

  render: ->
    jQuery('body').append @el

  unrender: ->

    url = 'cat/'+router.currentCat.get()
    router.navigate(url)

    @remove()