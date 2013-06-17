class Item extends Backbone.Model

  defaults:
    manisch: 'übersetzung fehlt'
    german: 'übersetzung fehlt'



class List extends Backbone.Collection

  model: Item

  byCategory: (categoryName) ->
    #@functionLog 'byCategory('+categoryName+')'

    # TODO: Da muss es einen einfacheren Weg geben. Sowas in richtung: @where({categorie: ...u.a. foobar... })
    # TODO: teste das hier: console.log @where({categorie: ...u.a. foobar... })
    result = new List
    _.each @models, (item) =>
      currentItem = item
      _.each item.get('category'), (categorie) =>
        if categorie == categoryName
          result.add currentItem
    return result

  search: (searchParam) ->
    if !searchParam
      return this

    byInput = (element, index, array) =>
      attributes = element.toJSON()
      #regEx = eval('/'+searchParam.toLowerCase()+'/g')
      pattern = RegExp(searchParam.toLowerCase())
      return attributes.german.toLowerCase().match(pattern) || attributes.manisch.toLowerCase().match(pattern)

    filtered = new List @filter byInput

    filtered

    # TODO: Brauche eine einfachere lösung

    #result = @where({german: searchParam})
    #return result




class ItemView extends Backbone.View

  tagName: 'li'

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
    _.templateSettings =
      interpolate : /\{\{(.+?)\}\}/g

    # TODO: Hier muss noch performance optimiert werden. Gendering von viellen elementen dauert noch zu lange.

    jQuery(@el).html( _.template(@template, @model.toJSON()) )

    @

  unrender: ->
    #@functionLog 'unrender()'
    $(@el).remove()

class pxwrkHelpersForViews extends Backbone.View

  functionLog: (name) ->
    console.log name

  valueHasChanged: ( ->
    latestValue = []
    return (value, id) ->
      if value == latestValue[id]
        result = false
      else
        latestValue[id] = value
        result = true

      return result
  )()

class AppView extends pxwrkHelpersForViews

  el: '#list'

  translations: new List

  visibleTranslations: new List

  getItemsBySearch: (searchParam = false) ->
    @functionLog 'getItemsBySearch('+searchParam+')'

    @removeAllItems()

    searchResult = @visibleTranslations.search(searchParam)

    _.each searchResult.models, (item) =>
      @appendItem(item)



  getItemsByCategory: (categoryName) ->
    @functionLog 'getItemsByCategory()'

    jQuery('.sort.active').removeClass 'active'
    jQuery('#'+categoryName).addClass 'active'

    @removeAllItems()

    if categoryName == 'all'
      @appendItems(@translations)
    else
      @appendItems(@translations.byCategory(categoryName))

  appendItem: (item) ->
    @functionLog 'appendItem()'

    item_view = new ItemView
      model: item

    $(@el).append( item_view.render().el )

  appendItems: (collection) ->
    @visibleTranslations = collection
    _.each collection.models, (item) =>
      item.set 'currentlyVisible', true
      @appendItem(item)

  removeAllItems: ->
    _.each @translations.models, (item) ->
      item.set 'currentlyVisible', false
    $(@el).html('')

  setFocusToFirstInput: ->
    jQuery('input:visible:first:text').focus()

  searchTimeout: false

  stopSearch: ->
    console.log 'stopSearch'
    clearTimeout @searchTimeout

  render: ->
    @functionLog 'render()'

    @getItemsByCategory('all')

    jQuery('.sort').on 'click', (event) =>
      @stopSearch()
      jQuery('#search').val('')
      @setFocusToFirstInput()
      categoryName = jQuery(event.target).attr('id')
      @getItemsByCategory(categoryName)

    @setFocusToFirstInput()

    jQuery('#search').on 'keyup', (event) =>

      val = jQuery(event.target).val()
      id = jQuery(event.target).attr('id')


      if @valueHasChanged(val, id)
        if val == ''
          clearTimeout @searchTimeout
          @getItemsBySearch()
        else
          clearTimeout @searchTimeout
          @searchTimeout = setTimeout =>
            @getItemsBySearch(val)
          , 10

  events:
    # TODO: hier stimmt irgendwas nicht... die events funktionieren nicht
    # TODO: das click .sort element ist doppelt ( jQuery(...).on 'click' ... )
    'click .sort': 'getItemsByCategory'

  initialize: ->
    @functionLog 'initialize()'
    _.bindAll @

    @translations.fetch
      url: 'content/manisch.json'
      success: =>
        @appendItems(@translations)

    @render()

App = new AppView