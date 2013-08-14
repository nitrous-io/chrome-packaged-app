AIO.OAuthRESTAdapter = Em.RESTAdapter.extend
  ajaxSettings: ->
    settings = @_super.apply this, arguments
    if accessToken = AIO.get 'accessToken'
      settings.headers ?= {}
      settings.headers.Authorization = "Bearer #{AIO.get 'accessToken'}"
    settings
