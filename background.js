chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('app/index.html', {
    bounds: {
      width: 800,
      height: 600,
      left: 0,
      top: 0
    },
    minWidth: 800,
    minHeight: 600
  });
});

chrome.runtime.onSuspend.addListener(function() {
  // persist and cleanup
});
