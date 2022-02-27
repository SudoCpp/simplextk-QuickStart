#include "simplextk.hpp"

int main (int numberArguments, char* commandlineArguments[])
{
    // int main() can be called and this code removed if arguments are not needed.
    simplex::Array<simplex::string> arguments{};
    for(int argumentLoop = 0; argumentLoop < numberArguments; argumentLoop++)
        arguments.add(commandlineArguments[argumentLoop]);

    // ... Code using simplextk goes here. ...

    return 0;
}