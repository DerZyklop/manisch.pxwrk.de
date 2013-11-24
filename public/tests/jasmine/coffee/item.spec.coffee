describe 'class Item', ->

  describe 'create instance', ->
    item = new Item
      manisch: 'Moss'
      german: 'Mädchen'

    it 'should be defined', ->
      expect(item).toBeDefined()

  describe 'create instance with missing manisch translation', ->
    it 'should throw an error', ->

      expect( ->
        item = new Item
          german: 'Mädchen'
      ).toThrow()

  describe 'create instance with missing german translation', ->
    it 'should throw an error', ->

      expect( ->
        item = new Item
          manisch: 'Moss'
      ).toThrow()