#= require ./chrome_model

AIO.User = AIO.ChromeModel.extend
  username    : null
  email       : null
  full_name   : null
  admin       : null

  logout: ->
    AIO.User.logout()

AIO.User.reopenClass
  store: []
  resourceCollection: 'user'

  logout: ->
    this.clear()
    # remove boxes from local storage
    AIO.Box.clear()
    # clear the access token
    AIO.Session.clear()
