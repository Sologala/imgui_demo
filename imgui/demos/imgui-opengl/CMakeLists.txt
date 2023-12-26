cmake_minimum_required(VERSION 3.12)

include(./cmake/imgui.cmake)

add_executable(imgui-opengl-demo ./main.cpp)
target_link_libraries(imgui-opengl-demo imgui)
