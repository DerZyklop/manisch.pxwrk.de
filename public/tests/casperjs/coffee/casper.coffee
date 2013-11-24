casper = require('casper').create()



casper.log('this is a debug message', 'debug')
casper.log('and an informative one', 'info')
casper.log('and a warning', 'warning')
casper.log('and an error', 'error')


casper.test.begin "Manisch Wörterbuch Tests", (test) ->

  baseUrl = 'http://localhost:8080/'

  listLength = ->
    jQuery('#list-view li').length

  casper.start baseUrl, ->

    @echo("URL: "+casper.getCurrentUrl(), 'INFO')

    test.comment("HTTP-Stuff checken")

    test.assertHttpStatus(200, 'Seite erreichbar')
    test.assertResourceExists (resource) ->
      resource.url.match("app.min.js")
    , "app.min.js vorhanden"

    test.comment("DOM-Stuff checken")

    test.assertTitleMatch /Manisch/, "Titel enthält 'Manisch'"
    test.assertExists "#primary", "#primary vorhanden"
    test.assertExists "#secondary", "#secondary vorhanden"
    test.assertExists "#list-view", "#list-view vorhanden"
    test.assertExists "#search", "#search vorhanden"

    resultListLength = @evaluate listLength
    test.assertFalsy resultListLength, "#list-view ist leer"
    this.click('#alle-btn')

  casper.then ->

    @echo("#alle-btn wurde geklickt")
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')

    test.assertUrlMatch /alle/, 'neue URL enthält /alle/'

    resultListLength = @evaluate listLength

    test.assertTruthy resultListLength > 1, "#list-view enthält mehr als ein Ergebnis"

    @fill('#searchform', { 'search': 'moss' }, false)

    @echo('"moss" wurde in das Suchfeld eingetragen')
    test.assertField 'search', 'moss', 'Suchfeld enthält "moss"'
    newResultListLength = @evaluate listLength
    test.assert newResultListLength < resultListLength, 'Ergebnisliste ist nach Suche kleiner geworden'

    @fill('#searchform', { 'search': 'moss' }, true)

    @echo("#searchform wurde submitted")

    newerResultListLength = @evaluate listLength
    test.assert newerResultListLength == newResultListLength, 'Ergebnisliste gleich geblieben'

    this.click('#random-btn')

  casper.then ->

    @echo("#random-btn wurde geklickt")
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')

    test.assertUrlMatch(/item/, 'url enthält /item/')

    test.assertExists('#item-detail-view')
    test.assertVisible('#item-detail-view')

    this.click('#item-detail-view')
    test.assertNotVisible('#item-detail-view')







  getFirstResult = ->
    jQuery('#list-view li').first().find('.manisch').html()

  foo = ''
  bar = ''

  casper.then ->
    @echo("[BEGIN] event-listenerBug", 'WARNING')

    this.click('#stadtbekannt-btn')
  casper.then ->
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')
    bar = @evaluate getFirstResult
    @echo bar
    test.assertNotEquals foo, bar
    @fill('#searchform', { 'search': 'mo' }, false)



    this.click('#nomen-btn')
  casper.then ->
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')
    foo = @evaluate getFirstResult
    @echo foo
    test.assertNotEquals foo, bar



    this.click('#stadtbekannt-btn')
  casper.then ->
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')
    bar = @evaluate getFirstResult
    @echo bar
    test.assertNotEquals foo, bar
    @fill('#searchform', { 'search': 'mo' }, false)



    this.click('#nomen-btn')

  casper.then ->
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')
    foo = @evaluate getFirstResult
    @echo foo
    test.assertNotEquals foo, bar



    this.click('#stadtbekannt-btn')
  casper.then ->
    @echo("URL: "+casper.getCurrentUrl(), 'INFO')
    bar = @evaluate getFirstResult
    @echo bar
    test.assertNotEquals foo, bar

  casper.then ->


    @echo("[END] event-listenerBug", 'WARNING')


  casper.then ->

    test.done()


































# Assert overview
# casper.then ->
#   casper.test.begin "API", (test) ->

#     testFunc1 = ->
#       return true
#     testFunc2 = ->
#       return 'foobar'
#     testFunc3 = ->
#       return false

#     # HTTP
#     test.assertHttpStatus(200, 'assertHttpStatus is 200')
#     test.assertUrlMatch(/^http:\/\//)
#     test.assertResourceExists (resource) ->
#       resource.url.match('backbone.js')

#     # true / false
#     test.assert(true, 'true is true')
#     test.assertNot(false, 'false is false')

#     # Comparison
#     test.assertEquals(true, true, 'true equals true')
#     test.assertNotEquals('irgendwas', 'irgnedwas anderes')
#     test.assertTruthy(testFunc1())
#     test.assertFalsy(testFunc3())
#     test.assertEval(testFunc1)
#     test.assertEvalEquals(testFunc2, 'foobar')

#     # Type
#     test.assertType(testFunc2(), 'string')

#     # DOM
#     #test.assertTitle('Mein Titel')
#     #test.assertTitleMatch(/Mein/)

#     test.assertExists('body')
#     test.assertDoesntExist('#hitler')

#     test.assertMatch('Chuck Norris', /^chuck/i, 'Chuck Norris\' first name is Chuck')
#     #test.assertSelectorHasText('title', 'Mein Titel')
#     test.assertSelectorDoesntHaveText('title', 'NPD Webseite')
#     test.assertVisible('body')
#     test.assertNotVisible('#stressiger_flashbanner')
#     casper.start 'http://www.pxwrk.de/', ->
#       test.assertTextExists('Impressum')
#       test.assertTextDoesntExist('Ausländer Raus!')
#     test.assertElementCount('h1', 1)
#     casper.start 'http://www.google.de/', ->
#         this.fill('form', { q: 'plop' }, false)
#         test.assertField('q', 'plop')

#     # LOG
#     test.comment("Hi, I'm a comment")
#     test.error("Hi, I'm an error")
#     test.fail("Georges W. Bush")

#     # Other
#     test.assertRaises ->
#         throw new Error('thrown')
#       , [true], 'Error has been raised.'

#     test.done()


casper.run()