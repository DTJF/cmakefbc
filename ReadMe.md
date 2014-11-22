Package cmakefbc
================

This is package cmakefbc, an extension for the build system CMake for
the FreeBASIC programming langunage.

Installation
============

Three steps are necessary to install this package

-# Preparation: get working installations of the packakes
  - FreeBASIC compiler (see http://www.freebasic.net)
  - CMake build system (see http://www.cmake.org)
-# Install FB extension
-# Compile and install fb_depends tool


Step 1 Preparation
------------------

Installing this package only makes sence if you have a working
installation of some programming tools, the FreeBASIC compiler fbc and
the CMake build system. Installation instructions of this packages are
beyond the scope of this guide. See the above mentions web pages for
details on how to download and install the packages on your system.


Step 2 FB extension
-------------------

Once you have CMake installed you can add the support for FreeBASIC
programming language. Since you read this file you already

- downloaded the cmakefbc package, and
- unpacked the archive.

Next step is to use CMake to install the extension files:

~~~{.sh}
cmake .
sudo make install
~~~

will copy six configuration files to the correct location in your CMake
installation. Now your system is ready to address the FreeBASIC
language and to compile simple projects like the fb_depends tool. This
tool helps to build big projects with complex source file dependencies.
We can use the source to test our CMake installation in the next step.


Step 3 fb_depends tool
----------------------

The fb_depends tool auto-generates source file dependencies for CMake,
which cannot handle this for FreeBASIC source code yet. So it's an
essential component of this package and should get build and installed
if you intend to build big projects.

