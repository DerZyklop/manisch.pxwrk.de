class AppView extends pxwrkHelpersForViews

  list: new ListView

  setFocusToFirstInput: ->
    jQuery('input:visible:first:text').focus()

  searchTimeout: false

  stopSearch: ->
    console.log 'stopSearch'
    clearTimeout @searchTimeout

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


App = new AppView