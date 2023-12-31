### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# This can be included multiple times

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()


if( LINK_PHASE)
### Install

   include( PreInstallExecutable OPTIONAL)

   install( TARGETS ${INSTALL_EXECUTABLE_TARGETS} DESTINATION "bin")
   foreach( TMP_NAME ${INSTALL_EXECUTABLE_TARGETS})
      string( MAKE_C_IDENTIFIER "${TMP_NAME}" TMP_IDENTIFIER)
      string( TOUPPER "${TMP_IDENTIFIER}" TMP_IDENTIFIER)
      # avoid empty share subdir
      if( (${INSTALL_${TMP_IDENTIFIER}_RESOURCE_DIRS}) OR (${INSTALL_${TMP_IDENTIFIER}_RESOURCES}))
         install( DIRECTORY ${INSTALL_${TMP_IDENTIFIER}_RESOURCE_DIRS} DESTINATION "share/${TMP_NAME}")
         install( FILES ${INSTALL_${TMP_IDENTIFIER}_RESOURCES} DESTINATION "share/${TMP_NAME}")
      endif()
   endforeach()


   include( PostInstallExecutable OPTIONAL)

endif()
