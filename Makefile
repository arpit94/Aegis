OUTPUT_FILE = isodir/boot/aegis.bin
TARGET=i686-elf

NO_COLOR=\x1b[0m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m

OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[WARNINGS]$(NO_COLOR)


ECHO=echo
CAT=cat
RM=rm

.PHONY : all
all: bootloader kernel $(OUTPUT_FILE)

.PHONY : install
install: myos.iso

.PHONY : bootloader
bootloader: boot.o
.PHONY : kernel
kernel: kernel.o

boot.o: boot.s
	@$(ECHO) -n Assembling the bootloader...
	@$(TARGET)-as $^ -o $@ 2> temp.log || touch temp.errors
	@if test -e temp.errors; then $(ECHO) "$(ERROR_STRING)" && $(CAT) temp.log && false; elif test -s temp.log; then $(ECHO) "$(WARN_STRING)" && $(CAT) temp.log; else $(ECHO) "$(OK_STRING)"; fi;
	@$(RM) -f temp.errors temp.log

kernel.o: kernel.c
	@$(ECHO) -n Compiling the kernel...
	@$(TARGET)-gcc -c $^ -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	@if test -e temp.errors; then $(ECHO) "$(ERROR_STRING)" && $(CAT) temp.log && false; elif test -s temp.log; then $(ECHO) "$(WARN_STRING)" && $(CAT) temp.log; else $(ECHO) "$(OK_STRING)"; fi;
	@$(RM) -f temp.errors temp.log

$(OUTPUT_FILE): boot.o kernel.o linker.ld
	@$(ECHO) -n Linking the kernel with bootloader...
	@$(TARGET)-gcc -T $(word 3, $^) -o $@ -ffreestanding -O2 -nostdlib $(word 1, $^) $(word 2, $^) -lgcc
	@if test -e temp.errors; then $(ECHO) "$(ERROR_STRING)" && $(CAT) temp.log && false; elif test -s temp.log; then $(ECHO) "$(WARN_STRING)" && $(CAT) temp.log; else $(ECHO) "$(OK_STRING)"; fi;
	@$(RM) -f temp.errors temp.log

myos.iso:
	@$(ECHO) -n Generating the iso file...
	@grub-mkrescue -o myos.iso isodir 2> temp.log || touch temp.errors
	@if test -e temp.errors; then $(ECHO) "$(ERROR_STRING)" && $(CAT) temp.l    og && false; elif test -s temp.log; then $(ECHO) "$(WARN_STRING)" && $(CAT)     temp.log; else $(ECHO) "$(OK_STRING)"; fi;
	@$(RM) -f temp.errors temp.log

.PHONY : clean
clean:
	@$(ECHO) -n Cleaning object files...
	@$(RM) -f *.o temp.log temp.errors $(OUTPUT_FILE) myos.iso
	@$(ECHO) "$(OK_STRING)"
