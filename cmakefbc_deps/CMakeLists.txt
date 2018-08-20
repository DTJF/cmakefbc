CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

# declare the project name and the language (compiler) to use
PROJECT(cmakefbc_deps Fbc)

# declare the target name and the source file[s]
ADD_EXECUTABLE(cmakefbc_deps cmakefbc_deps.bas)
SET(CMAKE_EXE_LINKER_FLAGS "-Wl -z,relro") # must be global

# define the compiler options (should have -m for executables)
SET_TARGET_PROPERTIES(cmakefbc_deps PROPERTIES
  COMPILE_FLAGS "-e -w all -m cmakefbc_deps"
  #LINK_FLAGS "-Wl -z,relro"
  )


# You may want to install in the standard directory
SET(dir bin)
# or use the CMake executable path
#GET_FILENAME_COMPONENT(dir ${CMAKE_COMMAND} PATH)

# declare installation rule
INSTALL(
  TARGETS cmakefbc_deps
  RUNTIME DESTINATION ${dir}
  )
