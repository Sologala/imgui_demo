cmake_minimum_required(VERSION 3.12) # FetchContent is available in 3.11+

project(imgui VERSION 0.0.1)
message("START Prepare Imgui Library")

# headers and paths
set(CPP_INCLUDE_DIRS "")
set(CPP_SOURCE_FILES "")
set(CPP_HEADER_FILES "")

# This section deal with the character sets UNICODE _UNICODE
# Directx win32 settings
# this deal with convert string
ADD_DEFINITIONS(-DUNICODE)
ADD_DEFINITIONS(-D_UNICODE)
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /UMBCS /D_UNICODE /DUNICODE")


set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# control where the static and shared libraries are built so that on windows
# we don't need to tinker with the path to run the executable
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}")

set(ENABLE_IMGUI ON)

if(ENABLE_IMGUI)
  if (NOT imgui_FOUND) # If there's none, fetch and build sdl
    include(FetchContent)
    FetchContent_Declare(
      imgui
      GIT_REPOSITORY https://github.com/ocornut/imgui.git
      # GIT_TAG v1.82
    )
    if (NOT imgui_POPULATED) # Have we downloaded yet?
      set(FETCHCONTENT_QUIET NO)
      FetchContent_MakeAvailable(imgui)
	  #INCLUDE
      list(APPEND CPP_INCLUDE_DIRS ${imgui_SOURCE_DIR})
      list(APPEND CPP_INCLUDE_DIRS ${imgui_SOURCE_DIR}/backends)
	  #SOURCE
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_demo.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_draw.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_tables.cpp)
      list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/imgui_widgets.cpp)
	  #HEADER
      list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imgui.h)
      list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imconfig.h)
      list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/imgui_internal.h)
	  
      #add_subdirectory(${imgui_SOURCE_DIR} ${imgui_BINARY_DIR}) #add to build in sub dir
    endif()
  endif()
endif()



if (WIN32)
  message("set IMGUI backend DirctX")
  set(ENABLE_DXSDK OFF) # Directx SDK june 2010
  set(ENABLE_WINDXSDK OFF) # Windows Kits 10
  set(WINDOWKIT_VERSION 10) # folder folder version
  set(WINDOWKIT_VERSION_UPDATE 10.0.19041.0) # sub folder folder version
  set(WINDOW_BIT x86) # arm, arm64, x64, x86

  set(ENABLE_DIRECTXHEADERS OFF)
  set(ENABLE_DIRECTXTK12 OFF)
  set(DIRECTX_VERSION 12) # ex. 9, 10, 11, 12
  set(DIRECTX_LIBS "") # ex. d3d11, d3dx11d, dxguid
# Directx win32 settings
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /SUBSYSTEM:CONSOLE")

  if(ENABLE_DXSDK)
    if( DEFINED ENV{DXSDK_DIR} ) # system path var
      set( DX_DIR $ENV{DXSDK_DIR})
    endif()
    #message("DX SDK: " ${DX_DIR})
    list(APPEND CPP_INCLUDE_DIRS ${DX_DIR}/Include)
    #link_libraries(${DX_DIR}/Lib/x86) # incorrect lib dir
    #link_directories(${DX_DIR}/Lib/x86/d3d11.lib)
    link_directories(${DX_DIR}/Lib/${WINDOW_BIT})
    #find_library(d3d11_LIB NAMES d3d11 HINTS ${DX_DIR}/Lib/x86)
    #find_library(d3dx11_LIB NAMES d3dx11 HINTS ${DX_DIR}/Lib/x86)
    #find_library(dxguid_LIB NAMES dxguid HINTS ${DX_DIR}/Lib/x86)
  endif()

  if(ENABLE_WINDXSDK)

    message("WINDOW 10 PROGRAM LOCTION: " $ENV{ProgramFiles\(x86\)})
    set(PROGRAMFILES_PATH $ENV{ProgramFiles\(x86\)})
    set(WINDOW_KITS "${PROGRAMFILES_PATH}/Windows Kits/${WINDOWKIT_VERSION}")
    set(WINDOW_DXSDK_INCULDE "${WINDOW_KITS}/Include/${WINDOWKIT_VERSION}/um")
    set(WINDOW_DXSDK_LIB "${WINDOW_KITS}/Include/${WINDOWKIT_VERSION}/um/${WINDOW_BIT}")

    list(APPEND CPP_INCLUDE_DIRS ${WINDOW_DXSDK_INCULDE})
    link_directories(${WINDOW_DXSDK_LIB})
  endif()


  if(ENABLE_DIRECTXHEADERS)
    if (NOT directx_headers_FOUND) # If there's none, fetch and build
      include(FetchContent)
      FetchContent_Declare(
        directx_headers
        GIT_REPOSITORY https://github.com/microsoft/DirectX-Headers.git
        GIT_TAG v1.0.2 #main
      )
      FetchContent_GetProperties(directx_headers)
      if (NOT directx_headers_POPULATED) # Have we downloaded yet?
        set(FETCHCONTENT_QUIET NO)
        FetchContent_Populate(directx_headers)
        #message("directx_headers_LIBRARY: " ${directx_headers_LIBRARY}) # fail but define in cmake
        #message("directx_headers_INCLUDE_DIR: " ${directx_headers_INCLUDE_DIR}) #pass
        #message("directx_headers_SOURCE_DIR: " ${directx_headers_SOURCE_DIR}) # pass
        #message("directx_headers_BINARY_DIR: " ${directx_headers_BINARY_DIR}) # pass

        #set(FT_WITH_ZLIB OFF CACHE BOOL "" FORCE)
        include_directories(${directx_headers_SOURCE_DIR}/include/directx)
        #list(APPEND CPP_HEADER_FILES ${directx_headers_SOURCE_DIR}/include/directx/d3d12.h)
        # build directx_headers
        add_subdirectory(${directx_headers_SOURCE_DIR} ${directx_headers_BINARY_DIR}) #add to build in sub dir
      endif()
    endif()
  endif()

  if(ENABLE_DIRECTXTK12)
    if (NOT directxtk12_FOUND) # If there's none, fetch and build
      include(FetchContent)
      FetchContent_Declare(
        directxtk12
        GIT_REPOSITORY https://github.com/microsoft/DirectXTK12
        GIT_TAG apr2021
      )
      FetchContent_GetProperties(directxtk12)
      if (NOT directxtk12_POPULATED) # Have we downloaded yet?
        set(FETCHCONTENT_QUIET NO)
        FetchContent_Populate(directxtk12)
        #message("directxtk12_LIBRARY: " ${directxtk12_LIBRARY}) # fail but define in cmake
        #message("directxtk12_INCLUDE_DIR: " ${directxtk12_INCLUDE_DIR}) #pass
        #message("directxtk12_SOURCE_DIR: " ${directxtk12_SOURCE_DIR}) # pass
        #message("directxtk12_BINARY_DIR: " ${directxtk12_BINARY_DIR}) # pass
        #set(FT_WITH_ZLIB OFF CACHE BOOL "" FORCE)
        add_subdirectory(${directxtk12_SOURCE_DIR} ${directxtk12_BINARY_DIR}) #add to build in sub dir
      endif()
    endif()
  endif()



  if(DIRECTX_VERSION EQUAL 9)
    list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx9.cpp)
    list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx9.h)
  elseif(DIRECTX_VERSION EQUAL 10)
    list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx10.cpp)
    list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx10.h)
  elseif(DIRECTX_VERSION EQUAL 11)
    list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx11.cpp)
    list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx11.h)
  elseif(DIRECTX_VERSION EQUAL 12)
    list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx12.cpp)
    list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_dx12.h)
  endif()

  if(DIRECTX_VERSION EQUAL 9)
    list(APPEND DIRECTX_LIBS d3d9)
    message("DIRECTX 9")
  elseif(DIRECTX_VERSION EQUAL 10)
    list(APPEND DIRECTX_LIBS d3d10)
    message("DIRECTX 10")
  elseif(DIRECTX_VERSION EQUAL 11)
    message("DIRECTX 11")
    list(APPEND DIRECTX_LIBS d3d11)
    #list(APPEND DIRECTX_LIBS d3dx11d)
    #list(APPEND DIRECTX_LIBS dxguid)
  elseif(DIRECTX_VERSION EQUAL 12)
    list(APPEND DIRECTX_LIBS d3d12)
    list(APPEND DIRECTX_LIBS dxguid)
    list(APPEND DIRECTX_LIBS dxgi)
    list(APPEND DIRECTX_LIBS d3dcompiler)
    #list(APPEND CPP_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/imgui_impl_dx12.cpp)
    message("DIRECTX 12")
  else()
    message("DIRECTX ERROR NOT VERSION")
  endif()

  #DIRECTX add backend  
  list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_win32.cpp)
  list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_win32.h)

  

elseif(UNIX)

  FetchContent_Declare(
      glfw
      GIT_REPOSITORY https://github.com/glfw/glfw.git
      GIT_TAG 3.3.9
    )
  FetchContent_GetProperties(glfw)
  if(NOT glfw_POPULATED)
    # Fetch the content using previously declared details
    FetchContent_Populate(glfw)
    
    # Set custom variables
    set(BUILD_SHARED_LIBS OFF)
    set(GLFW_BUILD_EXAMPLES OFF)
    set(GLFW_BUILD_TESTS OFF)
    set(GLFW_BUILD_DOCS OFF)
    set(GLFW_INSTALL OFF)
    set(GLFW_VULKAN_STATIC OFF)

    set(CMAKE_THREAD_LIBS_INIT "-lpthread")
    set(CMAKE_HAVE_THREADS_LIBRARY 1)
    set(CMAKE_USE_WIN32_THREADS_INIT 0)
    set(CMAKE_USE_PTHREADS_INIT 1)
    set(THREADS_PREFER_PTHREAD_FLAG ON)

    # Bring the populated content into the build
    add_subdirectory(${glfw_SOURCE_DIR} ${glfw_BINARY_DIR})
  endif() 
  #opengl add backend
  message("set IMGUI backend opengl + glfw")
  list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.cpp)
  list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_glfw.h)
  list(APPEND CPP_SOURCE_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp)
  list(APPEND CPP_HEADER_FILES ${imgui_SOURCE_DIR}/backends/imgui_impl_opengl3.h)
endif()

add_library(imgui
  ${CPP_HEADER_FILES}
  ${CPP_SOURCE_FILES}
)


if (WIN32)
    target_link_libraries(imgui PUBLIC ${DIRECTX_LIBS}) 
elseif(UNIX)
    find_package( OpenGL REQUIRED )
    find_package( GLEW REQUIRED )
    target_link_libraries(imgui PUBLIC ${OPENGL_LIBRARIES} glfw ${GLEW_LIBRARIES} pthread)
    target_include_directories(imgui PUBLIC ${GLEW_INCLUDE_DIRS})
endif()


message("CMAKE_CURRENT_SOURCE_DIR  >>> " ${CMAKE_CURRENT_SOURCE_DIR})
message("IMGUI_INCLUDE_DIRS  >>> " ${CPP_INCLUDE_DIRS})
# target_include_directories(imgui PUBLIC
#     ${CPP_INCLUDE_DIRS}
# )
target_include_directories(imgui PUBLIC
    $<BUILD_INTERFACE:${imgui_SOURCE_DIR}/backends>
    $<BUILD_INTERFACE:${imgui_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CPP_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:imgui>
)
