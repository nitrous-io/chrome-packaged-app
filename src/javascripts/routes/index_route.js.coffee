NIO.IndexRoute = Ember.Route.extend
  activate: ->
    NIO.Session.getToken (error) =>
      if error
        this.transitionTo 'login'
      else
        this.transitionTo 'main'
