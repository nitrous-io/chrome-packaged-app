AIO.AppDividerComponent = Ember.Component.extend
  sidebarVisible: true

  toggleSidebar: ->
    @toggleProperty 'sidebarVisible'
    $('#app').css 'padding-left', sidebarVisible ? 320 : 0
    $('#app-sidebar').css 'left', sidebarVisible ? 0 : -320
