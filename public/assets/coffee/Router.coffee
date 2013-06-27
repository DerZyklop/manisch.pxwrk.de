Router = Backbone.Router.extend

  routes:
    "cat/:categoryName": "cat"
    "cat/:categoryName/search/:searchval": "search"
    "cat/:categoryName/item/:itemid": "item"


  currentCat: (->
    currentCategory = 'alle'
    return {
      set: (newCat) ->
        currentCategory = newCat
      get: ->
        currentCategory
    }
  )()


  cat: (categoryName) ->
    console.log 'cat()'

    app.categoryRequest(categoryName)
    app.listView.render()

    @currentCat.set(categoryName)


  search: (categoryName, searchval = '') ->
    console.log 'search()'

    app.categoryRequest(categoryName)
    app.searchRequest(searchval, 'search')
    app.listView.render()

    @currentCat.set(categoryName)


  item: (categoryName, itemId) ->
    console.log 'item('+categoryName+', '+itemId+')'

    app.categoryRequest(categoryName)
    app.itemRequest(itemId)
    app.listView.render()

    @currentCat.set(categoryName)


  initialize: ->
    that = this

    jQuery('#search').on 'keyup', ->
      url = 'cat/'+that.currentCat.get()
      if jQuery(this).val()
        url += '/search/'+jQuery(this).val()
      that.navigate url, {trigger: true}


router = new Router

Backbone.history.start()
