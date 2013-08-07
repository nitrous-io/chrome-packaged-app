#= require ./chrome_model

NIO.User = NIO.ChromeModel.extend
  username    : null
  email       : null
  full_name   : null
  admin       : null

  logout: ->
    NIO.User.logout()

NIO.User.reopenClass
  store: []
  resourceCollection: 'user'

  logout: ->
    this.clear()
    # remove boxes from local storage
    NIO.Box.clear()
    # clear the access token
    NIO.Session.clear()
