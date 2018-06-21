CFLAGS=-c -m32 
LDFLAGS=--verbose
CC=i386-elf-gcc
LD=i386-elf-ld
RUN=qemu-system-i386
#RFLAGS=-nographic
RFLAGS=
LDSCRIPT_BOOT=linker_boot.x
LDSCRIPT_EPILOGUE=linker_epilogue.x
LDSCRIPT_OS=linker_os.x

TARGET=disk.img
TARGET_BOOT=boot.img
TARGET_EPILOGUE=epilogue.img
TARGET_OS=os.img

OBJS_BOOT=boot.o
OBJS_EPILOGUE=epilogue.o
OBJS_OS=os.o

.PHONY: clean

all: $(TARGET)

.s.o:
	$(CC) $(CFLAGS) $< -o $@

$(TARGET_BOOT): $(OBJS_BOOT) Makefile $(LDSCRIPT_BOOT)
	$(LD) $(LDFLAGS) $(OBJS_BOOT) -o $@ -T $(LDSCRIPT_BOOT)

$(TARGET_EPILOGUE): $(OBJS_EPILOGUE) Makefile $(LDSCRIPT_EPILOGUE)
	$(LD) $(LDFLAGS) $(OBJS_EPILOGUE) -o $@ -T $(LDSCRIPT_EPILOGUE)

$(TARGET_OS): $(OBJS_OS) Makefile $(LDSCRIPT_OS)
	$(LD) $(LDFLAGS) $(OBJS_OS) -o $@ -T $(LDSCRIPT_OS)

$(TARGET): $(TARGET_BOOT) $(TARGET_EPILOGUE) $(TARGET_OS)
	#mformat -f 1440 -C -B $(TARGET_BOOT) -i $(TARGET) ::
	#mcopy -i $(TARGET) $(TARGET_OS) ::
	cat $(TARGET_BOOT) $(TARGET_EPILOGUE) > $@
	cat $(TARGET_OS) | dd of=$@ bs=1 seek=0x004200 conv=notrunc

clean:
	rm -f *.o
	rm -f *.img

run: $(TARGET)
	#$(RUN) $(RFLAGS) -localtime -vga std -fda $<
	$(RUN) $(RFLAGS) -nographic -fda $<
