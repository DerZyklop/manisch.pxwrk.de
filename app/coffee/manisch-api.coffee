mongo = require('mongodb')

Server = mongo.Server
Db = mongo.Db
BSON = mongo.BSONPure

server = Server('localhost', 27017, {auto_reconnect: true})

db = new Db('manischdb', server)

populateDB = ->

    translations = require '../data/manisch.json'

    db.collection 'translations', (err, collection) ->
      if !err
        collection.insert translations, {safe:true}, (err, result) ->
          if err
            throw err
      else
        throw err

db.open (err, db) ->
  if !err
    console.log 'Connected to the manischdb'
    db.collection 'translations', {strict:true}, (err, collection) ->
      if err
        console.log 'The translations collection doesnt exist. Creating it with sample data...'
        populateDB()
  else
    throw err

exports.findAll = (req, res) ->
  db.collection 'translations', (err, collection) ->
    collection.find().toArray (err, items) ->
      res.send items

exports.findById = (req, res) ->
  id = req.params.id
  console.log 'Retrieving translation: ' + id
  db.collection 'translations', (err, collection) ->
    
    collection.findOne {'_id':new BSON.ObjectID(id)}, (err, item) ->
      res.send item

exports.addTranslation = ->
  translation = req.body
  console.log 'Adding translation: '+JSON.stringify(translation)
  db.collection 'translations', (err, collection) ->
    collection.insert translation, {safe: true}, (err, result) ->
      if err
        res.send
          'error': 'Error'
      else
        console.log 'Success!!!!'
        res.send result[0]

exports.updateTranslation = ->
  id = req.params.id
  translation = req.body
  console.log 'Updating translation: ' + id
  console.log JSON.stringify(translation)
  db.collection 'translations', (err, collection) ->
    collection.update {'_id':new BSON.ObjectID(id)}, translation, {safe:true}, (err, result) ->
      if err
        console.log 'Error updating wine: ' + err
        res.send
          'error': 'An error has occurred'
      else
        console.log ''+result+' document(s) updated'
        res.send translation



exports.deleteTranslation = ->
  id = req.params.id
  translation = req.body
  console.log('Deleting translation: ' + id)
  console.log(JSON.stringify(translation))
  db.collection 'translations', (err, collection) ->
    collection.remove {'_id':new BSON.ObjectID(id)}, translation, {safe:true}, (err, result) ->
      if err
        console.log 'Error updating wine: ' + err
        res.send
          'error': 'An error has occurred'
      else
        console.log ''+result+' document(s) deleted'
        res.send req.body