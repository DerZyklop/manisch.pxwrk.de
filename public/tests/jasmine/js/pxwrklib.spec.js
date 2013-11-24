// Generated by CoffeeScript 1.6.3
(function() {
  describe('class PxwrkLib', function() {
    var pxwrkLib;
    pxwrkLib = new PxwrkLib;
    it('should be defined', function() {
      return expect(pxwrkLib).toBeDefined();
    });
    describe('functionLog()', function() {
      return it('should return the functionName', function() {
        return expect(pxwrkLib.functionLog('nameOfFunction')).toBe('nameOfFunction');
      });
    });
    return describe('valueHasChanged()', function() {
      var myVar;
      myVar = {};
      beforeEach(function() {
        myVar = {
          id: 'verySpecialId',
          value: 'foo'
        };
        return pxwrkLib.valueHasChanged(myVar.value, myVar.id);
      });
      describe('when value has changed', function() {
        return it('should be true', function() {
          myVar.value = 'bar';
          return expect(pxwrkLib.valueHasChanged(myVar.value, myVar.id)).toBe(true);
        });
      });
      return describe('when value hasn\'t changed', function() {
        return it('should be false', function() {
          return expect(pxwrkLib.valueHasChanged(myVar.value, myVar.id)).toBe(false);
        });
      });
    });
  });

}).call(this);
