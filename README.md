# tika-docker [![Build Status](https://travis-ci.org/apache/tika-docker.svg?branch=master)](https://travis-ci.org/apache/tika-docker)

This repo is used to create convenience Docker images for Apache Tika Server published as [apache/tika](https://hub.docker.com/r/apache/tika) on DockerHub by the [Apache Tika](http://tika.apache.org) Dev team

The images create a functional Apache Tika Server instance that contains the latest Ubuntu running the appropriate version's server on Port 9998 using Java 8 (until version 1.20), Java 11 (1.21 and 1.24.1) and Java 14 for newer versions.

There is a minimal version, which contains only Apache Tika and it's core dependencies, and a full version, which also includes dependencies for the GDAL and Tesseract OCR parsers. To balance showing functionality versus the size of the full image, this file currently installs the language packs for the following languages:
* English
* French
* German
* Italian
* Spanish.

To install more languages simply update the apt-get command to include the package containing the language you required, or include your own custom packs using an ADD command.

## Available Tags

Below are the most recent tags:

- `latest`, `1.25`: Apache Tika Server 1.25 (Minimal)
- `latest-full`, `1.25-full`: Apache Tika Server 1.25 (Full)
- `1.25`: Apache Tika Server 1.25 (Minimal)
- `1.25-full`: Apache Tika Server 1.25 (Full)
- `1.24.1`: Apache Tika Server 1.24.1 (Minimal)
- `1.24.1-full`: Apache Tika Server 1.24.1 (Full)
- `1.24`: Apache Tika Server 1.24 (Minimal)
- `1.24-full`: Apache Tika Server 1.24 (Full)
- `1.23`: Apache Tika Server 1.23 (Minimal)
- `1.23-full`: Apache Tika Server 1.23 (Full)

You can see a full set of tags for historical versions [here](https://hub.docker.com/r/apache/tika/tags?page=1&ordering=last_updated).

## Usage

You can pull down the version you would like using:

    docker pull apache/tika:<tag>

Then to run the container, execute the following command:

    docker run -d -p 9998:9998 apache/tika:<tag>

Where <tag> is the DockerHub tag corresponding to the Apache Tika Server version - e.g. 1.23, 1.22, 1.23-full, 1.22-full.

NOTE: The latest and latest-full tags are explicitly set to the latest released version when they are published.

## Building

To build the image from scratch, simply invoke:

    docker build -t 'apache/tika' github.com/apache/tika-docker
   
You can then use the following command (using the name you allocated in the build command as part of -t option):

    docker run -d -p 9998:9998 apache/tika
    
## More Information

For more infomation on Apache Tika Server, go to the [Apache Tika Server documentation](http://wiki.apache.org/tika/TikaJAXRS).

For more information on Apache Tika, go to the official [Apache Tika](http://tika.apache.org) project website.

For more information on the Apache Software Foundation, go to the [Apache Software Foundation](http://apache.org) website.

## Authors

Apache Tika Dev Team (dev@tika.apache.org)
   
## Contributors

There have been a range of [contributors](https://github.com/apache/tika-docker/graphs/contributors) on GitHub and via suggestions, including:

- [@grossws](https://github.com/grossws)
- [@arjunyel](https://github.com/arjunyel)
- [@mpdude](https://github.com/mpdude)
- [@laszlocsontosuw](https://github.com/laszlocsontosuw)

## Licence

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 
## Disclaimer

It is worth noting that whilst these Docker images download the binary JARs published by the Apache Tika Team on the Apache Software Foundation distribution sites, only the source release of an Apache Software Foundation project is an official release artefact. See [Release Distribution Policy](https://www.apache.org/dev/release-distribution.html) for more details.
