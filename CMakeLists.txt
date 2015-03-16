#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014-2015, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
#
# All rights reserved.
#
# See ReadMe.md for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

# constants
SET(PROJ_NAME "cmakefbc"           CACHE STRING "project name" FORCE)
SET(PROJ_DESC "CMake support for FreeBASIC programming language" CACHE STRING "project description" FORCE)
SET(PROJ_VERS "0.4"                CACHE STRING "project version" FORCE)
SET(PROJ_AUTH "TJF"                CACHE STRING "project authors" FORCE)
SET(PROJ_MAIL "Thomas.Freiherr@gmx.net"  CACHE STRING "project mail address" FORCE)
SET(PROJ_WEBS "http://www.freebasic-portal.de" CACHE STRING "project website" FORCE)
SET(PROJ_LICE "GPLv3"              CACHE STRING "project licence" FORCE)
STRING(TIMESTAMP tmp "%Y" UTC)
SET(PROJ_YEAR "${tmp}"             CACHE STRING "project year" FORCE)

# Uncomment the next two lines to perform a standard build.
LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
ADD_SUBDIRECTORY(cmake_fb_deps)

ADD_SUBDIRECTORY(doc)

PROJECT(${PROJ_NAME} NONE)

INSTALL(DIRECTORY cmake/Modules DESTINATION ${CMAKE_ROOT})
