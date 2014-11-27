#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
#
# All rights reserved.
#
# See ReadMe.md for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(cmakefbc NONE)

#ADD_SUBDIRECTORY(fb_depends EXCLUDE_FROM_ALL)

# declare file to install
SET(CM_SRC
	CMakeFbcCompiler.cmake.in
	CMakeFbcInformation.cmake
	CMakeTestFbcCompiler.cmake
	CMakeDetermineFbcCompiler.cmake
)

SET(SYS_SRC
	Platform/Linux-fbc.cmake
	Platform/Windows-fbc.cmake
)

INSTALL(FILES  ${CM_SRC} DESTINATION ${CMAKE_ROOT}/Modules)
INSTALL(FILES ${SYS_SRC} DESTINATION ${CMAKE_ROOT}/Modules/Platform)
