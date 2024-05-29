/* kernel/kernel.ld */
OUTPUT_FORMAT(elf32-i386)
ENTRY(init_pm)

SECTIONS {
    . = 0x00100000;

    .text BLOCK(4K) : ALIGN(4K) {
        *(.text)
    }

    .rodata ALIGN(4K) : {
        *(.rodata)
    }

    .data ALIGN(4K) : {
        *(.data)
    }

    .bss ALIGN(4K) : {
        *(COMMON)
        *(.bss)
    }
}
