COMMENT=	Signal Desktop links with Signal

V=		7.11.0
DISTNAME=	Signal-Desktop-${V}
PKGNAME=	${DISTNAME:L}

DIST_TUPLE=	github signalapp Signal-Desktop v${V} .

CATEGORIES=	net

HOMEPAGE=	https://signal.org/
MAINTAINER=	fabien@openbsd.org

# BSD 2-Clause
PERMIT_PACKAGE=	Yes

WANTLIB += ${MODCARGO_WANTLIB} c++ crypto m

# make versions
# ELECTRON_V=30.0.6
# NODE_V=20.11.1
# better-sqlite3 depends
# BETTER_SQLITE3_V=8.7.1
FTS5_V=		0.2.1
SQLCIPHER_HASH=	ef53ea45ed92b928ecfd33c552d8d405263e86e63dec38e1ec63e1b0193b630b
SQLCIPHER_URI=	https://build-artifacts.signal.org/desktop/
SQLCIPHER_V=	4.5.5-fts5-fix--3.0.7--${FTS5_V}-${SQLCIPHER_HASH}
# libsignal depends
LIBSIGNAL_V=	0.46.2
BORING_ID=	b9a75167dc08a3b16dd203e0af78c8962c5439bd
# ringrtc depends
RINGRTC_V=	2.42.0
LIBWEBRTC_V=	6261i

# libsignal, boring depends
# see https://github.com/signalapp/boring/tree/libsignal/boring-sys/deps
BORINGSSL_ID=	44b3df6f03d85c901767250329c571db405122d5

# better-sqlite3, MIT
SQLCIPHER_T=		${WRKSRC}/node_modules/@signalapp/better-sqlite3/deps
DISTFILES.sqlcipher=	sqlcipher-${SQLCIPHER_V}.tar.gz
SITES.sqlcipher=	${SQLCIPHER_URI}
EXTRACT_CASES+=		${DISTFILES.sqlcipher});;

# Signal-FTS5-Extension, AGPLv3
FTS5_SRC=	${WRKDIR}/Signal-FTS5-Extension-${FTS5_V}
FTS5_TOML=	${FTS5_SRC}/Cargo.toml
DIST_TUPLE+=	github signalapp Signal-FTS5-Extension v${FTS5_V} .

# libsignal, AGPLv3
LIBSIGNAL_SRC=	${WRKDIR}/libsignal-${LIBSIGNAL_V}
LIBSIGNAL_NODE=	${LIBSIGNAL_SRC}/node
LIBSIGNAL_TOML=	${LIBSIGNAL_SRC}/Cargo.toml
LIBSIGNAL_T=	node_modules/@signalapp/libsignal-client/prebuilds
DIST_TUPLE+=	github signalapp libsignal v${LIBSIGNAL_V} .

# boringssl, OpenSSL/ISC
BORINGSSL_T=	${WRKDIR}/boring-${BORING_ID}/boring-sys/deps
DIST_TUPLE+=	github google boringssl ${BORINGSSL_ID} .

# ringrtc, AGPLv3
RINGRTC_SRC=	${WRKDIR}/ringrtc-${RINGRTC_V}
RINGRTC_NODE=	${RINGRTC_SRC}/src/node
RINGRTC_TOML=	${RINGRTC_SRC}/Cargo.toml
RINGRTC_T=	node_modules/@signalapp/ringrtc/build
DIST_TUPLE+=	github signalapp ringrtc v${RINGRTC_V} .

# libwebrtc, BSD-3-Clause
DIST_TUPLE+=	github signalapp webrtc ${LIBWEBRTC_V} .

# see webrtc-deps (.include webrtc.inc)
_DISTDIR=	signal-desktop
SITES.chrome=	https://chromium.googlesource.com/
SITES.boring=	https://boringssl.googlesource.com/
TEMPLATE_DISTFILES.webrtc= \
  ${_DISTDIR}/<account>-<project>-{<account>/<project>.git/+archive/}<id>.tar.gz
TEMPLATE_DISTFILES.chrome= ${TEMPLATE_DISTFILES.webrtc}
TEMPLATE_DISTFILES.boring= ${TEMPLATE_DISTFILES.webrtc}
EXTRACT_CASES+=${_DISTDIR}/*.tar.gz) \
	_filename=$${archive\#\#*/} && \
	mkdir -p $${_filename%.tar.gz} && \
	${GZIP_CMD} -d <${FULLDISTDIR}/$$archive | \
		${TAR} -C $${_filename%.tar.gz} -xf - -- ;;

WEBRTC_T=	${WRKDIR}/ringrtc-${RINGRTC_V}/src/webrtc
WEBRTC_SRC=	${RINGRTC_SRC}/src/webrtc/src
WEBRTC_DEPS= \
	src/base chromium/src-base \
	src/build chromium/src-build \
	src/buildtools chromium/src-buildtools \
	src/ringrtc/opus/src xiph-opus \
	src/testing chromium/src-testing \
	src/third_party chromium/src-third_party \
	src/third_party/boringssl/src .-boringssl \
	src/third_party/catapult .-catapult \
	src/third_party/icu chromium/deps-icu \
	src/third_party/libjpeg_turbo chromium/deps-libjpeg_turbo \
	src/third_party/libsrtp chromium/deps-libsrtp \
	src/third_party/libvpx/source/libvpx webm-libvpx \
	src/third_party/libyuv libyuv-libyuv \
	src/third_party/nasm chromium/deps-nasm \
	src/tools chromium/src-tools

ALL_PATCHFILES+=${PATCHDIR}/chromium/patch-*
PATCH_CASES+=	${PATCHDIR}/chromium/patch-*) \
		    ${PATCH} ${PATCH_DIST_ARGS} \
		    -z .orig.chromium \
		    -d ${WEBRTC_SRC}/ <$$patchfile ;;

COMPILER=	base-clang ports-gcc

MODULES=	devel/cargo \
		devel/cmake \
		devel/npm \
		devel/yarn \
		lang/clang \
		lang/python \
		www/electron

USE_GMAKE=	Yes

# pledge signal-desktop, avoid sqlcipher_mlock()
CFLAGS+=	-DOMIT_MEMLOCK

# see custom modcargo-gen-crates
MODCARGO_CARGOS_TOML=	${FTS5_TOML} ${LIBSIGNAL_TOML} ${RINGRTC_TOML}
# libsignal/linkme is broken with https://github.com/dtolnay/linkme/commit
# 64e7c63c106848481bea8f66c4885b52c26ca9ec
# It's probably related to https://github.com/dtolnay/linkme/issues/49
MODCARGO_RUSTFLAGS+=	-Clink-dead-code
# libclang.so
MODCARGO_ENV +=		LIBCLANG_PATH=${LOCALBASE}/llvm${MODCLANG_VERSION}/lib \
			LD_LIBRARY_PATH=${LOCALBASE}/llvm${MODCLANG_VERSION}/lib
MODPY_RUNDEP=		No
MODYARN_TARGETS=	${LIBSIGNAL_NODE} \
			${RINGRTC_NODE} \
			${WRKSRC}/sticker-creator \
			${WRKSRC}
MODELECTRON_BUILDER=	Yes
MODELECTRON_SRC=	${WRKSRC}
MODELECTRON_TARGET=	signal-desktop

BUILD_DEPENDS+=	devel/app-builder \
		devel/gn \
		devel/ninja
RUN_DEPENDS+=	devel/desktop-file-utils

DEBUG_PACKAGES=	${BUILD_PACKAGES}

SUBST_VARS+=	WRKSRC MODCARGO_TARGET_DIR

# pre-define source date, no git show -s --format=%ct
MAKE_ENV+=	SOURCE_DATE_EPOCH=$$(date +'%s')
# signal's appbuilder config
MAKE_ENV+=	SIGNAL_ENV=production

# see electron/Makefile
GN_SYSTEM_LIBS=	crc32c \
		dav1d \
		double-conversion \
		icu \
		jsoncpp \
		libaom \
		libevent \
		libpng \
		libvpx \
		libwebp \
		libxml \
		libxslt \
		openh264 \
		re2 \
		snappy \
		woff2
GN_ARGS=	use_system_libjpeg=true \
		use_system_harfbuzz=true \
# electron/Makefile link options
GN_ARGS+=	symbol_level=1 \
		is_component_build=false
GN_ARGS+=	use_thin_lto=false \
		thin_lto_enable_optimizations=true
.if ${MACHINE_ARCH} == "aarch64"
GN_ARGS+=	extra_ldflags=\"-L${LOCALBASE}/lib -L${X11BASE}/lib\"
PKG_ARGS+=	-Dswiftshader=0
.elif ${MACHINE_ARCH} == "amd64"
BUILD_DEPENDS+=	devel/nasm
GN_ARGS+=	extra_ldflags=\"-L${LOCALBASE}/lib -L${X11BASE}/lib\"
PKG_ARGS+=	-Dswiftshader=1
.elif ${MACHINE_ARCH} == "i386"
BUILD_DEPENDS+=	devel/nasm
GN_ARGS+=	extra_ldflags=\"-L${LOCALBASE}/lib -L${X11BASE}/lib -Wl,--no-keep-memory\"
PKG_ARGS+=	-Dswiftshader=1
.else
PKG_ARGS+=	-Dswiftshader=0
.endif
# electron/Makefile common options
GN_ARGS+=	clang_use_chrome_plugins=false \
		enable_rust=false \
		extra_cppflags=\"-idirafter ${LOCALBASE}/include -idirafter ${X11BASE}/include\" \
		fatal_linker_warnings=false \
		treat_warnings_as_errors=false \
		use_custom_libcxx=false \
		use_sysroot=false

# see ringrtc/bin/build-electron
GN_ARGS+=	rtc_build_examples=false \
		rtc_build_tools=false \
		rtc_include_tests=false \
		rtc_enable_protobuf=false \
		rtc_use_x11=false \
		rtc_enable_sctp=false \
		rtc_libvpx_build_vp9=true \
		rtc_include_ilbc=false

# webrtc
GN_ARGS+=	is_debug=false \
		is_clang=true \
		extra_cxxflags=\"${CXXFLAGS}\"

post-extract:
	# setup boring-sys
	rm -rf ${BORINGSSL_T}/*
	mv ${WRKDIR}/boringssl-${BORINGSSL_ID} ${BORINGSSL_T}/boringssl
	# setup webrtc
	mkdir -p ${WEBRTC_T}
	mv ${WRKDIR}/webrtc-${LIBWEBRTC_V} ${WEBRTC_T}/src
	mv ${WRKDIR}/{,xiph-}opus-*
.for _dst _name in ${WEBRTC_DEPS}
	mv ${WRKDIR}/${_name:T}-* ${WEBRTC_T}/${_dst}
.endfor

pre-patch:
# XXX DIST_TUPLE run after MODYARN
	# link depends into ${WRKSRC} to handle patches
	mv ${LIBSIGNAL_SRC} ${WRKSRC}/libsignal
	ln -s ${WRKSRC}/libsignal ${LIBSIGNAL_SRC}
	mv ${RINGRTC_SRC} ${WRKSRC}/ringrtc
	ln -s ${WRKSRC}/ringrtc ${RINGRTC_SRC}
	# apply signal-desktop patches
	for _p in ${WRKSRC}/patches/*.patch; do \
		${PATCH} -f -p1 -z .orig.signal \
			-d ${WRKSRC} -i $${_p}; \
	done

pre-configure:
	@ln -sf ${MODPY_BIN} ${WRKDIR}/bin/python
	@ln -sf ${MODPY_BIN} ${WRKDIR}/bin/vpython3
	@ln -sf ${LOCALBASE}/bin/llvm-ar-${MODCLANG_VERSION} ${WRKDIR}/bin/ar
	# setup yarnrc for using electron node headers
	echo 'nodedir "${ELECTRON_NODE_DIR}"' >> ${WRKSRC}/.yarnrc

do-configure:
	${MODCARGO_configure}
	${SUBST_DATA} ${FILESDIR}/cargo.toml \
		${WRKDIR}/cargo.toml
	cat ${WRKDIR}/cargo.toml >>${WRKDIR}/.cargo/config

pre-build: better-sqlite3 libsignal ringrtc sticker-creator

do-build:
	# setup build dir with dns-fallback.json
	mkdir -p ${WRKSRC}/build
	cp ${FILESDIR}/dns-fallback.json ${WRKSRC}/build/dns-fallback.json
	# build signal
	cd ${WRKSRC} && env -i ${MAKE_ENV} yarn build:acknowledgments
	cd ${WRKSRC} && env -i ${MAKE_ENV} yarn generate
	cd ${WRKSRC} && env -i ${MAKE_ENV} yarn build:esbuild:prod
	# electron-builder
	${ELECTRON_BUILDER_BUILD}

do-install:
	# electron-builder
	${ELECTRON_BUILDER_INSTALL}
	# wraper
	${SUBST_PROGRAM} ${FILESDIR}/${MODELECTRON_TARGET} \
		${PREFIX}/bin/${MODELECTRON_TARGET}
	# menu
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications
	${INSTALL_DATA} ${FILESDIR}/${MODELECTRON_TARGET}.desktop \
		${PREFIX}/share/applications/${MODELECTRON_TARGET}.desktop
	${INSTALL_DATA_DIR} ${PREFIX}/share/pixmaps
	${INSTALL_DATA} ${WRKSRC}/images/signal-logo-desktop-linux.png \
		${PREFIX}/share/pixmaps/${MODELECTRON_TARGET}.png

# XXX test-fts5 ?
# XXX test-better-sqlite ?
# XXX test-libwebrtc ?
do-test:	test-libsignal \
		test-ringrtc \
		test-sticker-creator \
		test-signal-desktop

fts5:
	# build fts5-extension native depends for better-sqlite3
	cd ${FTS5_SRC} && env -i ${MAKE_ENV} ${CONFIGURE_ENV} \
		${MODCARGO_ENV} ${MODCARGO_CARGO_BIN} build \
		--release

better-sqlite3: fts5
	# build better-sqlite3 native depends
	cp ${DISTDIR}/${DISTFILES.sqlcipher} ${SQLCIPHER_T}/sqlcipher.tar.gz
	${SUBST_CMD} ${SQLCIPHER_T}/sqlite3.gyp
	cd ${SQLCIPHER_T}/.. && env -i ${MAKE_ENV} ${ELECTRON_REBUILD_ENV} \
		node ${MODNPM_GYP_BIN} rebuild

libsignal:
	# build libsignal native depends (fake node-gyp build)
	cd ${LIBSIGNAL_SRC} && env -i ${MAKE_ENV} ${CONFIGURE_ENV} \
		${MODCARGO_ENV} ${MODCARGO_CARGO_BIN} build \
		-p libsignal-node --features testing-fns --release
	# install libsignal prebuild
	mkdir -p ${WRKSRC}/${LIBSIGNAL_T}/openbsd-${NODE_ARCH}
	cp ${MODCARGO_TARGET_DIR}/release/libsignal_node.so \
		${WRKSRC}/${LIBSIGNAL_T}/openbsd-${NODE_ARCH}/node.napi.node

libwebrtc:
	# configure libwebrtc native depends for ringrtc
	echo "# fake gclient_args" > ${WEBRTC_SRC}/build/config/gclient_args.gni
	cd ${WEBRTC_SRC} && env -i ${MAKE_ENV} \
		build/linux/unbundle/replace_gn_files.py \
		--system-libraries ${GN_SYSTEM_LIBS}
	cd ${WEBRTC_SRC} && env -i ${CONFIGURE_ENV} ${MAKE_ENV} \
		gn gen out/release --args="${GN_ARGS}"
	# build libwebrtc native depends for ringrtc
	cd ${WEBRTC_SRC} && env -i ${MAKE_ENV} \
		ninja -j ${MAKE_JOBS} -C out/release
	cd ${WEBRTC_SRC} && env -i ${MAKE_ENV} \
		ninja -j ${MAKE_JOBS} -C out/release \
		-t compdb > compile_commands.json

ringrtc: libwebrtc
	# build ringrtc native depends
	cd ${RINGRTC_SRC} && env -i ${MAKE_ENV} ${CONFIGURE_ENV} \
		OUTPUT_DIR=${WEBRTC_SRC}/out \
		${MODCARGO_ENV} ${MODCARGO_CARGO_BIN} build -p ringrtc \
		--features electron --release \
		${MODCARGO_BUILD_ARGS}
	# install ringrtc prebuild
	mkdir -p ${WRKSRC}/${RINGRTC_T}/openbsd
	cp ${MODCARGO_TARGET_DIR}/release/libringrtc.so \
		${WRKSRC}/${RINGRTC_T}/openbsd/libringrtc-${NODE_ARCH}.node

sticker-creator:
	# build sticker-creator
	cd ${WRKSRC}/sticker-creator && env -i ${MAKE_ENV} \
		yarn build

test-libsignal: libsignal
	# copy libsignal native lib
	mkdir -p ${LIBSIGNAL_NODE}/build/Release
	cp ${MODCARGO_TARGET_DIR}/release/libsignal_node.so \
		${LIBSIGNAL_NODE}/build/Release/node.napi.node
	# build libsignal test
	cd ${LIBSIGNAL_NODE} && env -i ${MAKE_ENV} yarn tsc
	# run libsignal test
	cd ${LIBSIGNAL_NODE} && env -i ${MAKE_ENV} yarn test

# XXX .sndio/cookie ?
# audio_device_sndio.cc:26: Couldn't open audio device
test-ringrtc: ringrtc
	# XXX Xvfb :1 &
	# copy ringrtc native lib
	mkdir -p ${RINGRTC_NODE}/build/openbsd
	cp ${MODCARGO_TARGET_DIR}/release/libringrtc.so \
		${RINGRTC_NODE}/build/openbsd/libringrtc-${NODE_ARCH}.node
	# build ringrtc test
	cd ${RINGRTC_NODE} && env -i ${MAKE_ENV} yarn tsc
	# run ringrtc test
	mkdir -p ${WRKDIR}/.config/chromium
# XXX cp cookie from user env
	cp -R ~/.sndio ${WRKDIR}/
	cd ${RINGRTC_NODE} && env -i ${MAKE_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron_nosandbox \
		yarn test

test-sticker-creator:
	# run sticker-creator test
	cd ${WRKSRC}/sticker-creator && env -i ${MAKE_ENV} \
		CI=ci yarn test

test-signal-desktop:
	# XXX Xvfb :1 &
	mkdir -p ${WRKDIR}/.config/chromium
	# setup electron wraper
	mkdir -p ${WRKSRC}/node_modules/.bin
	rm -rf ${WRKSRC}/node_modules/.bin/electron
	ln -fs ${LOCALBASE}/bin/electron_nosandbox \
		${WRKSRC}/node_modules/.bin/electron
	rm -rf ${WRKSRC}/dist/linux-unpacked/signal-desktop
	${SUBST_PROGRAM} ${FILESDIR}/signal-desktop \
		${WRKSRC}/dist/linux-unpacked/signal-desktop
	# copy libsignal native lib
	cd ${WRKSRC}/node_modules/@signalapp/mock-server/node_modules && \
		mkdir -p @signalapp/libsignal-client/build/Release && \
		cp ${MODCARGO_TARGET_DIR}/release/libsignal_node.so \
			@signalapp/libsignal-client/build/Release/node.napi.node
	# run signal-desktop test
	cd ${WRKSRC} && env -i ${TEST_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron_nosandbox \
		yarn test
# XXX fake launch test from system or make one more wraper ?
	cd ${WRKSRC} && env -i ${TEST_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron_nosandbox \
		yarn test-release
	cd ${WRKSRC} && env -i ${TEST_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron_nosandbox \
		yarn test-mock
# XXX ts/util/asyncIterables.js
# SyntaxError: Unexpected token '['
	cd ${WRKSRC} && env -i ${TEST_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron_nosandbox \
		ELECTRON_OVERRIDE_DIST_PATH=${WRKSRC}/node_modules/.bin \
		yarn test-node-coverage

### targets for port maintainer(s)

user-dev:
	cp ${WRKSRC}/config/{production,local-development}.json
	cd ${WRKSRC} && \
		NODE_ENV=development electron_nosandbox .

# make versions : download, extract then print versions for depends
# make modyarn-gen-modules : regen modules.inc, see devel/yarn
# make modcargo-gen-crates : handle multiple regen crates.inc
# make webrtc-deps

_TMP = /tmp/signal-desktop-${V}
_SIGNAL_GH =	https://raw.githubusercontent.com/signalapp/Signal-Desktop/
_RINGRTC_GH =	https://raw.githubusercontent.com/signalapp/ringrtc/
_BSQL_GH =	https://raw.githubusercontent.com/signalapp/better-sqlite3/
_LIBSIGNAL_GH =	https://raw.githubusercontent.com/signalapp/libsignal/
_BORING_GH =	https://raw.githubusercontent.com/signalapp/boring/
versions:
	# make versions
	@mkdir -p ${_TMP} ; \
	ftp -VMo ${_TMP}/package.json \
		${_SIGNAL_GH}/v${V}/package.json ; \
	_ringrtc_v=$$(grep "@signalapp/ringrtc" \
		${_TMP}/package.json | awk -F ":" '{print $$2}' | \
		sed -E 's#("|,| )##g') ; \
	_libsignal_v=$$(grep "@signalapp/libsignal-client" \
		${_TMP}/package.json | awk -F ":" '{print $$2}' | \
		sed -E 's#("|,| )##g') ; \
	_bsql_v=$$(grep '@signalapp/better-sqlite3' \
		${_TMP}/package.json | awk -F ":" '{print $$2}' | \
		sed -E 's#("|,| )##g') ; \
	printf "# ELECTRON_V=%s\n" $$(awk /'"electron":'/'{print $$2}' \
		${_TMP}/package.json | sed -E 's/("|,)//g') ; \
	printf "# NODE_V=%s\n" $$(awk /'"node":'/'{print $$2}' \
		${_TMP}/package.json | sed 's/"//g') ; \
	printf "# better-sqlite3 deps\n" ; \
	printf "# BETTER_SQLITE3_V=%s\n" $$_bsql_v ; \
	ftp -VMo ${_TMP}/download.js \
		${_BSQL_GH}/v$${_bsql_v}/deps/download.js ; \
	printf "FTS5_V=\t\t%s\n" $$(grep "const TOKENIZER_VERSION" \
		${_TMP}/download.js | awk -F '=' '{print $$2}' | \
		sed -e "s/ '//" -e "s/';//") ; \
	printf "SQLCIPHER_HASH=\t%s\n" $$(grep "const HASH" \
		${_TMP}/download.js | awk -F '=' '{print $$2}' | \
		sed -e "s/ '//" -e "s/';//") ; \
	printf "SQLCIPHER_URI=\t%s/\n" $$(grep "const BASE_URI" \
		${_TMP}/download.js | awk -F '=' '{print $$2}' | \
		sed -e "s/ \`//" -e "s/\`;//") ; \
	_sqlcipher_v=$$(grep "const SQLCIPHER_VERSION" \
		${_TMP}/download.js | awk -F '=' '{print $$2}' | \
		sed -e "s/ '//" -e "s/';//") ; \
	_openssl_v=$$(grep "const OPENSSL_VERSION" \
		${_TMP}/download.js | awk -F '=' '{print $$2}' | \
		sed -e "s/ '//" -e "s/';//") ; \
	printf "SQLCIPHER_V=\t%s--%s--\$${FTS5_V}-\$${SQLCIPHER_HASH}\n" \
		$$_sqlcipher_v $$_openssl_v ; \
	printf "# libsignel depends\n" ; \
	printf "LIBSIGNAL_V=\t%s\n" $$_libsignal_v ; \
	ftp -VMo ${_TMP}/Cargo.lock \
		${_LIBSIGNAL_GH}/v$${_libsignal_v}/Cargo.lock ; \
	_boring_v=$$(grep "signalapp/boring" \
		${_TMP}/Cargo.lock | uniq | awk -F '#|"' '{print $$3}') ; \
	printf "BORING_ID=\t%s\n" $$_boring_v ; \
	printf "# ringrtc depends\n" ; \
	printf "RINGRTC_V=\t%s\n" $$_ringrtc_v ; \
	ftp -VMo ${_TMP}/version.properties \
		${_RINGRTC_GH}/v$${_ringrtc_v}/config/version.properties ; \
	printf "LIBWEBRTC_V=\t%s\n" $$(grep "webrtc.version" \
		${_TMP}/version.properties | awk -F "=" '{print $$2}' ) ; \

# handle multiple cargo files and add github depends for libsignal
# XXX make modcargo-gen-crates-licenses doesn't preserve git+ depends
modcargo-gen-crates:
	@make extract >/dev/null 2>&1
	@echo '# run: make modcargo-gen-crates-licenses'
	@cat ${MODCARGO_CARGOS_TOML:toml=lock} | awk '\
		/^name = / { n=$$3; gsub("\"", "", n); } \
		/^version = / { v=$$3; gsub("\"", "", v); } \
		/^source = "registry\+https:\/\/github.com\/rust-lang\/crates\.io-index"/ \
			{ print "MODCARGO_CRATES +=	" n "	" v; }' | \
		sort | uniq
	# libsignal/Cargo.lock git+ depends
.for _target in boring curve25519-dalek
	@printf "DIST_TUPLE+=\tgithub signalapp ${_target} %s %s\n" $$( \
		grep "signalapp/${_target}" ${LIBSIGNAL_SRC}/Cargo.lock | \
		uniq | awk -F '#|"' '{print $$3}' ) ${_target}
.endfor

webrtc-deps:
	@make extract >/dev/null 2>&1
	# make webrtc-deps > webrtc.inc
	@echo "DIST_TUPLE+= \\"
.for _dst _name in ${WEBRTC_DEPS}
	@_id=$$(\
		grep -E '${_name:S|.-||:S|-|/|}(\.git)?@' \
			${WEBRTC_SRC}/DEPS | \
		awk -F '@' '{print $$2}' | \
		sed -e "s/',//" -e "s/'//") ; \
	if [ "${_name:S/.-//}" = "boringssl" ] ; then \
		printf 'boring %s %s . \\\n' "${_name:S/-/ /}" $$_id; \
	elif [ "${_name}" = "xiph-opus" ] ; then \
		printf 'github %s %s . \\\n' "${_name:S/-/ /}" $$_id; \
	else \
		printf 'chrome %s %s . \\\n' "${_name:S/-/ /}" $$_id; \
	fi
.endfor
	@echo

# XXX dns-fallback to pre-made dns-fallback.json
dns-fallback:
	@make configure >/dev/null 2>&1
	# make dns-fallback > files/dns-fallback.json
	@cd ${WRKSRC} && \
	env -i ${MAKE_ENV} yarn build:dns-fallback && \
	cat ${WRKSRC}/build/dns-fallback.json

chromium-patches:
	make extract
	# remember to update cvs co -D "..." if you change targeted version
	@if [ -d ${WRKDIR}/chromium ]; then \
		echo "${WRKDIR}/chromium exists, skip cvs co" ; \
	else \
		cd ${WRKDIR} && \
		cvs co -d chromium ports/www/chromium ; \
	fi
	# test chromium patches
	rm -rf ${WRKDIR}/patches
	mkdir -p ${WRKDIR}/patches/chromium{,.rej,.miss,.new}
	mkdir -p ${WRKDIR}/patches/webrtc
	@for p in ${WRKDIR}/chromium/patches/patch-*; do \
		if [[ $$p == *"third_party_webrtc"* ]]; then \
			cp $${p} ${WRKDIR}/patches/webrtc/$${p##*/} ; \
			p=${WRKDIR}/patches/webrtc/$${p##*/} ; \
			sed -i -e 's|third_party/webrtc/||g' $$p ; \
		fi ; \
		f=$$(grep 'Index' $$p | sed -e 's/.*: //' ) ; \
		if grep -q "@@ -0,0" $$p; then \
			cp $${p} ${WRKDIR}/patches/chromium/ ; \
			cp $${p} ${WRKDIR}/patches/chromium.new/ ; \
		elif [ -f "${WEBRTC_SRC}/$$f" ]; then \
			${PATCH} ${PATCH_DIST_ARGS} -sfC -z .orig.chromium \
				-d ${WEBRTC_SRC} < $${p} && \
				cp $${p} ${WRKDIR}/patches/chromium/ || \
				cp $${p} ${WRKDIR}/patches/chromium.rej/ ; \
		else \
			cp $${p} ${WRKDIR}/patches/chromium.miss/ ; \
		fi ; \
	done
	@echo "rejected:"
	@ls ${WRKDIR}/patches/chromium.rej
	# if ok, copy ${WRKDIR}/patches/chromium into port

.include "modules.inc"
.include "crates.inc"
.include "webrtc.inc"
.include <bsd.port.mk>
