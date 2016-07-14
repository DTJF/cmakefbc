#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014-2016, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
# License GPLv3 (see http://www.gnu.org/licenses/gpl-3.0.html)
#
# See ReadMe.md for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

# constants
SET(PROJ_NAME "cmakefbc"           CACHE STRING "project name" FORCE)
SET(PROJ_DESC "CMake support for FreeBASIC programming language" CACHE STRING "project description" FORCE)
SET(PROJ_VERS "0.4.3"              CACHE STRING "project version" FORCE)
SET(PROJ_AUTH "DTJF"               CACHE STRING "project authors" FORCE)
SET(PROJ_MAIL "Thomas{ doT ]Freiherr[ At ]gmx[ DoT }net"  CACHE STRING "project mail address" FORCE)
SET(PROJ_WEBS "https://github.com/DTJF/cmakefbc" CACHE STRING "project website" FORCE)
SET(PROJ_LICE "GPLv3"              CACHE STRING "project licence" FORCE)
SET(PROJ_YEAR "2016"               CACHE STRING "project year" FORCE)

# Uncomment the next two lines to perform a standard build.
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
ADD_SUBDIRECTORY(cmake_fb_deps)

ADD_SUBDIRECTORY(doxy)

PROJECT(${PROJ_NAME} NONE)

CONFIGURE_FILE(_ReadMe.md.in ${CMAKE_SOURCE_DIR}/ReadMe.md @ONLY)
INSTALL(DIRECTORY cmake/Modules DESTINATION ${CMAKE_ROOT})
