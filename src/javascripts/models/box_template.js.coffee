#= require ./chrome_model

NIO.BoxTemplate = NIO.ChromeModel.extend
  name                  : null
  image                 : null
  description           : null
  enabled               : false
  runtime               : null

NIO.BoxTemplate.reopenClass
  store: []
  resourceCollection: 'box_templates'
