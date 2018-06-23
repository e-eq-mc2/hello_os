CC=i386-elf-gcc
LD=i386-elf-ld
RUN=qemu-system-i386

CFLAGS=-c -m32 -O0
LDFLAGS=-nostdlib -nostdinc --verbose
#RFLAGS=-nographic
RFLAGS=-localtime -vga std

TARGET=fd.img
TARGET_IPL=ipl.img
TARGET_HEAD=head.img
TARGET_BOOTPACK=bootpack.img
TARGET_OS=os.img

OBJS_IPL=ipl.o
OBJS_HEAD=head.o
OBJS_BOOTPACK=bootpack.o func.o

LDSCRIPT_IPL=ipl.x
LDSCRIPT_HEAD=head.x
LDSCRIPT_BOOTPACK=bootpack.x

.PHONY: clean

all: $(TARGET)

.s.o:
	$(CC) $(CFLAGS) $< -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@

$(TARGET_IPL): $(OBJS_IPL) Makefile $(LDSCRIPT_IPL)
	$(LD) $(LDFLAGS) $(OBJS_IPL) -o $@ -T $(LDSCRIPT_IPL)

$(TARGET_HEAD): $(OBJS_HEAD) Makefile $(LDSCRIPT_HEAD)
	$(LD) $(LDFLAGS) $(OBJS_HEAD) -o $@ -T $(LDSCRIPT_HEAD)

$(TARGET_BOOTPACK): $(OBJS_BOOTPACK) Makefile $(LDSCRIPT_BOOTPACK)
	$(LD) $(LDFLAGS) $(OBJS_BOOTPACK) -o $@ -T $(LDSCRIPT_BOOTPACK)

$(TARGET): $(TARGET_IPL) $(TARGET_HEAD) $(TARGET_BOOTPACK)
	#mformat -f 1440 -C -B $(TARGET_IPL) -i $(TARGET) ::
	#mcopy -i $(TARGET) $(TARGET_HEAD) ::
	cp $(TARGET_IPL) $@
	cat $(TARGET_HEAD) $(TARGET_BOOTPACK) > $(TARGET_OS) 
	cat $(TARGET_OS) | dd of=$@ bs=1 seek=0x004200 conv=notrunc

clean:
	rm -f *.o
	rm -f *.img

run: $(TARGET)
	$(RUN) $(RFLAGS) -fda $<
