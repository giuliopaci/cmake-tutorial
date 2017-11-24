# Standard .c -> .o compilation command
%.o: %.c
	$(CC) -c $(<) -o $(@) -Iinclude

STATIC_LINKER  := $(AR) qc
DYNAMIC_LINKER := $(CC) -shared

# Default target
all: main main2 main3 main4 libphw.a libphw-shared.so

# Compile main - BEGIN

MAIN_SOURCES  := main.c
MAIN_OBJECTS  := $(MAIN_SOURCES:.c=.o)

main: $(MAIN_OBJECTS) $(MAIN_SOURCES)
	$(CC) $(MAIN_OBJECTS) -o $(@)

clean::
	$(RM) -f main $(MAIN_OBJECTS)

# Compile main - END

# Compile main2 - BEGIN

MAIN2_SOURCES := main2.c simple_print_hello_world.c include/simple_print_hello_world.h
MAIN2_OBJECTS := $(filter %.o,$(MAIN2_SOURCES:.c=.o))

main2: $(MAIN2_OBJECTS) $(MAIN2_SOURCES)
	$(CC) $(MAIN2_OBJECTS) -o $(@)

clean::
	$(RM) -f main2 $(MAIN2_OBJECTS)

# Compile main2 - END

# Compile libphw.a - BEGIN

PHW_SOURCES   := print_hello_world.c include/print_hello_world.h
PHW_OBJECTS   := $(filter %.o,$(PHW_SOURCES:.c=.o))

libphw.a: $(PHW_OBJECTS) $(PHW_SOURCES)
	$(STATIC_LINKER) $(@) $(PHW_OBJECTS)

clean::
	$(RM) -f libphw.a $(PHW_OBJECTS)

# Compile libphw.a - END

# Compile main3 - BEGIN

MAIN3_SOURCES := main3.c include/simple_print_hello_world.h
MAIN3_LIBS    := libphw.a
MAIN3_OBJECTS := $(filter %.o,$(MAIN3_SOURCES:.c=.o))

main3: $(MAIN3_OBJECTS) $(MAIN3_SOURCES) $(MAIN3_LIBS)
	$(CC) $(MAIN3_OBJECTS) $(MAIN3_LIBS) -o $(@)

clean::
	$(RM) -f main3 $(MAIN3_OBJECTS)

# Compile main3 - END

# Compile libphw-shared.so - BEGIN

PHW_SHARED_SOURCES   := print_hello_world.c include/print_hello_world.h
PHW_SHARED_OBJECTS   := $(addprefix shared-objs-, $(filter %.o,$(PHW_SHARED_SOURCES:.c=.o)))

# Shared objects .c -> .o compilation command
shared-objs-%.o: %.c
	$(CC) -c $(<) -fPIC -o $(@) -Iinclude

libphw-shared.so: $(PHW_SHARED_OBJECTS) $(PHW_SHARED_SOURCES)
	$(DYNAMIC_LINKER) -o $(@) $(PHW_SHARED_OBJECTS)

clean::
	$(RM) -f libphw-shared.so $(PHW_SHARED_OBJECTS)

# Compile libphw-shared.so - END

# Compile main4 - BEGIN

MAIN4_SOURCES := main3.c include/simple_print_hello_world.h
MAIN4_LIBS    := libphw-shared.so
MAIN4_OBJECTS := $(filter %.o,$(MAIN4_SOURCES:.c=.o))

main4: $(MAIN3_OBJECTS) $(MAIN4_SOURCES) $(MAIN4_LIBS)
	$(CC) $(MAIN4_OBJECTS) $(MAIN4_LIBS) -o $(@)

clean::
	$(RM) -f main4 $(MAIN4_OBJECTS)

# Compile main4 - END

# Makefile behaviour targets

.PHONY: clean all
.DELETE_ON_ERRORS:
