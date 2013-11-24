describe 'class PxwrkViewLib', ->

  pxwrkViewLib = new PxwrkViewLib

  it 'should be defined', ->
    expect(pxwrkViewLib).toBeDefined()

  describe 'itemDetailTmpl', ->
    it 'contained html should have ".content"', ->
      expect(jQuery(pxwrkViewLib.itemDetailTmpl).hasClass('content')).toBe(true)

  describe 'itemTmpl', ->
    it 'contained html should contain ".manisch" and ".german"', ->
      expect(jQuery(pxwrkViewLib.itemTmpl).find('.manisch').length).toBe(1)
      expect(jQuery(pxwrkViewLib.itemTmpl).find('.german').length).toBe(1)