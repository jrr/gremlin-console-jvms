
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


## Oracle ARM

JDK_ORACLE_18_ARM=https://download.oracle.com/java/18/latest/jdk-18_macos-aarch64_bin.tar.gz
JDK_ORACLE_18_ARM_DOWNLOADED=.downloads/jdk-18_macos-aarch64_bin.tar.gz
${JDK_ORACLE_18_ARM_DOWNLOADED}:
	mkdir -p .downloads
	wget -P .downloads ${JDK_ORACLE_18_ARM}

JDK_ORACLE_18_ARM_HOME=.jdks/oracle_18_arm/jdk-18.jdk/Contents/Home
${JDK_ORACLE_18_ARM_HOME}: ${JDK_ORACLE_18_ARM_DOWNLOADED}
	mkdir -p .jdks/oracle_18_arm
	tar xfz ${JDK_ORACLE_18_ARM_DOWNLOADED} --directory=.jdks/oracle_18_arm

test_oracle_18_arm: export JAVA_HOME=$(abspath $(JDK_ORACLE_18_ARM_HOME))
test_oracle_18_arm: export PATH=${JAVA_HOME}/bin:$(shell printenv PATH)
test_oracle_18_arm: ${JDK_ORACLE_18_ARM_HOME}
	file `which java`
	java -version
	make gremlin-console

## Oracle x64
JDK_ORACLE_18_X64=https://download.oracle.com/java/18/latest/jdk-18_macos-x64_bin.tar.gz
JDK_ORACLE_18_X64_DOWNLOADED=.downloads/jdk-18_macos-x64_bin.tar.gz
${JDK_ORACLE_18_X64_DOWNLOADED}:
	mkdir -p .downloads
	wget -P .downloads ${JDK_ORACLE_18_X64}

JDK_ORACLE_18_X64_HOME=.jdks/oracle_18_x64/jdk-18.jdk/Contents/Home
${JDK_ORACLE_18_X64_HOME}: ${JDK_ORACLE_18_X64_DOWNLOADED}
	mkdir -p .jdks/oracle_18_x64
	tar xfz ${JDK_ORACLE_18_X64_DOWNLOADED} --directory=.jdks/oracle_18_x64

test_oracle_18_x64: export JAVA_HOME=$(abspath $(JDK_ORACLE_18_X64_HOME))
test_oracle_18_x64: export PATH=${JAVA_HOME}/bin:$(shell printenv PATH)
test_oracle_18_x64: ${JDK_ORACLE_18_X64_HOME}
	file `which java`
	java -version
	make gremlin-console

## OpenJDK x64

JDK_OPENJDK_18_X64=https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_macos-x64_bin.tar.gz
JDK_OPENJDK_18_X64_DOWNLOADED=.downloads/openjdk-18_macos-x64_bin.tar.gz
${JDK_OPENJDK_18_X64_DOWNLOADED}:
	mkdir -p .downloads
	wget -P .downloads ${JDK_OPENJDK_18_X64}

JDK_OPENJDK_18_X64_HOME=.jdks/openjdk_18_x64/jdk-18.jdk/Contents/Home
${JDK_OPENJDK_18_X64_HOME}: ${JDK_OPENJDK_18_X64_DOWNLOADED}
	mkdir -p .jdks/openjdk_18_x64
	tar xfz ${JDK_OPENJDK_18_X64_DOWNLOADED} --directory=.jdks/openjdk_18_x64

test_openjdk_18_x64: export JAVA_HOME=$(abspath $(JDK_OPENJDK_18_X64_HOME))
test_openjdk_18_x64: export PATH=${JAVA_HOME}/bin:$(shell printenv PATH)
test_openjdk_18_x64: ${JDK_OPENJDK_18_X64_HOME}
	file `which java`
	java -version
	make gremlin-console

## OpenJDK ARM

JDK_OPENJDK_18_ARM=https://download.java.net/java/GA/jdk18/43f95e8614114aeaa8e8a5fcf20a682d/36/GPL/openjdk-18_macos-aarch64_bin.tar.gz
JDK_OPENJDK_18_ARM_DOWNLOADED=.downloads/openjdk-18_macos-aarch64_bin.tar.gz
${JDK_OPENJDK_18_ARM_DOWNLOADED}:
	mkdir -p .downloads
	wget -P .downloads ${JDK_OPENJDK_18_ARM}

JDK_OPENJDK_18_ARM_HOME=.jdks/openjdk_18_arm/jdk-18.jdk/Contents/Home
${JDK_OPENJDK_18_ARM_HOME}: ${JDK_OPENJDK_18_ARM_DOWNLOADED}
	mkdir -p .jdks/openjdk_18_arm
	tar xfz ${JDK_OPENJDK_18_ARM_DOWNLOADED} --directory=.jdks/openjdk_18_arm

test_openjdk_18_arm: export JAVA_HOME=$(abspath $(JDK_OPENJDK_18_ARM_HOME))
test_openjdk_18_arm: export PATH=${JAVA_HOME}/bin:$(shell printenv PATH)
test_openjdk_18_arm: ${JDK_OPENJDK_18_ARM_HOME}
	file `which java`
	java -version
	make gremlin-console

## Oracle 8u321
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

.PHONY: download-gremlin-console gremlin-console gremlin-console-local gremlin-console-neptune test_oracle_18_arm test_openjdk_18_x64 test_openjdk_18_arm test_8u321