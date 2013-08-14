AIO.BaseModel = klass = Em.Model.extend
  id: Em.attr()

klass.reopenClass
  adapter: AIO.OAuthRESTAdapter.create()
  camelizeKeys: true

  reset: ->
    @_findAllRecordArray = null
    @clearCache()

  prepopulate: (hashes) ->
    records = @_findAllRecordArray ?= Ember.RecordArray.create(modelClass: this)
    records.load(this, hashes) if hashes
    records

  recordsToStore: ->
    @_findAllRecordArray?.get('content')

  clearStorage: ->
    Ember.assert 'storageKey needs to be defined' unless @storageKey
    toStore = {}
    toStore[@storageKey] = null
    chrome.storage.sync.set toStore

  saveToStorage: ->
    Ember.assert 'storageKey needs to be defined' unless @storageKey
    toStore = {}
    toStore[@storageKey] = @recordsToStore()?.map (obj) =>
      json = obj.toJSON()
      json = json[@rootKey] if @rootKey
      json
    chrome.storage.sync.set toStore

  loadFromStorage: (callback) ->
    Ember.assert 'storageKey needs to be defined' unless @storageKey
    chrome.storage.sync.get @storageKey, (obj) =>
      if hashes = obj[@storageKey]
        records = @prepopulate(hashes)
        return callback? records
      callback?()
    @prepopulate()
