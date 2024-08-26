Index: src/main.js
--- src/main.js.orig
+++ src/main.js
@@ -165,7 +165,7 @@ if (userLocale) {
 // Pseudo Language Language Pack is being used.
 // In that case, use `en` as the Electron locale.
 
-if (process.platform === 'win32' || process.platform === 'linux') {
+if (['linux', 'openbsd', 'win32'].includes(process.platform)) {
 	const electronLocale = (!userLocale || userLocale === 'qps-ploc') ? 'en' : userLocale;
 	app.commandLine.appendSwitch('lang', electronLocale);
 }
@@ -235,7 +235,7 @@ function configureCommandlineSwitchesSync(cliArgs) {
 		'proxy-bypass-list'
 	];
 
-	if (process.platform === 'linux') {
+	if (['linux', 'openbsd'].includes(process.platform)) {
 
 		// Force enable screen readers on Linux via this flag
 		SUPPORTED_ELECTRON_SWITCHES.push('force-renderer-accessibility');
