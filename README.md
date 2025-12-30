This repository contains my hands-on practice with low-level programming, including:

          BIOS programming and interrupts
          
          Bootloader development in x86 assembly
          
          Keyboard and screen handling at the bare-metal level
          
          Basic OS concepts and memory management

The goal is to learn firmware, bootloaders, and operating system fundamentals from scratch, working directly with hardware and BIOS interfaces.



**DAY 6:**
**🧠 Multi-Stage x86 Bootloader (16-bit Real Mode)**

This project implements a multi-stage x86 bootloader written entirely in 16-bit assembly, designed to run in BIOS real mode and tested using QEMU.

The boot process is split into independent stages to demonstrate how early system software is loaded from disk and executed step-by-step.

🔹 Stage 1 – Boot Sector (512 bytes)

          Loaded by BIOS at 0x7C00
          
          Initializes segment registers and stack
          
          Prints a status message using BIOS INT 0x10
          
          Reads the next sector from disk using INT 0x13
          
          Transfers execution to Stage-2 using a far jump
          
          Preserves the BIOS-provided boot drive (DL), which is mandatory for disk access
          
          This stage strictly adheres to the 512-byte boot sector limit and ends with the 0xAA55 boot signature.

🔹 Stage 2 – Second-Stage Loader

          Loaded at a higher memory address (0x8000)
          
          Executes independently of Stage-1
          
          Prints confirmation message to verify successful disk loading
          
          Acts as a foundation for further expansion (Stage-3, kernel loader, etc.)

🔹Stage 3 – Extension Stage


🛠 Build & Run

          nasm -f bin boot.asm -o boot.bin
          
          nasm -f bin stage2.asm -o stage2.bin
          
          dd if=/dev/zero of=os.img bs=512 count=2880
          
          dd if=boot.bin  of=os.img conv=notrunc
          
          dd if=stage2.bin of=os.img bs=512 seek=1 conv=notrunc
          
          dd if=stag32.bin of=os.img bs=512 seek=2 conv=notrunc
          
          qemu-system-i386 -fda os.img

**Day 7**-E820 Memory Map

stage2.asm: This contains Stage 2 of a custom x86 bootloader written in 16-bit assembly. It prints a message and reads the BIOS memory map (E820) to identify usable and reserved memory.


          Prints "NOW IN SECOND" to the screen.
          
          Calls BIOS E820 to read memory descriptors.
          
          Loops through all entries and prints their type:

                    1 → Usable RAM
                    
                    2 → Reserved

**How to Run?**

Assemble with NASM:

          nasm -f bin stage2.asm -o stage2.bin


Test in QEMU:

          qemu-system-i386 -fda stage2.bin

**Notes:**

          Only type 1 memory is safe to use.
          
          EBX is preserved across calls; do not reset it.
          
          The buffer currently holds one descriptor; storing all entries is planned next.
