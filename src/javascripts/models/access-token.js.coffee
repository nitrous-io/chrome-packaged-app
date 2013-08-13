AIO.AccessToken = klass = Em.Model.extend
  username: Em.attr()
  password: Em.attr()
  accessToken: Em.attr()

  clientId: null
  clientSecret: null

  didSaveRecord: ->
    @set 'password', null
    @_super()

  toJSON: ->
    if json = @_super()
      json.client_id = @get 'clientId'
      json.client_secret = @get 'clientSecret'
      json.grant_type = 'password'
      json.scope = 'public boxes push web user'
    json

klass.reopenClass
  adapter: Em.RESTAdapter.create()
  url: "#{AIO.get 'host'}/oauth/token"

  clearStorage: ->
    chrome.storage.sync.set accessToken: null

  saveToStorage: (tokenString) ->
    chrome.storage.sync.set accessToken: tokenString

  loadFromStorage: (callback) ->
    chrome.storage.sync.get 'accessToken', (obj) ->
      callback? obj.accessToken
