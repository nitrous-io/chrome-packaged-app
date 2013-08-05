NIO.IndexController = Ember.Controller.extend
  connecting: null

  connect: ->
    @set 'connecting', true

    NIO.TokenFetcher.getToken true, (error, access_token) =>
      @set 'connecting', false

      if error
        # TODO: show a flash message
        console.log('Login Failed')
      else
        this.transitionToRoute 'main'


