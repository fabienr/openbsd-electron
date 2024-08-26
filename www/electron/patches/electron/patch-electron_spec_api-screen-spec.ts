Index: electron/spec/api-screen-spec.ts
--- electron/spec/api-screen-spec.ts.orig
+++ electron/spec/api-screen-spec.ts
@@ -94,7 +94,7 @@ describe('screen module', () => {
 
       const { size } = display!;
 
-      if (process.platform === 'linux') {
+      if (['freebsd', 'linux', 'openbsd'].includes(process.platform)) {
         expect(size).to.have.property('width').that.is.a('number');
         expect(size).to.have.property('height').that.is.a('number');
       } else {
@@ -108,7 +108,7 @@ describe('screen module', () => {
 
       const { workAreaSize } = display!;
 
-      if (process.platform === 'linux') {
+      if (['freebsd', 'linux', 'openbsd'].includes(process.platform)) {
         expect(workAreaSize).to.have.property('width').that.is.a('number');
         expect(workAreaSize).to.have.property('height').that.is.a('number');
       } else {
@@ -124,7 +124,7 @@ describe('screen module', () => {
       expect(bounds).to.have.property('x').that.is.a('number');
       expect(bounds).to.have.property('y').that.is.a('number');
 
-      if (process.platform === 'linux') {
+      if (['freebsd', 'linux', 'openbsd'].includes(process.platform)) {
         expect(bounds).to.have.property('width').that.is.a('number');
         expect(bounds).to.have.property('height').that.is.a('number');
       } else {
