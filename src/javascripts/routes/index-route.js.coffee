AIO.IndexRoute = Em.Route.extend
  activate: ->
    AIO.AccessToken.loadFromStorage (tokenString) =>
      if tokenString
        AIO.set 'accessToken', tokenString
        @transitionTo 'main'
      else
        @transitionTo 'sign-in'
