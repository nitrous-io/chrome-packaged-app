#= require ./base-model

AIO.SignInToken = klass = AIO.BaseModel.extend
  signInToken: Em.attr()
  token: Em.computed.alias 'signInToken'

klass.reopenClass
  url: "#{AIO.get 'host'}/api/v0/user/sign_in_token"
