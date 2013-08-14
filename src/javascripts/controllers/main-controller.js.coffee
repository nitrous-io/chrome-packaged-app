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
  webViewURL: null

  sortProperties: ['id']

  contentDidChange: (->
    AIO.Box.saveToStorage()
  ).observes 'content.@each'

  signInAndOpenInWebView: (path) ->
    AIO.SignInToken.reload().then (signInToken) =>
      if token = signInToken.get('token')
        @set 'webViewURL', Em.String.fmt(kSignInWithTokenURLFormat, [
          AIO.get('host')
          window.encodeURIComponent(token)
          window.encodeURIComponent(path)
        ])

  refresh: ->
    AIO.CurrentUser.reload()
    AIO.Box.find().reload()

  openPage: (page, box) ->
    @signInAndOpenInWebView Em.String.fmt(kPages[page], [box?.get 'id'])
