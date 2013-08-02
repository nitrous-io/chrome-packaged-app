NIO.Box = Ember.Object.extend
  id                    : null

  backend_available     : null
  box_server_uri        : null
  box_template_id       : null
  container_name        : null
  host                  : null
  memory                : null
  owner_id              : null
  port                  : null
  region_id             : null
  name                  : null
  state                 : null
  storeage              : null

  running: (->
    this.get('state') == 'running'
  ).property 'state'

  stopped: (->
    this.get('state') == 'stopped'
  ).property 'state'

NIO.Box.reopenClass
  store: []

  fetchFromRemote:  (deferred) ->
    host = NIO.get 'host'

    NIO.TokenFetcher.getToken false, (error, access_token) -> 
      if error
        deferred.reject(error)

      $.ajax
        url: "#{host}/api/v0/boxes"
        headers: { 'Authorization': "Bearer #{access_token}" }

      .done (data) ->
        boxes = data.boxes

        # store boxes in local storage
        chrome.storage.local.set {
          'boxes': boxes
        }, ->
          deferred.resolve boxes
      .fail (jqxhr, status, error) ->
        console.log 'Fetching boxes failed', error, status
        deferred.reject()

  fetch: ->
    store = @store
    deferred = jQuery.Deferred()

    deferred.done (boxes) ->
      # add them to store
      boxes.forEach (box) ->
        store.push(NIO.Box.create(box));

    chrome.storage.local.get 'boxes', (result) =>
      if result && ('boxes' in result)
        deferred.resolve result.boxes
      else
        this.fetchFromRemote deferred

    deferred.promise()

  findAll: ->
    @store

  find: (id) ->
    box = null
    this.store.some (value) -> 
      box = value
      box.id == id

    box

  first: ->
    @store[0]
