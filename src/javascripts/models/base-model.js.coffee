AIO.BaseModel = klass = Em.Model.extend
  id: Em.attr()

klass.reopenClass
  adapter: AIO.OAuthRESTAdapter.create()
  camelizeKeys: true

  reset: ->
    @_findAllRecordArray = null
    @recordCache = null
