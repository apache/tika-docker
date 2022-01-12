#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing,
#   software distributed under the License is distributed on an
#   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#   KIND, either express or implied.  See the License for the
#   specific language governing permissions and limitations
#   under the License.

while getopts ":h" opt; do
  case ${opt} in
    h )
      echo "Usage:"
      echo "    docker-tool.sh -h                      Display this help message."
      echo "    docker-tool.sh build <TIKA_VERSION>    Builds images for <TIKA_VERSION>."
      echo "    docker-tool.sh test <TIKA_VERSION>     Tests images for <TIKA_VERSION>."
      echo "    docker-tool.sh publish <TIKA_VERSION>  Publishes images for <TIKA_VERSION> to Docker Hub."
      echo "    docker-tool.sh latest <TIKA_VERSION>   Tags images for <TIKA_VERSION> as latest on Docker Hub."
      exit 0
      ;;
   \? )
     echo "Invalid Option: -$OPTARG" 1>&2
     exit 1
     ;;
  esac
done


test_docker_image() {
     docker run -d --name "$1" -p 9998:9998 apache/tika:"$1"
     sleep 10
     url=http://localhost:9998/version
     status=$(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${url})

     if [[ $status == '200' ]]
     then
      echo "$(tput setaf 2)Image: apache/tika:${1} - Passed$(tput sgr0)"
      docker kill "$1"
      docker rm "$1"
     else
      echo "$(tput setaf 1)Image: apache/tika:${1} - Failed$(tput sgr0)"
      docker kill "$1"
      docker rm "$1"
      exit 1
     fi
}

shift $((OPTIND -1))
subcommand=$1; shift
version=$1; shift
jar=$1; shift

if [ -z "$jar" ]
then
  jar="tika-server-standard"
fi


case "$subcommand" in
  build)
    # Build slim version with minimal dependencies
    docker build -t apache/tika:${version} --build-arg TIKA_VERSION=${version} --build-arg TIKA_JAR_NAME=${jar} - < minimal/Dockerfile --no-cache
    # Build full version with OCR, Fonts and GDAL
    docker build -t apache/tika:${version}-full --build-arg TIKA_VERSION=${version} --build-arg TIKA_JAR_NAME=${jar} - < full/Dockerfile --no-cache
    ;;

  test)
    # Test the images
    test_docker_image ${version}
    test_docker_image "${version}-full"
    ;;

  publish)
    # Push the build images
    docker push apache/tika:${version}
    docker push apache/tika:${version}-full
    ;;

  latest)
    # Update the latest tags to point to supplied version
    docker tag apache/tika:${version} apache/tika:latest
    docker push apache/tika:latest
    docker tag apache/tika:${version}-full apache/tika:latest-full
    docker push apache/tika:latest-full
    ;;

esac
