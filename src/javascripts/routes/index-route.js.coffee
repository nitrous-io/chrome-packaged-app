AIO.IndexRoute = Ember.Route.extend
  activate: ->
    AIO.Session.getToken (error) =>
      if error
        this.transitionTo 'login'
      else
        this.transitionTo 'main'
