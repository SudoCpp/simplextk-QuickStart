#!/bin/bash

function makeMainFileStructure
{
    if [ ! -d $projectName ]
    then
    echo "Creating main directory structure..."
    mkdir $projectName
    cd $projectName
        mkdir bin
        mkdir subprojects
    else
        echo "Directory named \"$projectName\" already exists."
        anotherProj=N
        echo ""
        echo "Would you like to add more projects to it? (y/N)"
        read anotherProj
        if [ "$anotherProj" == 'y' ] || [ "$anotherProj" == 'Y' ]
        then
            cd $projectName
            cd subprojects
            setProjectInfo
            writeProject

            writeAnotherProject
            exit
        else
            exit
        fi
    fi
}

function makeProjectStructure
{
    echo "Creating project structure..."
    mkdir $projectName
    cd $projectName
        mkdir include
        mkdir src
        if [ "$initGit" = 'Y' ] || [ "$initGit" = 'y' ]
        then
            git init
        fi
}

function writeProject
{
    makeProjectStructure
    writeProjectCMakeLists
    writeProjectMainHeader
    writeFormattingDecorations
    writeEndFormattingDecorations
    writeProjectExampleHeader
    writeProjectExampleSource
    echo "Project \"$projectName\" created!"
    echo ""
    cd ..
}

function writeEndFormattingDecorations
{
    cd include
    echo "Adding Formatting Decorations keyword support..."
    headerFile="FormattingDecorations.hpp"
    capitalProject=`echo ${projectName} | awk '{print toupper($0)}'`
    echo "#ifdef ${capitalProject}_FORMATTINGDECORATIONS_HPP" > $headerFile
    echo "#undef in" >> $headerFile
    echo "#undef inout" >> $headerFile
    echo "#undef out" >> $headerFile
    echo "#undef nullable" >> $headerFile
    echo "#undef ownership" >> $headerFile
    echo "#undef slots" >> $headerFile
    echo "#undef internal" >> $headerFile
    echo "#undef ${capitalProject}_FORMATTINGDECORATIONS_HPP" >> $headerFile
    echo "#endif //${capitalProject}_FORMATTINGDECORATIONS_HPP" >> $headerFile
    cd ..
}

function writeFormattingDecorations
{
    cd include
    echo "Adding 'internal' keyword support..."
    headerFile="EndFormattingDecorations.hpp"
    capitalProject=`echo ${projectName} | awk '{print toupper($0)}'`
    echo "#ifndef ${capitalProject}_FORMATTINGDECORATIONS_HPP" > $headerFile
    echo "#define ${capitalProject}_FORMATTINGDECORATIONS_HPP" >> $headerFile
    echo "#define in" >> $headerFile
    echo "#define inout" >> $headerFile
    echo "#define out" >> $headerFile
    echo "#define nullable" >> $headerFile
    echo "#define ownership" >> $headerFile
    echo "#define slots" >> $headerFile
    echo "//This needs to be set to the definition of the include all header" >> $headerFile
    echo "#ifdef ${capitalProject}_HPP" >> $headerFile
    echo "#define internal private" >> $headerFile
    echo "#else" >> $headerFile
    echo "#define internal public" >> $headerFile
    echo "#endif" >> $headerFile
    echo "#else" >> $headerFile
    echo "#error \"FormattingDecorations must be included after all other includes or last includer needs to include EndFormattingDecorations at the end.\"" >> $headerFile
    echo "#endif //${capitalProject}_FORMATTINGDECORATIONS_HPP" >> $headerFile
    cd ..
}

function writeProjectExampleHeader
{
    cd include
    echo "Writing Example class..."
    headerFile="Example.hpp"
    capitalProject=`echo ${projectName} | awk '{print toupper($0)}'`
    lowerProject=`echo ${projectName} | awk '{print tolower($0)}'`
    echo "#ifndef ${capitalProject}_EXAMPLE_HPP" > $headerFile
    echo "#define ${capitalProject}_EXAMPLE_HPP" >> $headerFile
    echo "" >> $headerFile
    echo "#include \"simplextk.hpp\"" >> $headerFile
    echo "#include \"FormattingDecorations.hpp\"" >> $headerFile
    echo "" >> $headerFile
    echo "namespace "$lowerProject >> $headerFile
    echo "{" >> $headerFile
    echo "    class Example : public simplex::object" >> $headerFile
    echo "    {" >> $headerFile
    echo "        public:" >> $headerFile
    echo "            Example();" >> $headerFile
    echo "    };" >> $headerFile
    echo "}" >> $headerFile
    echo "" >> $headerFile
    echo "#include \"EndFormattingDecorations.hpp\"" >> $headerFile
    echo "#endif //${capitalProject}_EXAMPLE_HPP" >> $headerFile
    cd ..
}

function writeProjectExampleSource
{
    cd src
    sourceFile="Example.cpp"
    lowerProject=`echo ${projectName} | awk '{print tolower($0)}'`
    echo "#include \"Example.hpp\"" > $sourceFile
    echo "" >> $sourceFile
    echo "#define __class__ \"$lowerProject::Example\"" >> $sourceFile
    echo "" >> $sourceFile
    echo "using namespace simplex;" >> $sourceFile
    echo "" >> $sourceFile
    echo "namespace "$lowerProject >> $sourceFile
    echo "{" >> $sourceFile
    echo "    Example::Example()" >> $sourceFile
    echo "    {" >> $sourceFile
    echo "        Console::WriteLine(\"Hello World!\");" >> $sourceFile
    echo "    }" >> $sourceFile
    echo "}" >> $sourceFile
    echo "" >> $sourceFile
    echo "#undef __class__" >> $sourceFile
    cd ..
}

function writeProjectMainHeader
{
    echo "Writing main project header..."
    headerFile=${projectName}".hpp"
    capitalProject=`echo ${projectName} | awk '{print toupper($0)}'`
    echo "#ifndef ${capitalProject}_HPP" > $headerFile
    echo "#define ${capitalProject}_HPP" >> $headerFile
    echo "" >> $headerFile
    echo "#include \"include/Example.hpp\"" >> $headerFile
    echo "" >> $headerFile
    echo "#endif //${capitalProject}_HPP" >> $headerFile
}

function writeProjectCMakeLists
{
    echo "Writing project CMakeLists.txt..."
    cmakeFile=CMakeLists.txt
    echo 'cmake_minimum_required(VERSION 3.1.0)' > $cmakeFile
    echo "project(${projectName} VERSION 2.8.0)" >> $cmakeFile
    echo '' >> $cmakeFile
    echo '#Debian Packages required' >> $cmakeFile
    echo '# none' >> $cmakeFile
    echo 'set (CMAKE_CXX_STANDARD 17)' >> $cmakeFile
    echo '' >> $cmakeFile
    if [ "$compileStatic" == 'Y' ] || [ "$compileStatic" == 'y' ]
    then
        echo 'set(ProjectType STATIC) #options are SHARED and STATIC' >> $cmakeFile
    else
        echo 'set(ProjectType SHARED) #options are SHARED and STATIC' >> $cmakeFile
    fi
    echo '' >> $cmakeFile
    echo 'set(Packages' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '    )' >> $cmakeFile
    echo '' >> $cmakeFile
    echo 'set(SubProjects' >> $cmakeFile
    echo '  simplextk' >> $cmakeFile
    echo '    ) ' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '#Add all the source files to build library' >> $cmakeFile
    echo 'set(SourceFiles' >> $cmakeFile
    echo '    src/Example.cpp' >> $cmakeFile
    echo '    )' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '        #Tabbed over values do not need to be edited' >> $cmakeFile
    echo '        if(NOT TARGET ${PROJECT_NAME})' >> $cmakeFile
    echo '            add_library(${PROJECT_NAME} ${ProjectType} ${SourceFiles})' >> $cmakeFile
    echo '#target_link_libraries(${PROJECT_NAME} "-l_additional_libraries")' >> $cmakeFile
    echo '            # Unix systems required the dl library for dynamically loading libraries' >> $cmakeFile
    echo '            if (UNIX)' >> $cmakeFile
    echo '                target_link_libraries(${PROJECT_NAME} "-ldl")' >> $cmakeFile
    echo '            endif()' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '            if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")' >> $cmakeFile
    echo '                target_link_libraries(${PROJECT_NAME} "-lstdc++fs")' >> $cmakeFile
    echo '            endif()' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '            # Include files for this project' >> $cmakeFile
    echo '            include_directories("include")' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '            # Go through all the packages that are required. Find them, and add support.' >> $cmakeFile
    echo '            foreach(Package IN LISTS Packages)' >> $cmakeFile
    echo '                find_package(${Package} REQUIRED)' >> $cmakeFile
    echo '                include_directories(${${Package}_INCLUDE_DIRS})' >> $cmakeFile
    echo '                target_link_libraries(${PROJECT_NAME} ${${Package}_LIBRARIES})' >> $cmakeFile
    echo '            endforeach()' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '            # Add all subprojects. ' >> $cmakeFile
    echo '            foreach(Project IN LISTS SubProjects)' >> $cmakeFile
    echo '                # This is like an include guard on a header file, they can only be added once' >> $cmakeFile
    echo '                if(NOT TARGET ${Project})' >> $cmakeFile
    echo '                    add_subdirectory("../${Project}" ${Project})' >> $cmakeFile
    echo '                endif()' >> $cmakeFile
    echo '                include_directories("../${Project}")' >> $cmakeFile
    echo '                target_link_libraries(${PROJECT_NAME} ${Project})' >> $cmakeFile
    echo '            endforeach()' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '            if(EXISTS tests)' >> $cmakeFile
    echo '                include(CTest)' >> $cmakeFile
    echo '                enable_testing()' >> $cmakeFile
    echo '                #Add testing executables' >> $cmakeFile
    echo '                set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${FullOutputDir}/tests/${PROJECT_NAME}")' >> $cmakeFile
    echo '                add_subdirectory(tests)' >> $cmakeFile
    echo '                set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${FullOutputDir})' >> $cmakeFile
    echo '            endif()' >> $cmakeFile
    echo '        endif()' >> $cmakeFile
    echo '' >> $cmakeFile
    echo '        #set(CPACK_PROJECT_NAME ${PROJECT_NAME})' >> $cmakeFile
    echo '        #set(CPACK_PROJECT_VERSION ${PROJECT_NAME})' >> $cmakeFile
    echo '        #include(CPack)' >> $cmakeFile
}

function makeMainCMakeLists
{
    echo "Writing main CMakeLists.txt..."
    mainCMake=CMakeLists.txt
    echo 'cmake_minimum_required(VERSION 3.0.0)' > $mainCMake
    echo 'project(Main VERSION 1.0.0)' >> $mainCMake
    echo '' >> $mainCMake
    echo '# Packages required to install' >> $mainCMake
    echo '# example: libsdl2-dev' >> $mainCMake
    echo '' >> $mainCMake
    echo '        # Code that is tabbed over like this should be code that is boilerplate' >> $mainCMake
    echo '        # and does not need to be modified.' >> $mainCMake
    echo '        include(CTest)' >> $mainCMake
    echo '        enable_testing()' >> $mainCMake
    echo '' >> $mainCMake
    echo '        if (MSVC)' >> $mainCMake
    echo '            add_compile_options(/std:c++latest)' >> $mainCMake
    echo '            set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)' >> $mainCMake
    echo '            set(BUILD_SHARED_LIBS TRUE)' >> $mainCMake
    echo '        endif()' >> $mainCMake
    echo '' >> $mainCMake
    echo '        #Determine if 32 or 64 bit for better output folder naming' >> $mainCMake
    echo '        set(OSBitness 32)' >> $mainCMake
    echo '        if(CMAKE_SIZEOF_VOID_P EQUAL 8)' >> $mainCMake
    echo '        set(OSBitness 64)' >> $mainCMake
    echo '        endif()' >> $mainCMake
    echo '' >> $mainCMake
    echo '        #Save outputs into bin folder. By having dynamic libraries in the same folder, ' >> $mainCMake
    echo '        # debugging is easier/posible' >> $mainCMake
    echo '        set(FullOutputDir "${CMAKE_SOURCE_DIR}/bin/${CMAKE_SYSTEM_NAME}${OSBitness}/${CMAKE_BUILD_TYPE}")' >> $mainCMake
    echo '        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${FullOutputDir}/static libs")' >> $mainCMake
    echo '        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${FullOutputDir})' >> $mainCMake
    echo '        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${FullOutputDir})' >> $mainCMake
    echo '' >> $mainCMake
    echo 'set(SubProjects' >> $mainCMake
    index=0
    while [ $index -lt $projectIndex ]
    do
    echo "    ${projects[$index]}" >> $mainCMake
        ((index=index+1))
    done
    echo '    )' >> $mainCMake
    echo '' >> $mainCMake
    echo '# Main.cpp is used to tie all the libraries together. It should be used' >> $mainCMake
    echo '# just to get the program started with minimal code.' >> $mainCMake
    echo 'add_executable(${PROJECT_NAME} main.cpp)' >> $mainCMake
    echo '' >> $mainCMake
    echo '# If needing to add a manual linkage for example the linux c math library' >> $mainCMake
    echo '#target_link_libraries(${PROJECT_Name} "-lm")' >> $mainCMake
    echo '' >> $mainCMake
    echo '        foreach(Project IN LISTS SubProjects)' >> $mainCMake
    echo '            # This folder contains the combined header file so that all public classes' >> $mainCMake
    echo '            # are available by including only this header. Users of the library should' >> $mainCMake
    echo '            # not need to know all the headers required to use the class.' >> $mainCMake
    echo '            include_directories("subprojects/${Project}")' >> $mainCMake
    echo '        endforeach()     ' >> $mainCMake
    echo '' >> $mainCMake
    echo '        # This will automatically add subprojects, give availability to the combined' >> $mainCMake
    echo '        # header and link them to the project.' >> $mainCMake
    echo '        foreach(Project IN LISTS SubProjects)' >> $mainCMake
    echo '            if(NOT TARGET ${Project})' >> $mainCMake
    echo '                # Add the project so it is available' >> $mainCMake
    echo '                add_subdirectory("subprojects/${Project}")' >> $mainCMake
    echo '            endif()' >> $mainCMake
    echo '            ' >> $mainCMake
    echo '            # Link in all the libraries included above by project name.' >> $mainCMake
    echo '            target_link_libraries(${PROJECT_NAME} ${Project})' >> $mainCMake
    echo '        endforeach()' >> $mainCMake
}

function makeMainCpp
{
    echo "Writing main.cpp..."
    cppFile=main.cpp
    lowerProject=`echo ${projectName} | awk '{print tolower($0)}'`
    echo '#include "simplextk.hpp"' > $cppFile
    echo "#include \"${projectName}.hpp\"" >> $cppFile
    echo '' >> $cppFile
    echo 'int main (int numberArguments, char* commandlineArguments[])' >> $cppFile
    echo '{' >> $cppFile
    echo '    // int main() can be called and this code removed if arguments are not needed.' >> $cppFile
    echo '    simplex::Array<simplex::string> arguments{};' >> $cppFile
    echo '    for(int argumentLoop = 0; argumentLoop < numberArguments; argumentLoop++)' >> $cppFile
    echo '        arguments.add(commandlineArguments[argumentLoop]);' >> $cppFile
    echo '' >> $cppFile
    echo "    ${lowerProject}::Example example{};" >> $cppFile
    echo '' >> $cppFile
    echo '    return 0;' >> $cppFile
    echo '}' >> $cppFile
}

function checkProgramsExist
{
    echo "Checking to see if prerequisites exist..."
    gitExists=$(git --version)
    cMakeExist=$(cmake --version)
    ninjaExist=$(ninja --version)
    codeExist=$(code --version)

    if [ "$gitExists" == "git: command not found" ]
    then
        echo "git: not found"
    else
        echo "git: found"
    fi

    if [ "$cMakeExist" == 'cmake: command not found' ]
    then
        echo "cmake: not found"
    else
        echo "cmake: found"
    fi

    if [ "$ninjaExist" == 'ninja: command not found' ]
    then
        echo "ninja (optional): not found"
    else
        echo "ninja (optional): found"
    fi

    if [ "$codeExist" == 'code: command not found' ]
    then
        echo "VS Code (optional): not found"
    else
        echo "VS Code (optional): found"
    fi
    
    echo ""
}

function setProjectInfo
{
    echo "What is the name of your project? (None) "
    read projectName

    if [ "$projectName" == '' ]
    then
        projectName=None
    fi

    projects[$projectIndex]=$projectName
    ((projectIndex=projectIndex+1))

    echo "Do you want your project to be compiled statically? (Y/n) "
    read compileStatic

    if [ "$compileStatic" != 'n' ] && [ "$compileStatic" != 'N' ]
    then
        compileStatic=Y
    fi

    echo "Do you want initialize a git repository? (Y/n) "
    read initGit

    if [ "$initGit" != 'n' ] && [ "$initGit" != 'N' ]
    then
        initGit=Y
    fi
}

function cloneSimplex
{
    echo "Bringing in Simplex TK..."
    git clone https://github.com/SudoCpp/simplextk.git
}


function writeAnotherProject
{
    anotherProj=N
    echo ""
    echo "Would you like to add another project? (y/N)"
    read anotherProj
    if [ "$anotherProj" == 'y' ] || [ "$anotherProj" == 'Y' ]
    then
        setProjectInfo
        writeProject
        writeAnotherProject
    fi
}

echo "+---------------------------------------------------+"
echo "|             Simplex TK Project Creator            |"
echo "+---------------------------------------------------+"
echo ""

projectName=None
compileStatic=Y
initGit=Y
projectIndex=0
projects[$projectIndex]=simplextk
((projectIndex=projectIndex+1))

checkProgramsExist

setProjectInfo

makeMainFileStructure
makeMainCpp
echo ""
cd subprojects

writeProject

cloneSimplex

writeAnotherProject

cd ..
makeMainCMakeLists