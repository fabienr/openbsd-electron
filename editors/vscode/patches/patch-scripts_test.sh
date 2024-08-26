Index: scripts/test.sh
--- scripts/test.sh.orig
+++ scripts/test.sh
@@ -27,7 +27,7 @@ VSCODECRASHDIR=$ROOT/.build/crashes
 test -d node_modules || yarn
 
 # Get electron
-yarn electron
+# yarn electron
 
 # Unit Tests
 if [[ "$OSTYPE" == "darwin"* ]]; then
@@ -39,5 +39,5 @@ else
 	cd $ROOT ; \
 		ELECTRON_ENABLE_LOGGING=1 \
 		"$CODE" \
-		test/unit/electron/index.js --crash-reporter-directory=$VSCODECRASHDIR $LINUX_EXTRA_ARGS "$@"
+		test/unit/electron/index.js --build --crash-reporter-directory=$VSCODECRASHDIR $LINUX_EXTRA_ARGS "$@"
 fi
