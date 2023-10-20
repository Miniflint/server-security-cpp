BINDIR  = 
BINDIR  += bin
CFLAGS  = 
CFLAGS  += -Werror -Wextra -Wall -Wno-misleading-indentation
ifeq ($(DEBUG), debug)
	CFLAGS += -fsanitize=address -g3
endif
ifeq ($(OS), Windows_NT)
	CFLAGS      += -static-libgcc -static-libstdc++ -lws2_32
	NAME        = gather_logs.exe
	REMOVEFILE  = del /Q
	CREATEDIR	= if not exist $(BINDIR) mkdir $(BINDIR)
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Darwin)
		CFLAGS      += -framework IOKit -framework CoreFoundation
		NAME        = gather_logs.out
		REMOVEFILE  = rm -f
		CREATEDIR	= test -d $(OBJDIR) || mkdir $(OBJDIR)
	else
    	$(error Your OS is not supported by this application yet $(UNAME_S).)
	endif
endif
ifneq ($(IP),)
	CFLAGS  += -DADDRESS_SERVER_PRIVAT="$(IP)"
endif
ifneq ($(PORT),)
	CFLAGS  += -DPORT_SERVER_USE="$(PORT)"
endif
TARGET	= $(BINDIR)\$(NAME)
MSRC    = src/get_logs.cpp
CC      = g++

all: $(TARGET)

$(TARGET):
	@echo -------------------------
	@echo Starting compilation
	@echo Compiling: $(IP) $(PORT)
	@$(CREATEDIR)
	$(CC) $(MSRC) $(CFLAGS) -o $@
	@echo Done

fclean:
	@echo -------------------------
	@echo Deleting executable..
	@$(REMOVEFILE) "$(TARGET)"
	@echo Done

re: fclean all

.PHONY:	fclean all re
