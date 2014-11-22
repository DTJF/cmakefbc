#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
#
# All rights reserved.
#
# See Copyright.txt for details.
#

PROJECT (cmakefbc NONE)

# declare file to install
SET (MOD_SRCS
	CMakeFbcCompiler.cmake.in
	CMakeFbcInformation.cmake
	CMakeTestFbcCompiler.cmake
	CMakeDetermineFbcCompiler.cmake
)

SET (PLAT_SRCS
	Platform/Linux-fbc.cmake
	Platform/Windows-fbc.cmake
)

INSTALL (FILES ${MOD_SRCS} DESTINATION ${CMAKE_ROOT}/Modules)
INSTALL (FILES ${PLAT_SRCS} DESTINATION ${CMAKE_ROOT}/Modules/Platform)
