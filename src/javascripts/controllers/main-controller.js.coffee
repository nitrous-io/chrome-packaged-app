kPages =
  ide: '/app#boxes/%@/ide'
  settings: '/app#boxes/%@/edit'
  terminal: '/app#boxes/%@/terminal'
  invites: '/app#invites'
  n2oBonus: '/app#n2o/bonus'
  boxes: '/app#boxes'
  publicKeys: '/app#public_keys'
  accountSettings: '/users/edit'
  applications: '/oauth/authorized_applications'
  newBox: '/app#boxes/new'

kSignInWithTokenURLFormat = '%@/users/sign_in_with_token?sign_in_token=%@&redirect_to=%@'

AIO.MainController = Em.ArrayController.extend
  # model: Box
  sortProperties: ['id']

  webViewURL: null
  webViewSignedIn: false
  pusher: null

  contentDidChange: (->
    AIO.Box.saveToStorage()
  ).observes 'content.@each'

  openInWebView: (path) ->
    webViewURL = @get 'webViewURL'
    host = AIO.get 'host'
    if @get 'webViewSignedIn'
      @set 'webViewURL', "#{host}#{path}"
    else
      AIO.SignInToken.reload().then (signInToken) =>
        if token = signInToken.get('token')
          @set 'webViewURL', Em.String.fmt(kSignInWithTokenURLFormat, [
            host
            window.encodeURIComponent(token)
            window.encodeURIComponent(path)
          ])
          $('#aio-main-view webview').one 'loadstop.main-controller', =>
            @set 'webViewSignedIn', true

  refresh: ->
    if AIO.get 'online'
      AIO.CurrentUser.reload()
      AIO.Box.find().reload()

  openPage: (page, box) ->
    @openInWebView Em.String.fmt(kPages[page], [box?.get 'id'])

  doAction: (action, box) ->
    box.makeRequest 'PUT', action

  signOut: ->
    AIO.CurrentUser.reset()
    AIO.AccessToken.reset()
    AIO.Box.reset()
    AIO.SignInToken.reset()
    AIO.set 'currentUser', null
    AIO.set 'accessToken', null
    $('#aio-main-view webview').off 'loadstop.main-controller'
    @set 'webViewSignedIn', false
    @set 'webViewURL', 'about:blank'
    @send 'signedOut'
