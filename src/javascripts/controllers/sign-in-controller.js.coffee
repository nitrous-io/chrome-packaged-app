AIO.SignInController = Em.ObjectController.extend
  errorMessage: null

  signInButtonDisabled: (->
    @get('isSaving') || !@get('username') || !@get('password')
  ).property 'isSaving', 'username', 'password'

  signIn: ->
    @set 'errorMessage', null
    @get('model').save().then =>
      accessToken = @get 'accessToken'
      AIO.set 'accessToken', accessToken
      AIO.AccessToken.saveToStroage accessToken
      @send 'signedIn'
    , (jqXHR) =>
      @set 'errorMessage', jqXHR.responseJSON?.error
      @set 'isSaving', false
