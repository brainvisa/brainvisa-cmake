
%Module brainvisa-cmake_tutorialsip

%Import aims.sip

namespace brainvisa-cmake_tutorial {

class Date
{
%TypeHeaderCode
#include <brainvisa-cmake_tutorial/brainvisa-cmake_tutorial.h>
%End
public:

  Date( int day, int month, int year );
  std::string str();

  int day;
  int month;
  int year;
};

}; // namespace brainvisa-cmake_tutorial
