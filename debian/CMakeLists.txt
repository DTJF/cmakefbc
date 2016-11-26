# check for Debian packaging tools
FIND_PROGRAM(deb_exe debuild)
IF(NOT deb_exe)
  MESSAGE(STATUS "no Debian tools found (tried command debuild) -> no target deb")
  RETURN()
ENDIF()

IF(DEBUILD_FLAGS)                          # append flags (if any)
  SET(deb_exe "${deb_exe} ${DEBUILD_FLAGS}")
ENDIF()

CONFIGURE_FILE(rules.in rules @ONLY)       # create rules file

# create target deb for in-source debuild
IF(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  ADD_CUSTOM_TARGET(deb ${deb_exe} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
ELSE()
  # out-of-source: create clean build folder
  SET(tar ${CMAKE_CURRENT_BINARY_DIR}/deb) # subfolder name for package building
  SET(fsrc                                 # files to copy from root dir
    CMakeLists.txt
    *.md
    *.md.in
    )
  SET(dsrc                                 # folders to copy from root dir
    cmake
    cmakefbc_deps
    debian
    doxy
    )
  # create target deb for out-of-source debuild
  ADD_CUSTOM_TARGET(deb ${CMAKE_COMMAND} -E remove_directory ${tar}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${tar}
    COMMAND ${CMAKE_COMMAND} -E chdir ${tar} ${CMAKE_COMMAND} -E make_directory ${dsrc}
    COMMAND ${CMAKE_COMMAND} -E copy ${dsrc} ${fsrc} ${tar}

    COMMAND ${CMAKE_COMMAND} -E rename ${CMAKE_CURRENT_BINARY_DIR}/rules ${tar}/debian/rules
    COMMAND ${CMAKE_COMMAND} -E chdir ${tar} ${deb_exe}

    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
ENDIF()
