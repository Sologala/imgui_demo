cmake_minimum_required(VERSION 3.12)
project(my-demo)

include(../cmake/imgui.cmake)

add_executable(my-demo ./my-demo.cpp)
target_link_libraries(my-demo PRIVATE imgui)