class List extends Backbone.Collection

  model: Item

  byCategory: (categoryName) ->
    #@functionLog 'byCategory('+categoryName+')'

    # TODO: Da muss es einen einfacheren Weg geben. Sowas in richtung: @where({categorie: ...u.a. foobar... })
    # TODO: teste das hier: console.log @where({categorie: ...u.a. foobar... })

    if categoryName == 'all'
      return @

    else

      result = new List

      _.each @models, (item) =>
        currentItem = item

        _.each item.get('category'), (categorie) =>
          if categorie == categoryName
            result.add currentItem

      return result

  search: (searchParam) ->
    if !searchParam
      return this

    byInput = (element, index, array) =>
      attributes = element.toJSON()
      #regEx = eval('/'+searchParam.toLowerCase()+'/g')
      pattern = RegExp(searchParam.toLowerCase())
      return attributes.german.toLowerCase().match(pattern) || attributes.manisch.toLowerCase().match(pattern)

    filtered = new List @filter byInput

    filtered

    # TODO: Brauche eine einfachere lösung

    #result = @where({german: searchParam})
    #return result
