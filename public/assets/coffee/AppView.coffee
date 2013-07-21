class AppView extends pxwrkHelpersForViews

  el: 'body'

  events:
    'keyup #search': 'performSearch'
    'keyup #primary': 'keyNav'

  listView: new ListView

  navHeight: jQuery('#secondary .top-bar').offset().top

  keyNav: (event) ->
    
    console.log @$el.find('#'+event.target.id).prev()

    el = @$el.find('#'+event.target.id)

    switch event.keyCode
      when 38
        el = el.prev()
        url = el.attr('href')
        router.navigate url, {trigger: true}
        el.focus()

        console.log 'hoch'
        return
      when 40
        el = el.next()
        url = el.attr('href')
        router.navigate url, {trigger: true}
        el.focus()

        console.log 'runter'
        return
      when 39
        console.log 'rechts'
        return
      when 37
        console.log 'links'
        return

  performSearch: (event) ->
    router.navigate router.getNewUrl(), {trigger: true}


  setFocusToFirstInput: ->
    #jQuery('input:visible:first:text').focus()


  checkNavHeight: ->
    jQuery('body').removeClass('fixsearch')
    @navHeight = jQuery('#secondary .top-bar').offset().top


  performScrollCheck: ->
    if jQuery('body').hasClass('fixsearch')

      if jQuery(window).scrollTop() < @navHeight
        jQuery('body').removeClass('fixsearch')

    else

      if jQuery(window).scrollTop() > @navHeight
        jQuery('body').addClass('fixsearch')


  listRequest: (params) ->
    @functionLog 'listRequest()'

    if jQuery('#search').val() != params.search
      jQuery('#search').val(params.search)

    if @valueHasChanged(params.search, 'search') || @valueHasChanged(params.category, 'category') 

      @listView.getFilteredList params


  randomItemRequest: ->
    jQuery('#search').val('')

    category = 'alle' || router.currentCat.get()

    params =
      category: category
      search: ''
      id: _.random(1, translations.length).toString()

    if !router.currentCat.get()
      @listRequest(params)
      @listView.render()

    @showItemDetail(params)


  showItemDetail: (params) ->

    items = translations.category('alle').search('')
    item = items.findWhere({id:params.id})

    itemDetailView = new ItemDetailView
      model: item
    itemDetailView.show()


  initialize: ->
    @functionLog 'initialize()'
    _.bindAll @

    @setFocusToFirstInput()

    jQuery(window).on 'scroll', =>
      @performScrollCheck()

    jQuery(window).on 'resize', =>
      @checkNavHeight()
      @performScrollCheck()

    setTimeout ->
      jQuery('body').animate({scrollTop: jQuery('#secondary .top-bar').offset().top}, 400)
    , 500