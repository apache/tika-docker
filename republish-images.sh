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


##
## Helper script to allow a republish of all versions released so far.
## This was used to support the original seeding of the DockerHub repo
##

# Early releases on JRE 8
for i in {6..13};
do
    docker build -t apache/tika:"1.$i" --build-arg TIKA_VERSION="1.$i" --build-arg JRE=openjdk-8-jre-headless - < minimal/Dockerfile
    docker build -t apache/tika:"1.$i"-full --build-arg TIKA_VERSION="1.$i" --build-arg JRE=openjdk-8-jre-headless - < full/Dockerfile
    ./docker-tool.sh test "1.$i"
    if [ $? -eq 0 ]
     then
        ./docker-tool.sh publish "1.$i"
     else
        echo "Failed to test and publish version ${1.$i}"
        echo "$(tput setaf 1)Failed to test and publish image : apache/tika:${1.$i}$(tput sgr0)"
        exit 1
    fi
done;

# Signing issues on these release where public key is not available
for i in {14..19};
do
    docker build -t apache/tika:"1.$i" --build-arg TIKA_VERSION="1.$i" --build-arg JRE=openjdk-8-jre-headless --build-arg CHECK_SIG=false - < minimal/Dockerfile
    docker build -t apache/tika:"1.$i"-full --build-arg TIKA_VERSION="1.$i" --build-arg JRE=openjdk-8-jre-headless --build-arg CHECK_SIG=false - < full/Dockerfile
    ./docker-tool.sh test "1.$i"
    if [ $? -eq 0 ]
     then
        ./docker-tool.sh publish "1.$i"
     else
        echo "Failed to test and publish version ${1.$i}"
        echo "$(tput setaf 1)Failed to test and publish image : apache/tika:${1.$i}$(tput sgr0)"
        exit 1
    fi
done;

# Moved to JRE 11 by default
for i in {20..23};
do
    ./docker-tool.sh build "1.$i"
    ./docker-tool.sh test "1.$i"
    if [ $? -eq 0 ]
     then
        ./docker-tool.sh publish "1.$i"
     else
        echo "Failed to test and publish version ${1.$i}"
        echo "$(tput setaf 1)Failed to test and publish image : apache/tika:${1.$i}$(tput sgr0)"
        exit 1
    fi
done;