#= require ./chrome_model

NIO.Region = NIO.ChromeModel.extend
  id                    : null

  name                  : null
  state                 : null
  description           : null

NIO.Region.reopenClass
  store: []
  resourceCollection: 'regions'
