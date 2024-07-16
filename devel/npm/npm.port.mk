MODNPM_DIST=	npm_modules

MODNPM_CACHE?=		${WRKDIR}/.npm
MODNPM_TARGETS?=	${WRKSRC}
MODNPM_LOCKS?=		${MODNPM_TARGETS:=%/package-lock.json}

MODNPM_OMITDEV?=	No # omit dev depends
MODNPM_OMITOPTIONAL?=	No # omit optional depends
MODNPM_INCLUDES?= 	# include package
MODNPM_EXCLUDES?= 	# exclude package

MODNPM_NPM_MOD=${LOCALBASE}/lib/node_modules/npm
MODNPM_GYP_BIN=${MODNPM_NPM_MOD}/node_modules/node-gyp/bin/node-gyp.js

SITES.npm ?=	https://registry.npmjs.org/

# XXX use DISTFILES.npm instead of DIST_TUPLE ? (get rid of .- maybe)
TEMPLATE_DISTFILES.npm ?= \
	${MODNPM_DIST}/<account>-{<account>/<project>/-/}<project>-<id>.tgz

# XXX always fix permission, at least for pngjs-6.0.0 (from games/byar-chobby)
EXTRACT_CASES +=	${MODNPM_DIST}/*.tgz) \
	_filename=$${archive\#\#*/} ; \
	_location=${MODNPM_CACHE}/$${_filename%.tgz} ; \
	[[ -d ${MODNPM_CACHE} ]] || mkdir ${MODNPM_CACHE} ; \
	${GZIP_CMD} -d <${FULLDISTDIR}/$$archive | ${TAR} -xf - -- && \
	mv "`${TAR} -ztf ${FULLDISTDIR}/$$archive | \
		awk -F/ '{print $$1}' | uniq`" $$_location && \
	chmod -R a+rX $$_location ;;

.if !empty(MODNPM_CP) && empty(_GEN_MODULES)
# note _dst;_src because list is sorted to let shorter _dst path come first
MODNPM_post-extract += \
	for _cp in $$(echo "${MODNPM_CP}"); do \
		_dst=$${_cp%;*} ; _src=$${_cp\#*;} ; \
		_t=`dirname ${WRKSRC}/$${_dst}`; \
		[[ -d $$_t ]] || mkdir -p $$_t ; \
		cp -Rp ${WRKDIR}/.npm/$${_src} ${WRKSRC}/$${_dst} ; \
	done ;
.endif

MODNPM_post-extract += rm -rf ${MODNPM_CACHE} ;

# XXX path to npm_dist
.if !target(modnpm-gen-modules)
modnpm-gen-modules:
	@${_MAKE} -D _GEN_MODULES extract >/dev/null 2>&1
	# make modnpm-gen-modules > modules.inc
	# MODNPM_OMITDEV=${MODNPM_OMITDEV}
	# MODNPM_OMITOPTIONAL=${MODNPM_OMITOPTIONAL}
	# MODNPM_INCLUDES=${MODNPM_INCLUDES}
	# MODNPM_EXCLUDES=${MODNPM_EXCLUDES}
	@/usr/ports/mystuff/devel/npm/npm_dist \
		${MODNPM_OMITDEV:S/Yes/-d/:S/No//} \
		${MODNPM_OMITOPTIONAL:S/Yes/-o/:S/No//} \
		${MODNPM_INCLUDES:='-i %'} \
		${MODNPM_EXCLUDES:='-x %'} \
		${WRKSRC} ${MODNPM_LOCKS}
.endif
