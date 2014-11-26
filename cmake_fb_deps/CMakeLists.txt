CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

# declare the project name and the language (compiler) to use
PROJECT(cmake_fb_deps Fbc)


#message(STATUS "CMAKE_SIZEOF_VOID_P: " ${CMAKE_SIZEOF_VOID_P})

# declare the target name and the source file[s]
ADD_EXECUTABLE(cmake_fb_deps cmake_fb_deps.bas)

# define the compiler options (must have -m for executables)
SET_TARGET_PROPERTIES(cmake_fb_deps PROPERTIES
  COMPILE_FLAGS "-e -w all -m cmake_fb_deps"
  )

# declare installation rules
GET_FILENAME_COMPONENT(dir ${CMAKE_COMMAND} PATH)
INSTALL(
  TARGETS cmake_fb_deps
  RUNTIME DESTINATION ${dir}
  )
