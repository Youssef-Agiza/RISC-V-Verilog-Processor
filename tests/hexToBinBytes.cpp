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
    std::string in_file = argv[1], out_file = argv[2]; //assign output file path here
    const std::string in_folder = "hexdeciaml_dump", out_folder = "memory_initialization";
    std::ifstream ins(in_folder + "/" + in_file);
    std::ofstream outs(out_folder + "/" + out_file);
    if (!ins.is_open() || !outs.is_open())
    {
        std::cout << "Couldn't Open the file for reading\n";
        exit(1);
    }

    // freopen(out_file, "w", stdout);
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
