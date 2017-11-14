# Find gettext libraries
#
# LIBGETTEXT_FOUND
# LIBGETTEXT_LIBASPRINTF - libasprintf library
# LIBGETTEXT_LIBINTL - libintl library
# LIBGETTEXT_LIBGETTEXTLIB - libgettextlib library
# LIBGETTEXT_LIBGETTEXTPO - libgettextpo library
# LIBGETTEXT_LIBGETTEXTSRC - libgettextsrc library
# LIBGETTEXT_LIBRARIES - gettext libraries

IF(LIBGETTEXT_LIBRARIES)
  # already found  
  SET(LIBGETTEXT_FOUND TRUE)
ELSE()
    unset(__library)
    foreach(__library asprintf 
                      intl 
                      gettextlib 
                      gettextpo 
                      gettextsrc)
        string(TOUPPER ${__library} __var_name)
        
        find_library(LIBGETTEXT_LIB${__var_name} ${__library})
        if(NOT LIBGETTEXT_LIB${__var_name})
            file(GLOB LIBGETTEXT_LIB${__var_name}
                 /usr/lib/lib${__library}.so.?)
        endif()
        
        if(LIBGETTEXT_LIB${__var_name})
            list(APPEND 
                 LIBGETTEXT_LIBRARIES
                 ${LIBGETTEXT_LIB${__var_name}})
            set(LIBGETTEXT_LIB${__var_name}
                ${LIBGETTEXT_LIB${__var_name}}
                CACHE PATH "Gettext ${__library} library"
                FORCE)
        endif()
    endforeach()
    unset(__library)
    
    if(LIBGETTEXT_LIBRARIES)
        set(LIBGETTEXT_LIBRARIES ${LIBGETTEXT_LIBRARIES}
            CACHE PATH "Gettext libraries" FORCE)
        set(LIBGETTEXT_FOUND TRUE)
    else()
        set(LIBGETTEXT_FOUND FALSE)
        
        if( LIBGETTEXT_FIND_REQUIRED )
            message(SEND_ERROR 
                    "Gettext libraries was not found")
        endif()
        if(NOT LIBGETTEXT_FIND_QUIETLY)
            message(STATUS "Gettext was not found")
        endif()
    endif()
endif()

