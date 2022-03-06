# example-simplex-implementation

This is an example of one way to use the simplextk library along with other libraries. To use this simply open up a terminal, console or git bash depending on your system. 

Then run this command to clone the repository:

`git clone https://github.com/SudoCpp/example-simplex-implementation.git`

After it is cloned go into the directory that was created and use this command to update all the subproject that are submodules:

`git submodule update --init --recursive --remote`

I personally use Visual Studio Code with the Cmake-tools extension by Microsoft. Using this press `F1` to get the menu and use Cmake Configure. Then it should be ready to build, debug or run.

CMakeLists.txt is an example of how to implement the simplextk library. Within the simplextk library itself, there is another CMakeLists.txt that shows how the library handles other dependancies.
