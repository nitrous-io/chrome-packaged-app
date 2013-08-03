#= require chrome_model

NIO.BoxTemplate = NIO.ChromeModel.extend
  id                    : null

  name                  : null
  image                 : null
  description           : null
  enabled               : false
  runtime               : null

NIO.BoxTemplate.reopenClass
  store: []
  resourceCollection: 'boxTemplates'

  resourceUrl: ->
    host = NIO.get 'host'
    "#{host}/box_templates"
