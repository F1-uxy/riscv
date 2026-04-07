# Toolchain
CC      = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy

# Target
TARGET  = test
SRC     = test.c
LINKER  = linker.ld

# Flags
CFLAGS  = -march=rv64i -mabi=lp64 -nostdlib -nostartfiles -ffreestanding -O0
LDFLAGS = -T $(LINKER)

# Default
all: $(TARGET).mem

$(TARGET).elf: $(SRC) $(LINKER)
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

$(TARGET).mem: $(TARGET).elf
	$(OBJCOPY) -O binary $< /dev/stdout | \
	hexdump -v -e '1/4 "%08x\n"' > $@

# Clean
clean:
	rm -f *.elf *.mem *.bin