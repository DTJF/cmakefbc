#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
#
# All rights reserved.
#
# See Copyright.txt for details.
#
# Modified from CMake 2.6.5 CMakeTestCCompiler.cmake
# See http://www.cmake.org/HTML/Copyright.html for details
#

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that the selected fbc compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.

IF(NOT CMAKE_Fbc_COMPILER_WORKS)
  MESSAGE(STATUS "Check for working fbc compiler: ${CMAKE_Fbc_COMPILER}")
  FILE(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testFbcCompiler.bas
    "END __FB_ARGC__ - 1\n")
	TRY_COMPILE(CMAKE_Fbc_COMPILER_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testFbcCompiler.bas
    COMPILE_DEFINITIONS "-m testFbcCompiler"
	  OUTPUT_VARIABLE OUTPUT)
  SET(FBC_TEST_WAS_RUN 1)
ENDIF(NOT CMAKE_Fbc_COMPILER_WORKS)

IF(CMAKE_Fbc_COMPILER_WORKS)
  IF(FBC_TEST_WAS_RUN)
    MESSAGE(STATUS "Check for working fbc compiler: ${CMAKE_Fbc_COMPILER} -- works")
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the fbc compiler works passed with "
      "the following output:\n${OUTPUT}\n\n")
  ENDIF(FBC_TEST_WAS_RUN)
  SET(CMAKE_Fbc_COMPILER_WORKS 1 CACHE INTERNAL "")
  # re-configure this file CMakeFbcCompiler.cmake so that it gets
  # the value for CMAKE_SIZEOF_VOID_P
  # configure variables set in this file for fast reload later on
  IF(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in)
  	CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in
  	  ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeFbcCompiler.cmake IMMEDIATE)
  ELSE(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in)
  	CONFIGURE_FILE(${CMAKE_ROOT}/Modules/CMakeFbcCompiler.cmake.in
	    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeFbcCompiler.cmake IMMEDIATE)
  ENDIF(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in)
ELSE(CMAKE_Fbc_COMPILER_WORKS)
  MESSAGE(STATUS "Check for working fbc compiler: ${CMAKE_Fbc_COMPILER} -- broken")
  MESSAGE(STATUS "To force a specific fbc compiler set the FBC environment variable")
  MESSAGE(STATUS "    ie - export FBC=\"/usr/local/bin/fbc\"")
  #message(STATUS "If the fbc path is not set please use the D_PATH variable")
  #message(STATUS "    ie - export D_PATH=\"/opt/dmd\"")
  FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the fbc compiler works failed with "
    "the following output:\n${OUTPUT}\n\n")
  MESSAGE(FATAL_ERROR
    "The fbc compiler \"${CMAKE_Fbc_COMPILER}\" is not able to compile a simple test program.\n"
    "It fails with the following output:\n---8<---\n${OUTPUT}\n--->8---\n"
    "CMake will not be able to correctly generate this project.")
ENDIF(CMAKE_Fbc_COMPILER_WORKS)
