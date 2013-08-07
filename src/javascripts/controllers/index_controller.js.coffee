NIO.IndexController = Ember.Controller.extend
  username: null
  password: null

  loading: null

  login: ->
    @set 'loading', true
    username = @get 'username'
    password = @get 'password'
   
    if username && password
      host = NIO.get 'host'
      jQuery.ajax({
        url: "#{host}/oauth/token"
        data: {
                grant_type: "password"
                username: username
                password: password
                scope: "public boxes push web user"
                client_id: NIO.get 'clientId'
                client_secret: NIO.get 'clientSecret'
              }
        type: "POST"
      })
      .done (data) =>
        # clear username and password
        @set 'username', null
        @set 'password', null

        NIO.Session.create data, =>
          @set 'loading', false
          this.transitionToRoute 'main'
          
      .fail -> 
        # TODO: show a flash message
        console.log('Login Failed')
