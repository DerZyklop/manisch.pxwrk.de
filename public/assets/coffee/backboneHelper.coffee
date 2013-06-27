class pxwrkHelpersForViews extends Backbone.View

  functionLog: (name) ->
    console.log name

  valueHasChanged: ( ->
    latestValue = []
    return (value, id) ->
      if value == latestValue[id]
        result = false
      else
        latestValue[id] = value
        result = true

      return result
  )()

  itemTmpl: (->
    t = false
    return (=>
#      if t == false
#        jQuery.ajax
#          url: 'site/templates/item.html'
#          async: false
#          dataType: 'html'
#          success: (data) =>
#            t = data
#          error: =>
#            t = '<span id="itemview"><span class="german"><%- german %></span>&nbsp;<span class="manisch"><%- manisch %></span></span><div class="clearit"></div>'
      t = '<span id="itemview"><span class="german"><%- german %></span>&nbsp;<span class="manisch"><%- manisch %></span></span><div class="clearit"></div>'
      return t
    )()
  )()
