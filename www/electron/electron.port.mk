# sync with Makefile
ELECTRON_V=		31.3.1
ELECTRON_DIST_APPS=	electron/resources
ELECTRON_WRAPPER=	electron/${ELECTRON_V}/electron.sh

# rebuild/update depends if version changed
ELECTRON_REV=${ELECTRON_V:S/.//g}
.if !empty(REVISION)
REV:=${REVISION}
.endif
REVISION=${ELECTRON_REV}${REV}

MODELECTRON_BUILDER?=No
# directory to build/install with app-builder
MODELECTRON_SRC?=
ELECTRON_BUILDER_DIR=${MODELECTRON_SRC}/dist/linux-unpacked/resources

# XXX target based on pkgname ?
# target application's name
MODELECTRON_TARGET?=
ELECTRON_DIST_TARGET=${ELECTRON_DIST_APPS}/${MODELECTRON_TARGET}

.if ${NO_BUILD:L} == "no"
MODELECTRON_BUILDDEP ?=	Yes
.else
MODELECTRON_BUILDDEP ?=	No
.endif
MODELECTRON_RUNDEP ?=	Yes
.if ${NO_TEST:L} == "no"
MODELECTRON_TESTDEP ?=	Yes
.else
MODELECTRON_TESTDEP ?=	No
.endif

SUBST_VARS+=		ELECTRON_V ELECTRON_DIST_APPS ELECTRON_WRAPPER

.if ${MODELECTRON_BUILDDEP:L} == "yes"
BUILD_DEPENDS +=	www/electron
.endif
.if ${MODELECTRON_RUNDEP:L} == "yes"
RUN_DEPENDS +=		www/electron
.endif
.if ${MODELECTRON_TESTDEP:L} == "yes"
TEST_DEPENDS +=		www/electron
.endif

PORTHOME=		${WRKDIR}
MAKE_ENV+=		TMPDIR=${WRKDIR}/tmp
MAKE_ENV+=		USE_SYSTEM_APP_BUILDER=true
MAKE_ENV+=		ELECTRON_SKIP_BINARY_DOWNLOAD=1
TEST_ENV+=		HOME=${PORTHOME}

ELECTRON_ARCH=		${ARCH:S/aarch64/arm64/:S/amd64/x64/:S/i386/ia32/}
NODE_ARCH=		${ARCH:S/aarch64/arm64/:S/amd64/x64/}

ELECTRON_URL=${SITES.github}electron/electron/releases/download/v${ELECTRON_V}
ELECTRON_URL_HASH=	$$(sha256 -q -s "${ELECTRON_URL}")
ELECTRON_RELEASES=	${LOCALBASE}/electron/${ELECTRON_V}/releases
ELECTRON_NODE_DIR=	${LOCALBASE}/electron/${ELECTRON_V}/node_headers
ELECTRON_REBUILD_ENV=	npm_config_runtime=electron \
			npm_config_target=${ELECTRON_V} \
			npm_config_nodedir=${ELECTRON_NODE_DIR}

ELECTRON_BUILDER_BUILD=\
	mkdir -p ${WRKDIR}/electron && \
		ln -fs ${LOCALBASE}/electron/${ELECTRON_V}/electron \
			${WRKDIR}/electron/electron ; \
	cd ${MODELECTRON_SRC} && ${SETENV} ${MAKE_ENV} \
		./node_modules/electron-builder/cli.js \
		--linux --dir \
		--config.npmRebuild=false \
		--config.electronVersion=${ELECTRON_V} \
		--config.electronDist=${WRKDIR}/electron
# XXX permission ? no INSTALL* fn ? chown ? chmod o-w ?
ELECTRON_BUILDER_INSTALL=\
	${INSTALL_DATA_DIR} ${PREFIX}/${ELECTRON_DIST_APPS} ; \
	${INSTALL_DATA_DIR} ${PREFIX}/${ELECTRON_DIST_TARGET}.asar.unpacked ; \
	cp -Rp ${ELECTRON_BUILDER_DIR}/app.asar.unpacked/* \
		${PREFIX}/${ELECTRON_DIST_TARGET}.asar.unpacked ; \
	${INSTALL_DATA} ${ELECTRON_BUILDER_DIR}/app.asar \
		${PREFIX}/${ELECTRON_DIST_TARGET}.asar
# XXX how app use this file ?
#	${INSTALL_DATA} ${BUILDDIR}/app-update.yml \
#		${PREFIX}/${ELECTRON_DIST_TARGET}-update.yml

.if !target(do-build)
do-build:
.  if ${MODELECTRON_BUILDER:L} == "yes"
	${ELECTRON_BUILDER_BUILD}
.  endif
.endif

.if !target(do-install)
do-install:
.  if ${MODELECTRON_BUILDER:L} == "yes"
	${ELECTRON_BUILDER_INSTALL}
.  endif
.endif
