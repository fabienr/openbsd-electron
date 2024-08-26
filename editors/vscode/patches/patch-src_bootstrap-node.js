Index: src/bootstrap-node.js
--- src/bootstrap-node.js.orig
+++ src/bootstrap-node.js
@@ -162,7 +162,7 @@ module.exports.configurePortable = function (product) 
 			return process.env['VSCODE_PORTABLE'];
 		}
 
-		if (process.platform === 'win32' || process.platform === 'linux') {
+		if (process.platform === 'win32' || process.platform === 'linux' || process.platform === 'openbsd') {
 			return path.join(getApplicationPath(path), 'data');
 		}
 
