# - MACRO_ENSURE_OUT_OF_SOURCE_BUILD(<errorMessage>)
# MACRO_ENSURE_OUT_OF_SOURCE_BUILD(<errorMessage>)

MACRO (MACRO_ENSURE_OUT_OF_SOURCE_BUILD _errorMessage)

   STRING(COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_BINARY_DIR}" insource)
   IF(insource)
      MESSAGE(FATAL_ERROR "${_errorMessage}")
   ENDIF(insource)

ENDMACRO (MACRO_ENSURE_OUT_OF_SOURCE_BUILD)
