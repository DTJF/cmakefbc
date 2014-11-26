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

# package support
SET(CPACK_GENERATOR "TGZ2")

SET(CPACK_PACKAGE_DESCRIPTION_FILE "ReadMe.md")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "CMake extension for FreeBASIC programming language")
SET(CPACK_PACKAGE_FILE_NAME "cmakefbc-0.0")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "cmakefbc 0.0")
SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "cmakefbc 0.0")

SET(CPACK_PACKAGE_VENDOR "Humanity")
SET(CPACK_PACKAGE_VERSION "0.0.0")
SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "0")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
SET(CPACK_RESOURCE_FILE_LICENSE "ReadMe.md")
SET(CPACK_RESOURCE_FILE_README "ReadMe.md")


INCLUDE(CPack)
