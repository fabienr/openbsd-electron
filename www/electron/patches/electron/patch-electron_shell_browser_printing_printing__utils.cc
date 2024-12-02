Index: electron/shell/browser/printing/printing_utils.cc
--- electron/shell/browser/printing/printing_utils.cc.orig
+++ electron/shell/browser/printing/printing_utils.cc
@@ -31,7 +31,7 @@
 #include <ApplicationServices/ApplicationServices.h>
 #endif
 
-#if BUILDFLAG(IS_LINUX)
+#if BUILDFLAG(IS_LINUX) || BUILDFLAG(IS_BSD)
 #include <gtk/gtk.h>
 #endif
 
