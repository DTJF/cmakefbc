# check for Debian packaging tools
FIND_PROGRAM(deb_exe debuild)
IF(NOT deb_exe)
  MESSAGE(STATUS "no Debian tools found (tried command debuild) -> no target deb")
  RETURN()
ENDIF()


# in-source: create target deb for in-source debuild
IF(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  ADD_CUSTOM_TARGET(deb
    COMMAND rm -rf debian/cmakefbc
    COMMAND rm -rf debian/cmakefbc.*.*
    COMMAND rm -rf `find . -iname Makefile -print`
    COMMAND rm -rf `find . -name CMakeCache.txt -print`
    COMMAND rm -rf `find . -name CMakeFiles -print`
    COMMAND rm -rf `find . -name cmake_install.cmake -print`
    COMMAND rm -rf `find . -name install_manifest.txt -print`
    COMMAND rm -rf doxy/DoxyExtension doxy/HtmOut doxy/PdfOut doxy/fb-doc.lfn
    COMMAND rm -rf doxy/html/ doxy/latex/

    COMMAND ${deb_exe} ${DEBUILD_FLAGS}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    )
  RETURN()
ENDIF()

# out-of-source:
# create clean build folder
SET(tar deb_package)                # subfolder name for package building
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
ADD_CUSTOM_TARGET(deb rm -rf ${tar}
  COMMAND mkdir ${tar}
  COMMAND cd ${CMAKE_SOURCE_DIR} && cp -r ${src} ${CMAKE_CURRENT_BINARY_DIR}/${tar}

  COMMAND cd ${tar} && ${deb_exe} ${DEBUILD_FLAGS}
  )
