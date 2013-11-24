describe 'class PxwrkLib', ->

  pxwrkLib = new PxwrkLib

  it 'should be defined', ->
    expect(pxwrkLib).toBeDefined()

  describe 'functionLog()', ->
    it 'should return the functionName', ->
      expect(pxwrkLib.functionLog('nameOfFunction')).toBe('nameOfFunction')

  describe 'valueHasChanged()', ->
    myVar = {}
    beforeEach ->
      myVar =
        id: 'verySpecialId'
        value: 'foo'
      pxwrkLib.valueHasChanged(myVar.value, myVar.id)

    describe 'when value has changed', ->
      it 'should be true', ->
        myVar.value = 'bar'
        expect(pxwrkLib.valueHasChanged(myVar.value, myVar.id)).toBe(true)

    describe 'when value hasn\'t changed', ->
      it 'should be false', ->
        expect(pxwrkLib.valueHasChanged(myVar.value, myVar.id)).toBe(false)