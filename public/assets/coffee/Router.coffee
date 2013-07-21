class Router extends Backbone.Router

  routes:
    "cat/:category(/search/:search)": "showFilteredList"
    "random": "showRandomItems"
    "cat/:category(/search/:search)/item/:itemid": "showItem"


  getNewUrl: ->
    console.log 'getNewUrl'
    url = 'cat/'+@currentCat.get()
    if jQuery('#search').val()
      url += '/search/'+jQuery('#search').val()
    return url


  showFilteredList: (category, search = '') ->
    console.log 'showFilteredList'
    @currentCat.set(category)

    app.listRequest
      category: category
      search: search
    app.listView.render()


  currentCat: (->
    currentCategory = 'alle'
    return {
      set: (newCat) ->
        currentCategory = newCat
      get: ->
        currentCategory
    }
  )()

  showRandomItems: ->
    console.log 'showRandomItems'
    #app.listView.unrender()
    #@currentCat.set('alle')

    #app.listView.unrender()

    app.randomItemRequest()
    app.randomView.render()


  showItem: (category, search, itemId) ->
    console.log 'showItem'
    @showFilteredList(category, search)

    app.showItemDetail
      category: category
      search: search
      id: itemId