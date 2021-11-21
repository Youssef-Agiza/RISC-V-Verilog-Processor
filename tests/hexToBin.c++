#include <iostream>
#include <string>
#include <fstream>
#include <iomanip>
#include "stdlib.h"

using namespace std;
int main(){

ifstream inf;
ofstream outf;
// std::string instructions[]={"slt","slti","sltiu","sltu"};
std::string instructions[]={"jalr"};
int size=sizeof(instructions)/sizeof(instructions[0]);
for(int i=0;i<size;i++){
    std::string inst_name=instructions[i];


inf.open("dump/"+inst_name+".dump");
outf.open("hex/"+inst_name+".hex");

    if(!inf.is_open()){
        cout<<" couldn't open file";
        exit(-1);
    }
 unsigned int num;

int j=0;
 while (inf>>hex>>num)
    {    outf<<"mem["<<dec<<j++<<"]=32'h";
        outf<<hex << num<<";\n";
}

inf.close();
outf.close();

}
return 0;

}