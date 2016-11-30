# check for Debian packaging tools
FIND_PROGRAM(deb_exe debuild)
IF(NOT deb_exe)
  MESSAGE(STATUS "no Debian tools found (tried command debuild) -> no target deb")
  RETURN()
ENDIF()


# in-source: create target deb for in-source debuild
IF(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  ADD_CUSTOM_TARGET(deb
    COMMAND cd ${CMAKE_SOURCE_DIR} && ${deb_exe} ${DEBUILD_FLAGS}
    )
  RETURN()
ENDIF()

# out-of-source:
# create clean build subfolder
SET(src                             # files&dirs to copy from root dir
  CMakeLists.txt
  *.md
  *.md.in
  cmake
  cmakefbc_deps
  debian
  doxy
  )
# create target deb for out-of-source debuild
ADD_CUSTOM_TARGET(deb rm -rf ${PROJ_NAME} ${CMAKE_SOURCE_DIR}/doxy/fb-doc.lfn
  COMMAND mkdir ${PROJ_NAME}
  COMMAND cd ${CMAKE_SOURCE_DIR} && cp -r ${src} ${CMAKE_CURRENT_BINARY_DIR}/${PROJ_NAME}

  COMMAND cd ${PROJ_NAME} && ${deb_exe} ${DEBUILD_FLAGS}
  )
