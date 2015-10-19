# This module prepares a standard doc build by the Doxygen generator,
# supported by the fb-doc tool (http://github.com/DTJF/fb-doc)
#
# It defines the following ...
#
# Copyright (C) 2014-2015, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net
# License GPLv3 (see http://www.gnu.org/licenses/gpl-3.0.html)
#
# See ReadMe.md for details.

# check for parser macro
IF(NOT COMMAND CMAKE_PARSE_ARGUMENTS)
  INCLUDE(CMakeParseArguments)
ENDIF()

FUNCTION(FB_DOCUMENTATION)
  SET(logfile ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log)
  SET(errfile ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log)

  # check for fb-doc tool
  INCLUDE(FindFb-Doc)
  IF(NOT FbDoc_WORKS)
    SET(msg "fb-doc tool not found ==> doc targets not available!")
    MESSAGE(STATUS ${msg})
    FILE(APPEND ${errfile} "${msg}\n\n")
    RETURN()
  ENDIF()

  # check for Doxygen
  INCLUDE(FindDoxygen)
  IF(NOT DOXYGEN_FOUND)
    SET(msg "Doxygen not found ==> doc targets not available!")
    MESSAGE(STATUS ${msg})
    FILE(APPEND ${errfile} "${msg}\n\n")
    RETURN()
  ENDIF()

  CMAKE_PARSE_ARGUMENTS(ARG "NO_LFN;NO_PROJDATA;NO_HTM;NO_PDF;NO_WWW;NO_SELFDEP" "DOXYFILE;MIRROR_CMD" "BAS_SRC;DEPENDS;DOXYCONF" ${ARGN})

  IF(ARG_NO_HTM AND ARG_NO_PDF AND ARG_NO_WWW)
    SET(msg "FB_DOCUMENTATION error: all output blocked ==> doc targets not available!")
    MESSAGE(STATUS ${msg})
    FILE(APPEND ${errfile} "${msg}\n\n")
    RETURN()
  ENDIF()
  IF(NOT ARG_NO_SELFDEP) #             add doc script to dependency list
    LIST(APPEND ARG_DEPENDS CMakeLists.txt)
  ENDIF()

  SET(doxyext ${CMAKE_CURRENT_BINARY_DIR}/DoxyExtension) # ext file name
  IF(NOT ARG_DOXYFILE) #                      default configuration file
    SET(ARG_DOXYFILE "${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile")
  ENDIF()
  IF(NOT ARG_NO_PROJDATA) #      transfer project data, generate aliases
    SET(projconf
"
PROJECT_NAME  =${PROJ_NAME}
PROJECT_BRIEF =\"${PROJ_DESC}\"
PROJECT_NUMBER=${PROJ_VERS}
ALIASES += \"Mail=${PROJ_MAIL}\" \\
           \"Proj=*${PROJ_NAME}*\" \\
           \"Year=${PROJ_YEAR}\" \\
           \"Webs=${PROJ_WEBS}\"
"
      )
  ENDIF()
  FILE(WRITE ${doxyext} #                           write extension file
"
@INCLUDE = ${ARG_DOXYFILE}
OUTPUT_DIRECTORY=${CMAKE_CURRENT_BINARY_DIR}
FILTER_PATTERNS        = *.bas=${FbDoc_EXECUTABLE} \\
                          *.bi=${FbDoc_EXECUTABLE}
FILTER_SOURCE_FILES    = YES
FILTER_SOURCE_PATTERNS = *.bas=${FbDoc_EXECUTABLE} \\
                          *.bi=${FbDoc_EXECUTABLE}
"
    ${projconf}
    "\n"
    ${ARG_DOXYCONF}
    )
  ADD_CUSTOM_TARGET(doc) #                           generate target doc

  IF(NOT ARG_NO_LFN) #                          generate file fb-doc.lfn
    #SET(msg "FB_DOCUMENTATION: generate list of function names")
    #FILE(APPEND ${logfile} "${msg}\n\n")
    SET(lfn ${CMAKE_CURRENT_SOURCE_DIR}/fb-doc.lfn)
    LIST(APPEND ARG_DEPENDS ${lfn})
    ADD_CUSTOM_COMMAND(OUTPUT ${lfn}
      COMMAND ${FbDoc_EXECUTABLE} -l ${doxyext}
      DEPENDS ${ARG_BAS_SRC}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      )
  ENDIF()
  SET(targets "doc")
  SET(nout
"
@INCLUDE = ${doxyext}
GENERATE_DOCBOOK = NO
GENERATE_XML     = NO
GENERATE_MAN     = NO
GENERATE_RTF     = NO
"
      )
  IF(NOT ARG_NO_WWW) # generate target doc_www (mirror local tree to server)
    IF(NOT ARG_MIRROR_CMD)
      SET(ARG_MIRROR_CMD "MirrorDoc.sh '--reverse --delete --verbose ${CMAKE_CURRENT_BINARY_DIR}/html public_html/Projekte/${PROJ_NAME}/doc/html'")
    ENDIF()
    SET(wwwfile ${CMAKE_CURRENT_BINARY_DIR}/DocWWW.time)
    ADD_CUSTOM_COMMAND(OUTPUT ${wwwfile}
      COMMAND ${ARG_MIRROR_CMD}
      )
    ADD_CUSTOM_TARGET(doc_www DEPENDS ${wwwfile})
    ADD_DEPENDENCIES(doc_www DEPENDS doc_htm)
    SET(ARG_NO_HTM)
    LIST(APPEND targets "doc_www")
  ENDIF()
  IF(NOT ARG_NO_HTM) #                           generate target doc_htm
    SET(htmconf ${CMAKE_CURRENT_BINARY_DIR}/HtmOut)
    FILE(WRITE ${htmconf}
      ${nout}
"
GENERATE_LATEX   = NO
GENERATE_HTML    = YES
HTML_OUTPUT      = html
"
      )
    SET(htmfile ${CMAKE_CURRENT_BINARY_DIR}/html/index.html)
    ADD_CUSTOM_COMMAND(OUTPUT ${htmfile}
      COMMAND ${DOXYGEN_EXECUTABLE} ${htmconf}
      COMMAND ${FbDoc_EXECUTABLE} -s ${htmconf}
      DEPENDS ${ARG_BAS_SRC} ${ARG_DEPENDS}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      VERBATIM
      )
    ADD_CUSTOM_TARGET(doc_htm DEPENDS ${htmfile})
    ADD_DEPENDENCIES(doc DEPENDS doc_htm)
    LIST(APPEND targets "doc_htm")
  ENDIF()
  IF(NOT ARG_NO_PDF) #                           generate target doc_pdf
    SET(pdfconf ${CMAKE_CURRENT_BINARY_DIR}/PdfOut)
    FILE(WRITE ${pdfconf}
      ${nout}
"
GENERATE_LATEX   = YES
GENERATE_HTML    = NO
LATEX_OUTPUT     = latex
"
      )
    SET(pdffile ${CMAKE_CURRENT_BINARY_DIR}/${PROJ_NAME}.pdf)
    SET(reffile ${CMAKE_CURRENT_BINARY_DIR}/latex/refman.pdf)
    ADD_CUSTOM_COMMAND(OUTPUT ${pdffile}
      COMMAND ${DOXYGEN_EXECUTABLE} ${pdfconf}
      COMMAND ${FbDoc_EXECUTABLE} -s ${pdfconf}
      COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR}/latex make
      COMMAND ${CMAKE_COMMAND} -E rename ${reffile} ${pdffile}
      DEPENDS ${ARG_BAS_SRC} ${ARG_DEPENDS}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      VERBATIM
      )
    ADD_CUSTOM_TARGET(doc_pdf DEPENDS ${pdffile})
    ADD_DEPENDENCIES(doc DEPENDS doc_pdf)
    LIST(APPEND targets "doc_pdf")
  ENDIF()
  #FILE(APPEND ${logfile} "FB_DOCUMENTATION configured (targets: ${targets})\n\n")
ENDFUNCTION(FB_DOCUMENTATION)

