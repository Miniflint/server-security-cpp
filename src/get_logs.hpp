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

// functions
int         __init_winsock(void);
void	    my_sleep(float milliseconds);
int         error_return(std::string error_str, int return_code);
int         write_to_file(std::string str_write, std::string username);

std::string get_current_username(void);
std::string get_program_name(std::string input);

#endif