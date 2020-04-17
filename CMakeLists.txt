#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014-2020, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
# License GPLv3 (see http://www.gnu.org/licenses/gpl-3.0.html)
#
# See ReadMe.md for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)
SET(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

# constants
SET(PROJ_NAME "cmakefbc"           CACHE STRING "project name" FORCE)
SET(PROJ_DESC "CMake support for FreeBASIC programming language" CACHE STRING "project description" FORCE)
SET(PROJ_VERS "1.0.2"              CACHE STRING "project version" FORCE)
SET(PROJ_AUTH "DTJF"               CACHE STRING "project authors" FORCE)
SET(PROJ_MAIL "Thomas{ doT ]Freiherr[ At ]gmx[ DoT }net"  CACHE STRING "project mail address" FORCE)
SET(PROJ_WEBS "https://github.com/DTJF/cmakefbc" CACHE STRING "project website" FORCE)
SET(PROJ_LICE "GPLv3"              CACHE STRING "project licence" FORCE)
SET(PROJ_YEAR "2020"               CACHE STRING "project year" FORCE)

FUNCTION(MSG_LOG Txt)
  FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log "${Txt}\n\n")
  MESSAGE(STATUS ${Txt})
ENDFUNCTION()

PROJECT(${PROJ_NAME} NONE)

ADD_SUBDIRECTORY(doxy)

ADD_SUBDIRECTORY(src/bas)

IF(UNIX)
  ADD_SUBDIRECTORY(debian)
  IF(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)             # in-source
    ADD_CUSTOM_TARGET(distclean make clean
      COMMAND rm -rf cmake/${PROJ_NAME}
      COMMAND rm -rf debian/${PROJ_NAME}
      COMMAND rm -rf debian/${PROJ_NAME}.*.*
      COMMAND rm -rf `find . -iname Makefile -print`
      COMMAND rm -rf `find . -name CMakeCache.txt -print`
      COMMAND rm -rf `find . -name CMakeFiles -print`
      COMMAND rm -rf `find . -name cmake_install.cmake -print`
      COMMAND rm -rf `find . -name install_manifest.txt -print`
      COMMAND rm -rf doxy/DoxyExtension doxy/HtmOut doxy/PdfOut doxy/fbdoc.lfn doxy/doxygen_sqlite3.db
      COMMAND rm -rf doxy/html/ doxy/latex/
      )
  ELSE()                                                 # out-of-source
    ADD_CUSTOM_TARGET(distclean rm -R *)
  ENDIF()
  SET(CMAKEFBC_FILE ${CMAKE_BINARY_DIR}/cmake/${PROJ_NAME})
  FILE(WRITE ${CMAKEFBC_FILE}
    "#!/bin/bash"
  "\n# Wrapper script for CMake, which adds freebasic support modules to"
  "\n# cmake command.\n"
  "\necho ${CMAKE_COMMAND} \"$@\" -DCMAKE_MODULE_PATH=${CMAKE_INSTALL_PREFIX}/share/cmakefbc/Modules"
  "\n${CMAKE_COMMAND} \"$@\" -DCMAKE_MODULE_PATH=${CMAKE_INSTALL_PREFIX}/share/cmakefbc/Modules"
  )
ELSE()
  SET(CMAKEFBC_FILE ${CMAKE_BINARY_DIR}/cmake/${PROJ_NAME}.bat)
  FILE(WRITE ${CMAKEFBC_FILE}
  "\"${CMAKE_COMMAND}\" \"%*\" -DCMAKE_MODULE_PATH=\"${CMAKE_INSTALL_PREFIX}/share/cmakefbc/Modules\""
  )
ENDIF()

INSTALL(DIRECTORY cmake/Modules DESTINATION share/${PROJ_NAME})
INSTALL(PROGRAMS ${CMAKEFBC_FILE} DESTINATION bin)
