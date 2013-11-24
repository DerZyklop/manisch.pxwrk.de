describe 'class AppView', ->

  view = undefined

  beforeEach ->
    view = new AppView

  describe 'create instance', ->

    it 'should be defined', ->
      expect(view).toBeDefined()


  describe 'render()', ->

    it 'should create #primary and #secondary', ->

      primary = app.render().$el.find('#primary').length
      secondary = app.render().$el.find('#secondary').length

      expect(primary).toBeGreaterThan(0)
      expect(secondary).toBeGreaterThan(0)



