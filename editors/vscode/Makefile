# XXX _pbuild default to openfiles-max=1024 is not eough ?
# XXX kerberos test ?

# XXX too restrictive ?
ONLY_FOR_ARCHS=	amd64

COMMENT=	Visual Studio Code - Open Source ("Code - OSS")

V=		1.96.2
COMMIT=		f1a4fb101478ce6ec82fe9627c43efbf9e98c813
PKGNAME=	vscode-${V}
DIST_TUPLE=	github microsoft vscode ${V} .

CATEGORIES=	editors

HOMEPAGE=	https://code.visualstudio.com/

MAINTAINER=	Fabien Romano <fabien@openbsd.org>

# MIT
PERMIT_PACKAGE=	Yes

# check builtInExtensions from product.json, use pre-build .vsix (.zip)
VSCODE_EXTENSIONS=	js-debug-companion js-debug-companion 1.1.3 \
			js-debug js-debug 1.96.0 \
			js-profile-visualizer vscode-js-profile-table 1.0.10
SITES.exts=		https://github.com/microsoft/

.for _git _ext _v in ${VSCODE_EXTENSIONS}
SITES.${_ext}=		${SITES.exts}/vscode-${_git}/releases/download/v${_v}/
DISTFILES.${_ext}=	ms-vscode.${_ext}.${_v}.vsix
.endfor

EXTRACT_CASES+=		*.vsix) \
	_filename=$${archive\#\#*/} && \
	${UNZIP} -oq ${FULLDISTDIR}/$$archive \
		-d ${WRKDIR}/$${_filename%.vsix} ;;

WANTLIB += ${COMPILER_LIBCXX} c m notify util

COMPILER=	base-clang ports-gcc

MODULES=	devel/npm \
		lang/python \
		security/heimdal \
		www/electron

MODPY_RUNDEP=	No

MODNPM_TARGETS=$$( \
	grep "'," ${WRKSRC}/build/npm/dirs.js | \
		cut -f 2 -d "'" | \
		xargs -L1 printf '${WRKSRC}/%s\n')
MODNPM_LOCKS=$$( \
	grep "'," ${WRKSRC}/build/npm/dirs.js | \
		cut -f 2 -d "'" | \
		xargs -L1 printf '${WRKSRC}/%s/package-lock.json\n')
MODNPM_BUILD=	No
MODNPM_INSTALL=	No

MODELECTRON_BUILD=	No
MODELECTRON_INSTALL=	No

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

CXXFLAGS+=	-I${LOCALBASE}/include/inotify
LDFLAGS+=	-L${LOCALBASE}/lib

MAKE_ENV+=	BUILD_SOURCEVERSION=${SOURCE_COMMIT_HASH}
# Don't download browser binaries on playwright node_modules installation
MAKE_ENV+=	PLAYWRIGHT_BROWSERS_PATH=${WRKDIR}/pw-browsers \
		PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

MAKE_ENV+=	CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"

DIST_TARGET =	${ELECTRON_DIST_APPS}/code-oss

post-extract:
	cp ${WRKSRC}/build/.moduleignore{.linux,.openbsd}

do-configure:
	mkdir -p ${WRKDIR}/tmp
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
	for subdir in `find ${WRKSRC}/node_modules -type f \
	    -name binding.gyp -exec dirname {} ';'`; do \
		[ -f $${subdir}/.build_done ] && \
			echo "skip $${subdir}" && \
			continue; \
		echo "rebuild $${subdir}"; \
		cd $${subdir} && ${SETENV} ${MAKE_ENV} ${ELECTRON_REBUILD_ENV} \
			node ${NPM_GYP_BIN} rebuild --verbose ; \
		touch $${subdir}/.build_done; \
	done
	cd ${WRKSRC}/extensions && ${SETENV} ${MAKE_ENV} \
		${ELECTRON_REBUILD_ENV} npm rebuild --verbose
	# rebuild native node modules for node
.for dir in build remote
	cd ${WRKSRC}/${dir} && ${NPM_CMD} rebuild ${NPM_ARGS}
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
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
		node ./node_modules/typescript/bin/tsc \
		-p build/tsconfig.build.json
	echo "require('graceful-fs').gracefulify(require('fs'));" \
		> ${WRKSRC}/use-graceful-fs.cjs
# XXX _pbuild default to openfiles-max=1024 is not eough ?
	ulimit -Sn `ulimit -Hn`
	ulimit -Sd `ulimit -Hd`
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
		NODE_OPTIONS="--require ${WRKSRC}/use-graceful-fs.cjs" \
		node ./node_modules/gulp/bin/gulp.js vscode-linux-x64-min
	# copy marketplace extensions
.for _git _ext _v in ${VSCODE_EXTENSIONS}
	_dst='${WRKDIR}/VSCode-linux-x64/extensions' && \
	mkdir -p $${_dst}/ms-vscode.${_ext} && \
	cp -Rp ${WRKDIR}/ms-vscode.${_ext}*${_v}/extension/* \
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
	mkdir -p ${WRKDIR}/.config/electron
# XXX not ok 95 app module sandbox options
# Unhandled exception in main spec runner:... to not include '--no-sandbox'
	cp ${LOCALBASE}/electron/${ELECTRON_V}/electron_nosandbox.sh \
		${WRKSRC}/.build/electron/code-oss
#	cp ${TRUEPREFIX}/bin/electron \
#		${WRKSRC}/.build/electron/code-oss
.for _git _ext _v in ${VSCODE_EXTENSIONS}
	_dst='${WRKSRC}/.build/builtInExtensions' && \
	mkdir -p $${_dst}/ms-vscode.${_ext} && \
	cp -Rp ${WRKDIR}/ms-vscode.${_ext}*${_v}/extension/* \
		$${_dst}/ms-vscode.${_ext}
.endfor

# XXX Xvfb :1 &
# XXX nosandbox || unveil /
do-test:
	# unit tests
	cd ${WRKSRC} && ${SETENV} ${TEST_ENV} DISPLAY=:1 \
		./scripts/test.sh || true
	# UI smoke tests
# XXX Error: Unsupported platform: openbsd
# node_modules/playwright-core/lib/server/registry/index.js
	cd ${WRKSRC} && ${SETENV} ${TEST_ENV} DISPLAY=:1 \
		ELECTRON_PATH=${LOCALBASE}/bin/electron \
		npm run smoketest

.include "modules.inc"

.include <bsd.port.mk>
