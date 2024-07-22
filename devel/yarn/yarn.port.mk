MODYARN_DIST=		yarn_modules

MODYARN_CACHE?=		${WRKDIR}/.yarn
MODYARN_TARGETS?=	${WRKSRC}
MODYARN_LOCKS?=		${MODYARN_TARGETS:=%/yarn.lock}

SITES.yarn?=		https://registry.yarnpkg.com/
SITES.yarn_npm?=	https://registry.npmjs.org/
SITES.yarn_github?=	${SITES.github}
SITES.yarn_codeload?=	${SITES.github}

# XXX use DISTFILES.<site> instead of DIST_TUPLE ? (get rid of .- maybe)
TEMPLATE_DISTFILES.yarn?= \
	${MODYARN_DIST}/<account>-{<account>/<project>/-/}<project>-<id>.tgz
TEMPLATE_DISTFILES.yarn_npm = ${TEMPLATE_DISTFILES.yarn}
TEMPLATE_DISTFILES.yarn_github?= \
	${MODYARN_DIST}/${TEMPLATE_DISTFILES.github:S/>-</>%</:S/-{/.git-{/}
TEMPLATE_DISTFILES.yarn_codeload?= \
	${MODYARN_DIST}/${TEMPLATE_DISTFILES.github:S/-{/%{/}

BUILD_DEPENDS+=		devel/yarn

PORTHOME?=		${WRKDIR}

EXTRACT_CASES+=		${MODYARN_DIST}/*.git-*) \
	_filename=$$(echo $${archive\#\#*/} | \
		sed -e '/%/s/${EXTRACT_SUFX.github}//' \
		-e '/%/s/.*%//' -e 's/\.-//') ; \
	_module=$$(${TAR} -ztf ${FULLDISTDIR}/$$archive | \
		awk -F/ '{print $$1}' | uniq) ; \
	[[ -d ${MODYARN_CACHE} ]] || mkdir -p ${MODYARN_CACHE} ; \
	${GZIP_CMD} -d <${FULLDISTDIR}/$$archive | ${TAR} -xf - -- && \
	${TAR} -cf ${MODYARN_CACHE}/$$_filename -C $$_module ./ && \
	rm -rf $$_module \
	;;

EXTRACT_CASES+=		${MODYARN_DIST}/*) \
	_filename=$$(echo $${archive\#\#*/} | \
		sed -e '/%/s/${EXTRACT_SUFX.github}//' \
		-e '/%/s/.*%//' -e 's/\.-//') && \
	mkdir -p ${MODYARN_CACHE} && \
	ln -fs ${FULLDISTDIR}/$$archive \
		${MODYARN_CACHE}/$$_filename \
	;;

.if empty(_GEN_MODULES)
MODYARN_post-extract+= \
	if [ -e ${MODYARN_CACHE} ]; then \
		echo 'yarn-offline-mirror "${MODYARN_CACHE}"' >> \
			${PORTHOME}/.yarnrc ; \
		for _target in ${MODYARN_TARGETS}; do \
			cd $$_target && env -i ${MAKE_ENV} \
			yarn install --frozen-lockfile --offline \
			--ignore-scripts --ignore-engines \
			${MODYARN_OMITOPTIONAL:S/Yes/--ignore-optional/:S/No//}\
			; \
		done ; \
	fi ;
.endif

MODYARN_post-extract += rm -rf ${MODYARN_CACHE} ;

# XXX path to yarn_dist
.if !target(modyarn-gen-modules)
modyarn-gen-modules:
	@make -D _GEN_MODULES extract >/dev/null 2>&1
	# make modyarn-gen-modules > modules.inc
	@/usr/ports/mystuff/devel/yarn/yarn_dist \
		${MODYARN_LOCKS}
.endif
