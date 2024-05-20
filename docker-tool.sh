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

die() {
  echo "$*" >&2
  exit 1
}

while getopts ":h" opt; do
  case ${opt} in
    h )
      echo "Usage:"
      echo "    docker-tool.sh -h                      Display this help message."
      echo "    docker-tool.sh build <TIKA_DOCKER_VERSION> <TIKA_VERSION>   Builds <TIKA_DOCKER_VERSION> images for <TIKA_VERSION>."
      echo "    docker-tool.sh test <TIKA_DOCKER_VERSION>     Tests images for <TIKA_DOCKER_VERSION>."
      echo "    docker-tool.sh publish <TIKA_DOCKER_VERSION> <TIKA_VERSION> Builds multi-arch images for <TIKA_DOCKER_VERSION> and pushes to Docker Hub."
      exit 0
      ;;
   \? )
     echo "Invalid Option: -$OPTARG" 1>&2
     exit 1
     ;;
  esac
done


test_docker_image() {
     docker run -d --name "$1" -p 127.0.0.1:9998:9998 apache/tika:"$1"
     sleep 10
     url=http://localhost:9998/
     status=$(curl --head --location --connect-timeout 5 --write-out %{http_code} --silent --output /dev/null ${url})
     user=$(docker inspect "$1" --format '{{.Config.User}}')

     if [[ $status == '200' ]]
     then
      echo "$(tput setaf 2)Image: apache/tika:${1} - Basic test passed$(tput sgr0)"
     else
      echo "$(tput setaf 1)Image: apache/tika:${1} - Basic test failed$(tput sgr0)"
      docker kill "$1"
      docker rm "$1"
      exit 1
     fi

     #now test that the user is correctly set
     if [[ $user == '35002:35002' ]]
      then
       echo "$(tput setaf 2)Image: apache/tika:${1} - User passed$(tput sgr0)"
       docker kill "$1"
       docker rm "$1"
      else
       echo "$(tput setaf 1)Image: apache/tika:${1} - User failed$(tput sgr0)"
        docker kill "$1"
        docker rm "$1"
        exit 1
     fi
}

shift $((OPTIND -1))
subcommand=$1; shift
tika_docker_version=$1; shift
tika_version=$1; shift


case "$subcommand" in
  build)
    # Build slim tika- with minimal dependencies
    docker build -t apache/tika:${tika_docker_version} --build-arg TIKA_VERSION=${tika_version} - < minimal/Dockerfile --no-cache || die "couldn't build"
    # Build full tika- with OCR, Fonts and GDAL
    docker build -t apache/tika:${tika_docker_version}-full --build-arg TIKA_VERSION=${tika_version} - < full/Dockerfile --no-cache || die "couldn't build"
    ;;

  test)
    # Test the images
    test_docker_image ${tika_docker_version}
    test_docker_image "${tika_docker_version}-full"
    ;;

  publish)
    docker buildx create --use --name tika-builder || die "couldn't start builder"
    # Build multi-arch with buildx and push
    docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --output "type=image,push=true" \
      --tag apache/tika:latest --tag apache/tika:${tika_docker_version} --build-arg TIKA_VERSION=${tika_version} --no-cache --builder tika-builder minimal || die "couldn't build multi-arch minimal"
    docker buildx build --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --output "type=image,push=true" \
      --tag apache/tika:latest-full --tag apache/tika:${tika_docker_version}-full --build-arg TIKA_VERSION=${tika_version} --no-cache --builder tika-builder full || die "couldn't build multi-arch full"
    docker buildx stop tika-builder
    ;;

esac
