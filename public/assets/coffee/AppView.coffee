class AppView extends pxwrkHelpersForViews

  el: 'body'

  events:
    'keyup #search': 'performSearch'

  listView: new ListView

  navHeight: jQuery('#secondary .top-bar').offset().top

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

    params =
      category: router.currentCat.get()
      search: ''
      id: _.random(1, translations.length).toString()

    if params.category == 'alle'
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