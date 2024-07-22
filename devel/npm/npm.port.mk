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

.if !empty(MODNPM_BIN) && empty(_GEN_MODULES)
# XXX multiple module may end with same bin, use ln -f
# ln: .../node_modules/.bin/jest: File exists
# /node_modules/jest-cli/./bin/jest.js;/node_modules/.bin/jest
# /node_modules/jest/./bin/jest.js;/node_modules/.bin/jest
MODNPM_post-extract += \
	for _ln in $$(echo "${MODNPM_BIN}"); do \
		_src=$${_ln%;*} ; _dst=$${_ln\#*;} ; \
		_t=`dirname ${WRKSRC}/$${_dst}`; \
		[[ -d $$_t ]] || mkdir -p $$_t ; \
		chmod +x ${WRKSRC}/$${_src} ; \
		ln -fs ${WRKSRC}/$${_src} ${WRKSRC}/$${_dst} ; \
	done ;
.endif

# XXX path to npm_dist
.if !target(modnpm-gen-modules)
modnpm-gen-modules:
	@make -D _GEN_MODULES extract >/dev/null 2>&1
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

# XXX path to npm_bin
.if !target(modnpm-gen-bin)
modnpm-gen-bin:
	@make extract >/dev/null 2>&1
	# make modnpm-gen-bin >> modules.inc
	@/usr/ports/mystuff/devel/npm/npm_bin \
		${WRKSRC} ${MODNPM_TARGETS}
.endif