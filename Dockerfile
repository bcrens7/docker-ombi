FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OMBI_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment settings
ENV HOME="/config"

RUN \
 apt-get update && \
 apt-get install -y \
	libcurl3 \
	libicu55 && \
 echo "**** install ombi ****" && \
 mkdir -p \
	/opt/ombi && \
 if [ -z ${OMBI_RELEASE+x} ]; then \
	OMBI_DURL="https://ci.appveyor.com/api/projects/tidusjar/requestplex/artifacts/linux.tar.gz?branch=develop&pr=false" \
 else \
	OMBI_JOBID=$(curl -s "https://ci.appveyor.com/api/projects/tidusjar/requestplex/build/${OMBI_RELEASE}" | jq -jr '. | .build.jobs[0].jobId') \
	OMBI_DURL="https://ci.appveyor.com/api/buildjobs/${OMBI_JOBID}/artifacts/linux.tar.gz" \
 fi && \
 curl -o \
	/tmp/ombi-src.tar.gz -L \
	"${OMBI_DURL}" && \
 tar xzf /tmp/ombi-src.tar.gz -C \
	/opt/ombi/ && \
 chmod +x /opt/ombi/Ombi && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3579
