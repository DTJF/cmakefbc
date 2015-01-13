#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
#
# All rights reserved.
#
# See ReadMe.md for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

# Uncomment the next two lines to perform a standard build.
#LIST(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")
#ADD_SUBDIRECTORY(cmake_fb_deps)

PROJECT(cmakefbc NONE)

INSTALL(DIRECTORY cmake/Modules DESTINATION ${CMAKE_ROOT})
