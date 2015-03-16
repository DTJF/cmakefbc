Installation  {#PagInstall}
============
\tableofcontents

This chapter describes two alternative ways to install this package

- Standard build (all components in one go) and

- Testing Build (install CMake macros first and test installation with
  included subproject).

For both alternatives you have to prepare your system as described in
section Preparation first.


Preparation  {#SecPrepare}
===========

Before you can use (or install) the *cmakefbc* package you have to have
a working installation of some programming tools,

- the [FB compiler](http://www.freebasic.net),
- the [CMake build system](http://www.cmake.org),
- the [Doxygen backend](http://www.cmake.org) (optional for documentation) and
- the [fb-doc package](http://www.cmake.org) (optional for documentation).

It's beyond the scope of this guide to describe the installation for
those programming tools. Follow the installation instructions in the
above links.


Standard Build  {#SecStandard}
==============

The package is prepared to perform a standard build by (execute in root
folder of the package)

~~~{.sh}
cmake .
make
sudo make install
~~~

This will use the shipped CMake macros to build a subproject called
cmake_fb_deps, before both components, the CMake macros and the tool
cmake_fb_deps, get installed on your system.

The output, when executing the above command tripple, should look like
(on Debian LINUX)

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


Testing Build  {#SecBuild1}
=============

This installation instruction installs the CMake macros first and then
uses those macros to build the subproject cmake_fb_deps, so that the
just installed macros get tested. This method is required when you
don't want to install the cmake_fb_deps tool (omit step 3 in that
case).

Step 1 Preparation  {#SubSecStep1}
------------------

In the just unpacked package directory, load the file `CMakeLists.txt`
from the root directory in to an editor, comment the following lines,
like

~~~{.cmake}
# Uncomment the next two lines to perform a standard build.
#LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
#ADD_SUBDIRECTORY(cmake_fb_deps)
~~~

and save the result. This removes the subproject cmake_fb_deps from the
build tree.

Step 2 CMake FB Extension Macros  {#SubSecStep2}
--------------------------------

Now use CMake to add the supporting macros for FB programming language
by executing the command sequence

~~~{.sh}
cd cmakefbc
cmake .
sudo make install
~~~

This command tripple changes to the project directory, creates the
Makefile by the CMake built management system and calls this Makefile
to copy the CMake macros in to the CMake installation (omit `sudo` on
non-LINUX systems).

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
sudo make install
~~~

to change to the subproject directory, build the Makefile by the CMake
built management system, compile and link the source code in to an
executable and finally install that executable (omit `sudo` on
non-LINUX systems).

The interaction in the terminal should look like (Debian LINUX)

~~~{.sh}
cmakefbc$ cd cmake_fb_deps

cmakefbc/cmake_fb_deps$ cmake .
-- Tool cmake_fb_deps not available -> no Fbc extensions!
-- Check for working compiler: /usr/local/bin/fbc ==> FreeBASIC 1.01.0
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


Uninstall  {#SecUninstall}
=========

To uninstall the package remove the files listed in the file(s)
`install_manifest.txt`. Ie. on Debian LINUX (or Ubuntu) type

~~~{.sh}
sudo xargs rm < install_manifest.txt
~~~


Documentation Build  {#SecBuildDoc}
===================

The package is prepared to build a documentation in form of a html
tree. This gets created by the Doxygen generator and the fb-doc tool to
filter the FreeBASIC source code. Generate html files in folder
doc/html by executing

~~~{.sh}
make doc
~~~

You can customize the output or generate additional LaTeX or XML output
by adapting the configuration file Doxyfile in folder doc.
