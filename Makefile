CFLAGS 	= 
CFLAGS 	+= -Werror -Wextra -Wall -Wno-misleading-indentation
ifeq ($(DEBUG), debug)
	CFLAGS += -fsanitize=address -g3
endif
ifeq ($(OS), Windows_NT)
	CFLAGS		+= -lws2_32 -static-libstdc++ -static-libgcc
	NAME		= gather_logs.exe
	REMOVEFILE	= del
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S), Darwin)
		CFLAGS		+= -framework IOKit -framework CoreFoundation
		NAME		= gather_logs
		REMOVEFILE	= rm -f
	endif
endif
ifneq ($(IP),)
	CFLAGS += -DADDRESS_SERVER_PRIVAT="$(IP)"
endif
ifneq ($(PORT),)
	CFLAGS += -DPORT_SERVER_USE="$(PORT)"
endif
MSRC	= get_logs.cpp
CC		= g++
all: $(NAME)

$(NAME):
	@echo -------------------------
	@echo Starting compilation
	$(CC) $(MSRC) $(CFLAGS) -o $@
	@echo Done

fclean:
	@echo -------------------------
	@echo Deleting executable..
	@$(REMOVEFILE) $(NAME)
	@echo Done

re: fclean all

.PHONY:	fclean all re