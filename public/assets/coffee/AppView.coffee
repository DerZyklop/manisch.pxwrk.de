class AppView extends PxwrkViewLib

  tmpl: (->
    result = ''
    jQuery.ajax
      url: '/site/templates/app.html'
      async: false
      success: (data) ->
        result = data
    result
  )()

  className: 'page-wrap'

  events:
    'keyup #search': 'performSearch'
    'change #search': 'performSearch'
    'submit #searchform': 'preventSubmit'
    'keyup #primary': 'keyNav'

  listView: new ListView

  render: ->
    pxwrk.functionLog 'AppView.render()'
    if @tmpl
      jQuery(@el).html( @tmpl )
    else
      jQuery(@el).html( 'Error: Missing Template' )
    @

  show: ->
    pxwrk.functionLog 'AppView.render()'
    jQuery('body#manischapp').html @el
    @

  navHeight: ->
    jQuery('#secondary .top-bar').offset()?.top

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

  isColored = false

  preventSubmit: (event) ->
    event.preventDefault()

    if !isColored
      isColored = true

      elements = jQuery('#itemview .german')

      jQuery.merge elements, jQuery('#itemview .manisch')

      backgroundColor = jQuery(elements[0]).css('color')

      elements.css('color', '#070')
      setTimeout ->
        elements.css
          'color': backgroundColor
        isColored = false
      , 500

  performSearch: (event) ->
    router.navigate router.getNewUrl(), {trigger: true}


  setFocusToFirstInput: ->
    #jQuery('input:visible:first:text').focus()


  performScrollCheck: ->
    currentNavHeight = @navHeight()
    if jQuery('body').hasClass('fixsearch')

      if currentNavHeight && jQuery(window).scrollTop() < currentNavHeight
        jQuery('body').removeClass('fixsearch')

    else

      if currentNavHeight && jQuery(window).scrollTop() > currentNavHeight
        jQuery('body').addClass('fixsearch')


  listRequest: (params) ->
    pxwrk.functionLog 'listRequest()'

    if jQuery('#search').val() != params.search
      jQuery('#search').val(params.search)

    if pxwrk.valueHasChanged(params.search, 'search') || pxwrk.valueHasChanged(params.category, 'category') 

      @listView.getFilteredList params



  clearSearchInput: ->
    jQuery('#search').val('')

  setRandomParams: ->
    if router.currentCat.get()
      category = router.currentCat.get()
    else
      category = 'alle'

    params =
      category: category
      search: ''
      id: _.random(1, translations.length).toString()

  loadListInBackground: (params) =>
    if !router.currentCat.get()
      @listRequest(params)
      @listView.render()

  randomItemRequest: ->
    params = @setRandomParams()

    @clearSearchInput()
    @loadListInBackground(params)
    @showItemDetail(params)



  showItemDetail: (params) ->

    items = translations.category('alle').search('')
    item = items.findWhere({id:params.id})

    itemDetailView = new ItemDetailView
      model: item
    itemDetailView.render().show()


  initialize: ->
    pxwrk.functionLog 'initialize()'
    _.bindAll @

    @render().show()

    @setFocusToFirstInput()

    jQuery(window).on 'scroll', =>
      @performScrollCheck()

    jQuery(window).on 'resize', =>
      jQuery('body').removeClass('fixsearch')
      @performScrollCheck()

  #  TODO: Fix on item-view
#    setTimeout ->
#      jQuery('body').animate({scrollTop: jQuery('#secondary .top-bar').offset().top}, 400)
#    , 500