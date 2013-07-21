translations = new List
translations.fetch
  url: 'translations'
  async: false
  error: (data) ->
    #console.log 'fetch error!!'
    #console.log data
  success: (data) ->
    #console.log 'fetch data:'
    #console.log data

app = new AppView
router = new Router

Backbone.history.start()