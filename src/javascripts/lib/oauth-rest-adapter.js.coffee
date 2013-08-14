AIO.OAuthRESTAdapter = Em.RESTAdapter.extend
  ajaxSettings: ->
    settings = @_super.apply this, arguments
    if accessToken = AIO.get 'accessToken.token'
      settings.headers ?= {}
      settings.headers.Authorization = "Bearer #{accessToken}"
    settings

  makeRequest: (record, method, action, params) ->
    recordClass = record.constructor
    urlRoot = Em.get recordClass, 'url'
    primaryKey = Em.get recordClass, 'primaryKey'
    id = Em.get record, primaryKey

    url = if Em.isEmpty(id)
      "#{urlRoot}/#{action}.json"
    else
      "#{urlRoot}/#{id}/#{action}.json"

    @ajax url, params, method
