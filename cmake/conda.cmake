# This file is included when CONDA variable is set. It must point to the directory of a
# Conda installation properly configured to be used by brainvisa-cmake.
# It defines variables that are tricks to allow compilation in this environment.

message("Using Conda environment located in ${CONDA}")
set(DESIRED_QT_VERSION 5)
set(DESIRED_SIP_VERSION 6)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated")
# The following line makes the linker use RUNPATH instead of RPATH.
# The latter does not takes precedence over LD_LIBRARY_PATH
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--enable-new-dtags" CACHE INTERNAL "")
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-new-dtags" CACHE INTERNAL "")
set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--enable-new-dtags" CACHE INTERNAL "")
set(CMAKE_C_FLAGS "-I$CASA/include")
set(OpenGL_GL_PREFERENCE "GLVND" CACHE STRING "")
set(OPENGL_EGL_INCLUDE_DIR "/usr/include" CACHE PATH "")
set(OPENGL_GLX_INCLUDE_DIR "/usr/include" CACHE PATH "")
set(OPENGL_INCLUDE_DIR "/usr/include" CACHE PATH "")
set(OPENGL_egl_LIBRARY "/usr/lib/x86_64-linux-gnu/libEGL.so" CACHE PATH "")
set(OPENGL_gl_LIBRARY "/usr/lib/x86_64-linux-gnu/libGL.so" CACHE PATH "")
set(OPENGL_glu_LIBRARY "/usr/lib/x86_64-linux-gnu/libGLU.so" CACHE PATH "")
set(OPENGL_glx_LIBRARY "/usr/lib/x86_64-linux-gnu/libGLX.so" CACHE PATH "")
set(OPENGL_opengl_LIBRARY "/usr/lib/x86_64-linux-gnu/libOpenGL.so" CACHE PATH "")
set(OPENGL_FIX_LIBRARY_DIRECTORIES "${CONDA}/lib" "/lib/x86_64-linux-gnu" CACHE INTERNAL "")
set(OPENGL_FIX_LIBRARIES 
    "X11" "GL" "GLdispatch" "GLX" 
    "/usr/lib/x86_64-linux-gnu/librt.so.1"
    "/usr/lib/x86_64-linux-gnu/libresolv.so.2"  CACHE INTERNAL "")
execute_process(COMMAND python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE python_version
)
set(PYTHON_INSTALL_DIRECTORY lib/python${python_version}/site-packages)
set(BUILD_VIDAIO NO)