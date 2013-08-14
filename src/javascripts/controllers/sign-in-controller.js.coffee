AIO.SignInController = Em.ObjectController.extend
  errorMessage: null

  signInButtonDisabled: (->
    @get('isSaving') || !@get('username') || !@get('password')
  ).property 'isSaving', 'username', 'password'

  signIn: ->
    @set 'errorMessage', null
    model = @get 'model'
    model.save().then =>
      AIO.set 'accessToken', model
      AIO.AccessToken.saveToStorage()
      @send 'signedIn'
    , (jqXHR) =>
      @set 'errorMessage', jqXHR.responseJSON?.error
      @set 'isSaving', false
