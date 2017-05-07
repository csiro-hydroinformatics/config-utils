include(FindPackageHandleStandardArgs)

set(ENV_XUNITPP_HOME $ENV{XUNITPP_HOME})
if (ENV_XUNITPP_HOME)
  string(REGEX REPLACE "\\\\" "/" ENV_XUNITPP_HOME ${ENV_XUNITPP_HOME})
endif ()

set(XUNITPP_PREFIX_PATH
  ${XUNITPP_HOME} ${ENV_XUNITPP_HOME}
)

find_path(XUNITPP_H_PATH NAMES xUnit++/xUnit++.h
            PATHS ${XUNITPP_PREFIX_PATH}
            PATH_SUFFIXES include xUnit++)

find_path(XUNITPP_BIN NAMES xUnit++.console
            PATHS ${XUNITPP_PREFIX_PATH}
            PATH_SUFFIXES bin "bin/xUnit++.console")

find_path(XUNITPP_BIN_DBG NAMES xUnit++.console.Debug
            PATHS ${XUNITPP_PREFIX_PATH}
            PATH_SUFFIXES bin "bin/xUnit++.console")

find_library(XUNITPP_LIB NAMES xUnit++
                PATHS ${XUNITPP_PREFIX_PATH}
                PATH_SUFFIXES lib "bin/xUnit++")

find_library(XUNITPP_LIB_DBG NAMES xUnit++.Debug
                PATHS ${XUNITPP_PREFIX_PATH}
                PATH_SUFFIXES lib "bin/xUnit++")

mark_as_advanced(XUNITPP_H_PATH XUNITPP_BIN_DBG XUNITPP_LIB XUNITPP_LIB_DBG)

if(NOT XUNITPP_BIN AND XUNITPP_BIN_DBG)
    set(XUNITPP_BIN ${XUNITPP_BIN_DBG})
endif()

if(NOT XUNITPP_LIB AND XUNITPP_LIB_DBG)
    set(XUNITPP_LIB ${XUNITPP_LIB_DBG})
endif()

find_package_handle_standard_args(xUnitpp REQUIRED_VARS XUNITPP_H_PATH XUNITPP_BIN XUNITPP_LIB)

if (XUNITPP_FOUND)
    set(XUNITPP_INCLUDE_DIR ${XUNITPP_H_PATH})
    set(XUNITPP_BINARY_DBG "${XUNITPP_BIN_DBG}/xUnit++.console.Debug")
    if(XUNITPP_BIN)
        set(XUNITPP_BINARY "${XUNITPP_BIN}/xUnit++.console")
    else()
        set(XUNITPP_BINARY ${XUNITPP_BINARY_DBG})
    endif()
    set(XUNITPP_LIBRARIES_DBG ${XUNITPP_LIB_DBG})
    if(XUNITPP_LIB)
        set(XUNITPP_LIBRARIES ${XUNITPP_LIB})
    else()
        set(XUNITPP_LIBRARIES ${XUNITPP_LIBRARIES_DBG})
    endif()
else()
    set(XUNITPP_INCLUDE_DIR)
    set(XUNITPP_BINARY)
    set(XUNITPP_BINARY_DBG)
    set(XUNITPP_LIBRARIES)
    set(XUNITPP_LIBRARIES_DBG)
endif()
