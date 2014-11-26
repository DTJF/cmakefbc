CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the language (compiler) to use
PROJECT(fb_depends Fbc)

# declare the target name and the source file[s]
ADD_EXECUTABLE(fb_depends fb_depends.bas)

# define the compiler options (must have -m for executables)
SET_TARGET_PROPERTIES(fb_depends PROPERTIES
  COMPILE_FLAGS "-e -w all -m fb_depends"
  )

# declare installation rules
GET_FILENAME_COMPONENT(DIR ${CMAKE_COMMAND} REALPATH)
INSTALL(
  TARGETS fb_depends
  RUNTIME DESTINATION ${DIR}
  )
