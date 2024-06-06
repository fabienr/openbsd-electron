# XXX games/recoil-rts is not compatible with byar, in discussion with thfr@
# move ${LOCALBASE}/bin/spring to ${LOCALBASE}/share/games/spring/spring
# use a wraper : exec "${LOCALBASE}/share/games/spring/spring" "${@}"

COMMENT =	launcher for Beyond All Reason

V =		1.2988.0
DISTNAME =	BYAR-Chobby-${V}
PKGNAME=	${DISTNAME:L}

DIST_TUPLE =	github beyond-all-reason BYAR-Chobby v${V} .

COMMIT =	2c0a6e17b50ab04ea592c53963c571e5ccb071ba
DIST_TUPLE +=	github beyond-all-reason spring-launcher ${COMMIT} launcher

CATEGORIES =	games

HOMEPAGE =	https://www.beyondallreason.info/
MAINTAINER =	fabien@openbsd.org

# XXX licence ??? (spring-launcher = MIT)
PERMIT_PACKAGE=	Yes

BUILD_DEPENDS+=	devel/app-builder

RUN_DEPENDS+=	archivers/p7zip \
		devel/desktop-file-utils \
		www/electron

MODULES =	devel/npm www/electron

MODNPM_OMITOPTIONAL=	Yes
MODNPM_LOCKS=		${WRKSRC}/launcher/package-lock.json
MODELECTRON_BUILDER=	Yes
MODELECTRON_SRC=	${WRKSRC}/launcher
MODELECTRON_TARGET=	byar_chobby_launcher

pre-patch:
	# node_modules
	mv ${WRKSRC}/node_modules ${WRKSRC}/launcher/

pre-build:
	# dist_cfg->launcher/ : build, src/config.json, src/renderer
# XXX from github workflow, cook something less smart ?
	cp -r ${WRKSRC}/dist_cfg/* ${WRKSRC}/launcher/src/
	for dir in bin files build; do \
		mkdir -p ${WRKSRC}/launcher/$$dir ; \
		if [ -d ${WRKSRC}/launcher/src/$$dir/ ]; then \
			mv ${WRKSRC}/launcher/src/$$dir/* \
				${WRKSRC}/launcher/$$dir/ ; \
			rm -rf ${WRKSRC}/launcher/src/$$dir ; \
		fi ; \
	done
	# package.json
# XXX replace with a patch ?
	cd ${WRKSRC} && env -i ${MAKE_ENV} \
		node build/make_package_json.js \
			launcher/package.json \
			dist_cfg/config.json \
			beyond-all-reason/BYAR-Chobby ${V}

post-install:
	# wraper
	${SUBST_PROGRAM} ${FILESDIR}/${MODELECTRON_TARGET} \
		${PREFIX}/bin/${MODELECTRON_TARGET}
	# menu
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications
	${INSTALL_DATA} ${FILESDIR}/${MODELECTRON_TARGET}.desktop \
		${PREFIX}/share/applications/${MODELECTRON_TARGET}.desktop
	${INSTALL_DATA_DIR} ${PREFIX}/share/pixmaps
	${INSTALL_DATA} ${WRKSRC}/dist_cfg/build/icon.png \
		${PREFIX}/share/pixmaps/${MODELECTRON_TARGET}.png
	# remove uneded files
	cd ${PREFIX}/${ELECTRON_DIST_TARGET}.asar.unpacked/ && \
		rm -rf node_modules/7zip-bin/linux && \
		rm -rf node_modules/7zip-bin/mac

.include "modules.inc"

.include <bsd.port.mk>