class List extends Backbone.Collection

  model: Item
  url: '/content/translations'

  fetch: (options) ->
    options = options || {}
    options.async = false
    super(options)

  category: (categoryName) ->
    #pxwrk.functionLog 'byCategory('+categoryName+')'

    if categoryName == 'alle'
      result = @

    else

      itemByCategory = (item) ->
        return _.contains(item.get('category'), categoryName)

      result = new List
      result.add @filter(itemByCategory)

    return result

  search: (param) ->
    if !param
      return this

    byInput = (element, index, array) =>
      attributes = element.toJSON()
      #regEx = eval('/'+searchParam.toLowerCase()+'/g')
      pattern = RegExp(param.toLowerCase())
      return attributes.german.toLowerCase().match(pattern) || attributes.manisch.toLowerCase().match(pattern)

    filtered = new List @filter byInput

    filtered
