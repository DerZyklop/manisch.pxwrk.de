class ItemDetailView extends pxwrkHelpersForViews

  tagName: 'div'

  id: 'item-detail-view'

  events:
    'click': 'unrenderCheck'
    'click a': 'unrender'
    'click .close': 'unrender'


  fadeDuration = 0

  itemHtml: ->
    _.template( @itemTmpl, @model.toJSON() )
  viewHtml: ->
    if @model
      item = _.template @itemDetailTmpl, 
        content: @itemHtml()
        item: @model.toJSON()
    else
      item = _.template @itemDetailTmpl, 
        content: 'Ulai! Isch kann die Übersetzung net finde. Da fällt mer <a href="#cat/alle/search/härles/">härles</a> aach ke <a href="#cat/alle/search/linkeresko/">linkeresko</a> ei!'
        more: '(Hier kommt später eine Share-Funktion für Facebook und Twitter)'

  initialize: ->
    _.bindAll @

    jQuery(document).on 'keyup', (event) =>
      if event.keyCode == 27
        @unrender()

  render: ->
    jQuery(@el).html(@viewHtml())

  show: ->
    @render()

    url = router.getNewUrl()

    if @model
      url += 'item/'+@model.toJSON().id

    router.navigate(url, {trigger: false})

    @$el.css 'display', 'none'
    jQuery('body').append @el
    @$el.fadeIn fadeDuration
    @$el.find('.button').focus()

  unrenderCheck: (event) ->
    if event.target.id == 'item-detail-view'
      @unrender(event)

  unrender: (event) ->
    jQuery(document).off 'keyup'

    @$el.fadeOut fadeDuration, ->
      @remove()

      url = router.getNewUrl()
      router.navigate(url, {trigger: false})
