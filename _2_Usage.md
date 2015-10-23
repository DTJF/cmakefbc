Usage  {#PagUsage}
=====
\tableofcontents

The \CMake build system is a powerful tool to build and test a project
and to pack it in to archives or installers. Describing all features of
this build management system is far beyond the scope of this
documentation (see http://www.cmake.org/documentation/ for
details). Find here some specials regarding the FB adaptions.

This package binds the FB compiler in to the \CMake build management
system. It supports two ways how to use the FB compiler:

- Direct compiling (.bas to binaries = object files), and
- indirect compiling (.bas to .c).

For direct compiling only the FB compiler is necessary (and its
tools). In contrast, for indirect compiling you'll need a further C
compiler to be installed on your system (which is the case when you use
a 64 bit FB version).

The later (indirect compiling) may be beneficial when porting a project
to new platforms or when packing Debian packages (.deb) with source
code. But in most cases it's more convenient to compile directly, since
you'll have less files in your project folders.


# Direct Compiling  {#SecDirect}

Direct compiling uses the FB compiler to generate the object files from
each source file specified for a top level target (executable or
library) and also to link the object files in to a binary. Just one
language gets specified for the project. A minimal CMakeLists.txt file
looks like

~~~{.cmake}
# declare the required CMake version (optional)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the language (compiler) to use
PROJECT(MyProject Fbc)

# declare the target name and the source file[s]
ADD_EXECUTABLE(MyProject MyProject.bas)

# define the compiler options (must have -m for executables)
SET_TARGET_PROPERTIES(MyProject PROPERTIES
  COMPILE_FLAGS "-w all -m MyProject"
  )
~~~

This example generates a project named `MyProject` that compiles an
executable, which is also named `MyProject` (or `MyProject.exe` on
non-LINUX systems). Find detailed information on the commands in the
[CMake Documentation](http://www.cmake.org/cmake/help/v3.0/index.html).

The language specification in the `PROJECT` line is `Fbc` (in camel
case with capital first letter). All compiler variables are specified
with camel case language name (ie. CMAKE_Fbc_COMPILER).

In the above example there's just one FB source file in the
`ADD_EXECUTABLE` line, so it's optional to specify option `-m` in the
`COMPILE_FLAGS` line (in this special case).

\note For executable targets with more than one source file, you have
      to specify the compile flag `-m` to tell the FB compiler where to
      find the main code.

\CMake scans dependency trees for source files, but only for native
languages (C, C++, RC, ASM, Fortran and Java). This is a useful feature
since an object file only gets re-build when one of the related source
files changed. Since FB isn't a native language, this package has to
provide an external solution for this feature. Therefor, and in
contrast to the \CMake documentation, only the compilable source files
(`*.bas`) gets specified in an `ADD_EXECUTABLE` or `ADD_LIBRARY`
command (it also works for the `ADD_CUSTOM_TARGTET` command). The
command `ADD_Fbc_SRC_DEPS` builds the dependency trees later for all
source files of that target:

~~~{.cmake}
# declare the required CMake version (optional)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the language (compiler) to use
PROJECT(MyLib Fbc)

# declare the soure files
SET(BAS MyLib.bas File2.bas File3.bas)

# declare the target name and the source file[s]
ADD_LIBRARY(MyLib ${BAS})

# generate the dependency trees for executable target MyProjekt
ADD_Fbc_SRC_DEPS(MyLib)

# define the compiler options (no -m for library)
SET_TARGET_PROPERTIES(MyLib PROPERTIES
  COMPILE_FLAGS "-Wc -fPIC"
  )
~~~

This `ADD_Fbc_SRC_DEPS` command requires a single parameter, which is
the name of the target. The related \CMake macro reads all source files
from the target properties and calls the \FbDeps tool to create a file
with the dependency trees. Then, this macro includes the generated file
in to your CMakeLists.txt file. The generated file also contains a
custom command which re-builds the file (itself) when one of the source
files in the dependency tree changed.

This mechanism ensures that only those object files get re-build that
are related to the changed source files.

\note The macro `ADD_Fbc_SRC_DEPS` is only available when the
      \FbDeps tool is installed. (Otherwise you'll get a message on the
      initial cmake call, like `Tool cmake_fb_deps not available -> no
      Fbc extensions!`.


# Indirect Compiling  {#SecIndirect}

Indirect compiling uses the FB compiler to generate C source code form
the .bas files and then uses a C compiler tool chain to generate the
object files from each C source file to finally build the binary of a
top level target (executable or library). So after pre-compiling the
.bas files, the further proceeding is exactly the same as for each
native C project.

Both languages get specified for such a project. A minimal
CMakeLists.txt file looks like

~~~{.cmake}
# declare the required CMake version (optional)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the languages (compilers) to use
PROJECT(MyProject Fbc C)

# pre-compile the C source, variable C_SRC contains the names of the C files
BAS_2_C(C_SRC MyProject.bas)

# declare the target name and the source file[s]
ADD_EXECUTABLE(MyProject C_SRC)
~~~

The `PROJECT` line specifies both languages `Fbc` and `C`. The C code
gets generated in the `BAS_2_C` line, which is the only difference to a
usual C project.

The function `BAS_2_C` requires at least two parameters. The first one
is the name of a variable that should be used to collect the file names
of the resulting C source files. The second (and further parameters)
are FB source file names to be pre-compiled.

The function calls the FB compiler for each FB source file and
pre-compiles a C source file. By default the C source files gets
written to the same directory where the FB files are from. This
function also creates the dependency tree file using the \FbDeps tool
and includes it in to your CMakeLists.txt file. By default the file is
named CMakeFiles/bas2c_deps.cmake. This means you can have only one
default `BAS_2_C` command per CMakeLists.txt file, since a second call
will oerride the dependency file from the first call.

Therefor the function can also be used in a more complex signature to
customize its behavior, like

~~~{.cmake}
BAS_2_C(<c_src_var>
  SOURCES
    MyProject.bas
    File2.bas
    File3.bas
  COMPILE_FLAGS
    -m MyProject
    -e
    -w all
  OUT_DIR
    CMakeFiles/MyProject.dir
  OUT_NAM
    MyProject
  NO_DEPS
  )
~~~

Where the argument separators have the following meanings

\Item{NO_DEPS} A flag to disable the dependency file generation /
   inclusion (, which is enabled by default).

\Item{OUT_NAM} A keyword followed by a single string containing the
   base name of the generated dependency file (suffix .cmake). This is
   to avoid naming conflicts in case of multiple calls of the macro
   in the same directory (CMakeLists.txt file). It overrides the
   default name (CMakeFiles/bas2c_deps.cmake). The file gets written in
   the directory `OUT_DIR` (, or in the current source directory if
   `OUT_DIR` isn't defined).

\Item{OUT_DIR} A keyword followed by a single string containing the
   directory where to store the C source files and the dependency file
   (unless `NO_DEPS` flag is set). This directory gets created if not
   present.

\Item{COMPILE_FLAGS} A keyword followed by on or more strings
   containing additional options to be used when calling the FB
   compiler. Those options get placed before the mandatory options
   `-gen gcc -r` and the file name.

\Item{SOURCES} A keyword followed by a list of FB source files to
   be compiled.

\Item{`c_src_var`} The name of the variable to return the list of C
   source file names.

All further parameters (not prepended by one of the above separators)
get interpreted as FB source file names.

\note The function `BAS_2_C` is only available when the cmake_fb_deps
      tool is installed. (Otherwise you'll get a message on the initial
      cmake call, like `Tool cmake_fb_deps not available -> no Fbc
      extensions!` and you'll find a similar entry in
      CMakeFiles/CMakeOutput.log.


# Shipping  {#SecShipping}

When shipping your project, the recipient needs the new CMake macros in
order to manage your project. Since they do not come with the original
\CMake install yet (effective 2015, Jan.), you have to include the
macros to your project (as it is done in this package).

Therefor just copy the folder `cmake` to the root directory of your
project and add the following line at the beginning of your root
CMakeLists.txt file (right below `CMAKE_MINIMUM_REQUIRED(...)`)

~~~{.cmake}
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
~~~

This makes \CMake to search for macro files in the specified directory
first.

\note The `CMAKE_MODULE_PATH` has higher priority than the `CMAKE_ROOT`
      folder, so that the default macros get disabled when similar
      named macros are present in this path.
