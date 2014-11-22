#
# CMakeFbc - CMake module for FreeBASIC Language
#
# Copyright (C) 2014, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
#
# All rights reserved.
#
# See Copyright.txt for details.
#
# Modified from CMake 2.6.5 CMakeDetermineCCompiler.cmake
# See http://www.cmake.org/HTML/Copyright.html for details
#

# determine the compiler to use for FreeBASIC programs
# NOTE, a generator may set CMAKE_Fbc_COMPILER before
# loading this file to force a compiler.
# use environment variable FBC first if defined by user, next use
# the cmake variable CMAKE_GENERATOR_FBC which can be defined by a generator
# as a default compiler

IF(NOT CMAKE_Fbc_COMPILER)

  # prefer the environment variable FBC
  IF($ENV{FBC} MATCHES ".+")
    GET_FILENAME_COMPONENT(CMAKE_Fbc_COMPILER_INIT $ENV{FBC} PROGRAM PROGRAM_ARGS CMAKE_Fbc_FLAGS_ENV_INIT)
    IF(CMAKE_Fbc_FLAGS_ENV_INIT)
      SET(CMAKE_Fbc_COMPILER_ARG1 "${CMAKE_Fbc_FLAGS_ENV_INIT}" CACHE STRING "First argument to fbc compiler")
    ENDIF(CMAKE_Fbc_FLAGS_ENV_INIT)
    IF(EXISTS ${CMAKE_Fbc_COMPILER_INIT})
    ELSE(EXISTS ${CMAKE_Fbc_COMPILER_INIT})
      MESSAGE(FATAL_ERROR "Could not find compiler set in environment variable\n  $ENV{FBC}.")
    ENDIF(EXISTS ${CMAKE_Fbc_COMPILER_INIT})
  ENDIF($ENV{FBC} MATCHES ".+")

  # next try prefer the compiler specified by the generator
  IF(CMAKE_GENERATOR_FBC)
    IF(NOT CMAKE_Fbc_COMPILER_INIT)
      SET(CMAKE_Fbc_COMPILER_INIT ${CMAKE_GENERATOR_FBC})
    ENDIF(NOT CMAKE_Fbc_COMPILER_INIT)
  ENDIF(CMAKE_GENERATOR_FBC)

  # finally list compilers to try
  IF(CMAKE_Fbc_COMPILER_INIT)
    SET(CMAKE_Fbc_COMPILER_LIST ${CMAKE_Fbc_COMPILER_INIT})
  ELSE(CMAKE_Fbc_COMPILER_INIT)
    SET(CMAKE_Fbc_COMPILER_LIST fbc)
  ENDIF(CMAKE_Fbc_COMPILER_INIT)

  # Find the compiler.
  FIND_PROGRAM(CMAKE_Fbc_COMPILER NAMES ${CMAKE_Fbc_COMPILER_LIST} DOC "fbc compiler")
  IF(CMAKE_Fbc_COMPILER_INIT AND NOT CMAKE_Fbc_COMPILER)
    SET(CMAKE_Fbc_COMPILER "${CMAKE_Fbc_COMPILER_INIT}" CACHE FILEPATH "fbc compiler" FORCE)
  ENDIF(CMAKE_Fbc_COMPILER_INIT AND NOT CMAKE_Fbc_COMPILER)
ENDIF(NOT CMAKE_Fbc_COMPILER)
MARK_AS_ADVANCED(CMAKE_Fbc_COMPILER)
GET_FILENAME_COMPONENT(COMPILER_LOCATION "${CMAKE_Fbc_COMPILER}" PATH)

FIND_PROGRAM(CMAKE_AR NAMES ar PATHS ${COMPILER_LOCATION} )

FIND_PROGRAM(CMAKE_RANLIB NAMES ranlib)
IF(NOT CMAKE_RANLIB)
   SET(CMAKE_RANLIB : CACHE INTERNAL "noop for ranlib")
ENDIF(NOT CMAKE_RANLIB)
MARK_AS_ADVANCED(CMAKE_RANLIB)

SET(CMAKE_COMPILER_IS_FBC 1)
FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
  "Determining fbc compiler as ${CMAKE_Fbc_COMPILER}\n\n")


# configure variables set in this file for fast reload later on
IF(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in)
	CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in
               "${CMAKE_PLATFORM_ROOT_BIN}/CMakeFbcCompiler.cmake" IMMEDIATE)
ELSE(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in)
	CONFIGURE_FILE(${CMAKE_ROOT}/Modules/CMakeFbcCompiler.cmake.in
               "${CMAKE_PLATFORM_ROOT_BIN}/CMakeFbcCompiler.cmake" IMMEDIATE)
ENDIF(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeFbcCompiler.cmake.in)

MARK_AS_ADVANCED(CMAKE_AR)
SET(CMAKE_Fbc_COMPILER_ENV_VAR "FBC")

