	.set noreorder
	.global start
	.ent    start
# IPL entrypoint is 0x40F0000 for 0.7.0+ 0x8400000 for older
# 0xBFE00000 is the start of the Tachyon Shared Memory (0x1D600000 on CP side), 0x200000 in length; Only available on Development Tools; Original kbooti loads at that address.
start:
# test register poke; sets 0xBE240004 to non zero to force service mode, unfortunately this register is read only, making this useless in its current form. uncomment to enable this patch.

#lui     $t5, 0xBE24
#li $t6, 0x10
#sw $t6, 4($t5)

# Fake register poke; this writes 0x10 at 0xBFEF00004, this allows in conjunction with a patch to fake service mode on retail Lib-PSP iplloader; uncomment to enable this patch

#lui     $t5, 0xBFEF
#li $t6, 0x10
#sw $t6, 4($t5)

# Copies decrypted Lib-PSP iplloader from 0xBFE02000 to 0xBFC00000 and jumps to that address

    li      $t0, 0xBFE02000   #boot vector/Lib-PSP iplloader loader code
    addiu   $t3, $t0, 0x1000 #don't go over 0x1000 bytes at a time
    li      $t1, 0xBFC00000 #Lib-PSP iplloader Loader entry point.
loop:
    lw      $t2, 0($t0)
    sw      $t2, 0($t1)
    addiu   $t0, 4
    bne     $t3, $t0, loop
    addiu   $t1, 4

# Stores 0xBFC00000 to register 29 and jumps to it.
	li      $29, 0xBFC00000
    jr      $29
    nop
	
   .end start
	.set reorder
