cmake_minimum_required(VERSION 3.12)

project(imgui_opengl_demo)
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

include(../cmake/imgui.cmake)

add_executable(imgui_opengl_demo ./main.cpp)
target_link_libraries(imgui_opengl_demo imgui)
