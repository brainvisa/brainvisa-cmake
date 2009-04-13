find_package( DCMTK2 REQUIRED QUIET )
BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${DCMTK_LIBRARIES} )
get_filename_component( _dir "${DCMTK_dcmdata_LIBRARY}" PATH )
if( EXISTS "${_dir}/dicom.dic" )
  BRAINVISA_INSTALL( FILES "${_dir}/dicom.dic" DESTINATION lib COMPONENT system-runtime )
endif( EXISTS "${_dir}/dicom.dic" )
