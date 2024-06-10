# XXX _pbuild default to openfiles-max=1024 is not eough ?

# XXX vscode 1.90.0 version mismatch :
# .yarnrc, electron 29.4.0 vs 29.4.1
# remote/.yarnrc, node 20.11.1 vs 20.13.1

# XXX too restrictive ?
ONLY_FOR_ARCHS=	amd64

COMMENT=	Visual Studio Code - Open Source ("Code - OSS")

V=		1.90.0
REVISION=	0
DIST_TUPLE=	github microsoft vscode ${V} .

CATEGORIES=	editors

HOMEPAGE=	https://code.visualstudio.com/
MAINTAINER=	fabien@openbsd.org

# MIT
PERMIT_PACKAGE=	Yes

# check builtInExtensions from product.json, use pre-build .vsix (.zip)
VSCODE_EXTENSIONS =	js-debug-companion 1.1.2 \
			js-debug 1.90.0 \
			vscode-js-profile-table 1.0.9
SITES.extensions=	https://open-vsx.org/vscode/gallery/publishers/ms-vscode/vsextensions/
.for _ext _v in ${VSCODE_EXTENSIONS}
DISTFILES.extensions+=	ms-vscode.${_ext}-${_v}.vsix{${_ext}/${_v}/vspackage}
.endfor
EXTRACT_CASES +=	*.vsix) \
	_filename=$${archive\#\#*/} && \
	${UNZIP} -oq ${FULLDISTDIR}/$$archive \
		-d ${WRKDIR}/$${_filename%.vsix} ;;

PATCH_LIST=	patch-* node_modules/patch-*

WANTLIB += ${COMPILER_LIBCXX} c m notify util

COMPILER=	base-clang ports-gcc

# npm for MODNPM_GYP_BIN only
MODULES =	devel/npm \
		devel/yarn \
		lang/python \
		www/electron

BUILD_DEPENDS=	archivers/unzip \
		archivers/zip \
		devel/libinotify \
		lang/node \
		textproc/ripgrep

RUN_DEPENDS=	devel/desktop-file-utils \
		devel/xdg-utils \
		shells/bash

LIB_DEPENDS=	devel/libnotify

USE_GMAKE=	Yes

MODPY_RUNDEP=	No

# XXX tree-sitter is not optional, looks like
# build/lib/policies.ts:11:25 - error TS2307:
# Cannot find module 'tree-sitter' or its corresponding type declarations
#MODYARN_OMITOPTIONAL=Yes

MODYARN_TARGETS=$$( \
	grep "'," ${WRKSRC}/build/npm/dirs.js | \
		cut -f 2 -d "'" | \
		xargs -L1 printf '${WRKSRC}/%s\n')
MODYARN_LOCKS=$$( \
	grep "'," ${WRKSRC}/build/npm/dirs.js | \
		cut -f 2 -d "'" | \
		xargs -L1 printf '${WRKSRC}/%s/yarn.lock\n')

CXXFLAGS+=	-I${LOCALBASE}/include/inotify
LDFLAGS+=	-L${LOCALBASE}/lib

DIST_TARGET =		${ELECTRON_DIST_APPS}/code-oss

# BUILD_SOURCEVERSION, github commitid matching release
MAKE_ENV+=	BUILD_SOURCEVERSION=${COMMIT}
MAKE_ENV+=	PLAYWRIGHT_BROWSERS_PATH=${WRKDIR}/pw-browsers \
		PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
MAKE_ENV+=	CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"

post-extract:
	cp ${WRKSRC}/build/.moduleignore{.linux,.openbsd}
	# early patch for yarn package manager
	for p in ${PATCHDIR}/post_extract/patch-*; do \
		${PATCH} ${PATCH_DIST_ARGS} \
		-z .orig.post_extract \
		-d ${WRKSRC} < $${p}; \
	done

do-configure:
	# setup yarnrc for using local node headers
	echo 'nodedir "${ELECTRON_NODE_DIR}"' >> ${WRKSRC}/.yarnrc
	echo 'nodedir "${LOCALBASE}"' >> ${WRKSRC}/remote/.yarnrc
	# preset desktop files
	sed -i.bak \
		's/@@NAME_LONG@@/Code - OSS/; \
		s/@@NAME_SHORT@@/Code - OSS/; \
		s/@@PRODNAME@@/Code - OSS/; \
		s/@@NAME@@/code-oss/g; \
		s|@@EXEC@@|${PREFIX}/bin/vscode|; \
		s/@@ICON@@/code-oss/; \
		s/@@URLPROTOCOL@@/code-oss/; \
		s/@@LICENSE@@/MIT/; \
		s/@@APPNAME@@/code-oss/g; \
		s|/usr/share|${PREFIX}/share|' \
		${WRKSRC}/resources/linux/code.appdata.xml \
		${WRKSRC}/resources/linux/code.desktop \
		${WRKSRC}/resources/linux/code-url-handler.desktop

pre-build:
	# rebuild native node modules for electron
# XXX do not rebuild if .build_done (for testing only ?)
	for subdir in `find ${WRKSRC}/node_modules -type f -name binding.gyp -exec dirname {} ';'`; do \
		name=`basename $${subdir}`; \
		[ -f $${subdir}/.build_done ] && \
			echo "skip $${subdir}" && \
			continue; \
		echo "rebuild $${subdir}"; \
		cd $${subdir} && env -i ${MAKE_ENV} ${ELECTRON_REBUILD_ENV} \
			node ${MODNPM_GYP_BIN} rebuild --verbose; \
		touch $${subdir}/.build_done; \
	done
	cd ${WRKSRC}/extensions && env -i ${MAKE_ENV} ${ELECTRON_REBUILD_ENV} \
		npm rebuild --verbose
	# rebuild native node modules for node
.for dir in build remote
	cd ${WRKSRC}/${dir} && env -i ${MAKE_ENV} \
		npm_config_nodedir=${LOCALBASE} \
		npm rebuild --verbose
.endfor
	# copy rg binary files to vscode-ripgrep module directory
	mkdir -p ${WRKSRC}/node_modules/@vscode/ripgrep/bin
	cp -p ${LOCALBASE}/bin/rg \
		${WRKSRC}/node_modules/@vscode/ripgrep/bin
	mkdir -p ${WRKSRC}/remote/node_modules/@vscode/ripgrep/bin
	cp -p ${LOCALBASE}/bin/rg \
		${WRKSRC}/remote/node_modules/@vscode/ripgrep/bin

do-build:
	# build and package vscode
	cd ${WRKSRC} && env -i ${MAKE_ENV} \
		yarn run tsc -p build/tsconfig.build.json
	echo "require('graceful-fs').gracefulify(require('fs'));" \
		> ${WRKSRC}/use-graceful-fs.js
# XXX _pbuild default to openfiles-max=1024 is not eough ?
	ulimit -Sn `ulimit -Hn`
	ulimit -Sd `ulimit -Hd`
	cd ${WRKSRC} && env -i ${MAKE_ENV} \
		NODE_OPTIONS="--require ${WRKSRC}/use-graceful-fs.js" \
		yarn gulp vscode-linux-x64-min
	# copy marketplace extensions
.for _ext _v in ${VSCODE_EXTENSIONS}
	_dst='${WRKDIR}/VSCode-linux-x64/extensions' && \
	mkdir -p $${_dst}/ms-vscode.${_ext} && \
	cp -Rp ${WRKDIR}/ms-vscode.${_ext}-${_v}/extension/* \
		$${_dst}/ms-vscode.${_ext}
.endfor

do-install:
	# wraper
	${SUBST_PROGRAM} ${FILESDIR}/vscode ${PREFIX}/bin/vscode
	# menu
	${INSTALL_DATA_DIR} ${PREFIX}/share/appdata
	${INSTALL_DATA} ${WRKSRC}/resources/linux/code.appdata.xml \
		${PREFIX}/share/appdata/code-oss.appdata.xml
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications
.for f in code.desktop code-url-handler.desktop
	${INSTALL_DATA} ${WRKSRC}/resources/linux/${f} \
		${PREFIX}/share/applications/${f:S/code/code-oss/}
.endfor
	${INSTALL_DATA_DIR} ${PREFIX}/share/pixmaps
	${INSTALL_DATA} ${WRKSRC}/resources/linux/code.png \
		${PREFIX}/share/pixmaps/code-oss.png
	# resources
	${INSTALL_DATA_DIR} ${PREFIX}/${DIST_TARGET}
	@cp -Rp ${WRKDIR}/VSCode-linux-x64/* ${PREFIX}/${DIST_TARGET}/
	@chown -R ${SHAREOWN}:${SHAREGRP} ${PREFIX}/${DIST_TARGET}
	@rm -rf ${PREFIX}/${DIST_TARGET}/bin
	@rm -rf ${PREFIX}/${DIST_TARGET}/resources/completions

pre-test:
	# setup electron dependency for unit tests
	mkdir -p ${WRKSRC}/.build/electron
	mkdir -p ${WRKDIR}/.config/chromium
# XXX not ok 95 app module sandbox options
# Unhandled exception in main spec runner:... to not include '--no-sandbox'
#	cp ${TRUEPREFIX}/bin/electron_nosandbox \
#		${WRKSRC}/.build/electron/code-oss
	cp ${TRUEPREFIX}/bin/electron \
		${WRKSRC}/.build/electron/code-oss
.for _ext _v in ${VSCODE_EXTENSIONS}
	_dst='${WRKSRC}/.build/builtInExtensions' && \
	mkdir -p $${_dst}/ms-vscode.${_ext} && \
	cp -Rp ${WRKDIR}/ms-vscode.${_ext}-${_v}/extension/* \
		$${_dst}/ms-vscode.${_ext}
.endfor
	rm -rf ${WRKSRC}/out
	ln -s ${WRKSRC}/out-build ${WRKSRC}/out

do-test:
	# XXX Xvfb :1 &
	# unit tests
	cd ${WRKSRC} && env -i ${TEST_ENV} DISPLAY=:1 \
		LD_LIBRARY_PATH="${LOCALBASE}/electron" \
		./scripts/test.sh || true
	# UI smoke tests
	# XXX Error: Unsupported platform: openbsd
	# node_modules/playwright-core/lib/server/registry/index.js
	cd ${WRKSRC} && env -i ${TEST_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron_nosandbox \
		yarn smoketest

.include "modules.inc"

.include <bsd.port.mk>
