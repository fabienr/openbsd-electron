# sync with Makefile
ELECTRON_V=		33.2.1

ELECTRON_DIST_APPS=	electron/resources
ELECTRON_WRAPPER=	electron/${ELECTRON_V}/electron.sh

# rebuild/update depends if version changed
ELECTRON_REV=${ELECTRON_V:S/.//g}
.if !empty(REVISION)
REV:=${REVISION}
.endif
REVISION=${ELECTRON_REV}${REV}

# XXX target based on pkgname ?
# target application's name
MODELECTRON_TARGET?=
ELECTRON_DIST_TARGET=${ELECTRON_DIST_APPS}/${MODELECTRON_TARGET}

MODELECTRON_WRAPPER?=No
# setup common wrapper during build
MODELECTRON_WRAPPER_APP?=
MODELECTRON_WRAPPER_ENV?=
MODELECTRON_WRAPPER_ARG?=

MODELECTRON_BUILDER?=No
# directory to build/install with app-builder
MODELECTRON_SRC?=
ELECTRON_BUILDER_DIR=${MODELECTRON_SRC}/dist/linux-unpacked/resources

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

MODELECTRON_BUILD?=	Yes
MODELECTRON_INSTALL?=	Yes

SUBST_VARS+=		ELECTRON_V ELECTRON_DIST_APPS ELECTRON_WRAPPER \
			MODELECTRON_TARGET MODELECTRON_WRAPPER_ENV \
			MODELECTRON_WRAPPER_ARG

.if ${MODELECTRON_BUILDDEP:L} == "yes"
BUILD_DEPENDS +=	www/electron
.  if ${MODELECTRON_BUILDER:L} == "yes"
BUILD_DEPENDS +=	devel/app-builder
.  endif
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

ELECTRON_BUILDER_INSTALL=\
	[ -d ${ELECTRON_BUILDER_DIR}/app.asar.unpacked ] && \
	${INSTALL_DATA_DIR} ${PREFIX}/${ELECTRON_DIST_TARGET}.asar.unpacked && \
	cp -Rp ${ELECTRON_BUILDER_DIR}/app.asar.unpacked/* \
		${PREFIX}/${ELECTRON_DIST_TARGET}.asar.unpacked ; \
	${INSTALL_DATA_DIR} ${PREFIX}/${ELECTRON_DIST_APPS} && \
	${INSTALL_DATA} ${ELECTRON_BUILDER_DIR}/app.asar \
		${PREFIX}/${ELECTRON_DIST_TARGET}.asar

# XXX how app use this file ?
#	${INSTALL_DATA} ${BUILDDIR}/app-update.yml \
#		${PREFIX}/${ELECTRON_DIST_TARGET}-update.yml

ELECTRON_WRAPPER_SCRIPT=\
\#!/bin/sh \n\
\# pre-create folder for unveil \n\
if [ -z "$${XDG_CONFIG_HOME}" ]; then \n\
	[ -d "$${HOME}/.config/${MODELECTRON_APPNAME}" ] || \
	mkdir -p "$${HOME}/.config/${MODELECTRON_APPNAME}" \n\
else \n\
	[ -d "$${XDG_CONFIG_HOME}/${MODELECTRON_APPNAME}" ] || \
	mkdir -p "$${XDG_CONFIG_HOME}/${MODELECTRON_APPNAME}" \n\
fi \n\
\# start \n\
${MODELECTRON_WRAPPER_ENV} exec ${TRUEPREFIX}/${ELECTRON_WRAPPER} \
	${MODELECTRON_WRAPPER_ARG} \
	--app="${TRUEPREFIX}/${ELECTRON_DIST_APPS}/${MODELECTRON_TARGET}.asar" \
	$$@ \n
ELECTRON_WRAPPER_INSTALL=\
	echo '${ELECTRON_WRAPPER_SCRIPT}' \
		> ${PREFIX}/bin/${MODELECTRON_TARGET} && \
		chmod +x ${PREFIX}/bin/${MODELECTRON_TARGET}

.if !target(do-build) && ${MODELECTRON_BUILD:L} == "yes"
do-build:
.  if ${MODELECTRON_BUILDER:L} == "yes"
	${ELECTRON_BUILDER_BUILD}
.  endif
.endif

.if !target(do-install) && ${MODELECTRON_INSTALL:L} == "yes"
do-install:
.  if ${MODELECTRON_BUILDER:L} == "yes"
	${ELECTRON_BUILDER_INSTALL}
.  endif
.  if ${MODELECTRON_WRAPPER:L} == "yes"
	${ELECTRON_WRAPPER_INSTALL}
.  endif
.endif
