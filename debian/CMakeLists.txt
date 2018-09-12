IF(${CMAKE_SYSTEM_VERSION} VERSION_LESS 4)
  SET(osvers wheezy)
ELSE()
  SET(osvers jessie)
ENDIF()

# check for Debian packaging tools
FIND_PROGRAM(deb_exe debuild)
IF(NOT deb_exe)
  MSG_LOG("!! no target <deb> (missing command 'debuild')")
  RETURN()
ENDIF()
MSG_LOG(">> target <deb> OK (working command 'debuild', system ${osvers})")


# in-source: create target deb for in-source debuild
IF(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  ADD_CUSTOM_TARGET(deb
    COMMAND cp    compat.${osvers} compat
    COMMAND cp   control.${osvers} control
    COMMAND cat   control.packages >> control
    COMMAND cp changelog.${osvers} changelog
    COMMAND echo doxy/html > ${PROJ_NAME}-doc.docs
    COMMAND cd ${CMAKE_SOURCE_DIR} && ${deb_exe} ${DEBUILD_FLAGS}
    )
  RETURN()
ENDIF()

# out-of-source: create clean build subfolder
SET(src # files & dirs to copy from root dir
  CMakeLists.txt
  *.md
  cmake
  src
  debian
  doxy
  )
# create target deb for out-of-source debuild
SET(bdir ${CMAKE_CURRENT_BINARY_DIR}/${PROJ_NAME})
SET(debdir ${bdir}/debian)
ADD_CUSTOM_TARGET(deb rm -rf ${PROJ_NAME} ${CMAKE_SOURCE_DIR}/doxy/fbdoc.lfn
  COMMAND mkdir ${PROJ_NAME}
  COMMAND cd ${CMAKE_SOURCE_DIR} && cp -r ${src} ${bdir}
  COMMAND cp    ${CMAKE_CURRENT_SOURCE_DIR}/compat.${osvers} ${debdir}/compat
  COMMAND cp   ${CMAKE_CURRENT_SOURCE_DIR}/control.${osvers} ${debdir}/control
  COMMAND cat  ${CMAKE_CURRENT_SOURCE_DIR}/control.packages >> ${debdir}/control
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/changelog.${osvers} ${debdir}/changelog
  COMMAND echo ../../doxy/html > ${debdir}/${PROJ_NAME}-doc.docs
  COMMAND cd ${bdir} && ${deb_exe} ${DEBUILD_FLAGS}
  )
