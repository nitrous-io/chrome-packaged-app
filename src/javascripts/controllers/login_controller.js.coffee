AIO.LoginController = Ember.Controller.extend
  username: null
  password: null

  error: null
  loading: null

  login: ->
    @set 'loading', true
    username = @get 'username'
    password = @get 'password'
   
    unless username && password
      @set 'error', true
    
    host = AIO.get 'host'
    jQuery.ajax({
      url: "#{host}/oauth/token"
      data: {
              grant_type: "password"
              username: username
              password: password
              scope: "public boxes push web user"
              client_id: AIO.get 'clientId'
              client_secret: AIO.get 'clientSecret'
            }
      type: "POST"
    })
    .done (data) =>
      # clear username and password
      @set 'username', null
      @set 'password', null

      AIO.Session.create data, =>
        this.transitionToRoute 'main'
    .fail => 
      @set 'error', true
    .always =>
      @set 'loading', false
