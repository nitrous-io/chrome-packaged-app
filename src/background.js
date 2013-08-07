chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('index.html', {
    bounds: {
      width: 950,
      height: 650,
      left: 0,
      top: 0
    },
    minWidth: 800,
    minHeight: 600
  });
});
