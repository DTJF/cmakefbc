Package cmakefbc
================

This is package cmakefbc, an extension for the build system CMake to
support the FreeBASIC programming language.


Installation
============

Three steps are necessary to install this package

-# Preparation: get working installations of the packages
  - FreeBASIC compiler, and
  - CMake build system.
-# Install CMake FB extension.
-# Compile and install fb_depends tool.


Step 1 Preparation
------------------

Installing this package only makes sence if you have a working
installation of some programming tools, the FreeBASIC compiler fbc (see
http://www.freebasic.net) and the CMake build system (see
http://www.cmake.org). Installation instructions of those packages are
beyond the scope of this guide.

Step 2 CMake FB extension
-------------------------

Once you have CMake installed you can add the support for FreeBASIC
programming language. Since you read this file you already

- downloaded the cmakefbc package, and
- unpacked the archive.

Next step is to use CMake to install the extension files:

~~~{.sh}
cd cmakefbc
cmake .
sudo make install
~~~

or on non LINUX systems

~~~{.sh}
cd cmakefbc
cmake .
make install
~~~

This commands will copy six configuration files to the correct location
in your CMake installation. Your system is ready to address the
FreeBASIC language now and to compile simple projects like the
fb_depends tool. Big projects may contain several source files and
headers and some of these source files depend on others. To re-compile
only the related files, CMake should handle this dependencies but isn't
prepared for FreeBASIC yet.

The tool fb_depends helps to resolve dependencies in big projects with
complex source file trees. We can use its source to test our CMake
installation in the next step.

Step 3 fb_depends tool
----------------------

The fb_depends tool auto-generates source file dependencies in a CMake
include file. So it's an essential component of this package and should
get build and installed if you intend to build big projects.

Once you installed the CMake FB extension (step 2) you can execute the
following commands

~~~{.sh}
cd fb_depends
cmake .
make
sudo make install
~~~

or on non LINUX systems

~~~{.sh}
cd fb_depends
cmake .
make
make install
~~~

to generate the build system (`cmake .`), compile the tool (`make`) and
install it on your system.


Usage
=====

The CMake build system is a powerful tool to build and test a project
and pack it in archives or installers Describing all features is for
beyond the scope of this documentation. Find here some specials
regarding building project with the FreeBASIC support.

This package binds the FreeBASIC compiler in to the CMake build system.
It supports two ways to use the compiler:

- Direct compiling (.bas to binaries), and
- indirect compiling (.bas to .c).

For direct compiling only the FreeBASIC compiler is necessary (and its
tools). In contrast for indirect compiling you'll need a further C
compiler to be installed on your system (which is the case when you use
a 64 bit FB version).

Indirect compiling may be beneficial when porting a project to new
platforms or when packing LINUX packages with source code. In most
cases it's more convenient to compile direct, since you'll have less
files in your project folders.

Direct Compiling
----------------

Direct compiling uses the FreeBASIC compiler to generate the object
files from each source file specified for a top level target
(executable or library) and to build the binary. Just one language gets
specified for the project. A minimal CMakeLists.txt file looks like

~~~{.sh}
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

This example generates a project named *MyProject* that compiles an
executable also named *MyProject* (or *MyProject.exe* on non-LINUX
systems). Find detailed information on the commands in the [CMake
Documentation](http://www.cmake.org/cmake/help/v3.0/index.html).

For FB projects it's important that the language name is defined as
`Fbc` (in camel case with capital first letter). In the above example
there's just one source file, so it's optional to use option `-m` in
this special case.

\note For executable targets with more than one source file, you have
      to specify the compile flag `-m` to tell the fbc where to find
      the main code.

CMake scans dependency trees for source files, but only for native
languages (C, C++, RC, ASM, Fortran and Java). This is a useful feature
since an object file only gets re-build when one of the related source
files changed. This package provides an external solution for this
feature. In contrast to the CMake documentation you should specify only
the compilable source files (*.bas) in an `ADD_EXECUTABLE` or
`ADD_ELIBRARY` command and use a further command to build a dependency
tree for all source files of that target (this also work for
`ADD_CUSTOM_TARGTET` command):

~~~{.sh}
# declare the required CMake version (optional)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the language (compiler) to use
PROJECT(MyLib Fbc)

# declare the soure files
SET(BAS MyLib.bas File2.bas File3.bas)

# declare the target name and the source file[s]
ADD_ELIBRARY(MyLib ${BAS})

# generate the dependency trees for executable target MyProjekt
ADD_Fbc_DEPS(MyLib)

# define the compiler options (must have -m for executables)
SET_TARGET_PROPERTIES(MyLib PROPERTIES
  COMPILE_FLAGS "-Wc -fPIC"
  )
~~~

The command `ADD_Fbc_DEPS` requires a single parameter, which is the
name of the target. The related CMake macro reads all source files from
the target properties and calls the fb_depends tool to create a file
with the dependency trees. Then this macro includes the generated file
to your CMakeLists.txt file. The generated file also contains a custom
command which re-builds the file when one of the source files in the
dependency tree changed.

This mechanism ensures that only those object files get re-build that
are related to the changed source files.

\note The macro `ADD_Fbc_DEPS` is only available when the fb_depends
      tool is installed. (Otherwise you'll get a message on the initial
      cmake call, like `Tool fb_depends not available -> no Fbc
      extensions!`.

Indirect Compiling
------------------

Indirect compiling uses the FreeBASIC compiler to generate C source
code form the .bas files and then uses a C compiler to generate the
object files from each C source file to build the binary of a top level
target (executable or library). So after pre-compiling the .bas files
the further proceeding is exactly the same as for each native C
project.

Both languages get specified for such a project. A minimal
CMakeLists.txt file looks like

~~~{.sh}
# declare the required CMake version (optional)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the languages (compilers) to use
PROJECT(MyProject Fbc C)

# pre-compile the C source, variable C_SRC contains the names of the C files
BAS_2_C(C_SRC MyProject.bas)

# declare the target name and the source file[s]
ADD_EXECUTABLE(MyProject C_SRC)
~~~

The function `BAS_2_C` requires at least two parameters. The first one
is the name of a variable that should be used to collect the file names
of the resulting C source files. The second (and further parameters)
are FreeBASIC source file names to be pre-compiled.

The function calls the FreeBASIC compiler for each FreeBASIC source
file and pre-compiles a C source file. By default the C source files
gets written to the same directory where the FB files are from. The
function also creates the dependency tree file using the fb_depends
tool and includes it in to your CMakeLists.txt file, by default using
the file name CMakeFiles/bas2c_deps.cmake. This means you can have only
one `BAS_2_C` command per CMakeLists.txt file, since a second call will
oerride the dependency file from the first call.

Therefor the function can be used in a more complex signature to
customize its behavior

~~~{.sh}
BAS_2_C(<C_SRC_VAR>
  SOURCES
    MyProject.bas
    File2.bas
    File3.bas
  OUT_DIR
    CMakeFiles/MyProject.dir
  OUT_NAM
    MyProject
  COMPILE_FLAGS
    "-m MyProject"
  NO_DEPS
  )
~~~

Where

- `NO_DEPS` is a flag to disable the dependency file generation /
  inclusion (, which is enabled by default).

- `COMPILE_FLAGS` is a keyword followed by a single string containing
   all options to be used when calling the FreeBASIC compiler.

- `OUT_NAM` is a keyword followed by a single string containing the
   name of the generated dependency file. This is to avoid naming
   conflicts in case of a multiple calls of the macro in the same
   directory (CMakeLists.txt file). It overrides the default name
   (CMakeFiles/bas2c_deps.cmake).

- `OUT_DIR` is a keyword followed by a single string containing the
   directory where to store the C source files and the dependency file
   (when `NO_DEPS` flag unset). This directory gets created if not
   present.

- `SOURCES` is a keyword followed by a list of FreeBASIC source files to
   be compiled.

All further parameters (not prepended by one of the above keywords) get
interpreted as FreeBASIC source file names.

\note The function `BAS_2_C` is only available when the fb_depends
      tool is installed. (Otherwise you'll get a message on the initial
      cmake call, like `Tool fb_depends not available -> no Fbc
      extensions!`.

