class ItemDetailView extends pxwrkHelpersForViews

  tagName: 'div'

  id: 'dark-overlay'

  initialize: ->
    _.bindAll @

  events:
    'click': 'unrender'

  itemDetail: ->
    console.log 'itemDetail()'

  render: ->
    jQuery('body').append @el

    # TODO: In css-datei auslagern
    jQuery(@el).css
      'background':'#000'
      'z-index':'200'
      'position':'fixed'
      'top':'0'
      'bottom':'0'
      'left':'0'
      'right':'0'

  unrender: ->
    # TODO: Beim zweiten mal klappts nicht mehr
    jQuery('#dark-overlay').remove()
