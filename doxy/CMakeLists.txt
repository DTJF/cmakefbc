# Note: this script needs an fb-doc version >= 0.4.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

IF(NOT COMMAND FB_DOCUMENTATION)
  INCLUDE(UseFb-Doc)
  IF(NOT COMMAND FB_DOCUMENTATION)
    RETURN()
  ENDIF()
ENDIF()

FB_DOCUMENTATION(
BAS_SRC
  ../cmake_fb_deps/cmake_fb_deps.bas
DEPENDS
  ../CMakeLists.txt
  ../ReadMe.md
  ../_1_Install.md
  ../_2_Usage.md
  ../_3_Tool.md
  ../_A_FileFold.md
  ../_z_ChangeLog.md
  Doxyfile
  cmakefbc.css
  cmakefbc.xml
  )

#INSTALL(DIRECTORY html DESTINATION /usr/share/doc/${PROJ_NAME})
