class AppView extends pxwrkHelpersForViews

  list: new ListView

  navHeight: jQuery('#secondary .top-bar').offset().top

  setFocusToFirstInput: ->
    #jQuery('input:visible:first:text').focus()

  searchTimeout: false

  stopSearch: ->
    clearTimeout @searchTimeout

  performScrollCheck: () ->
    if jQuery('body').hasClass('fixsearch')

      if jQuery(window).scrollTop() < @navHeight
        jQuery('body').removeClass('fixsearch')

    else

      if jQuery(window).scrollTop() > @navHeight
        jQuery('body').addClass('fixsearch')

  checkNavHeight: ->
    jQuery('body').removeClass('fixsearch')
    @navHeight = jQuery('#secondary .top-bar').offset().top

  searchRequest: (target) ->
    @functionLog 'searchRequest()'
    val = jQuery(target).val()
    id = jQuery(target).attr('id')


    if @valueHasChanged(val, id)

      if val == ''
        clearTimeout @searchTimeout
        @list.getItemsBySearch()
      else
        clearTimeout @searchTimeout
        @searchTimeout = setTimeout =>
          @list.getItemsBySearch(val)
        , 10

  categoryRequest: (category) ->
      @stopSearch()
      jQuery('#search').val('')
      @setFocusToFirstInput()

      @list.getItemsByCategory(category)

      jQuery('.active').removeClass 'active'
      jQuery('#'+category+'-btn').addClass 'active'

  #events:
    # TODO: hier stimmt irgendwas nicht... die events funktionieren nicht
    # TODO: das click .sort element ist doppelt ( jQuery(...).on 'click' ... )
    #'click .sort': 'getItemsByCategory'

  initialize: ->
    @functionLog 'initialize()'
    _.bindAll @

    @list.allTranslations.fetch
      url: 'content/manisch.json'
      async: false

    @setFocusToFirstInput()

    jQuery('#search').on 'keyup', (event) =>
      @searchRequest(event.target)


    jQuery(window).on 'scroll', =>
      @performScrollCheck()

    jQuery(window).on 'resize', =>
      @checkNavHeight()
      @performScrollCheck()


    setTimeout ->
      jQuery('body').animate({scrollTop: jQuery('#secondary .top-bar').offset().top}, 400)
    , 500



Router = Backbone.Router.extend

  routes:
    ":cat": "cat"

  cat: (category) ->
    console.log 'GO!!!!!!'
    @app.categoryRequest(category)

  initialize: ->
    @app = new AppView

  search: (query, page) ->

router = new Router


router.on 'route:alle', ->
  console.log 'arg'


Backbone.history.start()
