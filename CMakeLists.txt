# https://cmake.org/cmake/help/v3.10/command/project.html
project(helloworld
  DESCRIPTION "Print Hello World toolkit"
  LANGUAGES C)
# https://cmake.org/cmake/help/v3.10/command/cmake_minimum_required.html
cmake_minimum_required(VERSION 2.8)

# https://cmake.org/cmake/help/v3.10/command/option.html
# will show up in "cmake -LAH"
option(WANT_CMAKE_TO_FAIL "this option will make cmake fail")
option(WANT_TESTS "this option enable tests" ON)
option(WANT_COVERAGE "this option enable coverage" ON)

# https://cmake.org/cmake/help/v3.10/command/if.html
if(WANT_CMAKE_TO_FAIL)
  # https://cmake.org/cmake/help/v3.10/command/message.html
  message(FATAL_ERROR "CMake failed due to WANT_CMAKE_FAIL option")
endif()

if(NOT WANT_TESTS)
  # https://cmake.org/cmake/help/v3.10/command/set.html
  set(WANT_COVERAGE OFF)
endif()

if(NOT CMAKE_BUILD_TYPE MATCHES "Debug")
  set(WANT_COVERAGE OFF)
endif()

if(WANT_COVERAGE)
  # https://cmake.org/cmake/help/v3.10/command/list.html
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake-modules")
  # https://cmake.org/cmake/help/v3.10/command/include.html
  include(CodeCoverage)
  # The following line come from cmake-modules/CodeCoverage.cmake
  append_coverage_compiler_flags()
endif()

# https://cmake.org/cmake/help/v3.10/command/add_executable.html
add_executable(main main.c)
# https://cmake.org/cmake/help/v3.10/command/target_include_directories.html
target_include_directories(main PRIVATE include)

add_executable(main2 main2.c simple_print_hello_world.c include/simple_print_hello_world.h)
target_include_directories(main2 PRIVATE include)

# https://cmake.org/cmake/help/v3.10/command/add_library.html
add_library(phw print_hello_world.c include/print_hello_world.h include/print_hello_world_defines.h)
# https://cmake.org/cmake/help/v3.10/command/target_include_directories.html
target_include_directories(phw PUBLIC include)
# https://cmake.org/cmake/help/v3.10/command/set_target_properties.html
# https://cmake.org/cmake/help/v3.10/manual/cmake-properties.7.html#properties-on-targets
# https://cmake.org/cmake/help/v3.10/prop_tgt/PUBLIC_HEADER.html#prop_tgt:PUBLIC_HEADER
set_target_properties(phw PROPERTIES
  PUBLIC_HEADER "include/print_hello_world.h;include/print_hello_world_defines.h")

add_executable(main3 main3.c)
# https://cmake.org/cmake/help/v3.10/command/target_link_libraries.html
target_link_libraries(main3 phw)
# https://cmake.org/cmake/help/v3.10/command/target_include_directories.html
# https://cmake.org/cmake/help/v3.10/manual/cmake-generator-expressions.7.html#manual:cmake-generator-expressions(7)
# https://cmake.org/cmake/help/v3.10/prop_tgt/INTERFACE_INCLUDE_DIRECTORIES.html
target_include_directories(main3 PRIVATE $<TARGET_PROPERTY:phw,INTERFACE_INCLUDE_DIRECTORIES>)

# https://cmake.org/cmake/help/v3.10/command/add_library.html
add_library(phw-shared SHARED print_hello_world.c include/print_hello_world.h include/print_hello_world_defines.h)
target_include_directories(phw-shared PUBLIC include)
set_target_properties(phw-shared PROPERTIES
  PUBLIC_HEADER "include/print_hello_world.h;include/print_hello_world_defines.h")

add_executable(main4 main3.c)
target_link_libraries(main4 phw-shared)
target_include_directories(main4 PRIVATE $<TARGET_PROPERTY:phw-shared,INTERFACE_INCLUDE_DIRECTORIES>)

# https://cmake.org/cmake/help/v3.10/command/add_subdirectory.html
add_subdirectory(libphw2)

add_executable(main5 main3.c)
target_link_libraries(main5 phw2)
target_include_directories(main5 PRIVATE $<TARGET_PROPERTY:phw2,INTERFACE_INCLUDE_DIRECTORIES>)

# https://cmake.org/cmake/help/v3.10/command/install.html
install(TARGETS main main2 main3 main4 main5 phw phw-shared
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include)

if(WANT_TESTS)
  # https://cmake.org/cmake/help/v3.10/command/enable_testing.html
  enable_testing()

  # https://cmake.org/cmake/help/v3.10/command/add_test.html
  add_test(test-main ${TARGET_SYSTEM_EMULATOR} main)
  # https://cmake.org/cmake/help/v3.10/command/set_tests_properties.html
  set_tests_properties(test-main PROPERTIES PASS_REGULAR_EXPRESSION "^Hello world!\n$")

  add_test(test-main2 ${TARGET_SYSTEM_EMULATOR} main2)
  set_tests_properties(test-main2 PROPERTIES PASS_REGULAR_EXPRESSION "^Hello world!\n$")

  add_test(test-main3 ${TARGET_SYSTEM_EMULATOR} main3)
  set_tests_properties(test-main3 PROPERTIES PASS_REGULAR_EXPRESSION "^Hello world!\n$")

  add_test(test-main4 ${TARGET_SYSTEM_EMULATOR} main4)
  set_tests_properties(test-main4 PROPERTIES PASS_REGULAR_EXPRESSION "^Hello world!\n$")

  add_test(test-main5 ${TARGET_SYSTEM_EMULATOR} main5)
  set_tests_properties(test-main5 PROPERTIES PASS_REGULAR_EXPRESSION "^Hello world!\n$")
endif()

if(WANT_COVERAGE)
  setup_target_for_coverage(
    NAME coverage
    EXECUTABLE ctest -j ${PROCESSOR_COUNT}
    DEPENDENCIES main main2 main3 main4 main5
    )
endif()
