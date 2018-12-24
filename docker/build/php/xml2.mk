SHELL := /bin/bash
.DEFAULT_GOAL := make_xml2
url_xml2 = http://xmlsoft.org/sources/libxml2-${VERSION_XML2}.tar.gz
build_dir_xml2 = ${DEPS}/xml2

fetch_xml2:
	mkdir -p ${build_dir_xml2}
	${CURL} -Ls ${url_xml2} | tar $(shell ${TARGS} ${url_xml2}) ${build_dir_xml2} --strip-components=1

configure_xml2:
	cd ${build_dir_xml2} && \
	${build_dir_xml2}/configure \
        --prefix=${TARGET} \
        --exec-prefix=${TARGET} \
        --with-sysroot=${TARGET} \
        --enable-shared \
        --disable-static \
        --with-html \
        --with-history \
        --enable-ipv6=no \
        --with-icu \
        --with-zlib=${TARGET} \
		--without-python

build_xml2:
	cd ${build_dir_xml2} && \
	$(MAKE) install && \
	cp xml2-config ${TARGET}/bin/xml2-config
	
version_xml2:
	cat ${VERSIONS_FILE} | ${JQ} --unbuffered --arg xml2 ${VERSION_XML2} '.libraries += {xml2: $$xml2}' > ${VERSIONS_FILE}

make_xml2: fetch_xml2 configure_xml2 build_xml2 version_xml2