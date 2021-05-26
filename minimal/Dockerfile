# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
FROM ubuntu:focal as base
RUN apt-get update

FROM base as dependencies
ARG JRE='openjdk-14-jre-headless'

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install $JRE

FROM dependencies as fetch_tika
ARG TIKA_VERSION
ARG TIKA_JAR_NAME=tika-server
ARG CHECK_SIG=true

ENV NEAREST_TIKA_SERVER_URL="https://www.apache.org/dyn/closer.cgi/tika/${TIKA_JAR_NAME}-${TIKA_VERSION}.jar?filename=tika/${TIKA_JAR_NAME}-${TIKA_VERSION}.jar&action=download" \
    ARCHIVE_TIKA_SERVER_URL="https://archive.apache.org/dist/tika/${TIKA_JAR_NAME}-${TIKA_VERSION}.jar" \
    DEFAULT_TIKA_SERVER_ASC_URL="https://downloads.apache.org/tika/${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc" \
    ARCHIVE_TIKA_SERVER_ASC_URL="https://archive.apache.org/dist/tika/${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc" \
    TIKA_VERSION=$TIKA_VERSION

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg2 wget \
    && wget -t 10 --max-redirect 1 --retry-connrefused -qO- https://downloads.apache.org/tika/KEYS | gpg --import \
    && wget -t 10 --max-redirect 1 --retry-connrefused $NEAREST_TIKA_SERVER_URL -O /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar || rm /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar \
    && sh -c "[ -f /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar ]" || wget $ARCHIVE_TIKA_SERVER_URL -O /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar || rm /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar \
    && sh -c "[ -f /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar ]" || exit 1 \
    && wget -t 10 --max-redirect 1 --retry-connrefused $DEFAULT_TIKA_SERVER_ASC_URL -O /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc  || rm /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc ]" || wget $ARCHIVE_TIKA_SERVER_ASC_URL -O /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc || rm /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc \
    && sh -c "[ -f /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc ]" || exit 1;

RUN if [ "$CHECK_SIG" = "true" ] ; then gpg --verify /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar; fi

FROM dependencies as runtime
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ARG TIKA_VERSION
ENV TIKA_VERSION=$TIKA_VERSION
ARG TIKA_JAR_NAME
ENV TIKA_JAR_NAME=$TIKA_JAR_NAME
COPY --from=fetch_tika /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar

USER $UID_GID
EXPOSE 9998
ENTRYPOINT [ "/bin/sh", "-c", "exec java -jar /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar -h 0.0.0.0 $0 $@"]

LABEL maintainer="Apache Tika Developers dev@tika.apache.org"
