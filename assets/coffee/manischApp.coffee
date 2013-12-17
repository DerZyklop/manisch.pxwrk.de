pxwrk = new PxwrkLib

translations = new List
translations.fetch
  error: (data) ->
    #console.log 'fetch error!!'
    #console.log data
  success: (data) ->
    #console.log 'fetch data:'
    #console.log data

app = new AppView
app.render()
router = new Router

Backbone.history.start()