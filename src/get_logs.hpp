// guard
#ifndef GET_LOGS_HPP
# define GET_LOGS_HPP

# if defined(_WIN32) || defined(_WIN64)
#  include <winsock2.h>
#  include <windows.h>
#  include <Lmcons.h>
#  ifndef ISWINDOWS
#   define ISWINDOWS 1
#  endif
# else
#  include <arpa/inet.h>
#  include <cstdlib>
#  include <IOKit/IOKitLib.h>
#  include <pwd.h>
#  include <unistd.h>
#  ifndef ISWINDOWS
#   define ISWINDOWS 0
#  endif
# endif

// INCLUDES
# include <time.h>
# include <iostream>
# include <fstream>
# include <typeinfo>

// USEFUL
#define VAL(str) #str
#define TOSTRING(str) VAL(str)

#endif