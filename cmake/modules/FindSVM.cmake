# Try to find the svm library
# Once done this will define
#
# SVM_FOUND        - system has svm and it can be used
# SVM_INCLUDE_DIRS - directory where the header file can be found
# SVM_LIBRARIES    - the svm libraries


FIND_PATH( SVM_INCLUDE_DIR svm.h
  ${SVM_DIR}/include
  /i2bm/local/svm/include
  /usr/local/include
  /usr/include 
)


FIND_LIBRARY( SVM_LIBRARY svm
  ${SVM_DIR}/lib
  /i2bm/local/svm/lib
  /usr/local/lib
  /usr/lib
)

IF( SVM_INCLUDE_DIR )
IF( SVM_LIBRARY )

  SET( SVM_FOUND "YES" )

  SET(SVM_INCLUDE_DIRS
     ${SVM_INCLUDE_DIR}
  )

  SET(SVM_LIBRARIES
    ${SVM_LIBRARY}
  )

ENDIF( SVM_LIBRARY )
ENDIF( SVM_INCLUDE_DIR )

IF( NOT SVM_FOUND )
  SET( SVM_DIR "" CACHE PATH "Root of SVM source tree (optional)." )
  MARK_AS_ADVANCED( SVM_DIR )
ENDIF( NOT SVM_FOUND )
