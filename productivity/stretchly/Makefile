COMMENT=	break time reminder app

COMMIT=		ba95df8854b12f2518aa5bd3059c88679b8cda0b
DISTNAME=	stretchly-${COMMIT}
PKGNAME=	stretchly-1.15.1

DIST_TUPLE=	github hovancik stretchly ${COMMIT} .

CATEGORIES=	productivity

HOMEPAGE=	https://hovancik.net/stretchly/
MAINTAINER=	fabien@openbsd.org

# BSD 2-Clause
PERMIT_PACKAGE=	Yes

BUILD_DEPENDS+=	devel/app-builder

RUN_DEPENDS+=	devel/desktop-file-utils \
		x11/gtk+4,-guic

MODULES=	devel/npm www/electron

MODNPM_OMITOPTIONAL=	Yes
MODELECTRON_BUILDER=	Yes
MODELECTRON_SRC=	${WRKSRC}
MODELECTRON_TARGET=	stretchly

pre-build:
	# generate icon files
	cd ${WRKSRC} && env -i ${MAKE_ENV} app-builder icon \
		--input=icon.icns --out=icons --format=set --root=build
.for size in 16 48
	mv ${WRKSRC}/icons/icon_${size}x${size}.png \
		${WRKSRC}/icons/icon_${size}.png
.endfor

post-install:
	# wraper
	${SUBST_PROGRAM} ${FILESDIR}/${MODELECTRON_TARGET} \
		${PREFIX}/bin/${MODELECTRON_TARGET}
	# menu
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications
	${INSTALL_DATA} ${WRKSRC}/net.hovancik.Stretchly.desktop \
		${PREFIX}/share/applications/${MODELECTRON_TARGET}.desktop
	${INSTALL_DATA_DIR} ${PREFIX}/share/metainfo/
	${INSTALL_DATA} ${WRKSRC}/net.hovancik.Stretchly.metainfo.xml \
		${PREFIX}/share/metainfo/${MODELECTRON_TARGET}.metainfo.xml
.for size in 16 32 48 64 128 256 512 1024
	${INSTALL_DATA_DIR} ${PREFIX}/share/icons/hicolor/${size}x${size}/apps
	${INSTALL_DATA} ${WRKSRC}/icons/icon_${size}.png \
		${PREFIX}/share/icons/hicolor/${size}x${size}/apps/${MODELECTRON_TARGET}.png
.endfor

.include "modules.inc"

.include <bsd.port.mk>
