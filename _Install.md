Installation  {#PagInstall}
============
\tableofcontents

Three steps are necessary to install this package and test the
installations by building the separate `cmake_fb_deps` tool project
(Testing Build)

-# Preparation: get working installations of the packages
  - FB compiler, and
  - CMake build management system.
-# Install the CMake FB extension macros.
-# Compile and install the \FbDeps tool.


Testing Build  {#SecBuild1}
=============

Step 1 Preparation  {#SubSecStep1}
------------------

Before you can use (or install) the *cmakefbc* package you have to have
a working installation of some programming tools, the FB compiler (see
http://www.freebasic.net) and the CMake build system (see
http://www.cmake.org). It's beyond the scope of this guide to describe
the installation for those programming tools.


Step 2 CMake FB Extension Macros  {#SubSecStep2}
--------------------------------

Once you have CMake installed, you can add the supporting macros for FB
programming language. Since you read this file you already

- downloaded the *cmakefbc* package, and
- unpacked the archive.

Next step is to use (and thereby also check) the CMake installation
(from step 1) to copy the extension files by executing the command
sequence

~~~{.sh}
cd cmakefbc
cmake .
make install
~~~

This command tripple changes to the project directory, creates the
Makefile by the CMake built management system and calls this Makefile
to copy the CMake macros in to the CMake installation (this command
needs admin privileges on LINUX systems, ie. prepend `sudo` on Debian /
Ubuntu).

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


Step 3 cmake_fb_deps tool  {#SubSecStep3}
-------------------------

The cmake_fb_deps tool auto-generates a CMake include file declaring
the FB source file dependencies. So it's an essential component of this
package and should get build and installed, if you intend to use the
\Tar and \Bas features to build big projects.

Once you installed the CMake FB extension (step 2) you can use CMake to
build the executable of this tool by executing the following commands

~~~{.sh}
cd cmake_fb_deps
cmake .
make
make install
~~~

to change to the subproject directory, build the Makefile by the CMake
built management system, compile and link the source code in to an
executable and finally install that executable (this command needs
admin privileges on LINUX systems, ie. prepend sudo on Debian /
Ubuntu).

The interaction in the terminal should look like (Debian LINUX)

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


Standard Build  {#SecStandard}
==============

As an alternative you can adapt the configuration to perform a standard
build by

~~~{.sh}
cmake .
make
sudo make install
~~~

This will not test the CMake macro installations by the separate
`cmake_fb_deps` project. Instead this project gets added as a
subproject to the build tree and the code compiles before installing
both components together.

Therefor, in the just unpacked install, uncomment the following lines
in the `CMakeLists.txt` file in the root directory, like

~~~{.cmake}
# Uncomment the next two lines to perform a standard build.
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
ADD_SUBDIRECTORY(cmake_fb_deps)
~~~

Then execute the above command tripple. The output looks like (Debian LINUX)

~~~{.sh}
$ cd cmakefbc/

cmakefbc$ cmake .
-- Tool cmake_fb_deps not available -> no Fbc extensions!
-- Check for working Fbc compiler OK ==> /usr/local/bin/fbc (FreeBASIC 1.01.0)
-- Configuring done
-- Generating done
-- Build files have been written to: .../cmakefbc

cmakefbc$ make
Scanning dependencies of target cmake_fb_deps
[100%] Building Fbc object cmake_fb_deps/CMakeFiles/cmake_fb_deps.dir/cmake_fb_deps.bas.o
Linking Fbc executable cmake_fb_deps
[100%] Built target cmake_fb_deps

cmakefbc$ sudo make install
[sudo] password for tom:
[100%] Built target cmake_fb_deps
Install the project...
-- Install configuration: ""
-- Installing: /usr/share/cmake-2.8/Modules
-- Installing: /usr/share/cmake-2.8/Modules/CMakeTestFbcCompiler.cmake
-- Installing: /usr/share/cmake-2.8/Modules/CMakeFbcCompiler.cmake.in
-- Installing: /usr/share/cmake-2.8/Modules/Platform
-- Installing: /usr/share/cmake-2.8/Modules/Platform/Windows-fbc.cmake
-- Installing: /usr/share/cmake-2.8/Modules/Platform/Linux-fbc.cmake
-- Installing: /usr/share/cmake-2.8/Modules/CMakeDetermineFbcCompiler.cmake
-- Installing: /usr/share/cmake-2.8/Modules/CMakeFbcInformation.cmake
-- Installing: /usr/local/bin/cmake_fb_deps
~~~


Uninstall  {#SecUninstall}
=========

To uninstall the package remove the files listed in the file(s)
`install_manifest.txt`. Ie. on Debian LINUX (or Ubuntu) type

~~~{.sh}
sudo xargs rm < install_manifest.txt
~~~
