COMMENT =	google's tool to sync repository (DEPS)

COMMIT =	acd68a9a5dde2545a28c0c29c058a5070ede076f
V =		0.20240906
DISTNAME =	depot_tools-${COMMIT}
PKGNAME =	gclient-${V}

# see gsutil.py
GSUTIL_V =	4.68
GSUTIL_T =	${WRKSRC}/external_bin/gsutil/gsutil_${GSUTIL_V}

# see cipd_client_version
CIPD_COMMIT =	be41b8d978e22d396ecb4aa9f50ddc3f25977359
CIPD_PLATFORM =	openbsd-${MACHINE_ARCH}

CATEGORIES =	devel

HOMEPAGE =	https://chromium.googlesource.com/chromium/tools/depot_tools.git

MAINTAINER=	Fabien Romano <fabien@openbsd.org>

# BSD-like & Apache 2.0
PERMIT_PACKAGE=	Yes

# googlesource.com does not provide stable snapshots
SITES=		http://distfiles.opencrew.tech/depot_tools/

SITES.gs =	https://storage.googleapis.com/pub/
DISTFILES.gs =	gsutil_${GSUTIL_V}.zip

# XXX devel/cipd port
SITES.cipd =	https://chrome-infra-packages.appspot.com/
DISTFILES.cipd=cipd-${CIPD_PLATFORM}-${CIPD_COMMIT}{client?platform=${CIPD_PLATFORM}&version=git_revision:${CIPD_COMMIT}}

EXTRACT_CASES+=cipd-*) \
	cp ${FULLDISTDIR}/$$archive ${WRKSRC}/.cipd_client && \
	chmod +x ${WRKSRC}/.cipd_client ;;

MODULES =		lang/python

RUN_DEPENDS =		shells/bash \
			www/py-httplib2${MODPY_FLAVOR}

CONFIGURE_STYLE=none # prevent python MODULE from overriding do-build

NO_BUILD =		Yes
NO_TEST =		Yes

TARGET =		${PREFIX}/libexec/gclient

post-extract:
	# prepare gsutil for gclient
	mkdir -p ${GSUTIL_T}
	mv ${WRKDIR}/gsutil ${GSUTIL_T}
	# fake gsutil install from gclient
# XXX doesn't work, see patches
	touch ${GSUTIL_T}/gsutil/install.flag
	# fix MODPY_COMPILEALL
	rm -rf ${GSUTIL_T}/gsutil/gslib/vendored/boto/docs
	rm -rf ${GSUTIL_T}/gsutil/gslib/vendored/boto/tests/db/test_lists.py
	rm -rf ${GSUTIL_T}/gsutil/gslib/vendored/boto/tests/db/test_query.py
	rm -rf ${GSUTIL_T}/gsutil/gslib/vendored/boto/tests/fps/test.py
	rm -rf ${GSUTIL_T}/gsutil/third_party/apitools/ez_setup.py
	rm -rf ${GSUTIL_T}/gsutil/third_party/crcmod/python2
	rm -rf ${GSUTIL_T}/gsutil/third_party/crcmod_osx

do-install:
	${INSTALL_DATA_DIR} ${TARGET}
	cp -p ${WRKSRC}/cipd ${TARGET}
	cp -p ${WRKSRC}/.cipd_client ${TARGET}
	find ${WRKSRC} -name '*.py' -maxdepth 1 \
	    -exec cp "{}" ${TARGET} \;
	${INSTALL_DATA_DIR} ${TARGET}/third_party
	cp -Rp ${WRKSRC}/third_party/* ${TARGET}/third_party
	${INSTALL_DATA_DIR} ${TARGET}/external_bin
	cp -Rp ${WRKSRC}/external_bin/* ${TARGET}/external_bin
	${MODPY_COMPILEALL} ${TARGET}
	# wrapper
	${SUBST_PROGRAM} ${FILESDIR}/gclient \
		${PREFIX}/bin/gclient

### targets for port maintainer(s)

_SRC?=	${WRKDIR}/gn
_FETCH?=https://chromium.googlesource.com/chromium/tools/depot_tools.git \
	${COMMIT}
tarball:
	mkdir -p ${_SRC}/${DISTNAME}
	cd ${_SRC}/${DISTNAME} && [ -d ".git" ] || ( \
	HOME=${_SRC} git init && \
	HOME=${_SRC} git fetch ${_FETCH} --depth 1 && \
	HOME=${_SRC} git checkout FETCH_HEAD \
	)
	cd ${_SRC} && \
	find ./${DISTNAME} -type f -a ! -path '*/.git/*' | sort > files && \
	tar -cRzf ${DISTNAME}${EXTRACT_SUFX} -I files && \
	sha256 -b ${DISTNAME}${EXTRACT_SUFX}

.include <bsd.port.mk>
