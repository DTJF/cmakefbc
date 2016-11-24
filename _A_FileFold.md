Files and Folders  {#PagFileFold}
=================
\tableofcontents

The package contains the folders

- \ref SecFoldCMake : containing the \CMake macros and scripts related to the \FB compiler and \FbDoc
- \ref SecFoldTool : containing the source code for the tool \FbDeps
- \ref SecFoldDoc : containing configuration files to build the documentation (where \Doxygen executes in a manual build).


# cmake {#SecFoldCMake}

This folder contains the script files for \CMake in a subfolder called
`Modules`. The directory structure and also the file names are stated
by \CMake. The subfolders and their files get copied to your local CMake
installation when the install target gets build by executing `make
install`. And also they are used to build the default target by
executing `make` (since in file `CMakeLists.txt` in the root directory
the statement

~~~{.cmake}
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
~~~

adds this directory to the module paths, in order to make the scripts
available for the initial build).

Those script files are not in the \CMake distribution yet, so you've to
ship them with your projects (similar as it is done in this project),
in order to provide them to the users. See section \ref SecShipping for
details.

It's beyond the scope of this documentation to explain details about
the files and the integration of a new language in to \CMake. Find
further information in its documentation.

But there're two more files, rather related to the tool \FbDoc than to
the compiler integration

- \ref SubSecScriptFind and
- \ref SubSecMacroUse.

Those files are included because they're used to build this
documentation (the text you're currently reading). You may find them
helpful for your projects as well.


## FindFb-Doc.cmake  {#SubSecScriptFind}

This file is a \CMake script file that searches for the \FbDoc tool. It
tries to find the executable `fb-doc`, and on success it determines its
version. The script reports an error on versions smaller than 0.4.0.
Otherwise the following variables get set

\Item{FbDoc_EXECUTABLE} The full path to the \FbDoc executable.
\Item{FbDoc_WORKS} The status if the \FbDoc tool was found, is working and has a proper version number.
\Item{FbDoc_VERSION} The version number reported by command `fb-doc --version`.

Here's an example on how to use the script in your `CMakeLists.txt` code
~~~
INCLUDE(FindFb-Doc)
IF(NOT FbDoc_WORKS)
  MESSAGE(STATUS "fb-doc tool not found ==> doc targets not available!")
  RETURN()
ENDIF()
~~~


## UseFb-Doc.cmake  {#SubSecMacroUse}

This file is a \CMake macro file that declares a function to add custom
targets for a default documentation build. This function

- checks for proper tool installation of the \FbDoc tool (using the
  script \ref SubSecScriptFind) and the \Doxygen generator,

- adapts Doxygen configuration to the build path, and

- declares some targets to build documentation in PDF or HTML format

The process is designed to build the documentation either

- manually controlled in folder `doc` (ie. by using `doxywizard`), as well as
- automated by \CMake in-source in folder `doc`, or
- automated by \CMake out-of-source in any folder of your choise.

This is, the basis configuration gets loaded from the \Doxygen
configuration file (default is `doc/Doxyfile`) and in case of an
automated build some tags in that file get overridden, in order to

- adapt input and output paths,
- transfer project constants, and
- control the type of the generated output.

The file provides a function named `FB_DOCUMENTATION`, which declares
the custom targets

\Item{`doc`} build PDF file and HTML tree
\Item{`doc_pdf`} build PDF file (output `doc/${PROJ_NAME}.pdf`)
\Item{`doc_htm`} build HTML tree (startfile `doc/html/index.html`)
\Item{`doc_www`} mirror local HTML tree to a web server

Here's an minimal example on how to use this macro file and the
function in your `CMakeLists.txt` code

~~~{.cmake}
IF(NOT COMMAND FB_DOCUMENTATION)
  INCLUDE(UseFb-Doc)
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
re-build of the file fb-doc.lfn (which is necessary for caller and
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
  batch script, see \ref SubSubSecDocWww for details. Set this flag to
  suppress the target declaration.

\Item{NO_LFN} A flag to drop the preparation of the file fb-doc-lfn. If
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
  source code listings. Set this to skip the `fb-doc -s` execution
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
  in the above example). See \ref SubSubSecDocWww for details.

\Item{BAS_SRC} A keyword followed by a list (on or more strings)
  containing filenames (\FB source files) to be used as dependencies
  - for the doc targets and
  - for the custom command that generates the file fb-doc.lfn (unless `NO_WWW` flag is set).

\Item{DEPENDS} A keyword followed by a list (on or more strings)
  containing file names the build process depend on. List your input
  files here (`*.md`) and also files used to configure the build
  process.
  \note Those file names are used to specify the dependencies (only).
        The list doesn't affect the `INPUT` configuration, neither for
        \Doxygen nor for \FbDoc (in modi `--list-mode` or
        `--syntax-mode`).

\Item{DOXYCONF} A keyword followed by a list (on or more strings)
  containing additional tags to override the basis \Doxygen
  configuration. Those tags get inserted after the settings for paths
  and project data, but before the output settings (so changes to tags
  like `GENERATE_LATEX` or `GENERATE_XML` will get overriden further
  on).
  \note Those strings get parsed by \CMake, so you have to escape
        special charaters like `"` or `\`. See \ref
        SubSubSecExtensionFile for an alternative.


### Target doc_www  {#SubSubSecDocWww}

This target mirrors the local HTML tree to a webserver by executing a
batch script. By default it executes

~~~{.sh}
MirrorDoc.sh '--reverse --delete --verbose ${CMAKE_CURRENT_BINARY_DIR}/html public_html/Projekte/${PROJ_NAME}/doc/html'
~~~

Whereby the batch file `MirrorDoc.sh` contains the commands to mirror
the folders. Ie. when using [<tt>lftp</tt>](http://lftp.yar.ru/) for
mirroring, the context may look like

~~~{.sh}
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


### Configure by extension file  {#SubSubSecExtensionFile}

When the \CMake build should override some settings in the basis
configuration file, the keyword `DOXYCONF` can do the job.
Unfortunately the context has to get through the \CMake parser, so that
special characters have to get escaped. \Doxygen makes use of charaters
`"` and `\` in the configuration file syntax, so the context gets
unreadable soon.

As an alternative you can write your customized settings in to a
further configuration file and chain up this file with the basis
configuration by prepending an `@INCLUDE` command, like

~~~
# file MyCustomDoxyfile

@INCLUDE = Doxyfile

ALIASES += "Macro1=\p typewriter" \
           "Macro2=Macro2 \e Context"
~~~

Then pass this configuration file name to \Doxygen (by applying
`DOXYFILE MyCustomDoxyfile` in the `FB_DOCUMENTATION` function call, as
in the above example).

This process is also used in the function `FB_DOCUMENTATION` itself. If
you want to chain up with the functions configuration file, then
prepend your settings by

~~~
@INCLUDE = ${CMAKE_CURRENT_BINARY_DIR}/DoxyExtension
~~~


# cmakefbc_deps {#SecFoldTool}

This folder contains the source code for the tool \FbDeps, namely

- `cmakefbc_deps.bas` : the \FB source code,
- `_Tool.md` : the documentation context, and
- `CMakelists.txt` : the build script to compile and install the executable.


# doc {#SecFoldDoc}

This folder contains the configuration files to build the
documentation, namely

- `Doxyfile` : the \Doxygen basis configuration file,
- `cmakefbc.xml` : the html index file,
- `fb-doc.lfn` : the list of function names file,
- `logo.png` : the image file, and
- `CMakelists.txt` : the build script to compile and upload the documentation.
