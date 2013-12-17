class PxwrkViewLib extends Backbone.View

  itemDetailTmpl: (->
    result = ''
    jQuery.ajax
      url: '/site/snippets/item-detail.html'
      async: false
      success: (data) ->
        result = data
    result
  )()

  itemTmpl: (->
    result = ''
    jQuery.ajax
      url: '/site/snippets/item.html'
      async: false
      success: (data) ->
        result = data
    result
  )()
