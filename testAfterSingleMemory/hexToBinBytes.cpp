#include <fstream>
#include <iostream>
#include <vector>
#include <string>

std::string toStr(int n)
{
    return std::to_string(n);
}
int main(int argc, char *argv[])
{
    // if (argc < 3)
    // {
    //     std::cout << "Invalid number of arguments\n";
    //     exit(1);
    // }
    std::string input_file_name = argv[1];  //assign input file path here
    std::string output_file_name = argv[2]; //assign output file path here

    std::ifstream ins(input_file_name);
    std::ofstream outs(output_file_name);
    if (!ins.is_open() || !outs.is_open())
    {
        std::cout << "Couldn't Open the file for reading\n";
        exit(1);
    }

    // freopen(output_file_name, "w", stdout);
    int count = 0;
    std::string inputStr;
    inputStr = "{mem[" + toStr(count + 3) + "], mem[" + toStr(count + 2) + "], mem[" + toStr(count + 1) + "], mem[" + toStr(count) + "]} = 32'h13;";
    outs << inputStr << std::endl;
    count += 4;
    while (!ins.eof())
    {
        std::getline(ins, inputStr);
        inputStr = "{mem[" + toStr(count + 3) + "], mem[" + toStr(count + 2) + "], mem[" + toStr(count + 1) + "], mem[" + toStr(count) + "]} = 32'h" + inputStr + ";";
        outs << inputStr << std::endl;
        count += 4;
    }
}
