## per202 2016-07
# Adapted from https://raw.githubusercontent.com/minium/bitcoin-api-cpp/master/cmake/FindJSONCPP.cmake

# -*- cmake -*-
# - Find JSONCpp
# Find the JSONCpp includes and library
# This module defines
#  JSONCPP_INCLUDE_DIRS, where to find json.h, etc.
#  JSONCPP_LIBRARIES, the libraries needed to use jsoncpp.
#  JSONCPP_FOUND, If false, do not try to use jsoncpp.
#  also defined, but not for general use are
#  JSONCPP_LIBRARIES, where to find the jsoncpp library.


FIND_PATH(JSONCPP_INCLUDE_DIRS json/json.h
HINTS /usr/include
/usr/local/include
PATH_SUFFIXES jsoncpp
)

IF (NOT JSONCPP_INCLUDE_DIRS)
	FIND_PATH(JSONCPP_INCLUDE_DIRS json/json.h
	HINTS ${CMAKE_CURRENT_LIST_DIR}/../Externals/jsoncpp/include)
	#message("PROJECT_SOURCE_DIR = ${PROJECT_SOURCE_DIR}")
ENDIF ()

IF (NOT JSONCPP_INCLUDE_DIRS)
FIND_PATH(JSONCPP_INCLUDE_DIRS json/json.h
PATHS 
../Externals/jsoncpp/include
../../../Externals/jsoncpp/include
)
ENDIF (NOT JSONCPP_INCLUDE_DIRS)


#message("CMAKE_SYSTEM_LIBRARY_PATH=${CMAKE_SYSTEM_LIBRARY_PATH}")
#message("CMAKE_LIBRARY_PATH=${CMAKE_LIBRARY_PATH}")


FIND_LIBRARY(JSONCPP_LIBRARIES NAMES jsoncpp 
HINTS /usr/lib /usr/local/lib ~/lib
)

IF (JSONCPP_LIBRARIES AND JSONCPP_INCLUDE_DIRS)
    SET(JSONCPP_LIBRARIES ${JSONCPP_LIBRARIES})
    SET(JSONCPP_FOUND "YES")
ELSE (JSONCPP_LIBRARIES AND JSONCPP_INCLUDE_DIRS)
  SET(JSONCPP_FOUND "NO")
ENDIF (JSONCPP_LIBRARIES AND JSONCPP_INCLUDE_DIRS)


IF (JSONCPP_FOUND)
   IF (NOT JSONCPP_FIND_QUIETLY)
      MESSAGE(STATUS "Found JSONCpp: ${JSONCPP_LIBRARIES}")
   ENDIF (NOT JSONCPP_FIND_QUIETLY)
ELSE (JSONCPP_FOUND)
   IF (JSONCPP_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find JSONCPP library include: ${JSONCPP_INCLUDE_DIRS}, lib: ${JSONCPP_LIBRARIES}")
   ENDIF (JSONCPP_FIND_REQUIRED)
ENDIF (JSONCPP_FOUND)

MARK_AS_ADVANCED(
  JSONCPP_LIBRARIES
  JSONCPP_INCLUDE_DIRS
  )

