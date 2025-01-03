--- extensions/vscode-test-resolver/src/util/processes.ts.orig	2022-04-11 07:30:00 UTC
+++ extensions/vscode-test-resolver/src/util/processes.ts
@@ -20,7 +20,7 @@ export function terminateProcess(p: cp.ChildProcess, e
 		} catch (err) {
 			return { success: false, error: err };
 		}
-	} else if (process.platform === 'darwin' || process.platform === 'linux') {
+	} else if (['darwin', 'freebsd', 'linux', 'openbsd'].includes(process.platform)) {
 		try {
 			const cmd = path.join(extensionPath, 'scripts', 'terminateProcess.sh');
 			const result = cp.spawnSync(cmd, [p.pid!.toString()]);
