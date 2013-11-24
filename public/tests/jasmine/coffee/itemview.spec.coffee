describe 'class ItemView', ->
  itemView = ''



  describe 'when view is initialized without model', ->
    it 'should throw exception', ->

      expect( ->
        new ItemView()
      ).toThrow()

  describe 'when model.constructor.name is not a "Item"', ->
    it 'should throw exception', ->

      expect( ->
        new ItemView
          model: '3'
      ).toThrow()



  beforeEach ->
    itemView = new ItemView
      model: new Item
        manisch: 'Moss'
        german: 'Mädchen'
        id: '4'


  it 'should be defined', ->
    expect(itemView).toBeDefined()

  describe 'render()', ->

    beforeEach ->
      itemView = new ItemView
        model: new Item
          manisch: 'Moss'
          german: 'Mädchen'
      itemView.render()

    it 'should contain the translations', ->
      expect(itemView.$el.html()).toMatch(itemView.model.get('manisch'))
      expect(itemView.$el.html()).toMatch(itemView.model.get('german'))


  describe 'renderItemDetailView()', ->

    it 'should contain the translations', ->
      detailItem = itemView.renderItemDetailView()
      html = detailItem.$el.html()
      expect(html).toMatch(itemView.model.get('manisch'))
      expect(html).toMatch(itemView.model.get('german'))


  describe 'unrender()', ->
    pxwrk.functionLog 'unrender()'

