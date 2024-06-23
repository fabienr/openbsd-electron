# XXX no member named 'ToV8' in 'gin::Converter<unsigned long>' ?
# electron/shell/browser/api/electron_api_content_tracing.cc
# cast unsigned long to int isn't a good choice

# XXX FilePath(NULL) segfault, strcmp 'electron' (was 'chrome')
# XXX handle error or crash early (which leed to this) ?
# base/process/process_handle_openbsd.cc

# XXX folder-hash looks broken on openbsd, skip SpecHash
# electron/script/spec-runner.js

# XXX openbsd use a wrapper, skip bin/electron check
# electron/spec/api-app-spec.ts

# XXX test crashReporter, check if its actually disabled from source ?
# not ok 709 -> 748
# electron/spec/disabled-tests.json

# XXX some other debug flags to play with (?)
# BUILDTYPE=Debug
# GN_FILE=testing.gn
# GN_ARGS+=is_debug=true
# GN_ARGS+=is_component_build=false
# GN_ARGS+=symbol_level=1
# GN_BOOTSTRAP_FLAGS+=--debug

# XXX annoying
#[ERROR:bus.cc(407)] Failed to connect to the bus:
# Could not parse server address: Unknown address type (examples of valid types
# are "tcp" and on UNIX "unix")

# XXX another one
#[ERROR:simple_backend_impl.cc(79)] Failed to create directory:
# /home/fabien/.config/Code - OSS/Shared Dictionary/cache
#[ERROR:simple_backend_impl.cc(751)] Simple Cache Backend:
# wrong file structure on disk: 1 path:
# /home/fabien/.config/.../Shared Dictionary/cache
#[ERROR:disk_cache.cc(208)] Unable to create cache

# XXX portcheck
# 8 line(s) longer than 80 columns in Makefile
# extra directory: patches/chromium
# extra directory: patches/chromium.local
# extra directory: patches/node
# www/electron

# XXX looks like we don't care about distfiles release to install apps
# no duplicate electron, installer have to overcome missing distfiles somehow
# wrong assumption : for ex, cypress needs it or a big hammer patch perhaps.

# XXX start apps with --app= instead of a bundle electron copy
# runing command line without args bring a different config, diff ?

# XXX pledge & unveil integration
# pledge does not work on vscode (--no-sandbox)
# test does not pass without unveil "/ rwcx"
# need more app to learn from ecosystem

BROKEN-powerpc64=Check failed: false. OS architecture not handled. (powerpc64)

USE_WXNEEDED=		Yes

DPB_PROPERTIES=		parallel parallel2
.if ${MACHINE_ARCH:Mi386}
DPB_PROPERTIES+=	lonesome
.endif

.include "Makefile.version"
COMMENT=		cross-platform desktop applications
DIST_TUPLE=		github electron electron v${ELECTRON_V} .
REVISION=		2

CATEGORIES=		www

HOMEPAGE=		https://www.electronjs.org/
MAINTAINER=		fabien@openbsd.org

# MIT
PERMIT_PACKAGE=		Yes

# uses pledge()
WANTLIB += EGL FLAC GL X11 X11-xcb Xau Xcomposite Xcursor Xdamage
WANTLIB += Xdmcp Xext Xfixes Xft Xi Xinerama Xrandr Xrender Xtst
WANTLIB += Xxf86vm aom atk-1.0 atk-bridge-2.0 atspi c cairo cairo-gobject
WANTLIB += cares cbor crc32c crypto cups dav1d dbus-1 double-conversion
WANTLIB += drm epoll-shim epoxy event execinfo expat ffi fido2
WANTLIB += fontconfig freetype fribidi gbm gdk-3 gdk_pixbuf-2.0
WANTLIB += gio-2.0 glib-2.0 gmodule-2.0 gobject-2.0 graphite2
WANTLIB += gthread-2.0 gtk-3 harfbuzz harfbuzz-gobject harfbuzz-subset
WANTLIB += icudata icui18n icuuc intl jpeg kvm lcms2 lzma m nghttp2
WANTLIB += nspr4 nss3 nssutil3 ogg openh264 opus pango-1.0 pangocairo-1.0
WANTLIB += pangoft2-1.0 pcre2-8 pixman-1 plc4 plds4 png sharpyuv
WANTLIB += smime3 snappy sndio tiff usbhid util vpx wayland-client
WANTLIB += wayland-cursor wayland-egl webp webpdemux webpmux xcb
WANTLIB += xcb-dri2 xcb-glx xcb-render xcb-shm xkbcommon xml2
WANTLIB += xshmfence xslt z zstd

# See electron/DEPS for versions, post-extract & pre-patch
CHROMIUM_V=			122.0.6261.156
NODE_V=				20.9.0
NAN_V=				e14bdcd1f72d62bca1d541b66da43130384ec213
SQUIRREL_MAC_V=			0e5d146ba13101a1302d59ea6e6e0b3cace4ae38
REACTIVEOBJC_V=			74ab5baccc6f7202c8ac69a8d1e152c29dc1ea76
MANTLE_V=			78d3966b3c331292ea29ec38661b25df0a245948
ENGFLOW_RECLIENT_CONFIGS_V=	955335c30a752e9ef7bff375baab5e0819b6c00d
# See third_party/node/node_modules.tar.gz.sha1
CHROMIUM_NODE_MODULES_HASH=	e0b8a95aed06c02287872a2d15c28509b9808446
# See third_party/test_fonts/test_fonts.tar.gz.sha1
CHROMIUM_TEST_FONTS_HASH=	336e775eec536b2d785cc80eff6ac39051931286

# XXX fallback to freebsd distfiles
#DISTFILES.chromium=	chromium-${CHROMIUM_V}${EXTRACT_SUFX}
#SITES.chromium=	https://commondatastorage.googleapis.com/chromium-browser-official/
DISTFILES.chromium=	chromium-${CHROMIUM_V}.tar.xz
SITES.chromium=		https://github.com/tagattie/FreeBSD-Electron/releases/download/v29.2.0/
DISTFILES.nodemodule=	${CHROMIUM_NODE_MODULES_HASH}
SITES.nodemodule=	https://commondatastorage.googleapis.com/chromium-nodejs/
DISTFILES.fonts=	${CHROMIUM_TEST_FONTS_HASH}
SITES.fonts=		https://commondatastorage.googleapis.com/chromium-fonts/

DIST_TUPLE+=	github nodejs node v${NODE_V} .
DIST_TUPLE+=	github nodejs nan ${NAN_V} .
DIST_TUPLE+=	github Squirrel Squirrel.Mac ${SQUIRREL_MAC_V} .
DIST_TUPLE+=	github ReactiveCocoa ReactiveObjC ${REACTIVEOBJC_V} .
DIST_TUPLE+=	github Mantle Mantle ${MANTLE_V} .
DIST_TUPLE+=	github EngFlow reclient-configs ${ENGFLOW_RECLIENT_CONFIGS_V} .

# pre-patch electron > ALL_PATCHFILES > PATCH_LIST
.if empty(_MAKE_PATCHES)
ALL_PATCHFILES=	${PATCHDIR}/chromium/patch-* \
		${PATCHDIR}/node/patch-*
PATCH_CASES+=	${PATCHDIR}/chromium/patch-*) \
		    ${PATCH} ${PATCH_DIST_ARGS} \
		    -z .orig.chromium \
		    -d ${WRKSRC}/ <$$patchfile ;;
PATCH_CASES+=	${PATCHDIR}/node/patch-*) \
		    ${PATCH} ${PATCH_DIST_ARGS} \
		    -z .orig.node \
		    -d ${WRKSRC}/third_party/electron_node/ \
		    <$$patchfile ;;
PATCH_LIST=	patch-* chromium.local/patch-*
.else
# pre-patch only, see targets chromium-patches & node-patches
ALL_PATCHFILES=
PATCH_LIST=
.endif

COMPILER=	ports-clang

MODULES=	devel/yarn lang/clang lang/python

MODCLANG_VERSION=	17
MODPY_RUNDEP=		No
MODYARN_TARGETS=	${WRKSRC}/electron ${WRKSRC}/electron/spec

# XXX LIB_DEPENDS devel/libnotify, BUILD|LIB ?
RUN_DEPENDS+=	devel/desktop-file-utils \
		devel/xdg-utils \
		fonts/noto/fonts \
		graphics/libexif \
		sysutils/libudev-openbsd \
		x11/gtk+3,-cups \
		x11/gtk+4,-guic
BUILD_DEPENDS+=	archivers/bzip2 \
		devel/bison \
		devel/gperf \
		devel/libnotify \
		lang/node \
		shells/bash \
		sysutils/flock \
		sysutils/pciutils \
		devel/ninja \
		x11/py-xcbgen${MODPY_FLAVOR} \
		${MODGCC4_CPPDEP} \
		${RUN_DEPENDS}
LIB_DEPENDS+=	archivers/snappy \
		audio/flac \
		audio/opus \
		devel/crc32c \
		devel/pango \
		graphics/jpeg \
		graphics/lcms2 \
		graphics/libwebp \
		graphics/png \
		graphics/tiff \
		math/double-conversion \
		multimedia/aom \
		multimedia/dav1d \
		multimedia/libvpx \
		multimedia/openh264 \
		net/libcares \
		security/nss \
		textproc/icu4c \
		textproc/libxml \
		textproc/libxslt \
		www/nghttp2 \
		x11/gnome/at-spi2-core \
		x11/gtk+3,-main \
		x11/xkbcommon \
		print/cups,-libs
TEST_DEPENDS+=	devel/py-dbusmock \
		x11/dbus-python \
		devel/py-gobject3 \
		devel/glib2

USE_GMAKE=	Yes

# XXX needed ?
DEBUG_PACKAGES=	${BUILD_PACKAGES}

.include <bsd.own.mk>

SUBST_VARS+=	WRKSRC WRKDIR

# Collect all DISTS under 'src'
WRKDIST=		${WRKDIR}/src
WRKSRC=			${WRKDIR}/src

ALL_TARGET=		electron \
			electron:node_headers \
			chromedriver
# XXX also include *zip build targets ? required for building apps ?
# XXX missing chromedriver(.debug), manual STRIP in post-build ?
# XXX looks like we don't care about distfiles release to install apps, remove ?
POST_BUILD_TARGET=	licenses \
			version \
			electron_dist_zip \
			electron_mksnapshot_zip \
			electron_chromedriver_zip

DIST_TARGET_DIR=	electron/${ELECTRON_V}

# These libraries are used from the system and the build infrastructure
# removes them from the bundled third_party directory and replaces them
# with hooks to use them from the system.
# Some GN_SYSTEM_LIBS just change args, prefer GN_ARGS then.
GN_SYSTEM_LIBS=	crc32c \
		dav1d \
		double-conversion \
		flac \
		icu \
		libaom \
		libevent \
		libpng \
		libvpx \
		libwebp \
		libxml \
		libxslt \
		openh264 \
		opus \
		snappy
# make gn_args-check, review ${WRKDIR}/gn_args.list
GN_ARGS=	use_system_libjpeg=true \
		use_system_harfbuzz=true \
		use_system_cares=true \
		use_system_nghttp2=true
# pdfium
GN_ARGS+=	use_system_lcms2=true \
		use_system_libpng=true \
		use_system_libtiff=true \
		use_system_zlib=true

GN_ARGS+=	clang_use_chrome_plugins=false \
		disable_fieldtrial_testing_config=true \
		enable_backup_ref_ptr_support=false \
		enable_hangout_services_extension=true \
		enable_log_error_not_reached=true \
		enable_remoting=false \
		enable_rust=false \
		extra_cppflags=\"-idirafter ${LOCALBASE}/include -idirafter ${X11BASE}/include\" \
		fatal_linker_warnings=false \
		icu_use_data_file=false \
		treat_warnings_as_errors=false \
		use_allocator_shim=false \
		use_custom_libunwind=true \
		use_kerberos=false \
		use_pulseaudio=true \
		use_sysroot=false \
		v8_enable_cet_ibt=true

# XXX not from chromium, not any more perhaps
#		use_bundled_fontconfig=false

# XXX chromium, rust
# RUSTC_VERSION!!=rustc -V
# MAKE_ENV+=	RUSTC_BOOTSTRAP=1
# GN_ARGS+=	enable_rust=true \
# 		rust_sysroot_absolute=\"${LOCALBASE}\" \
# 		rustc_version=\"${RUSTC_VERSION}\"

# XXX chromium, notyet
# Indicates if VA-API-based hardware acceleration is to be used. This
# is typically the case on x86-based ChromeOS devices.
# VA-API should also be compiled by default on x11/wayland linux devices
# using x86/x64.
GN_ARGS+=	use_vaapi=false

.if ${MACHINE_ARCH} == "aarch64"
GN_ARGS+=	extra_ldflags=\"-L${LOCALBASE}/lib -L${X11BASE}/lib\"
PKG_ARGS+=	-Dswiftshader=0
FFMPEG_TARGET=	arm64
.elif ${MACHINE_ARCH} == "amd64"
BUILD_DEPENDS+=	devel/nasm
GN_ARGS+=	extra_ldflags=\"-L${LOCALBASE}/lib -L${X11BASE}/lib\"
PKG_ARGS+=	-Dswiftshader=1
FFMPEG_TARGET=	x64
.elif ${MACHINE_ARCH} == "i386"
BUILD_DEPENDS+=	devel/nasm
GN_ARGS+=	extra_ldflags=\"-L${LOCALBASE}/lib -L${X11BASE}/lib -Wl,--no-keep-memory\"
PKG_ARGS+=	-Dswiftshader=1
FFMPEG_TARGET=	ia32
.else
PKG_ARGS+=	-Dswiftshader=0
.endif

FFMPEG_BRAND=	Chrome
FFMPEG_BDIR=	${WRKSRC}/build.${FFMPEG_TARGET}.openbsd/${FFMPEG_BRAND}
FFMPEG_CDIR=	${WRKSRC}/third_party/ffmpeg/chromium/config/${FFMPEG_BRAND}/openbsd/${FFMPEG_TARGET}

GN_ARGS+=	ffmpeg_branding=\"${FFMPEG_BRAND}\" \
		proprietary_codecs=true

# XXX dwz doesn't work with chromium yet
# dwz: .debug/electron.dbg: Too many DIEs, not optimizing
DWZ = :

# always build with symbol, bsd.port.mk will strip
GN_ARGS+=	symbol_level=1
# always link static into bin, no component
GN_ARGS+=	is_component_build=false \
		is_component_ffmpeg=false
# do not use lto, otherwise it needs -fno-ret-protector & -mno-retpoline
GN_ARGS+=	use_thin_lto=false \
		thin_lto_enable_optimizations=true

GN_ARGS+=	override_electron_version=\"${ELECTRON_V}\"

# XXX need chrome-linux-${CHROMIUM_V}-llvm<XX>.profdata${EXTRACT_SUFX}
GN_ARGS+=	chrome_pgo_phase=0

BUILDTYPE=		Release
BUILDDIR=		${WRKSRC}/out/${BUILDTYPE}
GN_FILE=		release.gn
GN_BOOTSTRAP_FLAGS=	--skip-generate-buildfiles
ELECTRON_PATCH=		${WRKSRC}/electron/patches/config.json

post-extract:
	# setup distfiles into src
	mv ${WRKDIR}/chromium-${CHROMIUM_V} ${WRKSRC}
	mv ${WRKDIR}/electron-${ELECTRON_V} ${WRKSRC}/electron
	mv ${WRKDIR}/node_modules ${WRKSRC}/third_party/node/node_modules
	mv ${WRKDIR}/test_fonts ${WRKSRC}/third_party/test_fonts
	mv ${WRKDIR}/node-${NODE_V} ${WRKSRC}/third_party/electron_node
	mv ${WRKDIR}/nan-${NAN_V} ${WRKSRC}/third_party/nan
	mv ${WRKDIR}/Squirrel.Mac-${SQUIRREL_MAC_V} \
		${WRKSRC}/third_party/squirrel.mac
	mkdir -p ${WRKSRC}/third_party/squirrel.mac/vendor
	mv ${WRKDIR}/ReactiveObjC-${REACTIVEOBJC_V} \
		${WRKSRC}/third_party/squirrel.mac/vendor/ReactiveObjC
	mv ${WRKDIR}/Mantle-${MANTLE_V} \
		${WRKSRC}/third_party/squirrel.mac/vendor/Mantle
	mv ${WRKDIR}/reclient-configs-${ENGFLOW_RECLIENT_CONFIGS_V} \
		${WRKSRC}/third_party/engflow-reclient-configs

pre-patch:
	# apply electron patches
	@for _pair in $$(grep ':' ${ELECTRON_PATCH} | cut -f 4,8 -d '"' ); do \
		_from=${WRKDIR}/$$(echo $${_pair} | cut -f 1 -d '"') ; \
		_to=${WRKDIR}/$$(echo $${_pair} | cut -f 2 -d '"') ; \
		for _p in $$(cat $${_from}/.patches); do \
			echo "Apply $${_from}/$${_p} into $${_to}"; \
			${PATCH} -f -p1 -z .orig.electron \
				-d $${_to} -i $${_from}/$${_p}; \
			grep -R '^rename' $${_from}/$${_p} | \
				cut -f 3 -d ' ' | xargs -r -L2 sh -c \
				"cd $${_to} && mv \$$@" mv ; \
		done ; \
	done

pre-configure:
	@ln -sf ${MODPY_BIN} ${WRKDIR}/bin/python
	@ln -sf ${LOCALBASE}/bin/llvm-ar-${MODCLANG_VERSION} ${WRKDIR}/bin/ar
	cd ${WRKSRC}/third_party/ffmpeg && \
		${MODPY_BIN} chromium/scripts/build_ffmpeg.py \
		openbsd ${FFMPEG_TARGET} --config-only \
		--branding=${FFMPEG_BRAND}
	cd ${FFMPEG_BDIR} && ${GMAKE} ffversion.h
	${INSTALL_DATA_DIR} ${FFMPEG_CDIR}
.for _e in config.h config.asm config_components.h libavcodec libavformat libavutil
	-cp -pR ${FFMPEG_BDIR}/${_e} ${FFMPEG_CDIR}
.endfor
	@mkdir -p ${WRKSRC}/third_party/node/openbsd/node-openbsd/bin
	@ln -sf ${LOCALBASE}/bin/node \
		${WRKSRC}/third_party/node/openbsd/node-openbsd/bin/node
	${SUBST_CMD} \
		${WRKSRC}/build/gn_run_binary.py \
		${WRKSRC}/v8/tools/run.py \
		${WRKSRC}/tools/protoc_wrapper/protoc_wrapper.py \
		${WRKSRC}/third_party/blink/renderer/build/scripts/run_with_pythonpath.py \
		${WRKSRC}/third_party/electron_node/src/env.cc

# Configuration consists of three steps:
# 1. replace the specified bundled libraries with hooks to use the system libs
# 2. bootstrap gn, the tool to generate ninja files
# 3. run gn with the appropriate configuration arguments
do-configure:
	cd ${WRKSRC} && env -i ${MAKE_ENV} \
		build/linux/unbundle/replace_gn_files.py \
		--system-libraries ${GN_SYSTEM_LIBS}
	cd ${WRKSRC}/tools/gn && env -i ${MAKE_ENV} \
		LDFLAGS=-L${LOCALBASE}/lib ${MODPY_BIN} \
		bootstrap/bootstrap.py --no-clean -s ${GN_BOOTSTRAP_FLAGS}
	cd ${WRKSRC} && env -i ${CONFIGURE_ENV} \
		${WRKSRC}/out/${BUILDTYPE}/gn gen out/${BUILDTYPE} \
		--args="import(\"//electron/build/args/${GN_FILE}\") ${GN_ARGS}"

do-build:
	@cd ${WRKSRC} && env -i ${MAKE_ENV} \
		ninja -j ${MAKE_JOBS} -C out/${BUILDTYPE} ${ALL_TARGET}
	@cd ${WRKSRC} && env -i ${MAKE_ENV} \
		ninja -j ${MAKE_JOBS} -C out/${BUILDTYPE} ${ALL_TARGET} \
		-t compdb > compile_commands.json

post-build:
# XXX need chromedriver.debug & chromedriver for electron_chromedriver_zip
	${STRIP} -o ${WRKSRC}/out/${BUILDTYPE}/chromedriver \
		${WRKSRC}/out/${BUILDTYPE}/chromedriver.unstripped
	${STRIP} --only-keep-debug \
		-o ${WRKSRC}/out/${BUILDTYPE}/chromedriver.debug \
		${WRKSRC}/out/${BUILDTYPE}/chromedriver.unstripped
	@cd ${WRKSRC} && env -i ${MAKE_ENV} \
		ninja -j ${MAKE_JOBS} -C out/${BUILDTYPE} ${POST_BUILD_TARGET}
	@cd ${WRKSRC} && env -i ${MAKE_ENV} \
		ninja -j ${MAKE_JOBS} -C out/${BUILDTYPE} ${POST_BUILD_TARGET} \
		-t compdb >> compile_commands.json
# XXX looks like we don't care about distfiles release to install apps, remove ?
	@cd ${BUILDDIR} && cp chromedriver.zip \
		chromedriver-v${ELECTRON_V}-openbsd-${ELECTRON_ARCH}.zip
	@cd ${BUILDDIR} && cp dist.zip \
		electron-v${ELECTRON_V}-openbsd-${ELECTRON_ARCH}.zip
	@cd ${BUILDDIR} && cp mksnapshot.zip \
		mksnapshot-v${ELECTRON_V}-openbsd-${ELECTRON_ARCH}.zip
	@cd ${BUILDDIR} && sha256 -r *-v${ELECTRON_V}-openbsd-*.zip | \
		sed -e 's/ / */' > SHASUMS256.txt

do-install:
# XXX do we want all those files ?
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}
.for f in electron mksnapshot v8_context_snapshot_generator
	${INSTALL_PROGRAM} ${BUILDDIR}/${f} \
		${PREFIX}/${DIST_TARGET_DIR}
.endfor
	${SUBST_PROGRAM} ${FILESDIR}/electron \
		${PREFIX}/${DIST_TARGET_DIR}/electron.sh
	${SUBST_PROGRAM} ${FILESDIR}/electron_nosandbox \
		${PREFIX}/${DIST_TARGET_DIR}/electron_nosandbox.sh
	ln -s ${TRUEPREFIX}/${DIST_TARGET_DIR}/electron.sh \
		${PREFIX}/bin/electron
	${INSTALL_PROGRAM} ${BUILDDIR}/chromedriver.unstripped \
		${PREFIX}/${DIST_TARGET_DIR}/chromedriver
	# copy .pak
	${INSTALL_DATA} ${BUILDDIR}/*.pak ${PREFIX}/${DIST_TARGET_DIR}
	# copy locales & ressources
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}/locales
	${INSTALL_DATA} ${BUILDDIR}/locales/* \
		${PREFIX}/${DIST_TARGET_DIR}/locales
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}/resources
# XXX permission ? no INSTALL* fn ? chown ? chmod o-w ?
	cp -Rp ${BUILDDIR}/resources/* ${PREFIX}/${DIST_TARGET_DIR}/resources
	@chown -R ${SHAREOWN}:${SHAREGRP} ${PREFIX}/${DIST_TARGET_DIR}/resources
	# ANGLE, EGL, Vk, ...
.for f in libEGL libGLESv2 libvk_swiftshader libVkICD_mock_icd
	${INSTALL_DATA} ${BUILDDIR}/${f}.so ${PREFIX}/${DIST_TARGET_DIR}
.endfor
	${INSTALL_DATA} ${BUILDDIR}/libvulkan.so.1 \
		${PREFIX}/${DIST_TARGET_DIR}/libvulkan.so
.if ${MACHINE_ARCH} != "aarch64"
	# SwiftShader
	${INSTALL_DATA} ${BUILDDIR}/libvk_swiftshader.so \
		${PREFIX}/${DIST_TARGET_DIR}
.endif
	# sandbox, unveil & pledge
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/electron
	${INSTALL_DATA} ${FILESDIR}/unveil.gpu ${PREFIX}/share/examples/electron
.for f in main utility_audio utility_network utility_video
	${INSTALL_DATA} ${FILESDIR}/{pledge,unveil}.${f} \
		${PREFIX}/share/examples/electron
.endfor
	# data
.for f in LICENSE LICENSES.chromium.html protoc snapshot_blob.bin \
    v8_context_snapshot.bin version vk_swiftshader_icd.json
	${INSTALL_DATA} ${BUILDDIR}/${f} ${PREFIX}/${DIST_TARGET_DIR}
.endfor
	# electron
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}/node_headers
# XXX permission ? no INSTALL* fn ? chown ? chmod o-w ?
	cp -Rp ${BUILDDIR}/gen/node_headers/* \
		${PREFIX}/${DIST_TARGET_DIR}/node_headers
	@chown -R ${SHAREOWN}:${SHAREGRP} \
		${PREFIX}/${DIST_TARGET_DIR}/node_headers
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}/gen/electron/buildflags
	${INSTALL_DATA} ${BUILDDIR}/gen/electron/buildflags/* \
		${PREFIX}/${DIST_TARGET_DIR}/gen/electron/buildflags
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}/gen/v8
	${INSTALL_DATA} ${BUILDDIR}/gen/v8/embedded.S \
		${PREFIX}/${DIST_TARGET_DIR}/gen/v8/embedded.S
	# release
# XXX looks like we don't care about distfiles release to install apps, remove ?
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET_DIR}/releases
	${INSTALL_DATA} ${BUILDDIR}/SHASUMS256.txt \
		${PREFIX}/${DIST_TARGET_DIR}/releases
	${INSTALL_DATA} ${BUILDDIR}/*-v${ELECTRON_V}-openbsd-*.zip \
		${PREFIX}/${DIST_TARGET_DIR}/releases

# XXX test only work if installed
# some test spawn electron (${LOCALBASE}/electron/29.4.1/electron)
do-test:
	# XXX --no-sandbox (hard to setup, not tested)
	# XXX unveil "/ rwcx" (/etc/electron/unveil.main)
	# XXX Xvfb :1 &
	rm -rf ${WRKDIR}/.config
	mkdir -p ${WRKDIR}/.config/Electron
	ulimit -Sn `ulimit -Hn`
	ulimit -Sd `ulimit -Hd`
	# XXX LOCAL_GIT_DIRECTORY=${LOCALBASE} ?
	cd ${WRKSRC}/electron && env -i ${TEST_ENV} \
		ELECTRON_OUT_DIR=${BUILDTYPE} \
		LD_LIBRARY_PATH=${BUILDDIR} \
		DISPLAY=:1 \
		npm run test -- --ci

### targets for port maintainer(s)

_TMP = /tmp/electron-${ELECTRON_V}
chromium-patches:
	${_MAKE} -D _MAKE_PATCHES patch
	# remember to update cvs co -D "..." if you change targeted version
	if [ -d ${_TMP}/chromium ]; then \
		echo "${_TMP}/chromium exists, skip cvs co" ; \
	else \
		mkdir -p ${_TMP} && cd ${_TMP} && \
		cvs co -D "2024-03-7" -d chromium ports/www/chromium ; \
	fi
	# test chromium patches on top of electron patch (pre-patch)
	rm -rf ${_TMP}/patches/chromium*
	mkdir -p ${_TMP}/patches/chromium{,.rej,.miss,.new}
	for p in ${_TMP}/chromium/patches/patch-*; do \
		f=$$(grep -m1 'Index: ' $$p | sed -e 's/.*: //' ) ; \
		if grep -q "@@ -0,0" $$p; then \
			cp $${p} ${_TMP}/patches/chromium/ ; \
			cp $${p} ${_TMP}/patches/chromium.new/ ; \
		elif [ -f "${WRKSRC}/$$f" ]; then \
			${PATCH} ${PATCH_DIST_ARGS} -sfC -z .orig.chromium \
				-d ${WRKSRC} < $${p} && \
				cp $${p} ${_TMP}/patches/chromium/ || \
				cp $${p} ${_TMP}/patches/chromium.rej/ ; \
		else \
			echo "missing ${WRKSRC}/$$f" ; \
			cp $${p} ${_TMP}/patches/chromium.miss/ ; \
		fi ; \
	done
	@echo "rejected:"
	@ls ${_TMP}/patches/chromium.rej
	# if ok, copy ${_TMP}/patches/chromium into port && make clean

node-patches:
	${_MAKE} -D _MAKE_PATCHES patch
	# remember to update cvs co -D "..." if you change targeted version
	if [ -d ${_TMP}/node ]; then \
		echo "${_TMP}/node exists, skip cvs co" ; \
	else \
		mkdir -p ${_TMP} && cd ${_TMP} && \
		cvs co -d node ports/lang/node ; \
	fi
	# test node patches on top of electron patch (pre-patch)
	rm -rf ${_TMP}/patches/node*
	mkdir -p ${_TMP}/patches/node{,.rej}
	for p in ${_TMP}/node/patches/patch-*; do \
		${PATCH} ${PATCH_DIST_ARGS} -sfC -z .orig.node \
			-d ${WRKSRC}/third_party/electron_node/ < $${p} && \
			cp $${p} ${_TMP}/patches/node/ || \
			cp $${p} ${_TMP}/patches/node.rej/ ; \
	done
	@echo "rejected:"
	@ls ${_TMP}/patches/node.rej
	# remember to copy ${_TMP}/patches/node/ into port && make clean

# run under _pbuild
_gn_args-list:
	# ${WRKDIR}/gn_args.list
	@if [[ ! -e "${WRKDIR}/gn_args.list" ]] ; then \
		cd ${WRKSRC} && env -i ${CONFIGURE_ENV} \
		${WRKSRC}/out/${BUILDTYPE}/gn args out/${BUILDTYPE} \
		--list > ${WRKDIR}/gn_args.list ; \
	fi

# run under _pbuild
_gn_args-chromium-list:
	# ${WRKDIR}/gn_args-chromium.list
	@if [[ ! -e "${WRKDIR}/gn_args-chromium.list" ]] ; then \
		cd ${PORTSDIR}/www/chromium ; \
		_wrksrc=$$(make show=WRKSRC) ; \
		cd $$_wrksrc && env -i ${CONFIGURE_ENV} \
			$$_wrksrc/out/${BUILDTYPE}/gn args out/${BUILDTYPE} \
			--list > ${WRKDIR}/gn_args-chromium.list ; \
	fi

# run under _pbuild
_gn_args-diff:
	# ${WRKDIR}/gn_args.diff
	diff -uN ${WRKDIR}/gn_args{-chromium,}.list \
		> ${WRKDIR}/gn_args.diff

gn_args-check:
	make configure
	${_PBUILD} make _gn_args-list
	# check GN_ARGS from www/chromium
	@cd ${PORTSDIR}/www/chromium && make show=GN_ARGS \
	    | sed -e 's/  /;/g' -e 's/" /";/g' | tr -s ';' '\n' \
	    | sed -e '/^[^"]*$$/s/ /;/g' | tr -s ';' '\n' \
	    | sort \
	    | while IFS=';' read _gn ; do \
		_arg=$${_gn%%=*} ; \
		_value=$${_gn##*=} ; \
		grep -A1 "^$${_arg}$$" ${WRKDIR}/gn_args.list \
		    | grep -q "$$_value" || \
		echo "Wrong" $$(grep -A1 "^$${_arg}$$" ${WRKDIR}/gn_args.list) \
		    "\nInstead of $$_arg = $$_value"; \
	done

gn_args-diff:
	#make configure
	#${_PBUILD} make _gn_args-list
	# configure www/chromium in order to compare
	cd ${PORTSDIR}/www/chromium && make configure ; cd -
	${_PBUILD} make _gn_args-chromium-list
	# ${WRKDIR}/gn_args.diff
	@${_PBUILD} sh -c \
	"diff -uN ${WRKDIR}/gn_args{-chromium,}.list > ${WRKDIR}/gn_args.diff" \
		|| wc -l ${WRKDIR}/gn_args.diff

gn_args-system:
	make configure
	${_PBUILD} make _gn_args-list
	@_systems=$$(grep -C0 -e '^[^[:space:]]*use_system_.*' \
		${WRKDIR}/gn_args.list) ; \
	for _system in $$_systems; do \
		grep -A1 "^$$_system" ${WRKDIR}/gn_args.list | \
			grep -q true || \
			echo $$(grep -A1 "^$$_system" ${WRKDIR}/gn_args.list) \
		; \
	done

.include "modules.inc"

.include <bsd.port.mk>
