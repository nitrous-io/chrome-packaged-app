AIO.MainRoute = Em.Route.extend
  beforeModel: ->
    if !AIO.get('accessToken')
      @transitionTo 'sign-in'

  setupController: (controller) ->
    @_super.apply this, arguments

    AIO.set 'currentUser', AIO.CurrentUser.loadFromStorage ->
      AIO.CurrentUser.reload()

    AIO.SignInToken.reload().then (signInToken) =>
      token = window.encodeURIComponent(signInToken.get 'token')
      path = window.encodeURIComponent('/app')
      webViewURL = "#{AIO.get 'host'}/users/sign_in_with_token?sign_in_token=#{token}&redirect_to=#{path}"
      controller.set 'webViewURL', "#{AIO.get 'host'}/users/sign_in_with_token?sign_in_token=#{token}&redirect_to=#{path}"

  events:
    signedOut: ->
      @transitionTo 'sign-in'
