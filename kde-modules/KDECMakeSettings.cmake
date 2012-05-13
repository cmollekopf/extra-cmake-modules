# The following variables can be set to TRUE to skip parts of the functionality:
#  KDE_SKIP_RPATH_SETTINGS
#  KDE_SKIP_BUILD_SETTINGS
#  KDE_SKIP_TEST_SETTINGS


################# RPATH handling ##################################

if(NOT KDE_SKIP_RPATH_SETTINGS)

   if(NOT LIB_INSTALL_DIR)
      message(FATAL_ERROR "LIB_INSTALL_DIR not set. This is necessary for using the RPATH settings.")
   endif()

   set(_abs_LIB_INSTALL_DIR "${LIB_INSTALL_DIR}")
   if (NOT IS_ABSOLUTE "${_abs_LIB_INSTALL_DIR}")
      set(_abs_LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}")
   endif()

   # setup default RPATH/install_name handling, may be overridden by KDE4_HANDLE_RPATH_FOR_EXECUTABLE
   # It sets up to build with full RPATH. When installing, RPATH will be changed to the LIB_INSTALL_DIR
   # and all link directories which are not inside the current build dir.
   if (UNIX)
      # the rest is RPATH handling
      # here the defaults are set
      # which are partly overwritten in kde4_handle_rpath_for_library()
      # and kde4_handle_rpath_for_executable(), both located in KDE4Macros.cmake, Alex
      if (APPLE)
         set(CMAKE_INSTALL_NAME_DIR ${_abs_LIB_INSTALL_DIR})
      else ()
         # add our LIB_INSTALL_DIR to the RPATH (but only when it is not one of the standard system link
         # directories listed in CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES) and use the RPATH figured out by cmake when compiling

         list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${_abs_LIB_INSTALL_DIR}" _isSystemLibDir)
         list(FIND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES      "${_abs_LIB_INSTALL_DIR}" _isSystemCxxLibDir)
         list(FIND CMAKE_C_IMPLICIT_LINK_DIRECTORIES        "${_abs_LIB_INSTALL_DIR}" _isSystemCLibDir)
         if("${_isSystemLibDir}" STREQUAL "-1"  AND  "${_isSystemCxxLibDir}" STREQUAL "-1"  AND  "${_isSystemCLibDir}" STREQUAL "-1")
            set(CMAKE_INSTALL_RPATH "${_abs_LIB_INSTALL_DIR}")
         endif()

         set(CMAKE_SKIP_BUILD_RPATH FALSE)
         set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
         set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
      endif ()
   endif (UNIX)

endif()

################ Testing setup ####################################


if(NOT KDE_SKIP_TEST_SETTINGS)
   enable_testing()

   # support for cdash dashboards
   if (EXISTS ${CMAKE_SOURCE_DIR}/CTestConfig.cmake)
      include(CTest)
   endif (EXISTS ${CMAKE_SOURCE_DIR}/CTestConfig.cmake)
endif()

# Tell FindQt4.cmake to point the QT_QTFOO_LIBRARY targets at the imported targets
# for the Qt libraries, so we get full handling of release and debug versions of the
# Qt libs and are flexible regarding the install location of Qt under Windows
set(QT_USE_IMPORTED_TARGETS TRUE)


################ Build-related settings ###########################

if(NOT KDE_SKIP_BUILD_SETTINGS)

   # Always include srcdir and builddir in include path
   # This saves typing ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} in about every subdir
   # since cmake 2.4.0
   set(CMAKE_INCLUDE_CURRENT_DIR ON)

   # put the include dirs which are in the source or build tree
   # before all other include dirs, so the headers in the sources
   # are prefered over the already installed ones
   # since cmake 2.4.1
   set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)


   # This will only have an effect in CMake 2.8.7
   set(CMAKE_LINK_INTERFACE_LIBRARIES "")

   # Default to shared libs for KDE, if no type is explicitely given to add_library():
   set(BUILD_SHARED_LIBS TRUE CACHE BOOL "If enabled, shared libs will be built by default, otherwise static libs")

   # Enable automoc in cmake
   set(CMAKE_AUTOMOC ON)

   # under Windows, generate all executables and libraries into
   # one common directory, so the executables find their dlls
   if(WIN32)
      set(ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
      set(LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
      set(RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
   endif()

endif()

###################################################################