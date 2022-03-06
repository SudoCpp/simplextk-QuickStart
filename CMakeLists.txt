cmake_minimum_required(VERSION 3.0.0)
project(Tester VERSION 1.0.0)

# Packages required to install
# example: libsdl2-dev

        # Code that is tabbed over like this should be code that is boilerplate
        # and does not need to be modified.
        include(CTest)
        enable_testing()

        #Determine if 32 or 64 bit for better output folder naming
        set(OSBitness 32)
        if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(OSBitness 64)
        endif()

        #Save outputs into bin folder. By having dynamic libraries in the same folder, 
        # debugging is easier/posible
        set(FullOutputDir "${CMAKE_SOURCE_DIR}/bin/${CMAKE_SYSTEM_NAME}${OSBitness}/${CMAKE_BUILD_TYPE}")
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${FullOutputDir}/static libs")
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${FullOutputDir})
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${FullOutputDir})

set(SubProjects
    simplextk
    )

# Main.cpp is used to tie all the libraries together. It should be used
# just to get the program started with minimal code.
add_executable(${PROJECT_NAME} main.cpp)

# If needing to add a manual linkage for example the linux c math library
target_link_libraries(${PROJECT_NAME} "-lm")

        # This will automatically add subprojects, give availability to the combined
        # header and link them to the project.
        foreach(Project IN LISTS SubProjects)
            if(NOT TARGET ${Project})
                # Add the project so it is available
                add_subdirectory("subprojects/${Project}")


                # This folder contains the combined header file so that all public classes
                # are available by including only this header. Users of the library should
                # not need to know all the headers required to use the class.
                include_directories("subprojects/${Project}")

                # Link in all the libraries included above by project name.
                target_link_libraries(${PROJECT_NAME} ${Project})
            endif()
        endforeach()