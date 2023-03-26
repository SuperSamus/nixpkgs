cmake_minimum_required(VERSION 3.9)
project(SSVOpenHexagon CXX C)
enable_testing()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

find_package(luajit REQUIRED)

find_package(ZLIB REQUIRED)

# imgui has no CMake support, so we create our own target

file(GLOB imgui_sources "${imgui_SOURCE_DIR}/*.cpp")
file(GLOB imgui_sources_cpp "${imgui_SOURCE_DIR}/misc/cpp/*.cpp")

list(REMOVE_ITEM imgui_sources "${imgui_SOURCE_DIR}/imgui_demo.cpp")

set(IMGUI_DIR ${imgui_SOURCE_DIR})
set(IMGUI_INCLUDE_DIR ${imgui_SOURCE_DIR})
set(IMGUI_SOURCES ${imgui_sources} ${imgui_sources_cpp})


find_package(ImGui-SFML CONFIG REQUIRED)

find_package(sodium REQUIRED)

set(boostpfr_INCLUDE_DIR ${boostpfr_SOURCE_DIR}/include)

list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_SOURCE_DIR}/cmake/"
    "${CMAKE_SOURCE_DIR}/cmake/modules/"
    "${CMAKE_SOURCE_DIR}/../vrm_cmake/cmake/"
    "${CMAKE_SOURCE_DIR}/extlibs/vrm_cmake/cmake/")

include(vrm_cmake)

message(STATUS "setting required C++ standard to 20")
set(CMAKE_CXX_STANDARD "20")
set(CMAKE_CXX_STANDARD_REQUIRED on)

project(SSVOpenHexagon CXX C)
enable_testing()

set(PROJECT_NAME_UPPER "")
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

set("${PROJECT_NAME_UPPER}_SOURCE_DIR" "${CMAKE_CURRENT_SOURCE_DIR}")

list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

message(STATUS "initialized project ${PROJECT_NAME}")

set(CMAKE_UNITY_BUILD OFF)
set(CMAKE_UNITY_BUILD_BATCH_SIZE 4)

set(INC_DIR "include" CACHE STRING "")
set(SRC_DIR "src" CACHE STRING "")

include_directories("./")
include_directories("./${INC_DIR}")

file(GLOB_RECURSE MAIN_FILE "${SRC_DIR}/SSVOpenHexagon/*/main.cpp")

file(GLOB_RECURSE SRC_LIST
    "${INC_DIR}/SSVOpenHexagon/*"
    "${SRC_DIR}/SSVOpenHexagon/*"
    "public/discord/*")

file(GLOB_RECURSE C_SRC_LIST
     "public/sqlite/*.c")

list(REMOVE_ITEM SRC_LIST ${MAIN_FILE})

set_source_files_properties("public/sqlite/sqlite3.c"
                            "public/sqlite/shell.c" PROPERTIES COMPILE_FLAGS "-w")

vrm_cmake_include_vc_dependency_once(vc_detection)

add_library(SSVOpenHexagonLibC STATIC ${C_SRC_LIST})
add_library(SSVOpenHexagonLib STATIC ${SRC_LIST})

add_executable(SSVOpenHexagon ${MAIN_FILE})

target_precompile_headers(
    SSVOpenHexagonLib PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include/SSVOpenHexagon/Global/PCH.hpp"
)

target_precompile_headers(SSVOpenHexagon REUSE_FROM SSVOpenHexagonLib)

set(PUBLIC_INCLUDE_DIRS "public" "public/sqlite" "public/sqlite_orm")

set(SFML_LIBRARIES
    sfml-system sfml-window sfml-graphics sfml-audio sfml-network)

set(PUBLIC_LIBRARIES
    "${CMAKE_CURRENT_SOURCE_DIR}/_RELEASE/libsteam_api.so"
    "${CMAKE_CURRENT_SOURCE_DIR}/_RELEASE/libdiscord_game_sdk.so"
    "${CMAKE_CURRENT_SOURCE_DIR}/_RELEASE/libsdkencryptedappticket.so"
    Xcursor
    sodium
)

target_include_directories(
    SSVOpenHexagonLib SYSTEM PUBLIC ${SFML_SOURCE_DIR}/include
                             PUBLIC ${PUBLIC_INCLUDE_DIRS}
                             PUBLIC ${zlib_SOURCE_DIR}
                             PUBLIC ${zlib_BINARY_DIR}
                             PUBLIC ${luajit_SOURCE_DIR}/src
                             PUBLIC ${boostpfr_INCLUDE_DIR}
)

target_link_libraries(
    SSVOpenHexagonLib ${SFML_LIBRARIES}
                      libluajit
                      zlib
                      ${PUBLIC_LIBRARIES}
)

target_include_directories(SSVOpenHexagonLib SYSTEM PUBLIC ${imgui_SOURCE_DIR})
target_link_libraries(SSVOpenHexagonLib ImGui-SFML::ImGui-SFML)

macro(ssvoh_find_extlib_for_target target extlib)
    list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_SOURCE_DIR}/../${extlib}/cmake/modules/"
        "${CMAKE_SOURCE_DIR}/../${extlib}/cmake/"
        "${CMAKE_SOURCE_DIR}/extlibs/${extlib}/cmake/modules/"
        "${CMAKE_SOURCE_DIR}/extlibs/${extlib}/cmake/")

    find_package("${extlib}" REQUIRED)
    string(TOUPPER "${extlib}" ${extlib}_UPPER)

    target_include_directories(${target} PUBLIC "${${${extlib}_UPPER}_INCLUDE_DIR}")
endmacro()

ssvoh_find_extlib_for_target(SSVOpenHexagonLib vrm_pp)
ssvoh_find_extlib_for_target(SSVOpenHexagonLib SSVUtils)
ssvoh_find_extlib_for_target(SSVOpenHexagonLib SSVMenuSystem)
ssvoh_find_extlib_for_target(SSVOpenHexagonLib SSVStart)

target_link_libraries(SSVOpenHexagon SSVOpenHexagonLib SSVOpenHexagonLibC)

set(SSVOH_INCLUDE_DIRECTORIES ${SFML_SOURCE_DIR}/include
                              ${PUBLIC_INCLUDE_DIRS}
                              ${zlib_SOURCE_DIR}
                              ${zlib_BINARY_DIR}
                              ${LUASRC})

set(SSVOH_INCLUDE_DIRECTORIES "${SSVOH_INCLUDE_DIRECTORIES} ${imgui_SOURCE_DIR}")

target_include_directories(
    SSVOpenHexagon SYSTEM PUBLIC ${SSVOH_INCLUDE_DIRECTORIES}
)

target_link_libraries(SSVOpenHexagonLib pthread)

install(
    TARGETS SSVOpenHexagon RUNTIME DESTINATION ${CMAKE_SOURCE_DIR}/_RELEASE/
)

set(STEAM_LIBRARIES "${CMAKE_CURRENT_SOURCE_DIR}/_RELEASE/libsteam_api.so")

add_executable(
    OHWorkshopUploader "${CMAKE_CURRENT_SOURCE_DIR}/src/OHWorkshopUploader/main.cpp"
)

target_include_directories(
    OHWorkshopUploader SYSTEM PUBLIC ${PUBLIC_INCLUDE_DIRS}
)

target_link_libraries(OHWorkshopUploader ${STEAM_LIBRARIES})

target_link_libraries(OHWorkshopUploader pthread)

install(
    TARGETS OHWorkshopUploader RUNTIME DESTINATION ${CMAKE_SOURCE_DIR}/_RELEASE/
)

add_executable(
    OHServerControl "${CMAKE_CURRENT_SOURCE_DIR}/src/OHServerControl/main.cpp"
)

target_include_directories(
    OHServerControl SYSTEM PUBLIC ${SFML_SOURCE_DIR}/include
)

target_link_libraries(OHServerControl sfml-system sfml-network)

target_link_libraries(OHServerControl pthread)

install(
    TARGETS OHServerControl RUNTIME DESTINATION ${CMAKE_SOURCE_DIR}/_RELEASE/
)

vrm_check_target()