Installation  {#PagInstall}
============
\tableofcontents

Three steps are necessary to install this package

-# Preparation: get working installations of the packages
  - FB compiler, and
  - CMake build management system.
-# Install the CMake FB extension macros.
-# Compile and install \FbDeps tool.


Step 1 Preparation  {#SecStep1}
==================

Before you can use (or install) the *cmakefbc* package you have to have
a working installation of some programming tools, the FB compiler (see
http://www.freebasic.net) and the CMake build system (see
http://www.cmake.org). It's beyond the scope of this guide to describe
the installation for those programming tools.

Step 2 CMake FB Extension Macros  {#SecStep2}
================================

Once you have CMake installed, you can add the supporting macros for FB
programming language. Since you read this file you already

- downloaded the *cmakefbc* package, and
- unpacked the archive.

Next step is to use CMake to install the extension files (`make
install` needs admin privileges on LINUX systems, ie. prepend `sudo` on
Debian / Ubuntu):

~~~{.sh}
cd cmakefbc
cmake .
make install
~~~

This commands will copy six configuration files to the correct location
in your CMake installation. Your system is ready to address the FB
language now, and to compile simple projects like the \FbDeps tool. Big
projects may contain several source files and headers and some of these
source files depend on others. To re-compile only the related files,
CMake should handle this dependencies but isn't prepared for FB
dependencies yet.

The tool \FbDeps helps to resolve FB dependencies in big projects with
complex source file trees. We can use its source to test the newly
installed CMake configuration files in the next step.


Step 3 cmake_fb_deps tool  {#SecStep3}
=========================

The cmake_fb_deps tool auto-generates a CMake include file declaring
the FB source file dependencies. So it's an essential component of this
package and should get build and installed, if you intend to use the
\Tar and \Bas features and / or build big projects.

Once you installed the CMake FB extension (step 2) you can execute the
following commands (`make install` needs admin privileges on LINUX
systems, ie. prepend `sudo` on Debian / Ubuntu):

~~~{.sh}
cd cmake_fb_deps
cmake .
make
make install
~~~

to generate the build system (command `cmake .`), compile the tool
(command `make`) and install (command `make install`) it on your
system.
