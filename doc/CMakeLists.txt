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
  ../_1_Install.md
  ../_2_Usage.md
  ../cmake_fb_deps/_3_Tool.md
  ../_4_FileFold.md
  ../_9_ChangeLog.md
  Doxyfile
  cmakefbc.css
  cmakefbc.xml
  ../CMakeLists.txt
  )
