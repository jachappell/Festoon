PROG=festoon
OBJDIR=.obj
CC=gcc
DESTINATION=/usr/local

CFLAGS = -Wall 
LDFLAGS = 

$(shell mkdir -p $(OBJDIR)) 

OBJS = $(OBJDIR)/fest.o

$(PROG) : $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $(PROG)

-include $(OBJS:.o=.d)

$(OBJDIR)/%.o: %.c
	$(CC) -c $(CFLAGS) $*.c -o $(OBJDIR)/$*.o
	$(CC) -MM $(CFLAGS) $*.c > $(OBJDIR)/$*.d
	@mv -f $(OBJDIR)/$*.d $(OBJDIR)/$*.d.tmp
	@sed -e 's|.*:|$(OBJDIR)/$*.o:|' < $(OBJDIR)/$*.d.tmp > $(OBJDIR)/$*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $(OBJDIR)/$*.d.tmp | fmt -1 | \
	  sed -e 's/^ *//' -e 's/$$/:/' >> $(OBJDIR)/$*.d
	@rm -f $(OBJDIR)/$*.d.tmp

clean:
	rm -rf $(PROG) $(OBJDIR)

install:
	cp festoon $(DESTINATION)/games
	cp festoon.6 $(DESTINATION)/man/man6
