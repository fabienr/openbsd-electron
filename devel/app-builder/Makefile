COMMENT =	generic helper tool to build app in a distributable format

MODGO_MODNAME =	github.com/develar/app-builder
MODGO_VERSION =	v0.0.0-20240501180311-d0aa23a1b5f2

DISTNAME =	app-builder-v5.0.0

CATEGORIES =	devel

MAINTAINER=	fabien@openbsd.org

# MIT
PERMIT_PACKAGE=	Yes

WANTLIB += c pthread

TEST_DEPENDS+=	lang/node devel/pnpm devel/yarn

MODULES =	lang/go

WRKDIST =	${WRKSRC}

# XXX test need internet acces, check pf.conf for _pbuild
pre-test:
	# setup npm, pnpm, yarn node_modules
	cd ${WRKSRC}/pkg/node-modules/npm-demo && \
		env -i ${MAKE_ENV} HOME=${WRKDIR} \
		npm ci
	cd ${WRKSRC}/pkg/node-modules/pnpm-demo && \
		env -i ${MAKE_ENV} HOME=${WRKDIR} \
		pnpm install --frozen-lockfile
	cd ${WRKSRC}/pkg/node-modules/yarn-demo && \
		env -i ${MAKE_ENV} HOME=${WRKDIR} \
		yarn install --frozen-lockfile

do-test:
	cd ${WRKSRC} && ${MODGO_CMD} test ./pkg/...
	chmod -R u+w ${MODGO_WORKSPACE}/pkg/mod

.include "modules.inc"

.include <bsd.port.mk>
