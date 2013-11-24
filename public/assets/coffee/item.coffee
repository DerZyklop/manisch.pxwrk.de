class Item extends Backbone.Model

  defaults:
    id: 'Fehler! ID fehlt'

  initialize: ->
    if not @get 'manisch'
      throw new Error 'manisch translation is missing'

    if not @get 'german'
      throw new Error 'german translation is missing'
