class AppView extends pxwrkHelpersForViews

  list: new ListView

  setFocusToFirstInput: ->
    jQuery('input:visible:first:text').focus()

  searchTimeout: false

  stopSearch: ->
    console.log 'stopSearch'
    clearTimeout @searchTimeout

  performScrollCheck: (navHeight) ->
    if jQuery('body').hasClass('fixsearch')

      if jQuery(window).scrollTop() < navHeight
        jQuery('body').removeClass('fixsearch')

    else

      if jQuery(window).scrollTop() > navHeight
        jQuery('body').addClass('fixsearch')

  events:
    # TODO: hier stimmt irgendwas nicht... die events funktionieren nicht
    # TODO: das click .sort element ist doppelt ( jQuery(...).on 'click' ... )
    'click .sort': 'getItemsByCategory'

  initialize: ->
    @functionLog 'initialize()'
    _.bindAll @

    @list.allTranslations.fetch
      url: 'content/manisch.json'
      success: (model) =>
        @list.appendItems(@list.allTranslations)

    @list.render(@list.getItemsByCategory('all'))

    @setFocusToFirstInput()

    jQuery('.sort').on 'click', (event) =>
      @stopSearch()
      jQuery('#search').val('')
      @setFocusToFirstInput()
      categoryName = jQuery(event.target).attr('id')
      @list.appendItems( @list.getItemsByCategory(categoryName) )

    jQuery('#search').on 'keyup', (event) =>

      val = jQuery(event.target).val()
      id = jQuery(event.target).attr('id')


      if @valueHasChanged(val, id)

        if val == ''
          clearTimeout @searchTimeout
          @list.getItemsBySearch()
        else
          clearTimeout @searchTimeout
          @searchTimeout = setTimeout =>
            @list.getItemsBySearch(val)
          , 10





    navHeight = jQuery('.search-wrap').offset().top


    jQuery(window).on 'scroll', =>
      @performScrollCheck(navHeight)


    jQuery(window).on 'resize', =>
      jQuery('body').removeClass('fixsearch')
      navHeight = jQuery('.search-wrap').offset().top
      @performScrollCheck(navHeight)


    setTimeout ->
      jQuery('body').animate({scrollTop: jQuery('.search-wrap').offset().top}, 400)
    , 500

App = new AppView