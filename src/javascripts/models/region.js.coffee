#= require ./chrome_model

AIO.Region = AIO.ChromeModel.extend
  name                  : null
  state                 : null
  description           : null

AIO.Region.reopenClass
  store: []
  resourceCollection: 'regions'
