#include "get_logs.hpp"
#include "get_logs_define.hpp"


int __init_winsock(void)
{
    #if defined(_WIN32) || defined(_WIN64)
        WSADATA wsaData;
        if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
            return (error_return("WSA Startup Failed", 1));
    #endif
        return (0);
}

void	my_sleep(float milliseconds)
{
    #if defined(_WIN32) || defined(_WIN64)
        Sleep(milliseconds);
    #else
        sleep(milliseconds / 1000);
    #endif
}


std::string get_program_name(std::string input)
{
    size_t  lastBackslashPos;
    size_t  lastSlashPos;

    lastBackslashPos = input.find_last_of('\\');
    lastSlashPos = input.find_last_of('/');
    if (lastBackslashPos != std::string::npos)
        return input.substr(lastBackslashPos + 1);
    if (lastSlashPos != std::string::npos)
        return input.substr(lastSlashPos + 1);
    else
        return input;
}

int error_return(std::string error_str, int return_code)
{
    std::string username;

    username = get_current_username();
    write_to_file(error_str, username);
    // std::cerr << error_str << std::endl;
    return (return_code);
}