# Changes

As of 2.5.0.1, we started adding a digit for Docker versions.  Going forward, we'll include
a four digit version, where the first three are the Tika version and the last one is the docker version.
As of 2.5.0.2, we started tagging release commits in our github repo.

* 3.1.0.1 (5 Jan 2025)
  * TIKA-4380 -- use -XX:UseSVE=0 to avoid an M4 bug
  
* 3.1.0.0 (31 Jan 2025)
  * First 3.1.0 release
  * Update base to oracular

* 3.0.0.0 (21 Oct 2024)
  * First 3.x stable release
  * Bump jre to 21

* 2.9.2.1 (21 May 2024)
  * Updated to noble
  * First multi-arch release

* 2.9.2.0 (10 October 2023)
  * Initial release for Tika 2.9.2

* 2.9.1.0 (10 October 2023)
  * Initial release for Tika 2.9.1

* 2.9.0.0 (28 August 2023)
  * Initial release for Tika 2.9.0

* 2.8.0.0 (15 May 2023)
  * Initial release for Tika 2.8.0


* 2.7.0.1 (27 March 2023)
  * More efficient build process and final image size via @stumpylog on [pr#17](https://github.com/apache/tika-docker/pull).

* 2.7.0.0 (6 Feb 2023)
  * Initial release for Tika 2.7.0

* 2.6.0.1 (10 November 2022)
  * Update operating system against OpenSSL CVE (TIKA-3926).

* 2.6.0.0 (7 November 2022)
  * Initial release for Tika 2.6.0

* 2.5.0.2 (31 October 2022)
  * Fixed root-user regression caused by differences in Docker behavior based on the build system's OS (TIKA-3912)
  * Added tika-extras/ directory to pick up extra jars via mounted drive or for those using our image as a base image (TIKA-3907)
* 
* 2.5.0.1 (27 October 2022)
  * Update to latest jammy to avoid recent CVEs (TIKA-3906)