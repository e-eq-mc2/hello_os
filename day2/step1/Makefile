CFLAGS=-c -m32 
LDFLAGS=--verbose
CC=i386-elf-gcc
LD=i386-elf-ld
CAT=cat
RUN=qemu-system-i386
RFLAGS=-nographic
LDSCRIPT_BOOT=linker_boot.x
LDSCRIPT_EPILOGUE=linker_epilogue.x

TARGET=os.img
TARGET_BOOT=boot.img
TARGET_EPILOGUE=epilogue.img

OBJS_BOOT=boot.o
OBJS_EPILOGUE=epilogue.o

.PHONY: clean

all: $(TARGET)

.s.o:
	$(CC) $(CFLAGS) $< -o $@

$(TARGET_BOOT): $(OBJS_BOOT) Makefile $(LDSCRIPT_BOOT)
	$(LD) $(LDFLAGS) $(OBJS_BOOT) -o $@ -T $(LDSCRIPT_BOOT)

$(TARGET_EPILOGUE): $(OBJS_EPILOGUE) Makefile $(LDSCRIPT_EPILOGUE)
	$(LD) $(LDFLAGS) $(OBJS_EPILOGUE) -o $@ -T $(LDSCRIPT_EPILOGUE)

$(TARGET): $(TARGET_BOOT) $(TARGET_EPILOGUE)
	$(CAT) $^ > $@


clean:
	rm -f *.o
	rm -f *.img

run: $(TARGET)
	$(RUN) $(RFLAGS) -fda $<
