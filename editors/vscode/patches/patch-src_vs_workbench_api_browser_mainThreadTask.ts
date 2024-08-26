Index: src/vs/workbench/api/browser/mainThreadTask.ts
--- src/vs/workbench/api/browser/mainThreadTask.ts.orig
+++ src/vs/workbench/api/browser/mainThreadTask.ts
@@ -673,7 +673,7 @@ export class MainThreadTask extends Disposable impleme
 			case 'darwin':
 				platform = Platform.Platform.Mac;
 				break;
-			case 'linux':
+			case 'linux': case 'freebsd': case 'openbsd':
 				platform = Platform.Platform.Linux;
 				break;
 			default:
