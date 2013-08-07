#= require ./chrome_model

AIO.BoxTemplate = AIO.ChromeModel.extend
  name                  : null
  image                 : null
  description           : null
  enabled               : false
  runtime               : null

AIO.BoxTemplate.reopenClass
  store: []
  resourceCollection: 'box_templates'
