# Chrome Packaged App for Nitrous.IO

## Testing

**For the first run:**
  Do `bundle`

1. Go to relevant Nitrous.IO web app and create a new app (eg. for development, https://nitrous.io/oauth/applications) 

  You can enter something like `https://example.com/callback` for the callback URL.

2. Save `config.json-example` as `config.json`. Use the `client_id` and `client_secret` from the oAuth application you created in the first step.

3. Then run, `rake build` (or `rake build:staging` if you want to create a staging build)

4. In Chrome, bring up the extensions management page by clicking the wrench icon and choosing Tools > Extensions.
   If Developer mode has a + by it, click the +. 
   The + changes to a -, and more buttons and information appear.

5. Click the Load unpacked extension button. A file dialog appears.

6. In the file dialog, select the `build/development` and click OK.

7. Once the app is loaded, Chrome will show a unique ID for it (a 32-byte alphanumeric string)
    
8. Use that to derive the callback URL for the app (ie. https://{APP_ID}.chromiumapp.org/nitrous)
    
   Go back to "oAuth Applications" section in the NitrousIO app and update the callback URL with it.

9. Click 'Launch' on Chrome app and you're ready to go.

   **Note**: If you only see a blank window, click 'Inspect Element' on the context menu (right-click). That should bring up the console and load the app (this is due to some Ember loading issues).
    

## Development

1. Make changes

2. Run `rake build`

3. Reload the app in Chrome

## TODO

* Figure out a way to switch to production build of ember when releasing.
* Add loading animations to connect and webview.
