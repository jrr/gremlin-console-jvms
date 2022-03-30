
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

JDK_ORACLE_8U321=https://javadl.oracle.com/webapps/download/GetFile/1.8.0_321-b07/df5ad55fdd604472a86a45a217032c7d/unix-i586/jdk-8u321-macosx-x64.dmg
JDK_ORACLE_8U321_DOWNLOADED=.downloads/jdk-8u321-macosx-x64.dmg

JDK_ORACLE_8U321_HOME=.jdks/oracle_8u321/Contents/Home

${JDK_ORACLE_8U321_DOWNLOADED}:
	mkdir -p .downloads
	wget -P .downloads ${JDK_ORACLE_8U321}

${JDK_ORACLE_8U321_HOME}: ${JDK_ORACLE_8U321_DOWNLOADED}
	7z x ${JDK_ORACLE_8U321_DOWNLOADED} -otmp
	cd tmp && xar -xf "JDK 8 Update 321/JDK 8 Update 321.pkg"
	mkdir -p .jdks/oracle_8u321
	tar xf tmp/jdk1.8.0_321.pkg/Payload --directory=.jdks/oracle_8u321

test_8u321: export JAVA_HOME=$(abspath $(JDK_ORACLE_8U321_HOME))
test_8u321: export PATH=${JAVA_HOME}/bin:$(shell printenv PATH)
test_8u321: ${JDK_ORACLE_8U321_HOME}
	file `which java`
	java -version
	make gremlin-console

#####

.PHONY: gremlin gremlin-console-local neptune gremlin-console-neptune gremlin-load-local-data TIMESTAMP deploy-uat-with-ci