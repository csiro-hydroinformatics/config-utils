macro(_eigen3_check_version)
  file(READ "${EIGEN3_INCLUDE_DIR}/Eigen/src/Core/util/Macros.h" _eigen3_version_header)

  string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen3_world_version_match "${_eigen3_version_header}")
  set(EIGEN3_WORLD_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen3_major_version_match "${_eigen3_version_header}")
  set(EIGEN3_MAJOR_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen3_minor_version_match "${_eigen3_version_header}")
  set(EIGEN3_MINOR_VERSION "${CMAKE_MATCH_1}")
  set(EIGEN3_VERSION ${EIGEN3_WORLD_VERSION}.${EIGEN3_MAJOR_VERSION}.${EIGEN3_MINOR_VERSION})
  set(EIGEN3_VERSION_OK TRUE)
endmacro(_eigen3_check_version)

if (EIGEN3_INCLUDE_DIR)

  _eigen3_check_version( )
  set(EIGEN3_FOUND ${EIGEN3_VERSION_OK})

else (EIGEN3_INCLUDE_DIR)

  find_path(EIGEN3_INCLUDE_DIR NAMES signature_of_eigen3_matrix_library
      PATHS
      ${PROJECT_SOURCE_DIR}/External
      ${CMAKE_INSTALL_PREFIX}/include
      ${KDE4_INCLUDE_DIR}
      PATH_SUFFIXES eigen3 eigen
    )

  if(EIGEN3_INCLUDE_DIR)
    _eigen3_check_version( )
  endif(EIGEN3_INCLUDE_DIR)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Eigen3 DEFAULT_MSG EIGEN3_INCLUDE_DIR EIGEN3_VERSION_OK)

  mark_as_advanced(EIGEN3_INCLUDE_DIR)

endif(EIGEN3_INCLUDE_DIR)


IF (NOT EIGEN3_INCLUDE_DIR)
FIND_PATH(EIGEN3_INCLUDE_DIR Eigen/Dense
HINTS /usr/include
/usr/local/include
PATH_SUFFIXES eigen3 eigen
)
ENDIF ()

IF (NOT EIGEN3_INCLUDE_DIR)
  FIND_PATH(EIGEN3_INCLUDE_DIR Eigen/Dense
  # Oh yes, yuck...
	HINTS /apps/eigen/3.2.9/include/eigen3  
)
ENDIF ()

IF (EIGEN3_INCLUDE_DIR)
    SET(EIGEN3_FOUND "YES")
ELSE (EIGEN3_INCLUDE_DIR)
  SET(EIGEN3_FOUND "NO")
ENDIF (EIGEN3_INCLUDE_DIR)


IF (EIGEN3_FOUND)
   IF (NOT EIGEN3_FIND_QUIETLY)
      MESSAGE(STATUS "Found EIGEN3 include dir: ${EIGEN3_INCLUDE_DIR}")
   ENDIF (NOT EIGEN3_FIND_QUIETLY)
ELSE (EIGEN3_FOUND)
   IF (EIGEN3_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find EIGEN3 library include: ${EIGEN3_INCLUDE_DIR}")
   ENDIF (EIGEN3_FIND_REQUIRED)
ENDIF (EIGEN3_FOUND)

MARK_AS_ADVANCED(
  EIGEN3_INCLUDE_DIR
  )



