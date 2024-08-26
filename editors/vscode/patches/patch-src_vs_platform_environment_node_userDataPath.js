Index: src/vs/platform/environment/node/userDataPath.js
--- src/vs/platform/environment/node/userDataPath.js.orig
+++ src/vs/platform/environment/node/userDataPath.js
@@ -101,7 +101,7 @@
 				case 'darwin':
 					appDataPath = path.join(os.homedir(), 'Library', 'Application Support');
 					break;
-				case 'linux':
+				case 'linux': case 'freebsd': case 'openbsd':
 					appDataPath = process.env['XDG_CONFIG_HOME'] || path.join(os.homedir(), '.config');
 					break;
 				default:
