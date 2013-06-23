class AppView extends pxwrkHelpersForViews

  listView: new ListView

  navHeight: jQuery('#secondary .top-bar').offset().top

  setFocusToFirstInput: ->
    #jQuery('input:visible:first:text').focus()

  checkNavHeight: ->
    jQuery('body').removeClass('fixsearch')
    @navHeight = jQuery('#secondary .top-bar').offset().top

  performScrollCheck: () ->
    if jQuery('body').hasClass('fixsearch')

      if jQuery(window).scrollTop() < @navHeight
        jQuery('body').removeClass('fixsearch')

    else

      if jQuery(window).scrollTop() > @navHeight
        jQuery('body').addClass('fixsearch')


  searchRequest: (val, id) ->
    @functionLog 'searchRequest()'

    if jQuery('#search').val() != val
      jQuery('#search').val(val)

    if @valueHasChanged(val, id)

      if val == ''
        @listView.getItemsBySearch()
      else
        @listView.getItemsBySearch(val)


  categoryRequest: (category) ->
    jQuery('#search').val('')
    @setFocusToFirstInput()

    @listView.getItemsByCategory(category)

    jQuery('.active').removeClass 'active'
    jQuery('#'+category+'-btn').addClass 'active'


  itemRequest: (itemId) ->

    @listView.openItemDetail(itemId)


  #events:
    # TODO: hier stimmt irgendwas nicht... die events funktionieren nicht
    # TODO: das click .sort element ist doppelt ( jQuery(...).on 'click' ... )
    #'click .sort': 'getItemsByCategory'

  initialize: ->
    @functionLog 'initialize()'
    _.bindAll @

    @listView.allTranslations.fetch
      url: 'content/manisch.json'
      async: false
      error: ->
        console.log 'fetch error!!'
      success: (data) ->
        console.log 'fetch data:'
        console.log data

    @setFocusToFirstInput()

    jQuery(window).on 'scroll', =>
      @performScrollCheck()

    jQuery(window).on 'resize', =>
      @checkNavHeight()
      @performScrollCheck()


    setTimeout ->
      jQuery('body').animate({scrollTop: jQuery('#secondary .top-bar').offset().top}, 400)
    , 500

app = new AppView