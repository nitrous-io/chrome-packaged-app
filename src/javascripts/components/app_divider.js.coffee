AIO.AppDividerComponent = Ember.Component.extend
  sidebarVisible: false

  didInsertElement: ->
    this.toggleSidebar()

  toggleSidebar: ->
    if sidebarVisible = @toggleProperty('sidebarVisible')
      console.log sidebarVisible
      $('#app').css 'padding-left', 320
      $('#app-sidebar').css 'left', 0
    else
      $('#app').css 'padding-left', 0
      $('#app-sidebar').css 'left', -320
      

