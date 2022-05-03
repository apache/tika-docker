# tika-docker [![Build Status](https://api.travis-ci.com/apache/tika-docker.svg?branch=master)](https://travis-ci.com/github/apache/tika-docker)

This repo is used to create convenience Docker images for Apache Tika Server published as [apache/tika](https://hub.docker.com/r/apache/tika) on DockerHub by the [Apache Tika](http://tika.apache.org) Dev team

The images create a functional Apache Tika Server instance that contains the latest Ubuntu running the appropriate version's server on Port 9998 using Java 8 (until version 1.20), Java 11 (1.21 and 1.24.1), Java 14 (until 1.27/2.0.0), Java 16 (for 2.1.0), and Java 17 LTS for newer versions.

There is a minimal version, which contains only Apache Tika and it's core dependencies, and a full version, which also includes dependencies for the GDAL and Tesseract OCR parsers. To balance showing functionality versus the size of the full image, this file currently installs the language packs for the following languages:
* English
* French
* German
* Italian
* Spanish.

To install more languages simply update the apt-get command to include the package containing the language you required, or include your own custom packs using an ADD command.

## Available Tags

Below are the most recent 2.x series tags:

- `latest`, `2.4.0`: Apache Tika Server 2.4.0 (Minimal)
- `latest-full`, `2.4.0-full`: Apache Tika Server 2.4.0 (Full)
- `2.3.0`: Apache Tika Server 2.3.0 (Minimal)
- `2.3.0-full`: Apache Tika Server 2.3.0 (Full)
- `2.2.1`: Apache Tika Server 2.2.1 (Minimal)
- `2.2.1-full`: Apache Tika Server 2.2.1 (Full)
- `2.2.0`: Apache Tika Server 2.2.0 (Minimal)
- `2.2.0-full`: Apache Tika Server 2.2.0 (Full)

Below are the most recent 1.x series tags:

- `1.28.2`: Apache Tika Server 1.28.2 (Minimal)
- `1.28.2-full`: Apache Tika Server 1.28.2 (Full)
- `1.28.1`: Apache Tika Server 1.28.1 (Minimal)
- `1.28.1-full`: Apache Tika Server 1.28.1 (Full)
- `1.28`: Apache Tika Server 1.28 (Minimal)
- `1.28-full`: Apache Tika Server 1.28 (Full)
- `1.27`: Apache Tika Server 1.27 (Minimal)
- `1.27-full`: Apache Tika Server 1.27 (Full)

You can see a full set of tags for historical versions [here](https://hub.docker.com/r/apache/tika/tags?page=1&ordering=last_updated).

## Usage

### Default

You can pull down the version you would like using:

    docker pull apache/tika:<tag>

Then to run the container, execute the following command:

    docker run -d -p 9998:9998 apache/tika:<tag>

Where <tag> is the DockerHub tag corresponding to the Apache Tika Server version - e.g. 1.23, 1.22, 1.23-full, 1.22-full.

NOTE: The latest and latest-full tags are explicitly set to the latest released version when they are published.

### Custom Config

From version 1.25 and 1.25-full of the image it is now easier to override the defaults and pass parameters to the running instance.

So for example if you wish to disable the OCR parser in the full image you could write a custom configuration:

```
cat <<EOT >> tika-config.xml
<?xml version="1.0" encoding="UTF-8"?>
<properties>
  <parsers>
      <parser class="org.apache.tika.parser.DefaultParser">
          <parser-exclude class="org.apache.tika.parser.ocr.TesseractOCRParser"/>
      </parser>
  </parsers>
</properties>
EOT
```
Then by mounting this custom configuration as a volume, you could pass the command line parameter to load it

    docker run -d -p 9998:9998 -v `pwd`/tika-config.xml:/tika-config.xml apache/tika:1.25-full --config /tika-config.xml

You can see more configuration examples [here](https://tika.apache.org/1.26/configuring.html).

### Docker Compose Examples

There are a number of sample Docker Compose files included in the repos to allow you to test some different scenarios.

These files use docker-compose 3.x series and include:

* docker-compose-tika-vision.yml - TensorFlow Inception REST API Vision examples
* docker-compose-tika-grobid.yml - Grobid REST parsing example
* docker-compose-tika-customocr.yml - Tesseract OCR example with custom configuration
* docker-compose-tika-ner.yml - Named Entity Recognition example

The Docker Compose files and configurations (sourced from _sample-configs_ directory) all have comments in them so you can try different options, or use them as a base to create your own custom configuration.

**N.B.** You will want to create a environment variable (used in some bash scripts) matching the version of tika-docker you want to work with in the docker compositions e.g. `export TAG=1.26`. Similarly you should also consult `.env` which is used in the docker-compose `.yml` files.

You can install docker-compose from [here](https://docs.docker.com/compose/install/).

## Building

To build the image from scratch, simply invoke:

    docker build -t 'apache/tika' github.com/apache/tika-docker
   
You can then use the following command (using the name you allocated in the build command as part of -t option):

    docker run -d -p 9998:9998 apache/tika
    
## More Information

For more infomation on Apache Tika Server, go to the [Apache Tika Server documentation](https://cwiki.apache.org/confluence/display/TIKA/TikaServer).

For more information on Apache Tika, go to the official [Apache Tika](http://tika.apache.org) project website.

To meet up with others using Apache Tika, consider coming to one of the [Apache Tika Virtual Meetups](https://www.meetup.com/apache-tika-community/).

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
