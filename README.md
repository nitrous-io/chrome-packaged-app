# Chrome Package App for Nitrous.IO

Warning: WIP - Still works only with the dev environment.

## Testing

**For the first run:**
  Do `bundle`

1. `rake build` 

2. In Chrome, bring up the extensions management page by clicking the wrench icon and choosing Tools > Extensions.
   If Developer mode has a + by it, click the +. 
   The + changes to a -, and more buttons and information appear.

3. Click the Load unpacked extension button. A file dialog appears.

4. In the file dialog, navigate to `build/development/compiled` and click OK.

## TODO

* Figure out a way to switch to production build of ember when releasing.
* Add loading animations to connect and webview.
