#= require ./base-model

AIO.CurrentUser = klass = AIO.BaseModel.extend
  username: Em.attr()
  email: Em.attr()
  fullName: Em.attr()

  usedN2o: Em.attr()
  maxN2o: Em.attr()

  usedN2O: Em.computed.alias 'usedN2o'
  maxN2O: Em.computed.alias 'maxN2o'

  freeN2O: (->
    (@get('maxN2O') ? 0) - (@get('usedN2O') ? 0)
  ).property 'usedN2O', 'maxN2O'
  freeN2o: Em.computed.alias 'freeN2O'

  load: ->
    @_super.apply this, arguments
    @constructor.saveToStorage()

klass.reopenClass
  adapter: AIO.SingularResourceAdapter.create()
  rootKey: 'user'
  storageKey: 'currentUser'
  primaryKey: 'noKey' # primary key is irrelevant since it's a singular resource
  url: "#{AIO.get 'host'}/api/v0/user"

  prepopulate: (hashes) ->
    record = @cachedRecordForId()
    if hash = hashes?[0]
      record.load undefined, hash
    record

  recordsToStore: ->
    [@findById()]
