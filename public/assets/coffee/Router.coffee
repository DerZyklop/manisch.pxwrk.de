class Router extends Backbone.Router

  routes:
    "(cat/:category)(/)(search/:search)/": "showFilteredList"
    "random/": "showRandomItems"
    "(cat/:category/)(search/:search/)item/:itemid": "showItem"




  beforeNavigate: (params) ->
    app.$el.find('#primary .active').removeClass 'active'
    app.$el.find('#'+params.category+'-btn').addClass 'active'
    #app.render()


  getNewUrl: ->
    pxwrk.functionLog 'getNewUrl'
    url = ''
    if @currentCat.get()
      url += 'cat/'+@currentCat.get()+'/'
    if jQuery('#search').val()
      url += 'search/'+jQuery('#search').val()+'/'
    return url




  showFilteredList: (category = 'alle', search = '') ->

    params =
      category: category
      search: search

    @beforeNavigate(params)

    pxwrk.functionLog 'showFilteredList'
    @currentCat.set(params.category)

    app.listView.unrender()
    app.listRequest(params)

    app.listView.render()

    #console.log app.listView.el
    app


  currentCat: (->
    currentCategory = false
    return {
      set: (newCat) ->
        currentCategory = newCat
      get: ->
        currentCategory
    }
  )()

  showRandomItems: ->
    pxwrk.functionLog 'showRandomItems'

    app.randomItemRequest()


  showItem: (category, search, id) ->
    params =
      category: category
      search: search
      id: id

    @beforeNavigate(params)

    @showFilteredList(category, search)

    app.showItemDetail(params)