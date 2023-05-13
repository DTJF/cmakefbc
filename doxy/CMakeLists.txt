# Note: this script needs an fbdoc version >= 0.4.0

IF(NOT COMMAND FB_DOCUMENTATION)
  INCLUDE(UseFbDoc)
  IF(NOT COMMAND FB_DOCUMENTATION)
    MSG_LOG("!! no targets <doc...> (UseFbDoc.cmake failed)")
    RETURN()
  ENDIF()
ENDIF()
MSG_LOG(">> targets <doc...> OK")

CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/src/doc/ReadMe.md.in ${CMAKE_SOURCE_DIR}/ReadMe.md @ONLY)

FB_DOCUMENTATION(
BAS_SRC
  ../src/bas/cmakefbc_deps.bas
DEPENDS
  ../CMakeLists.txt
  ../ReadMe.md
  ../src/doc/_1_Install.md
  ../src/doc/_2_Usage.md
  ../src/doc/_3_Tool.md
  ../src/doc/_A_FileFold.md
  ../src/doc/_z_ChangeLog.md
  Doxyfile
  cmakefbc.css
  cmakefbc.xml
  )

#INSTALL(DIRECTORY html DESTINATION /usr/share/doc/${PROJ_NAME}) #TEST
