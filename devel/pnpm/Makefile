COMMENT=	fast, disk space efficient package manager

DISTNAME=	pnpm-9.1.2

CATEGORIES=	devel

HOMEPAGE=	https://pnpm.io/

# MIT
PERMIT_PACKAGE=	Yes

SITES=		https://registry.npmjs.org/pnpm/-/
EXTRACT_SUFX=	.tgz

MODULES=	lang/python

RUN_DEPENDS=	lang/node

NO_BUILD=	Yes

WRKDIST=	${WRKDIR}/package

do-install:
	${INSTALL_DATA_DIR} ${PREFIX}/lib/node_modules/pnpm
	cp -Rp ${WRKDIR}/package/* ${PREFIX}/lib/node_modules/pnpm
	chown -R ${SHAREOWN}:${SHAREGRP} ${PREFIX}/lib/node_modules
	ln -s ../lib/node_modules/pnpm/bin/pnpm.cjs ${PREFIX}/bin/pnpm
	ln -s ../lib/node_modules/pnpm/bin/pnpx.cjs ${PREFIX}/bin/pnpx

post-install:
	${MODPY_COMPILEALL} \
		${PREFIX}/lib/node_modules/pnpm/dist/node_modules/node-gyp

.include <bsd.port.mk>