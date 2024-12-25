COMMENT =	unofficial Microsoft Teams client

T=		teams-for-linux
V=		1.11.5
DIST_TUPLE =	github IsmaelMartinez ${T} v${V} .

CATEGORIES =	net

MAINTAINER=	Fabien Romano <fabien@openbsd.org>

# GPLv3
PERMIT_PACKAGE =	Yes

# Any modules we may be using
MODULES =		devel/npm \
			www/electron

MODELECTRON_BUILDER=	Yes
MODELECTRON_SRC=	${WRKSRC}
MODELECTRON_TARGET=	${T}

MODELECTRON_WRAPPER=	Yes
MODELECTRON_WRAPPER_APP=${T}
MODELECTRON_WRAPPER_ARG=--no-sandbox # temporary, untested

MODNPM_BUILD=		No
MODNPM_INSTALL=		No

RUN_DEPENDS+=devel/desktop-file-utils

post-install:
	# menu
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications
	${INSTALL_DATA} ${FILESDIR}/${MODELECTRON_TARGET}.desktop \
		${PREFIX}/share/applications/${MODELECTRON_TARGET}.desktop
	${INSTALL_DATA_DIR} ${PREFIX}/share/pixmaps
	${INSTALL_DATA} ${WRKSRC}/build/icons/1024x1024.png \
		${PREFIX}/share/pixmaps/${MODELECTRON_TARGET}.png

.include "modules.inc"

.include <bsd.port.mk>
