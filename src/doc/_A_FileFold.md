Files and Folders  {#PagFileFold}
=================
\tableofcontents

The package contains the subfolders

- \ref SecFoldCMake : containing the \CMake macros and scripts related to the \FB compiler and \FbDoc
- \ref SecFoldTool : containing the source code for the tool \FbDeps
- \ref SecFoldDoxy : containing configuration files to build the documentation (where \Doxygen executes in a manual build)
- \ref SecFoldDebian : containing configuration files to build Debian packages

And some files in the root folder.


# Root {#SecFoldRoot}

The root directory contains the file

\Item{CMakeLists.txt} main configuration for the CMake build process

and the documentation context in human readable markup format

\Item{%ReadMe.md} general information

\Item{%_1_Install.md} install instructions

\Item{%_2_Usage.md} usage informations

\Item{%_3_Tool.md} description of tool cmakefbc_deps

\Item{%_A_FileFold.md} this chapter

\Item{%_z_ChangeLog.md} Version information and credits

\Item{_ReadMe.md.in} configuration file for %ReadMe.md


# cmake {#SecFoldCMake}

This folder contains the FB extension scripts for \CMake in a subfolder
called `Modules`, and also two further scripts to control the build
process of this documentation with Doxygen and fbdoc. The later are
included in order to build this project, namely

- \ref SubFindFbDoc : find and check the fbdoc executable

- \ref SubUseFbDoc : create targets to control the documentation build

Target `install` copies them all to your system folder, since the
fbdoc scripts may be useful for your projects as well. The destination
folder is declared as `${CMAKE_INSTALL_PREFIX}/share/${PROJ_NAME}`.
Variable `CMAKE_INSTALL_PREFIX` depends on your system, find details in
the [CMake
documantation](https://cmake.org/cmake/help/v3.7/variable/CMAKE_INSTALL_PREFIX.html).


## FB extension scripts {#SubFbExtension}

The directory structure and also the file names are stated by \CMake.
It's beyond the scope of this documentation to explain details about
the files and the integration of a new language in to \CMake. Find
further information in the [CMake
documentation](https://cmake.org/documentation/).


## FindFbDoc.cmake  {#SubFindFbDoc}

This file is a \CMake script file that searches for the \FbDoc tool. It
tries to find the executable `fbdoc`, and on success it determines its
version. The script reports an error on versions smaller than 0.4.0.
Otherwise the following variables get set

\Item{FbDoc_EXECUTABLE} The full path to the \FbDoc executable.

\Item{FbDoc_WORKS} The status if the \FbDoc tool was found, is working and has a proper version number.

\Item{FbDoc_VERSION} The version number reported by command `fbdoc --version`.

Here's an example on how to use the script in your `CMakeLists.txt` code
~~~
INCLUDE(FindFbDoc)
IF(NOT FbDoc_WORKS)
  MESSAGE(STATUS "fbdoc tool not found ==> doc targets not available!")
  RETURN()
ENDIF()
~~~


## UseFbDoc.cmake  {#SubUseFbDoc}

This file is a \CMake macro file that declares a function to add custom
targets for a default documentation build. This function

- checks for proper tool installation of the \FbDoc tool (using the
  script \ref SubFindFbDoc) and the \Doxygen generator,

- adapts Doxygen configuration to the build path, and

- declares some targets to build documentation in PDF or HTML format

The process is designed to build the documentation either

- manually controlled in folder `doxy` (ie. by using `doxywizard`), as well as
- automated by \CMake in-source in folder `doxy`, or
- automated by \CMake out-of-source in any folder of your choise.

This is, the basis configuration gets loaded from the \Doxygen
configuration file (default is `doxy/Doxyfile`) and in case of an
automated build some tags in that file get overridden, in order to

- adapt input and output paths,
- transfer project constants, and
- control the type of the generated output.

The file provides a function named `FB_DOCUMENTATION`, which declares
the custom targets listed in section \ref SubDocTargets.

Here's an minimal example on how to use this macro file and the
function in your `CMakeLists.txt` code

~~~{.cmake}
IF(NOT COMMAND FB_DOCUMENTATION)
  INCLUDE(UseFbDoc)
ENDIF()

FB_DOCUMENTATION(
  DEPENDS
    ../ReadMe.md
    ../_Install.md
    ../_Usage.md
    ../_ChangeLog.md
    ../_FileFold.md
    ../cmakefbc_deps/_Tool.md
    Doxyfile
    cmakefbc.xml
    ../CMakeLists.txt
  BAS_SRC
    ../cmakefbc_deps/cmakefbc_deps.bas
  )
~~~

Below the keyword `DEPENDS` the dependency files are listed. The
documentation gets re-build if any of those files get changed. The
files listed below the keyword `BAS_SRC` also cause a re-build of the
documentation, but they are in a separate list since they also cause a
re-build of the file fbdoc.lfn (which is necessary for caller and
callee graphs, see \FbDoc documentation for details).

In order to customize the target declarations, the function can get
called in a more complex signature like

~~~{.cmake}
FB_DOCUMENTATION(
  NO_PDF
  NO_HTM
  NO_WWW
  NO_LFN
  NO_SELFDEP
  NO_PROJDATA
  NO_SYNTAX
  DOXYFILE MyCustomDoxyfile
  MIRROR_CMD BatchScript.sh
  DEPENDS
    ../ReadMe.md
    ../_Install.md
    ../_Usage.md
    ../_ChangeLog.md
    ../_FileFold.md
    ../cmakefbc_deps/_Tool.md
    Doxyfile
    cmakefbc.xml
    ../CMakeLists.txt
  BAS_SRC
    ../cmakefbc_deps/cmakefbc_deps.bas
  DOXYCONF
"
ALIASES    +=\"Top= the original \\p cmakefbc package\"
STRIP_FROM_PATH        = abc
STRIP_FROM_INC_PATH    = xyz/abc
"                                 #< block of three lines
  "QT_AUTOBRIEF           = NO\n" #< single line
  "TAB_SIZE               = 8\n"  #< single line
  )
~~~

\Item{NO_PDF} A flag to drop the default target `doc_pdf`. Set this to
  generate HTML output only.

\Item{NO_HTM} A flag to drop the default target `doc_htm`. Set this and
  `NO_WWW` to generate PDF output only.

\Item{NO_WWW} A flag to drop the default target `doc_www`. By default
  this target mirrors the local HTML tree to a webserver by executing a
  batch script, see target \ref SubDocWww for details. Set this flag to
  suppress the target declaration.

\Item{NO_LFN} A flag to drop the preparation of the file fbdoc-lfn. If
  you don't want caller and callee graphs, you don't need this file.
  Suppress it's generation by setting this flag.

\Item{NO_SELFDEP} A flag to drop the dependency on itself. By default
  the function adds a dependency on the file `CMakeLists.txt` in the
  current source folder, which is the file wherein the function gets
  called. This makes \CMake to re-build the documentation in case of
  any configuration changes. Set this flag to suppress this dependency.

\Item{NO_PROJDATA} A flag to drop the transfer of the project data to
  the doxygen configuration file. By default the function transfers
  some project constants (`PROJ_NAME`, `PROJ_DESC`, `PROJ_VERS`, ...)
  to the \Doxygen configuration, which overrides the tags
  `PROJECT_NAME`, `PROJECT_BRIEF` and `PROJECT_NUMBER`. Also some
  default `ALIASES` get declared (`Mail=${PROJ_MAIL}`,
  `Proj=*${PROJ_NAME}*`, `Year=${PROJ_YEAR}`, `Webs=${PROJ_WEBS}`). Set
  the flag to suppress this.

\Item{NO_SYNTAX} A flag to drop the default syntax highlighting in
  source code listings. Set this to skip the `fbdoc -s` execution
  after the `doxygen` run, ie. when you don't include source listings
  or when you want to check the intermediate format generation.

\Item{DOXYFILE} A keyword followed by a single string containing the
  name of the \Doxygen configuration file (`MyCustomDoxyfile` in the
  above example). By default `doxygen` gets executed without any
  options, so that it loads its default configuration file `Doxyfile`.
  Use this keyword to specify a different configuration file name (or
  further option for \Doxygen).

\Item{MIRROR_CMD} A keyword followed by a single string containing the
  command to mirror the local HTML tree to a webserver (`BatchScript.sh`
  in the above example). See target \ref SubDocWww for details.

\Item{BAS_SRC} A keyword followed by a list (on or more strings)
  containing filenames (\FB source files) to be used as dependencies
  - for the doc targets and
  - for the custom command that generates the file fbdoc.lfn (unless `NO_WWW` flag is set).

\Item{DEPENDS} A keyword followed by a list (on or more strings)
  containing file names the build process depend on. List your input
  files here (`*.md`) and also files used to configure the build
  process.
  \note Those file names are used to specify the dependencies (only).
        The list doesn't affect the `INPUT` configuration, neither for
        \Doxygen nor for \FbDoc (in modi `--list-mode` or
        `--syntax-mode`).

\Item{DOXYCONF} A keyword followed by a single string (or a list of
  strings) containing additional tags to override the basis \Doxygen
  configuration. Those strings get inserted after the settings for paths
  and project data, but before the output settings (so changes to tags
  like `GENERATE_LATEX` or `GENERATE_XML` will get overriden further
  on).
  \note Those strings get parsed by \CMake, so you have to escape
        special charaters like `"` (gets `\"`) or `\` (gets `\\`). See
        \ref SubDoxyControl for an alternative.


### Targets  {#SubDocTargets}

The function `FB_DOCUMENTATION` creates new targets:

- \ref SubDocHtm : build the documentation in html format
- \ref SubDocPdf : build the documentation in pdf format (LaTeX required)
- doc: build the former targets doc_htm and doc_pdf
- \ref SubDocWww : upload the html tree to a server by executing a script

\note Those targets get created anyway, regardless if your systems
      provides the depending tools. \Proj cannot check all dependencies
      that may be specified in the Doxygen configuration file.


#### doc_htm  {#SubDocHtm}

This target uses the specified `DOXYFILE`, extends it by fbdoc
specific code and sets the output format to html in subfolder `html`.
Afterwards it calls Doxygen to generate the html tree. When finished,
find the start page at `html/index.html` in your Doxygen build folder,
or in the subfolder `html` in the directory specified by `Doxyfile` tag
`OUTPUT_DIRECTORY`.

\note The subfoldername `html` is fixed.


#### doc_pdf  {#SubDocPdf}

This target uses the specified `DOXYFILE`, extends it by fbdoc
specific code and sets the output format to pdf in subfolder `latex`.
Afterwards it calls Doxygen to generate the pdf file. When finished,
find the output named `${PROJ_NAME}.pdf` in your Doxygen build folder,
or in the folder specified by `Doxyfile` tag `OUTPUT_DIRECTORY`.

\note The subfoldername `latex` is fixed.


#### doc_www  {#SubDocWww}

This target mirrors the local HTML tree to a webserver by executing a
batch script. By default it executes

~~~{.txt}
MirrorDoc.sh '--reverse --delete --verbose ${CMAKE_CURRENT_BINARY_DIR}/html public_html/Projekte/${PROJ_NAME}/doc/html'
~~~

Whereby the batch file `MirrorDoc.sh` contains the commands to mirror
the folders. Ie. when using [<tt>lftp</tt>](http://lftp.yar.ru/) for
mirroring, the context may look like

~~~{.txt}
#!/bin/bash
HOST='ftp://your.server.adr'
USER='UserName'
PASS='PassWord'

lftp -c "
open $HOST
user $USER $PASS
set mirror:use-pget-n 3
mirror -P3 $*
bye
"
~~~

\note Adapt variable declarations `HOST`, `USER` and `PASS` to
      match your server login.

\note In order to customize the command (and the batch script to use)
      see keyword `MIRROR_CMD`.


### Controling Doxygen  {#SubDoxyControl}

In order to control the Doxygen generation process, the function does
not override the original configuration file (default name `Doxyfile`).
Instead, the related tags controlling the CMake build process get
written to extension files, a general

\Item{DoxyExtension} global extensions for all output types (macros and filter tags)

and output format specific

\Item{HtmOut} setting for html output

\Item{PDFOut} setting for pdf output

The CMake function passes the latest output specific file to Doxygen,
which `@INCLUDE`s the general extension, which finally `@INCLUDE`s the
original configuration. Doxygen reads the original configuration first,
then overrides the general tags, and finally overrides the output tags.

\note This concept ensures that Doxygen can either get controlled by
      the CMake build, or manually at the command line, or by any GUI
      (ie. like `doxywizzard`).

In case of CMake build, use keyword `DOXYFILE` to override the default
file name of the original configuration file. And use keyword
`DOXYCONF` to append further tags to the general extension file
(optional).

As an alternative you can chain up your customized settings from a
further configuration file, like

~~~{.txt}
# file MyCustomDoxyfile

@INCLUDE = Doxyfile                    # the original config file

ALIASES += "Macro1=\p typewriter" \    # extension tags
           "Macro2=Macro2 \e Context"
~~~

Then pass this configuration file to \Doxygen (by applying `DOXYFILE
MyCustomDoxyfile`).


# cmakefbc_deps {#SecFoldTool}

This folder contains the source code for the tool \FbDeps, namely

\Item{cmakefbc_deps.bas} the \FB source code,

\Item{CMakelists.txt} the build script to compile and install the executable.


# doxy {#SecFoldDoxy}

This folder contains the configuration files to build the
documentation, namely

\Item{Doxyfile} the \Doxygen basis configuration file,

\Item{cmakefbc.xml} the html index file,

\Item{logo.png} the image file, and

\Item{CMakelists.txt} the build script to compile and upload the documentation.


# debian {#SecFoldDebian}

This folder contains the configuration files to build Debian Linux
packages from the source tree. Find detailed information about package
building in the Debian documentation. Three packages are configured:

\Item{cmakefbc} containing CMake macros, cmakefbc_deps binary, cmakefbc wrapper and man pages (any platform)

\Item{cmakefbc-doc} containing the documentation in html format (all platforms)

\Item{cmakefbc-src} containing the source code (all platforms)

\note Instead of using CPack, this configuration is designed to work
      with the original Debian tools, started by `debuild` command.

Either start the build process by executing `debuild` in the root
folder. In this case the resulting output gets generated in the
directory above the root folder.

Or let CMake handle it by executing `make deb` and find the resulting
output either in the directory above the root folder (in-source build)
or in subfolder debian.
