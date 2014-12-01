Installation  {#PagInstall}
============
\tableofcontents

Three steps are necessary to install this package

-# Preparation: get working installations of the packages
  - FB compiler, and
  - CMake build management system.
-# Install the CMake FB extension macros.
-# Compile and install the \FbDeps tool.


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

Next step is to use (and thereby also check) the CMake installation
(from step 1) to copy the extension files by executing the command
sequence

\Item{cd cmakefbc} Change to the project directory.

\Item{cmake .} Build the Makefile by the CMake built management system.

\Item{make install} Call the Makefile to copy the macros in to the
   CMake installation (this command needs admin privileges on LINUX
   systems, ie. prepend `sudo` on Debian / Ubuntu).

The interaction in the terminal should look like

~~~{.sh}
$ cd cmakefbc

cmakefbc$ cmake .
-- Configuring done
-- Generating done
-- Build files have been written to: /home/tom/Projekte/git/cmakefbc

cmakefbc$ sudo make install
Install the project...
-- Install configuration: "Release"
-- Installing: /usr/share/cmake-2.8/Modules/CMakeFbcCompiler.cmake.in
-- Installing: /usr/share/cmake-2.8/Modules/CMakeFbcInformation.cmake
-- Installing: /usr/share/cmake-2.8/Modules/CMakeTestFbcCompiler.cmake
-- Installing: /usr/share/cmake-2.8/Modules/CMakeDetermineFbcCompiler.cmake
-- Installing: /usr/share/cmake-2.8/Modules/Platform/Linux-fbc.cmake
-- Installing: /usr/share/cmake-2.8/Modules/Platform/Windows-fbc.cmake
~~~

The lines starting with the text "-- Installing:" indicate that six
configuration files have been copied to the correct location in the
CMake Modules directory and subfolder Platform. The CMake build
management system is now ready to address the FB language, and to
compile simple projects like the \FbDeps tool. Big projects may contain
several source files and headers and some of those source files depend
on others. CMake should handle this dependencies to re-compile only the
related files, but isn't prepared for FB dependencies yet.

The tool \FbDeps helps to resolve FB dependencies in big projects with
complex source file trees. We compile its source with CMake in the next
step, and thereby test the newly installed configuration files.


Step 3 cmake_fb_deps tool  {#SecStep3}
=========================

The cmake_fb_deps tool auto-generates a CMake include file declaring
the FB source file dependencies. So it's an essential component of this
package and should get build and installed, if you intend to use the
\Tar and \Bas features to build big projects.

Once you installed the CMake FB extension (step 2) you can use CMake to
build the executable of this tool by executing the following commands

\Item{cd cmake_fb_deps} Change to the subproject directory.

\Item{cmake .} Build the Makefile by the CMake built management system.

\Item{make} Compile and link the source code in to an executable.

\Item{make install} Install that executable (this command needs admin
   privileges on LINUX systems, ie. prepend `sudo` on Debian / Ubuntu).

The interaction in the terminal should look like

~~~{.sh}
cmakefbc$ cd cmake_fb_deps

cmakefbc/cmake_fb_deps$ cmake .
-- Tool cmake_fb_deps not available -> no Fbc extensions!
-- Check for working compiler: /usr/local/bin/fbc ==> FreeBASIC 0.90.0
-- Configuring done
-- Generating done
-- Build files have been written to: /home/tom/Projekte/git/cmakefbc/cmake_fb_deps

cmakefbc/cmake_fb_deps$ make
Scanning dependencies of target cmake_fb_deps
[100%] Building Fbc object CMakeFiles/cmake_fb_deps.dir/cmake_fb_deps.bas.o
Linking Fbc executable cmake_fb_deps
[100%] Built target cmake_fb_deps

cmakefbc/cmake_fb_deps$ sudo make install
[100%] Built target cmake_fb_deps
Install the project...
-- Install configuration: ""
-- Installing: /usr/local/bin/cmake_fb_deps
~~~

Now your CMake installation is complete. It's ready to use all features
of this package and to build complex FB projects on your system.
