project(libphw2
  DESCRIPTION "Print Hello World toolkit library"
  LANGUAGES C)
cmake_minimum_required(VERSION 2.8)

add_library(phw2 SHARED print_hello_world.c include/print_hello_world.h include/print_hello_world_defines.h)
target_include_directories(phw2 PUBLIC include)
set_target_properties(phw2 PROPERTIES
  PUBLIC_HEADER "include/print_hello_world.h;include/print_hello_world_defines.h")

install(TARGETS phw2
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include)

