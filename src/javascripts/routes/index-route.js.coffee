AIO.IndexRoute = Em.Route.extend
  activate: ->
    AIO.AccessToken.loadFromStorage (accessToken) =>
      if accessToken
        AIO.set 'accessToken', accessToken
        @transitionTo 'main'
      else
        @transitionTo 'sign-in'
