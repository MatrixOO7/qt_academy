# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appIntroToQML_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appIntroToQML_autogen.dir/ParseCache.txt"
  "appIntroToQML_autogen"
  )
endif()
