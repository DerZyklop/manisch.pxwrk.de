describe 'class List', ->

  list = new List

  it 'should be defined', ->
    expect(list).toBeDefined()

  it 'should be possible to fetch items with options', ->
    list.fetch
      success: ->
        #console.log "everything's fine"
    expect(list.length).toBeGreaterThan(1)

  beforeEach ->
    list.fetch()

  describe 'fetch()', ->

    it 'should get more then one item', ->

      expect(list.length).toBeGreaterThan(1)


  describe "category()", ->

    it "should find as many 'alle' as length of list", ->
      newLength = list.category('alle').length
      expect(newLength).toEqual(list.length)

    it "should find less 'nomen' then 'alle'", ->
      newLength = list.category('nomen').length
      expect(newLength).toBeLessThan(list.length)


  describe "search()", ->

    it "should find a 'Moss' in the List", ->
      newLength = list.search('Moss').length
      expect(newLength).toBeLessThan(list.length)