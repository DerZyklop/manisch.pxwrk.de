class Item extends Backbone.Model

  defaults:
    manisch: 'übersetzung fehlt'
    german: 'übersetzung fehlt'



class List extends Backbone.Collection

  model: Item

  byCategory: (categoryName) ->
    console.log 'byCategory('+categoryName+')'

    # TODO: Da muss es einen einfacheren Weg geben. Sowas in richtung: @where({categorie: ...u.a. foobar... })
    result = []
    _.each @models, (item) =>
      currentItem = item
      _.each item.get('category'), (categorie) =>
        #console.log currentItem
        if categorie == categoryName
          result.push currentItem
    return result



class ItemView extends Backbone.View

  tagName: 'li'

  counter: 0

  initialize: ->
    _.bindAll @

    jQuery.ajax
      url: 'site/templates/item.html'
      async: false
      dataType: 'html'
      success: (data) =>
        @template = data
      error: ->
        console.log 'error'

  render: ->
    _.templateSettings =
      interpolate : /\{\{(.+?)\}\}/g

    jQuery(@el).html( _.template(@template, @model.toJSON()) )

    @

  unrender: ->
    console.log 'unrender()'
    $(@el).remove()

class AppView extends Backbone.View

  el: '#list'

  collection: new List

  initialize: ->
    console.log 'initialize()'
    _.bindAll @

    @counter = 0
    @translations = new List
    @translations.fetch
      url: 'content/manisch.json'
      success: =>
        @appendAllItems()

    @render()

  events:
    'click .sort': 'getItemsByCategory'

  render: ->
    console.log 'render()'

    @getItemsByCategory('all')

    jQuery('.sort').on 'click', (event) =>
      categoryName = jQuery(event.target).attr('id')
      @getItemsByCategory(categoryName)

    searchTimeout = false
    jQuery('#search').on 'keyup', (event) =>
      searchParam = jQuery(event.target).val()
      clearTimeout searchTimeout
      searchTimeout = setTimeout =>
        @getItemsBySearch(searchParam)
      , 2000

  appendAllItems: () ->
    console.log @translations.models
    _.each @translations.models, (item) =>
      @appendItem(item)

  appendItem: (item) ->
    console.log 'appendItem()'

    if !item.get 'counter'
      @counter++
      item.set
        counter: @counter

    item_view = new ItemView
      model: item

    $(@el).append( item_view.render().el )

  removeAllItems: ->
    $(@el).html('')

  getItemsBySearch: (searchParam) ->
    console.log searchParam

  getItemsByCategory: (categoryName) ->
    console.log 'getItemsByCategory()'

    jQuery('.sort.active').removeClass 'active'
    jQuery('#'+categoryName).addClass 'active'

    @removeAllItems()

    if categoryName == 'all'
      @appendAllItems()
    else
      _.each @translations.byCategory(categoryName), (item) =>
        @appendItem(item)


App = new AppView