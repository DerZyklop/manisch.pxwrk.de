page = require('webpage').create()

jQuery = require('jquery')


describe "Maths", ->
    it "should add two numbers", ->
        result = utilityAdd(1, 2)
        expect(result).toEqual(3)

#jasmine = require('jasmine')


page.onConsoleMessage = (msg) ->
  console.log(msg)

console.log('[phantomjs] Loading page...')

page.open 'http://localhost:3030/', (status) ->
  if status != 'success'
    console.log('could not retrieve!')
  else
    page.includeJs 'http://localhost:3030/testing/jasmine/jasmine/jasmine.js', ->
      console.log('retrieved')

      page.evaluate ->
        console.log('[phantomjs] Querying for titles...')
        list = Array.prototype.slice.call(document.querySelectorAll('h1'), 0)
        console.log('[phantomjs] ' + list.length + ' titles:')
        #console.log(jQuery('body').html())

        describe 'click Schimpfwörter', ->
          jQuery('#schimpfwort-btn').trigger 'click'
          setTimeout ->
            console.log jQuery('#secondary .content').html()
          , 1000
          jQuery('#schimpfwort-btn').trigger 'click', ->
            console.log '"§§"§"§"§§"§""§'
            it 'should be defined', =>
              expect(true).toEqual(false)



        list.forEach (el) ->
          console.log '  ' + el.innerHTML.replace(/<.*?>/g, '')

      phantom.exit()



