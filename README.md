# Chrome Packaged App for Nitrous.IO

## Testing

**Before the first run:**

1. Do `bundle`.
1. Save `config.json-example` as `config.json`.
1. Then run, `rake` (or `rake <env name>` where `env name` can be `development`, `staging`, or `production`.)
1. In Chrome, bring up the extensions management page by clicking the wrench icon and choosing Tools > Extensions.
   If Developer mode has a + by it, click the +.
   The + changes to a -, and more buttons and information appear.
1. Click the Load unpacked extension button. A file dialog appears.
1. In the file dialog, select the `build/development` and click OK.
1. Click 'Launch' on Chrome app and you're ready to go.

   **Note**: If you only see a blank window, click 'Inspect Element' on the context menu (right-click). That should bring up the console and load the app (this is due to some Ember loading issues).


## Development

1. Make changes
1. Run `rake build`
1. Reload the app in Chrome
