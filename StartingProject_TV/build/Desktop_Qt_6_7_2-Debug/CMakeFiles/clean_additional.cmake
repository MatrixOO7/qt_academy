# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appIntroToQtQuick_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appIntroToQtQuick_autogen.dir/ParseCache.txt"
  "appIntroToQtQuick_autogen"
  )
endif()
