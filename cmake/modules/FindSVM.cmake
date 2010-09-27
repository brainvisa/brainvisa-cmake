# Try to find the svm library
# Once done this will define
#
# SVM_FOUND        - system has svm and it can be used
# SVM_INCLUDE_DIRS - directory where the header file can be found
# SVM_LIBRARIES    - the svm libraries

find_path( SVM_INCLUDE_DIRS "svm.h"
    ${SVM_DIR}/include
    /usr/local/include
    /usr/include
    PATH_SUFFIXES libsvm/include include/libsvm-2.0/libsvm include )

FIND_LIBRARY( SVM_LIBRARIES svm
  ${SVM_DIR}/lib
  /usr/local/lib
  /usr/lib
  PATH_SUFFIXES libsvm/lib lib
)

IF( SVM_INCLUDE_DIRS AND SVM_LIBRARIES )

  SET( SVM_FOUND TRUE )

ENDIF()

IF( NOT SVM_FOUND )
  SET( SVM_DIR "" CACHE PATH "Root of SVM source tree (optional)." )
  MARK_AS_ADVANCED( SVM_DIR )
ENDIF( NOT SVM_FOUND )
