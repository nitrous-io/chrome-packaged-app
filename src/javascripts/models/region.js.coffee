#= require ./chrome_model

NIO.Region = NIO.ChromeModel.extend
  name                  : null
  state                 : null
  description           : null

NIO.Region.reopenClass
  store: []
  resourceCollection: 'regions'
