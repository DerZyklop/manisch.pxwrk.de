describe 'class Router', ->

  it 'TODO Router'

  beforeEach ->
    router = new Router


  describe 'click #stadtbekannt-btn', ->

    it 'should fill #list-view with some li\'s', ->

      app = router.showFilteredList('stadtbekannt')
      #console.log app.$el.find('#list-view').html()
      # listitems = app.render().$el.find('#list-view ul').length
      # console.log app.render().$el.find('#list-view').html()

      # setTimeout ->
      #   console.log app.render().$el.find('#list-view').html()
      # , 200

      # expect(listitems).toBeGreaterThan(0)

