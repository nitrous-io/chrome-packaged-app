# This is a minimal model implementation which backed by Chrome local storage.
# TODO: Rewrite to use Ember data adapters.

AIO.ChromeModel = Ember.Object.extend {}

AIO.ChromeModel.reopenClass
  store: null
  resourceCollection: null

  resourceUrl: ->
    host = AIO.get 'host'
    "#{host}/api/v0/#{@resourceCollection}"

  _fetchFromRemote:  (deferred) ->
    AIO.Session.getToken (error, access_token) =>
      if error
        deferred.reject(error)

      jQuery.ajax
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
    deferred = jQuery.Deferred()

    deferred.done (loadedResources) =>
      @store = []
      if Ember.isArray(loadedResources)
        loadedResources.forEach (resource) =>
          this._createResource resource
      else
        this._createResource loadedResources

    if forceRefresh
      this._fetchFromRemote deferred
    else
      chrome.storage.local.get @resourceCollection, (result) =>
        if result && (@resourceCollection of result)
          deferred.resolve result[@resourceCollection]
        else
          this._fetchFromRemote deferred

    deferred.promise()

  findAll: ->
    @store

  find: (id) ->
    @store.find (resource) ->
      resource.id == id

  first: ->
    @store[0]

  clear: ->
    @store = []
    chrome.storage.local.remove @resourceCollection

  _createResource: (attrs) ->
    resource = this.create attrs
    @store.push resource
