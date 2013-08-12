#= require ./chrome-model

AIO.User = AIO.ChromeModel.extend
  username    : null
  email       : null
  full_name   : null
  admin       : null
  used_n2o    : null
  max_n2o     : null

  free_n2o: (->
    (@get('max_n2o') ? 0) - (@get('used_n2o') ? 0)
  ).property 'used_n2o', 'max_n2o'

AIO.User.reopenClass
  store: []
  resourceCollection: 'user'

  signout: ->
    this.clear()
    # remove boxes from local storage
    AIO.Box.clear()
    # clear the access token
    AIO.Session.clear()
