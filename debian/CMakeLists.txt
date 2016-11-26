# check for Debian packaging tools
FIND_PROGRAM(deb_exe debuild)
IF(NOT deb_exe)
  MESSAGE(STATUS "no Debian tools found (tried command debuild) -> no target deb")
  RETURN()
ENDIF()



# files to copy from root dir
SET(fsrc
  CMakeLists.txt
  *.md
  *.md.in
  )

# create rules file
CONFIGURE_FILE(rules.in rules @ONLY)

# create clean build folder and execute debuild
IF(${CMAKE_SOURCE_DIR} EQUAL ${CMAKE_BINARY_DIR})
  # folder for package building
  ADD_CUSTOM_TARGET(deb
    COMMAND ${CMAKE_COMMAND} -E debuild -d
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
ELSE()
  # folder for package building
  SET(tar ${CMAKE_CURRENT_BINARY_DIR}/deb)
  ADD_CUSTOM_TARGET(deb ${CMAKE_COMMAND} -E remove_directory ${tar}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${tar}
    COMMAND ${CMAKE_COMMAND} -E copy ${fsrc} ${tar}
    COMMAND ${CMAKE_COMMAND} -E copy_directory cmake ${tar}/cmake
    COMMAND ${CMAKE_COMMAND} -E copy_directory cmakefbc_deps ${tar}/cmakefbc_deps
    COMMAND ${CMAKE_COMMAND} -E copy_directory debian ${tar}/debian
    COMMAND ${CMAKE_COMMAND} -E copy_directory doxy ${tar}/doxy

    COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/rules ${tar}/debian/rules
    COMMAND ${CMAKE_COMMAND} -E chdir ${tar} debuild -d

    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
ENDIF()
