Installation  {#PagInstall}
============
\tableofcontents

In order to work properly, this extension needs the \CMake macros and a
binary of the tool cmakefbc_deps, which has to get compiled for your
system from source. This chapter describes alternative ways to
install the components

- Package install (currently Debian on armhf platforms only)

- Standard build (all in one go, in-source or out-of-source) and

- Testing Build (install \CMake macros first and test installation with
  included subproject).

For the later alternatives you have to prepare your system as described
in section \ref SubPrepare first.

\note The project builds on all platforms supported by CMake and the
      FreeBASIC compiler, find details at [CMake
      releases](https://cmake.org/download/#latest) and [the FB
      Wiki](http://www.freebasic.net/wiki/wikka.php?wakka=CompilerInstalling).


# Package Install  {#SecPackage}

You're lucky, if you're on a armhf platform running Debian operation
system (ie. like Beaglebone or Raspberry). The project isn't in
mainline yet, but Arend Lammertink prepared packages and provides them
at his server. Three packages are available:

- cmakefbc: all you need to use the FB-CMake extension
- cmakefbc-src: all the source code
- cmakefbc-doc: this documentation in html format

To use this service, add new PPAs (Personal Package Archive) to your
system:

~~~{.txt}
sudo add-apt-repository "deb http://beagle.tuks.nl/debian unstable main"
sudo add-apt-repository "deb-src http://beagle.tuks.nl/debian unstable main"
wget -qO - http://beagle.tuks.nl/debian/public.key | sudo apt-key add -
~~~

Once prepared, you can download all packages by executing

~~~{.txt}
sudo apt-get install cmakefbc cmakefbc-src cmakefbc-doc
~~~

Feel free to remove package[s] form the list, if you don't need them.


# Building Project  {#SecBuilding}

Before you can build (or install) the \Proj package you have to have a
working installation of some programming tools. Afterwards download
the projects source and choose one of the decribed build methods.


## Preparation  {#SubPrepare}

The following table lists all dependencies for the \Proj package and
their types. At least, you have to install the FreeBASIC compiler on
your system to build any executable using the \Proj features. Beside
this mandatory (M) tools, the others are optional. Some are recommended
(R) in order to make use of all package features. LINUX users find some
packages in their distrubution management system (D), or pre-installed
(I).

|                                               Name  | Type |  Function                                                      |
| --------------------------------------------------: | :--: | :------------------------------------------------------------- |
| [fbc](http://www.freebasic.net)                     | M    | FreeBASIC compiler to compile the source code                  |
| [CMake](http://www.cmake.org)                       | M  D | Build management system to build executables and documentation |
| [GIT](http://git-scm.com/)                          | R  D | Version control system to organize the files                   |
| [fb-doc](http://github.com/DTJF/fb-doc)             | R    | FreeBASIC extension tool for Doxygen                           |
| [Doxygen](http://www.doxygen.org/)                  | R  D | Documentation generator (for html output)                      |
| [Graphviz](http://www.graphviz.org/)                | R  D | Graph Visualization Software (caller/callee graphs)            |
| [LaTeX](https://latex-project.org/ftp.html)         | R  D | A document preparation system (for PDF output)                 |
| [devscripts & tools](https://www.debian.org/doc)    | R  D | Scripts for building Debian packages (for target deb)          |

It's beyond the scope of this guide to describe the installation for
all those tools. Find detailed installation instructions on the related
websides, linked by the name in the first column.

Just an example on how to install the tolls on Debian based Linux
systems (ie. like Ubuntu, Mint, ...). The following commands install
them on your system:

-# First, install the distributed (D) packages of your choise, either mandatory
   ~~~{.txt}
   sudo apt-get install git cmake
   ~~~
   or full install (recommended)
   ~~~{.txt}
   sudo apt-get install git cmake doxygen graphviz doxygen-latex texlive devscripts
   ~~~

-# You should already have FB the compiler working. Otherwise here's an
   example for 64 bit compiler version 1.05.0 ([other package
   downloads](https://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/))
   ~~~{.txt}
   wget https://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/FreeBASIC-1.05.0-linux-x86_64.tar.gz/download
   tar xzf FreeBASIC-1.05.0-linux-x86_64.tar.gz
   cd FreeBASIC-1.05.0-linux-x86_64
   sudo  ./install.sh -i
   ~~~

-# And finaly, install fb-doc (if wanted) by using GIT and CMake.
   Execute the commands
   ~~~{.txt}
   git clone https://github.com/DTJF/fb-doc
   cd fb-doc
   mkdir build
   cd build
   cmake ..
   make
   sudo make install
   ~~~


## Get Source  {#SubGet}

Depending on whether you installed the optional GIT package, there're
two ways to get the \Proj source package.

### GIT  {#SubGetGit}

Using GIT is the prefered way to download the \Proj package (since it
helps users to get involved in to the development process). Get your
copy and change to the source tree by executing

~~~{.txt}
git clone https://github.com/DTJF/cmakefbc
cd cmakefbc
~~~

### ZIP  {#SubGetZip}

As an alternative you can download a Zip archive by clicking the
[Download ZIP](https://github.com/DTJF/cmakefbc/archive/master.zip)
button on the \Proj website, and use your local Zip software to unpack
the archive. Then change to the newly created folder.

\note Zip files always contain the latest development version. You
      cannot switch to a certain branch or point in the history.


## Standard Build  {#SubStandard}

The package is prepared to perform a standard build tripple:

\Item{cmake} configure build tree
\Item{make} build executable binaries
\Item{make install} install at your system

This can either be done

\Item{in-source} \CMake generates auxiliary files in the source tree, or
\Item{out-of-source} \CMake generates auxiliary files in a separate folder

depending on the directory where you configure the build tree. So for
an in-source build change to the projects root directory and call

~~~{.txt}
cmake . -DCMAKE_MODULE_PATH=./cmake/Modules
~~~

and for an out-of-source build (recommended) create the build folder
first, change to that directory and execute

~~~{.txt}
mkdir build
cd build
cmake .. -DCMAKE_MODULE_PATH=../cmake/Modules
~~~

\note Since the package is self-hosted, it needs its context to build.
      So, before you installed the project, you have to care about a
      boot-strapping issue and tell \CMake where to find the new
      scripts by passing command line flag
      `-DCMAKE_MODULE_PATH=./cmake/Modules`.

You should see output like

~~~{.txt}
$ cmake .. -DCMAKE_MODULE_PATH=../cmakefbc/Modules
-- Check for working fb-doc tool OK ==> /usr/local/bin/fb-doc (0.4.2)
-- Found Doxygen: /usr/bin/doxygen (found version "1.8.11")
-- FB_DOCUMENTATION configured: SELFDEP;SYNTAX;PROJDATA;LFN targets doc;doc_www;doc_htm;doc_pdf
-- Check for working cmakefbc_deps tool OK ==> /usr/local/bin/cmakefbc_deps
-- Found working Fbc compiler ==> /usr/local/bin/fbc (1.05.0)
-- Configuring done
-- Generating done
-- Build files have been written to: /Projekte/cmakefbc/build
~~~

If you don't get the last line (`-- Build files have been ...`) a tool
is missing on your system. Check the output, install the requested
tool, and try again.


### Binary Build and Install {#SubBuildBin}

Once you configured the build tree, you can compile the binaries and
install them by executing (in the configured build folder from the
previous section, omit `sudo` on non-Linux systems)

~~~{.txt}
make
sudo make install
~~~

The output should look like (Debian LINUX example)

~~~{.txt}
$ make
Scanning dependencies of target cmakefbc_deps
[ 50%] Building Fbc object cmakefbc_deps/CMakeFiles/cmakefbc_deps.dir/cmakefbc_deps.bas.o
[100%] Linking Fbc executable cmakefbc_deps
[100%] Built target cmakefbc_deps

$ sudo make install
[sudo] Passwort für user:
[100%] Built target cmakefbc_deps
Install the project...
-- Install configuration: ""
-- Installing: /usr/local/share/cmakefbc/Modules
-- Installing: /usr/local/share/cmakefbc/Modules/UseFb-Doc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeDetermineFbcCompiler.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeTestFbcCompiler.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/Platform
-- Installing: /usr/local/share/cmakefbc/Modules/Platform/Windows-Fbc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/Platform/Linux-Fbc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeFbcInformation.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/FindFb-Doc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeFbcCompiler.cmake.in
-- Installing: /usr/local/bin/cmakefbc
-- Installing: /usr/local/bin/cmakefbc_deps
~~~

The \Proj project is now installed at your system and can get used in
any of your projects. Furthermore, you need not pass the option
`-DCMAKE_MODULE_PATH=...` to the configuration command. Instead call
the wrapper script that handles this option for you (ie. replace `cmake
.. -DCMAKE_MODULE_PATH=../cmakefbc/Modules` by `cmakefbc ..`).


### Documentation Build  {#SubBuildDoc}

The package is prepared to build a documentation in form of a HTML tree
and a PDF file. Both get created by the \Doxygen generator, using the
\FbDoc tool to extract (filter) the documentation context from the \FB
source code. Generate PDF and HTML files by executing

~~~{.txt}
make doc
~~~

Find the output in file `doxy/cmakefbc.pdf` and the HTML startpage in
file `doxy/html/index.html`. Both outputs can also get build separately
by building targets

~~~{.txt}
make doc_pdf
make doc_htm
~~~

A further target is implemented to upload the html tree to a web
server, by executing

~~~{.txt}
make doc_www
~~~

Find details in section \ref SubUseFbDoc.


### Package Build  {#SubBuildDeb}

On Linus systems the project is prepared to build Debian packages.
You'll need all tools listed above, to execute.

~~~{.txt}
make deb
~~~

Which will create the following output files (`_*` replaced by
version and platform info, ie. like `_0.11.5_amd64`):

\Item{cmakefbc-doc_*.deb} html documentation tree
\Item{cmakefbc_*.deb} binary package
\Item{cmakefbc_*.tar.xz} source code
\Item{cmakefbc_*.build} log file of packaging process
\Item{cmakefbc_*.changes} auxiliary file for auto-upload
\Item{cmakefbc_*.dsc} auxiliary file for auto-upload

Find the output either in the folder above the root directory
(in-source build), or in folder debian (out-of-source build).

Additionally, the classic package building method is implemented by
executing (in the root directory)

~~~{.txt}
debuild
~~~

This will create the output in the folder above. To get this working,
the Unix build tree contains a further targe `distclean` that removes
all CMake auxiliary files from the source tree and resets it to its
original state (but doesn't remove any files created by target
install).


## Testing Build  {#SubBuild1}

Here's an alternative installation method, which installs the CMake
macros first, and then uses this fresh install to build the subproject
cmakefbc_deps and further targets. In this case you need not care about
the boot-strapping issue.


### Step 1 Preparation  {#SubStep1}

In order to prepare that build type, edit file `CMakeLists.txt` in the
projects root directory and comment out the `ADD_SUBDIRECTORY` lines,
like

~~~{.txt}
...
#ADD_SUBDIRECTORY(doxy)

#ADD_SUBDIRECTORY(cmakefbc_deps)

IF(UNIX)
  #ADD_SUBDIRECTORY(debian)
...
~~~


### Step 2 Install CMake scripts  {#SubStep2}

Use \CMake to configure the project and install the macros for \FB
programming language support. Change to the projects root folder and
execute the command sequence (out-of-source build, we skip the `make`
step here, omit `sudo` on non-Linux systems)

~~~{.txt}
mkdir build
cd build
cmake ..
sudo make install
~~~

The terminal output should look like

~~~{.txt}
$mkdir build

$cd build

$ cmake ..
-- Configuring done
-- Generating done
-- Build files have been written to: /Projekte/cmakefbc/build

$ sudo make install
Install the project...
-- Install configuration: ""
-- Installing: /usr/local/share/cmakefbc/Modules
-- Installing: /usr/local/share/cmakefbc/Modules/UseFb-Doc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeDetermineFbcCompiler.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeTestFbcCompiler.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/Platform
-- Installing: /usr/local/share/cmakefbc/Modules/Platform/Windows-Fbc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/Platform/Linux-Fbc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeFbcInformation.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/FindFb-Doc.cmake
-- Installing: /usr/local/share/cmakefbc/Modules/CMakeFbcCompiler.cmake.in
-- Installing: /usr/local/bin/cmakefbc
~~~

This indicates that several script files have been copied to the system,
as well as the wrapper script (mentioned in the last line). The \CMake
build management system is now ready to address the \FB language, and
to compile simple projects, like the \FbDeps tool. Big projects may
contain several source files and headers, and some of those source
files depend on others. In order to let \CMake handle this dependencies
and re-compile only the related files, a further tool is necessary.

The tool \FbDeps helps to resolve \FB dependencies in big projects with
complex source file trees. We compile its source with \CMake in the next
step, and thereby test the newly installed configuration files.


### Step 3 Tool cmakefbc_deps  {#SubStep3}

Once you installed the \CMake \FB extension macros (step 2), you can
restore changes from step 1 in file `CMakeLists.txt` in the projects
root directory and uncomment the `ADD_SUBDIRECTORY` lines, like

~~~{.txt}
...
ADD_SUBDIRECTORY(doxy)

ADD_SUBDIRECTORY(cmakefbc_deps)

IF(UNIX)
  ADD_SUBDIRECTORY(debian)
...
~~~

Then reconfigure the build tree, build the tools executable and install
the tool by executing

~~~{.txt}
cmakefbc ..
make
sudo make install
~~~

The interaction in the terminal should look like (Debian LINUX)

~~~{.txt}
$ cmakefbc ..
/usr/bin/cmake .. -DCMAKE_MODULE_PATH=/usr/local/share/cmakefbc/Modules
-- Check for working fb-doc tool OK ==> /usr/local/bin/fb-doc (0.4.2)
-- Found Doxygen: /usr/bin/doxygen (found version "1.8.11")
-- FB_DOCUMENTATION configured: SELFDEP;SYNTAX;PROJDATA;LFN targets doc;doc_www;doc_htm;doc_pdf
-- Check for working cmakefbc_deps tool OK ==> /usr/local/bin/cmakefbc_deps
-- Found working Fbc compiler ==> /usr/local/bin/fbc (1.05.0)
-- Configuring done
-- Generating done
-- Build files have been written to: /Projekte/cmakefbc/build

$ make
Scanning dependencies of target cmakefbc_deps
[ 50%] Building Fbc object cmakefbc_deps/CMakeFiles/cmakefbc_deps.dir/cmakefbc_deps.bas.o
[100%] Linking Fbc executable cmakefbc_deps
[100%] Built target cmakefbc_deps

$ sudo make install
[100%] Built target cmakefbc_deps
Install the project...
-- Install configuration: ""
-- Up-to-date: /usr/local/share/cmakefbc/Modules
-- Up-to-date: /usr/local/share/cmakefbc/Modules/UseFb-Doc.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/CMakeDetermineFbcCompiler.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/CMakeTestFbcCompiler.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/Platform
-- Up-to-date: /usr/local/share/cmakefbc/Modules/Platform/Windows-Fbc.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/Platform/Linux-Fbc.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/CMakeFbcInformation.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/FindFb-Doc.cmake
-- Up-to-date: /usr/local/share/cmakefbc/Modules/CMakeFbcCompiler.cmake.in
-- Up-to-date: /usr/local/bin/cmakefbc
-- Installing: /usr/local/bin/cmakefbc_deps
~~~

Now your CMake installation is complete. It's ready to use all features
of this package and to build complex \FB projects on your system.


## Uninstall  {#SubUninstall}

CMake doesn't support the `uninstall` target, find details in [CMake
FAQ](https://cmake.org/Wiki/CMake_FAQ#Can_I_do_.22make_uninstall.22_with_CMake.3F).
In order to uninstall the project, remove the files listed in the file
`install_manifest.txt`. Ie. on Unix systems execute

~~~{.txt}
sudo xargs rm < install_manifest.txt
~~~
