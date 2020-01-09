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
      echo "    docker-tool.sh build <TIKA_VERSION>    Builds image(s) for <TIKA_VERSION>."
      echo "    docker-tool.sh test <TIKA_VERSION>     Tests image(s) for <TIKA_VERSION>."
      echo "    docker-tool.sh publish <TIKA_VERSION>  Publishes image(s) for <TIKA_VERSION> to Docker Hub."
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
     curl http://localhost:9998/version
     docker kill "$1"
     docker rm "$1"
}

shift $((OPTIND -1))
subcommand=$1; shift
version=$1; shift

case "$subcommand" in
  build)
    # Build slim version with minimal dependencies
    docker build -t apache/tika:${version} --build-arg TIKA_VERSION=${version} - < minimal/Dockerfile
    # Build full version with OCR, Fonts and GDAL
    docker build -t apache/tika:${version}-full --build-arg TIKA_VERSION=${version} - < full/Dockerfile
    ;;

  test)
    # Test minimal image
    test_docker_image ${version}
    # Test full image
    test_docker_image "${version}-full"
    ;;

  publish)
    echo "Does nothing until we get Docker Hub access setup under Apache Organisation"
    ;;

esac
