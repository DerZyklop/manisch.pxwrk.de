class Router extends Backbone.Router

  routes:
    "(cat/:category)(/)(search/:search)/": "showFilteredList"
    "random/": "showRandomItems"
    "(cat/:category/)(search/:search/)item/:itemid": "showItem"




  beforeNavigate: (params) ->
    jQuery('.active').removeClass 'active'
    jQuery('#'+params.category+'-btn').addClass 'active'


  getNewUrl: ->
    console.log 'getNewUrl'
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

    console.log 'showFilteredList'
    @currentCat.set(params.category)

    app.listView.unrender()
    app.listRequest(params)
    app.listView.render()


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
    console.log 'showRandomItems'

    app.randomItemRequest()


  showItem: (category, search, id) ->
    params =
      category: category
      search: search
      id: id

    @beforeNavigate(params)

    @showFilteredList(category, search)

    app.showItemDetail(params)