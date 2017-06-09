# Try to find the minc library
# Once done this will define
#
# NETCDF_FOUND        - system has minc and it can be used
# NETCDF_INCLUDE_DIR  - directory where the header file can be found
# NETCDF_LIBRARIES    - the minc libraries
# NETCDF_NEEDS_MPI    - TRUE if NetCDF is built using MPI library
#
# Need to look for Netcdf and hdf5 as well

if(NETCDF_INCLUDE_DIR AND NETCDF_LIBRARY)
    SET( NETCDF_FOUND "YES" )
else()
    FIND_PATH( NETCDF_INCLUDE_DIR netcdf.h
        ${NETCDF_DIR}/include
        ${NETCDF_DIR}/include/netcdf-3
        ${NETCDF_DIR}/include/netcdf
        /usr/include 
        /usr/include/netcdf-3 
        /usr/include/netcdf
    )

    FIND_LIBRARY( NETCDF_LIBRARY netcdf
        ${NETCDF_DIR}/lib
        /usr/lib
    )



    IF( NETCDF_INCLUDE_DIR )
        # check dependance on mpi
        file(READ "${NETCDF_INCLUDE_DIR}/netcdf.h" _netcdf_h )
        string(REGEX MATCH "#include <mpi.h>" _mpi_inc ${_netcdf_h} )
        if( _mpi_inc )
            find_package( MPI )
            set( NETCDF_INCLUDE_DIR ${NETCDF_INCLUDE_DIR} ${MPI_C_INCLUDE_PATH}
                 CACHE PATH "NetCDF include path" FORCE )
            set( NETCDF_NEEDS_MPI "TRUE"
                 CACHE STRING "if NetCDF is built using MPI library" )
        endif()

        IF( NETCDF_LIBRARY )
            SET( NETCDF_FOUND "YES" )
        ENDIF( NETCDF_LIBRARY )
    ENDIF( NETCDF_INCLUDE_DIR )

    IF( NOT NETCDF_FOUND )
        SET( NETCDF_DIR "" CACHE PATH "Root of NETCDF source tree (optional)." )
        MARK_AS_ADVANCED( NETCDF_DIR )
    ENDIF( NOT NETCDF_FOUND )
endif()
