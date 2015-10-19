# Note: this script needs an fb-doc version (0.4), which may not be published yet.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

IF(NOT COMMAND FB_DOCUMENTATION)
  INCLUDE(UseFb-Doc)
ENDIF()

FB_DOCUMENTATION(
BAS_SRC
  ../cmake_fb_deps/cmake_fb_deps.bas
DEPENDS
  ../ReadMe.md
  ../_Install.md
  ../_Usage.md
  ../_ChangeLog.md
  ../_FileFold.md
  ../cmake_fb_deps/_Tool.md
  Doxyfile
  cmakefbc.xml
  ../CMakeLists.txt
  )
