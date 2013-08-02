chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('index.html', {
    bounds: {
      width: 325,
      height: 385,
      left: 0,
      top: 0
    },
    minWidth: 100,
    minHeight: 100
  });
});

chrome.runtime.onSuspend.addListener(function() {
  // persist and cleanup
});
