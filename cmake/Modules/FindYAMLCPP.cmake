## per202 2016-07
# Adapted from https://raw.githubusercontent.com/minium/bitcoin-api-cpp/master/cmake/FindJSONCPP.cmake

# -*- cmake -*-
# - Find YAMLCpp
# Find the YAMLCpp includes and library
# This module defines
#  YAMLCPP_INCLUDE_DIRS, where to find json.h, etc.
#  YAMLCPP_LIBRARIES, the libraries needed to use yaml-cpp.
#  YAMLCPP_FOUND, If false, do not try to use yaml-cpp.
#  also defined, but not for general use are
#  YAMLCPP_LIBRARIES, where to find the yaml-cpp library.

FIND_PATH(YAMLCPP_INCLUDE_DIRS yaml-cpp/yaml.h
HINTS /usr/include
/usr/local/include
#PATH_SUFFIXES yaml-cpp
)

IF (NOT YAMLCPP_INCLUDE_DIRS)
	FIND_PATH(YAMLCPP_INCLUDE_DIRS yaml-cpp/yaml.h
	HINTS ${CMAKE_CURRENT_LIST_DIR}/../Externals/yaml-cpp/include
	#PATH_SUFFIXES yaml-cpp 
)
ENDIF ()


FIND_LIBRARY(YAMLCPP_LIBRARIES NAMES yaml-cpp HINTS /usr/lib /usr/local/lib )

IF (YAMLCPP_LIBRARIES AND YAMLCPP_INCLUDE_DIRS)
    SET(YAMLCPP_LIBRARIES ${YAMLCPP_LIBRARIES})
    SET(YAMLCPP_FOUND "YES")
ELSE (YAMLCPP_LIBRARIES AND YAMLCPP_INCLUDE_DIRS)
  SET(YAMLCPP_FOUND "NO")
ENDIF (YAMLCPP_LIBRARIES AND YAMLCPP_INCLUDE_DIRS)


IF (YAMLCPP_FOUND)
   IF (NOT YAMLCPP_FIND_QUIETLY)
      MESSAGE(STATUS "Found YAMLCpp: ${YAMLCPP_LIBRARIES}")
   ENDIF (NOT YAMLCPP_FIND_QUIETLY)
ELSE (YAMLCPP_FOUND)
   IF (YAMLCPP_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find YAMLCPP library include: ${YAMLCPP_INCLUDE_DIRS}, lib: ${YAMLCPP_LIBRARIES}")
   ENDIF (YAMLCPP_FIND_REQUIRED)
ENDIF (YAMLCPP_FOUND)

MARK_AS_ADVANCED(
  YAMLCPP_LIBRARIES
  YAMLCPP_INCLUDE_DIRS
  )



