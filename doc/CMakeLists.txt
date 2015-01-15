# Note: this script needs an fb-doc version (0.4), which may not be published yet.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.3)

SET(src
  "Doxyfile"
  "../_Licence.md"
  "../_Install.md"
  "../_Usage.md"
  "../cmake_fb_deps/_Tool.md"
  "../_ChangeLog.md"
  )
SET(lfn ${CMAKE_CURRENT_SOURCE_DIR}/fb-doc.lfn)
SET(tar ${CMAKE_CURRENT_BINARY_DIR}/html)
SET(res ${tar}/index.html)

ADD_CUSTOM_COMMAND(OUTPUT lfn
  COMMAND fbdoc -l
  DEPENDS ../cmake_fb_deps/cmake_fb_deps.bas
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  )

#ADD_CUSTOM_COMMAND(OUTPUT res
  #COMMAND doxygen
  #COMMAND fbdoc -s
  #COMMAND ${CMAKE_COMMAND} -E remove_directory ${tar}
  #COMMAND ${CMAKE_COMMAND} -E rename html ${tar}
  #DEPENDS lfn ${src}
  #WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  #)

IF(UNIX)
SET(com) "( cat Doxyfile ; echo \"OUTPUT_DIRECTORY=${tar}\" ) | doxygen -"
ELSE()
SET(com) "( type Doxyfile & echo \"OUTPUT_DIRECTORY=${tar}\" ) | doxygen -"
ENDIF()
ADD_CUSTOM_COMMAND(OUTPUT res
  COMMAND ${com}
  COMMAND fbdoc -s
  DEPENDS lfn ${src}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  )

# declare the target name and the source file[s]
ADD_CUSTOM_TARGET(doc DEPENDS lfn res)
SET_TARGET_PROPERTIES(doc PROPERTIES EXCLUDE_FROM_ALL 1)

# declare installation rule
INSTALL(
  DIRECTORY ${tar}
  DESTINATION doc/${CMAKE_PROJECT_NAME}
  )
