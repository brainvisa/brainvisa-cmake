# Try to find the svm library
# Once done this will define
#
# SVM_FOUND        - system has svm and it can be used
# SVM_INCLUDE_DIRS - directory where the header file can be found
# SVM_LIBRARIES    - the svm libraries

if(SVM_INCLUDE_DIRS AND SVM_LIBRARIES)
  set(SVM_FOUND TRUE)
else()
  find_path( SVM_INCLUDE_DIRS "svm.h"
      PATHS ${SVM_DIR}/include
      /usr/local/include
      /usr/include
      PATH_SUFFIXES libsvm/include include/libsvm-2.0/libsvm include )
  
  FIND_LIBRARY( SVM_LIBRARIES svm
    PATHS ${SVM_DIR}/lib
    /usr/local/lib
    /usr/lib
    PATH_SUFFIXES libsvm/lib lib
  )
  
  if( SVM_INCLUDE_DIRS AND SVM_LIBRARIES )
    set( SVM_FOUND TRUE )
  else()
    IF( NOT SVM_FOUND )
      SET( SVM_DIR "" CACHE PATH "Root of SVM source tree (optional)." )
      MARK_AS_ADVANCED( SVM_DIR )
    ENDIF( NOT SVM_FOUND )
    if( SVM_FIND_REQUIRED )
        message( SEND_ERROR "SVM library was not found." )
    else()
      if(NOT SVM_FIND_QUIETLY)
        message(STATUS "SVM library was not found.")
      endif()
    endif()

  endif()
  
endif()