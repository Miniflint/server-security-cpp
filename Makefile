CFLAGS	= 
DFLAGS	=
ifeq ($(DEBUG), debug)
	CFLAGS += -fsanitize=address -g3
endif
ifeq ($(OS), Windows_NT)
	CFLAGS		= -static-libgcc -static-libstdc++ -lws2_32
	NAME		= gather_logs.exe
	REMOVEFILE 	= del /f /q
	BINDIR		= bin
	OBJDIR		= objects
	CREATEBIN	= if not exist $(BINDIR) mkdir $(BINDIR)
	CREATEOBJ	= if not exist $(OBJDIR) mkdir $(OBJDIR)
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Darwin)
		CFLAGS		= -framework IOKit -framework CoreFoundation
		NAME		= gather_logs.out
		REMOVEFILE 	= rm -rf
		BINDIR		= bin
		OBJDIR		= objects
		CREATEBIN	= test -d $(BINDIR) || mkdir $(BINDIR)
		CREATEOBJ	= test -d $(OBJDIR) || mkdir $(OBJDIR)
	else
		$(error Your OS is not supported by this application yet $(UNAME_S).)
	endif
endif
ifneq ($(IP),)
    $(info Compiling with: $(IP).)
	DFLAGS  += -DADDRESS_SERVER_PRIVAT="$(IP)"
endif
ifneq ($(PORT),)
    $(info Compiling with: $(PORT).)
	DFLAGS  += -DPORT_SERVER_USE="$(PORT)"
endif

CC		= g++
FLAGS	= -Werror -Wextra -Wall -Wno-misleading-indentation
SRCDIR	= src
MSRC	= $(SRCDIR)/get_logs.cpp
OBJS	= $(strip $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o, $(MSRC)))
TARGET	= $(BINDIR)/$(NAME)

all: $(TARGET)

$(TARGET): $(OBJS) | $(BINDIR)
	@echo -------------------------
	@echo Starting compilation
	@$(CC) $(OBJS) $(DFLAGS) -o $@ $(CFLAGS)
	@echo Done

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR)
	@echo -------------------------
	@echo Creating objects files
	@$(CC) $(FLAGS) $(DFLAGS) -c $< -o $@
	@echo Done

$(OBJDIR):
	@$(CREATEOBJ)

$(BINDIR):
	@$(CREATEBIN)

clean:
	@echo -------------------------
	@echo Deleting objects files..
	@$(REMOVEFILE) $(OBJDIR)
	@echo Done	

fclean: clean
	@echo -------------------------
	@echo Deleting executable..
	@$(REMOVEFILE) $(BINDIR)
	@echo Done

re: fclean all

.PHONY:	 all re clean fclean
