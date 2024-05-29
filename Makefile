# Makefile
ISO = simple-os.iso
CC = i686-elf-gcc
LD = i686-elf-ld
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T kernel/kernel.ld

all: $(ISO)

kernel/kernel.bin: boot/boot.o kernel/kernel.o
	$(LD) $(LDFLAGS) -o $@ $^

boot/boot.o: boot/boot.asm
	nasm -f elf32 $< -o $@

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

$(ISO): kernel/kernel.bin
	mkdir -p iso/boot/grub
	cp kernel/kernel.bin iso/boot/kernel.bin
	cp iso/grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) iso

clean:
	rm -rf iso
	rm -f boot/*.o kernel/*.o kernel/kernel.bin $(ISO)
