AIO.OAuthRESTAdapter = Em.RESTAdapter.extend
  ajaxSettings: ->
    settings = @_super.apply this, arguments
    if accessToken = AIO.get 'accessToken.token'
      settings.headers ?= {}
      settings.headers.Authorization = "Bearer #{accessToken}"
    settings
