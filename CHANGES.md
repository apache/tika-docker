# Changes

As of 2.5.0.1, we started adding a digit for Docker versions.  Going forward, we'll include
a four digit version, where the first three are the Tika version and the last one is the docker version.
As of 2.5.0.2, we started tagging release commits in our github repo.

* 2.6.0.1 (10 November 2022)
  * Update operating system against OpenSSL CVE (TIKA-3926).

* 2.6.0.0 (7 November 2022)
  * Initial release for Tika 2.6.0

* 2.5.0.2 (31 October 2022)
  * Fixed root-user regression caused by differences in Docker behavior based on the build system's OS (TIKA-3912)
  * Added tika-extras/ directory to pick up extra jars via mounted drive or for those using our image as a base image (TIKA-3907)
* 2.5.0.1 (27 October 2022)
  * Update to latest jammy to avoid recent CVEs (TIKA-3906)