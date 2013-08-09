# Chrome Packaged App for Nitrous.IO

## Testing

**Before the first run:**

Do `bundle`

1. For now, you will need to switch to the `support-for-chrome-app` branch of the web app to test the packaged app. It adds several API endpoints needed by the Chrome app.

2. On the web app end, run `rake db:seed`.

3. Save `config.json-example` as `config.json`.

4. Then run, `rake` (or `rake <env name>` where `env name` can be `development`, `staging`, or `production`.)

5. In Chrome, bring up the extensions management page by clicking the wrench icon and choosing Tools > Extensions.
   If Developer mode has a + by it, click the +.
   The + changes to a -, and more buttons and information appear.

6. Click the Load unpacked extension button. A file dialog appears.

7. In the file dialog, select the `build/development` and click OK.

8. Once the app is loaded, Chrome will show a unique ID for it (a 32-byte alphanumeric string)

9. Use that to derive the callback URL for the app (ie. https://{APP_ID}.chromiumapp.org/oauth_response.html)

   Go to the "oAuth Applications" section in the NitrousIO web app (ie. https://www.n2odev.com/oauth/applications) and update the callback URL with the derived URL.

10. Click 'Launch' on Chrome app and you're ready to go.

   **Note**: If you only see a blank window, click 'Inspect Element' on the context menu (right-click). That should bring up the console and load the app (this is due to some Ember loading issues).


## Development

1. Make changes

2. Run `rake build`

3. Reload the app in Chrome
