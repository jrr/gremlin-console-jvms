
GREMLIN_VERSION=3.5.2
MIRROR_URL=https://ftp.wayne.edu/apache

# (more mirrors available at https://www.apache.org/dyn/closer.lua/tinkerpop/ )

## Intermediate Variables

GREMLIN_ZIP=apache-tinkerpop-gremlin-console-${GREMLIN_VERSION}-bin.zip
GREMLIN_ZIP_URL=${MIRROR_URL}/tinkerpop/${GREMLIN_VERSION}/${GREMLIN_ZIP}

DOWNLOAD_DIR=.gremlin-console
DOWNLOADED_GREMLIN_ZIP=${DOWNLOAD_DIR}/${GREMLIN_ZIP}

GREMLIN_UNZIPPED=apache-tinkerpop-gremlin-console-${GREMLIN_VERSION}
GREMLIN_RENAMED=apache-tinkerpop-gremlin-console

GREMLIN_SH=${DOWNLOAD_DIR}/${GREMLIN_RENAMED}/bin/gremlin.sh

${GREMLIN_SH}:
	mkdir -p ${DOWNLOAD_DIR}
	wget ${GREMLIN_ZIP_URL} -O ${DOWNLOADED_GREMLIN_ZIP}
	file ${DOWNLOADED_GREMLIN_ZIP}
	unzip -q ${DOWNLOADED_GREMLIN_ZIP} -d ${DOWNLOAD_DIR}
	# give it a version-independent name so we can add it to PATH with direnv:
	mv ${DOWNLOAD_DIR}/${GREMLIN_UNZIPPED} ${DOWNLOAD_DIR}/${GREMLIN_RENAMED}

download-gremlin-console: ${GREMLIN_SH}
	${GREMLIN_SH} --version

gremlin-console: ${GREMLIN_SH}
	${GREMLIN_SH}

gremlin-console-local: ${GREMLIN_SH}
	${GREMLIN_SH} -i gremlin/gremlin-local.groovy

# for use with an SSH tunnel on :8183
gremlin-console-neptune: ${GREMLIN_SH}
	${GREMLIN_SH} -i gremlin/gremlin-neptune.groovy


##### more JVMs

JDK_ORACLE_18_ARM=https://download.oracle.com/java/18/latest/jdk-18_macos-aarch64_bin.tar.gz
JDK_ORACLE_18_X64=https://download.oracle.com/java/18/latest/jdk-18_macos-x64_bin.tar.gz
JDK_OPENJDK_18_ARM=https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_macos-aarch64_bin.tar.gz
JDK_OPENJDK_18_X64=https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_macos-x64_bin.tar.gz

#####

.PHONY: gremlin gremlin-console-local neptune gremlin-console-neptune gremlin-load-local-data TIMESTAMP deploy-uat-with-ci