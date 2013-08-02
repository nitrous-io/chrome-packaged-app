#= require ./libs/jquery-1.9.1
#= require ./libs/handlebars-1.0.12
#= require ./libs/ember-1.0.0-rc.6.1
#= require_self
#= require router
#= require routes
#= require models
#= require controllers
#= require_tree ./templates

#= require token_fetcher

window.NIO = Ember.Application.create()

NIO.reopen
  host: 'https://www.n2odev.com:5000'
  clientId: '2aa25d507f263f954c331c57d04f3e147e39fdaf9c6c4e146d496e99b51ddfd6'
  clientSecret: 'ac187c7e14fbd91943ba1350c62ec2cd85730ada36614a9f24fa831fc2de0b38'

