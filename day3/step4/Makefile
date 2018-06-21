CFLAGS=-c -m32 
LDFLAGS=--verbose
CC=i386-elf-gcc
LD=i386-elf-ld
RUN=qemu-system-i386
RFLAGS=-nographic
#RFLAGS=-localtime -vga std -fda $<

TARGET=fd.img
TARGET_IPL=ipl.img
TARGET_OS=os.img

OBJS_IPL=ipl.o
OBJS_OS=os.o

LDSCRIPT_IPL=ipl.x
LDSCRIPT_OS=os.x

.PHONY: clean

all: $(TARGET)

.s.o:
	$(CC) $(CFLAGS) $< -o $@

$(TARGET_IPL): $(OBJS_IPL) Makefile $(LDSCRIPT_IPL)
	$(LD) $(LDFLAGS) $(OBJS_IPL) -o $@ -T $(LDSCRIPT_IPL)

$(TARGET_OS): $(OBJS_OS) Makefile $(LDSCRIPT_OS)
	$(LD) $(LDFLAGS) $(OBJS_OS) -o $@ -T $(LDSCRIPT_OS)

$(TARGET): $(TARGET_IPL) $(TARGET_OS)
	#mformat -f 1440 -C -B $(TARGET_IPL) -i $(TARGET) ::
	#mcopy -i $(TARGET) $(TARGET_OS) ::
	cp $(TARGET_IPL) $@
	cat $(TARGET_OS) | dd of=$@ bs=1 seek=0x004200 conv=notrunc

clean:
	rm -f *.o
	rm -f *.img

run: $(TARGET)
	$(RUN) $(RFLAGS) -fda $<
