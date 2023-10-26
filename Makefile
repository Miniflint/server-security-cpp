DFLAGS	=

$(info -------------------------)
ifeq ($(OS), Windows_NT)
    $(info Target set to WINDOWS.)
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
    	$(info Target set to MACOS.)
		CFLAGS		= -framework IOKit -framework CoreFoundation
		NAME		= gather_logs.out
		REMOVEFILE 	= rm -rf
		BINDIR		= bin
		OBJDIR		= objects
		CREATEBIN	= test -d $(BINDIR) || mkdir $(BINDIR)
		CREATEOBJ	= test -d $(OBJDIR) || mkdir $(OBJDIR)
		ifeq ($(DEBUG), debug)
			DFLAGS += -fsanitize=address -g3
		endif
	else
		$(error Your OS is not supported by this application yet $(UNAME_S).)
	endif
endif
ifneq ($(IP),)
    $(info Compiling with: IP=$(IP))
	DFLAGS  += -DADDRESS_SERVER_PRIVAT="$(IP)"
endif
ifneq ($(PORT),)
    $(info Compiling with: PORT=$(PORT))
	DFLAGS  += -DPORT_SERVER_USE="$(PORT)"
endif

$(info -------------------------)

CC		= g++
FLAGS	= -Werror -Wextra -Wall -Wno-misleading-indentation
SRCDIR	= src
MSRC	= $(SRCDIR)/get_logs.cpp $(SRCDIR)/utils_get_logs.cpp
OBJS	= $(strip $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o, $(MSRC)))
TARGET	= $(BINDIR)/$(NAME)

all: $(TARGET)

$(TARGET): $(OBJS) | $(BINDIR)
	@echo Starting compilation
	@$(CC) $(OBJS) $(DFLAGS) -o $@ $(CFLAGS)
	@echo Done
	@echo -------------------------

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR)
	@$(CC) $(FLAGS) $(DFLAGS) -c $< -o $@ 

$(OBJDIR):
	@$(CREATEOBJ)

$(BINDIR):
	@$(CREATEBIN)

clean:
	@echo Deleting objects files..
	@$(REMOVEFILE) $(OBJDIR)
	@echo Done
	@echo -------------------------

fclean: clean
	@echo Deleting executable..
	@$(REMOVEFILE) $(BINDIR)
	@echo Done
	@echo -------------------------

re: fclean all

.PHONY:	 all re clean fclean
