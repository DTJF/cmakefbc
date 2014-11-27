CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the language (compiler) to use
PROJECT(cmake_fb_deps Fbc C)

# declare the target name and the source file[s]
ADD_EXECUTABLE(cmake_fb_deps cmake_fb_deps.bas)

# define the compiler options (should have -m for executables)
SET_TARGET_PROPERTIES(cmake_fb_deps PROPERTIES
  COMPILE_FLAGS "-e -w all -m cmake_fb_deps"
  )


# you may want to install in the directory of the CMake executable
#GET_FILENAME_COMPONENT(dir ${CMAKE_COMMAND} PATH)

# or use the standard
SET(dir bin)

# declare installation rule
INSTALL(
  TARGETS cmake_fb_deps
  RUNTIME DESTINATION ${dir}
  )
