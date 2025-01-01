COMMENT=	generic helper tool to build app in a distributable format

MODGO_MODNAME=	github.com/develar/app-builder
MODGO_VERSION=	v0.0.0-20240625173044-ea95e30dbc1a

DISTNAME=	app-builder-v5.0.0
REVISION=	0

CATEGORIES=	devel

HOMEPAGE=	https://github.com/develar/app-builder

MAINTAINER=	Fabien Romano <fabien@openbsd.org>

# MIT
PERMIT_PACKAGE=	Yes

WANTLIB += c pthread

TEST_DEPENDS+=	lang/node devel/pnpm devel/yarn

MODULES=	lang/go

WRKDIST=	${WRKSRC}

# XXX test need internet acces, check pf.conf for _pbuild
pre-test:
	# setup npm, pnpm, yarn node_modules
	cd ${WRKSRC}/pkg/node-modules/npm-demo && \
		${SETENV} ${MAKE_ENV} HOME=${WRKDIR} \
		npm ci --ignore-scripts
	cd ${WRKSRC}/pkg/node-modules/pnpm-demo && \
		${SETENV} ${MAKE_ENV} HOME=${WRKDIR} \
		pnpm install --ignore-scripts --frozen-lockfile
	cd ${WRKSRC}/pkg/node-modules/yarn-demo && \
		${SETENV} ${MAKE_ENV} HOME=${WRKDIR} \
		yarn install --ignore-scripts --frozen-lockfile

do-test:
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} HOME=${WRKDIR} DEBUG=* \
		${MODGO_CMD} test ./pkg/... ; \
		chmod -R u+w ${MODGO_WORKSPACE}/pkg/mod

.include "modules.inc"

.include <bsd.port.mk>
