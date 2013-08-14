#= require ./oauth-rest-adapter

AIO.SingularResourceAdapter = AIO.OAuthRESTAdapter.extend
  # simple patch to allow singular resource endpoints

  didFindAll: (klass, records, data) ->
    rootKey = Em.get klass, 'rootKey'
    dataToLoad = if rootKey then data[rootKey] else data
    records.load klass, [dataToLoad]

  buildURL: (klass, id) ->
    unless urlRoot = Em.get(klass, 'url')
      @_super.apply this, arguments
    urlRoot + ".json"
