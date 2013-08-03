# This is a minimal model implementation which backed by Chrome local storage.

NIO.ChromeModel = Ember.Object.extend {}

NIO.ChromeModel.reopenClass
  store: null
  resourceCollection: null
  
  resourceUrl: ->
    host = NIO.get 'host'
    "#{host}/api/v0/#{@resourceCollection}"
    
  _fetchFromRemote:  (deferred) ->
    NIO.TokenFetcher.getToken false, (error, access_token) => 
      if error
        deferred.reject(error)

      $.ajax
        url: this.resourceUrl()
        headers: { 'Authorization': "Bearer #{access_token}" }

      .done (data) =>
        loadedResources = data[@resourceCollection]

        storageObj = {}
        storageObj[@resourceCollection] = loadedResources

        chrome.storage.local.set storageObj, ->
          deferred.resolve loadedResources
      .fail (jqxhr, status, error) =>
        console.log 'Fetching #{@resourceCollection} failed', error, status
        deferred.reject()

  fetch: (forceRefresh=false) ->
    store = @store
    deferred = jQuery.Deferred()

    deferred.done (loadedResources) =>
      # add them to store
      loadedResources.forEach (resource) =>
        store.push this.create(resource)

    if forceRefresh
      this._fetchFromRemote deferred
    else
      chrome.storage.local.get @resourceCollection, (result) =>
        if result && (@resourceCollection in result)
          deferred.resolve result[@resourceCollection]
        else
          this._fetchFromRemote deferred

    deferred.promise()

  findAll: ->
    @store

  find: (id) ->
    resource = null
    this.store.some (value) -> 
      resource = value
      resource.id == id

    resource 

  first: ->
    @store[0]
