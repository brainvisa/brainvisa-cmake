find_package( Qt5Widgets )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5core RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN DEPENDS libqt5gui RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN DEPENDS libqt5widgets RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN DEPENDS libqt5opengl RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5network RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5sql RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5multimedia RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5multimediawidgets RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5webkit RUN ">= ${QT_VERSION}" )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libqt5webkitwidgets RUN )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5svg RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5xml RUN ">= ${QT_VERSION}" )
  BRAINVISA_DEPENDENCY( RUN RECOMMENDS libqt5xmlpatterns RUN ">= ${QT_VERSION}" )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libqt5quick RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libqt5positioning RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libqt5sensors RUN )
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER "18.0" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libqt5webchannel RUN )
  endif()
  # TODO...
#   libqt5clucene5:amd64
#   libqt5concurrent5:amd64
#   libqt5dbus5:amd64
#   libqt5designer5:amd64
#   libqt5designercomponents5:amd64
#   libqt5feedback5:amd64
#   libqt5help5:amd64
#   libqt5multimediaquick-p5:amd64
#   libqt5organizer5:amd64
#   libqt5qml-graphicaleffects
#   libqt5quickparticles5:amd64
#   libqt5quickwidgets5:amd64
#   libqt5script5:amd64
#   libqt5waylandclient5:amd64
#   libqt5waylandclient5-dev:amd64
#   libqt5x11extras5:amd64
#   libqt5x11extras5-dev:amd64

endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(Qt5Widgets_FOUND)
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt5-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(Qt5Widgets_FOUND)
    BRAINVISA_DEPENDENCY( DEV DEPENDS libqt5core DEV )
    BRAINVISA_DEPENDENCY( DEV DEPENDS libqt5gui DEV )
    BRAINVISA_DEPENDENCY( DEV DEPENDS libqt5widgets DEV )
    BRAINVISA_DEPENDENCY( DEV DEPENDS libqt5opengl DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5network DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5sql DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5multimedia DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5multimediawidgets DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5webkit DEV )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV RECOMMENDS libqt5webkitwidgets DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5svg DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5xml DEV )
    BRAINVISA_DEPENDENCY( DEV RECOMMENDS libqt5xmlpatterns DEV )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV RECOMMENDS libqt5quick DEV )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV RECOMMENDS libqt5positioning DEV )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV RECOMMENDS libqt5sensors DEV )
    if( LSB_DISTRIB STREQUAL "ubuntu"
        AND LSB_DISTRIB_RELEASE VERSION_GREATER "18.0" )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV RECOMMENDS libqt5webchannel DEV )
    endif()

    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()
