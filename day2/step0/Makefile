CFLAGS=-c -m32 
LDFLAGS=--verbose
CC=i386-elf-gcc
LD=i386-elf-ld
RUN=qemu-system-i386
RFLAGS=-nographic
LDSCRIPT=linker.x

TARGET=boot.img
OBJS=boot.o

.PHONY: clean

.s.o:
	$(CC) $(CFLAGS) $< -o $@

$(TARGET): $(OBJS) Makefile $(LDSCRIPT)
	$(LD) $(LDFLAGS) $(OBJS) -o $@ -T $(LDSCRIPT)

clean:
	rm -f *.o

run: $(TARGET)
	$(RUN) $(RFLAGS) -fda $<
