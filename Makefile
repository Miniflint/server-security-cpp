BINDIR	= 
BINDIR	+= bin
CFLAGS 	= 
CFLAGS 	+= -Werror -Wextra -Wall -Wno-misleading-indentation
ifeq ($(DEBUG), debug)
	CFLAGS += -fsanitize=address -g3
endif
ifeq ($(OS), Windows_NT)
	CFLAGS		+= -static-libgcc -static-libstdc++ -lws2_32
	NAME		= gather_logs.exe
	REMOVEFILE	= del /Q
	TARGET	= $(BINDIR)\$(NAME)
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S), Darwin)
		CFLAGS		+= -framework IOKit -framework CoreFoundation
		NAME		= gather_logs
		REMOVEFILE	= rm -f
		TARGET	= $(BINDIR)/$(NAME)
	endif
endif
ifneq ($(IP),)
	CFLAGS += -DADDRESS_SERVER_PRIVAT="$(IP)"
endif
ifneq ($(PORT),)
	CFLAGS += -DPORT_SERVER_USE="$(PORT)"
endif
MSRC	= src/get_logs.cpp
CC		= g++

all: $(TARGET)

$(TARGET):
	@echo -------------------------
	@echo Starting compilation
	@if not exist $(BINDIR) mkdir $(BINDIR)
	$(CC) $(MSRC) $(CFLAGS) -o $@
	@echo Done

fclean:
	@echo -------------------------
	@echo Deleting executable..
	@echo $(REMOVEFILE) "$(TARGET)"
	@$(REMOVEFILE) "$(TARGET)"
	@echo Done

re: fclean all

.PHONY:	fclean all re