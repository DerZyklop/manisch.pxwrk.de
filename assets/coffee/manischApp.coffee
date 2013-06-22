class AppView extends pxwrkHelpersForViews

  list: new ListView

  setFocusToFirstInput: ->
    jQuery('input:visible:first:text').focus()

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

  events:
    # TODO: hier stimmt irgendwas nicht... die events funktionieren nicht
    # TODO: das click .sort element ist doppelt ( jQuery(...).on 'click' ... )
    'click .sort': 'getItemsByCategory'

  performSearch: (event) ->
    val = jQuery(event.target).val()
    id = jQuery(event.target).attr('id')


    if @valueHasChanged(val, id)

      if val == ''
        clearTimeout @searchTimeout
        performSearchResult = @list.getItemsBySearch()
        @list.appendItems(performSearchResult)
      else
        clearTimeout @searchTimeout
        @searchTimeout = setTimeout =>
          performSearchResult = @list.getItemsBySearch(val)
          @list.appendItems(performSearchResult)
        , 10

  initialize: ->
    @functionLog 'initialize()'
    _.bindAll @

    @list.allTranslations.fetch
      url: 'content/manisch.json'
      success: (model) =>
        #@list.appendItems(@list.allTranslations)

    @list.render(@list.getItemsByCategory('all'))

    @setFocusToFirstInput()

    jQuery('.sort').on 'click', (event) =>
      @stopSearch()
      jQuery('#search').val('')
      @setFocusToFirstInput()
      categoryName = jQuery(event.target).attr('id')
      @list.appendItems( @list.getItemsByCategory(categoryName) )

    jQuery('#search').on 'keyup', (event) =>
      @performSearch(event)






    @navHeight = jQuery('#secondary .top-bar').offset().top


    jQuery(window).on 'scroll', =>
      @performScrollCheck()


    jQuery(window).on 'resize', =>
      jQuery('body').removeClass('fixsearch')
      @navHeight = jQuery('#secondary .top-bar').offset().top
      @performScrollCheck()


    setTimeout ->
      jQuery('body').animate({scrollTop: jQuery('#secondary .top-bar').offset().top}, 400)
    , 500



App = new AppView