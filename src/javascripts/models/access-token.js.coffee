#= require ./base-model

AIO.AccessToken = klass = AIO.BaseModel.extend
  username: Em.attr()
  password: Em.attr()
  accessToken: Em.attr()
  token: Em.computed.alias 'accessToken'

  clientId: null
  clientSecret: null

  didSaveRecord: ->
    @set 'password', null
    klass.singleton = this
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
  primaryKey: 'clientId'
  storageKey: 'accessToken'
  singleton: null

  prepopulate: (hashes) ->
    if hash = hashes?[0]
      @singleton = @findFromCacheOrLoad(hash)

  recordsToStore: ->
    [@singleton]
