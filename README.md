Lib-PSP iplloader Bootstraper for DTP-T1000

This tool allows you to bootstrap a DECRYPTED Lib-PSP iplloader (aka pre-ipl)

How it works: 

It will decrypt/load and jump to an IPL block that itself stores 0xbfe01100 to a register and jumps to it

0xbfe01100 contains instructions that will copy 0x1000 from 0xbfe02000 to 0xbfc00000 and jump there

0xbfe02000 contains the decrypted pre-ipl code

More information on Lib-PSP iplloader 

https://playstationdev.wiki/pspdevwiki/index.php?title=PRE-IPL (the page has been taken down, a previous version of it is backupped is here: https://web.archive.org/web/20180906001636/https://www.pspdevwiki.com/wiki/PRE-IPL and here: https://drive.google.com/open?id=1ZIVlyj0bX5Twj-eUAwdkvIXZAUOcEjnvFGrGUZAawio


If you wonder what a DTP-T1000 is and what development SKUs are available, a backup of the old SKU model page is available here: 

https://web.archive.org/web/20180903223627/https://www.pspdevwiki.com/wiki/SKU_Models and here: 
https://drive.google.com/open?id=19a7AZMWZ4IZ99fJYEwT3uJHZnAB4VPdgiAD3_MT60YE

For further details you may also want to look into this project: https://github.com/mathieulh/DTP-T1000-Pre-IPL-dumper

Requirements: 

- A DTP-T1000 or a DEM-1000 unit.
- Knowing your way around an hexadecimal editor


How to:


1. Build the bootstraper shellcode accordingly (comment or uncomment the patches you want, alternatively a prebuilt version is available)
2. Build the jr_0xbfe01100 shellcode or use one of the encrypted pre-built IPL blocks in the ipl_blocks folder (jr_0xbfe01100_0.6.0.bin is for Lib-PSP iplloader 0.6.0 and below; jr_0xbfe01100_0.7.0+.bin is for Lib-PSP iplloader 0.7.0 and higher)
3. Copy your Lib-PSP iplloader of choice (I would recommend using the version 0.4.0 as higher versions (especially 0.7.0+) write to a bunch of registers and you may want those untouched., Lib-PSP iplloader are located at the first 0x1000 bytes of kbooti.bin/dformati.bin/formati.bin/write*.bin/initi.bin/bootdispi.bin...
4. Copy the encrypted pre-built IPL block (or one you built and encrypted yourself) to 0x1000
5. Copy the built (decrypted) bootstraper shellcode to 0x1100
6. Copy your DECRYPTED (that's the whole point, right?) Lib-PSP iplloader to 0x2000
7. Profit! 

A few notes to take into consideration: 

* If your attempt is to run the retail Lib-PSP iplloader on your development kit, while this is possible, know that 0xBFD00000 is an illegal address range on Development Tools, 
you will need to patch the 3 references (found on Tachyon0x01400000 and Tachyon0x00400000 builds) to a valid address on development kits (such as 0xBFC00000) otherwise it won't run.

* Service mode only exists on retail Lib-PSP iplloader (DTP-T1000 and DEM-1000 units have an equivalent out of the box), it is enabled through the following c heck if ((*(u32 *)0xbe240004) & 0x10)
{
    use memory stick ipl routines;
}
else
{
   use nand ipl routines;
}

The 0xbe240004 is read only and can only be enabled through syscon, it is however possible to bypass this by patching the register address (or the check itself) in the pre-ipl; I personally set it to read 0xbfef00004
because 0xBFD* is an illegal range, no publicly available Pandora MS IPL, including the time attacked IPL block are compatible, you may however craft your own IPL using ipltool (see here: https://github.com/zecoxao/ipltool) and the IPL SDK (https://github.com/mathieulh/PSP_IPL_SDK)

* If you want to use a DEM-1000/DTP-T1000 decrypted kbooti (you can dump them using the project here: https://github.com/mathieulh/DTP-T1000-Pre-IPL-dumper
you need to understand that unless you change the IPL read address to something other than 0xBFE01000, Lib-PSP iplloader will go into an infinite loop.
I typically set it to 0xBFE03000 and write my (legit) IPL at 0x3000 in the file and I reserve anything below 0x3000 to the encrypted Lib-PSP iplloader+bootstrapper+decrypted Lib-PSP iplloader combo

Feel free to use one of the provided ips patches if for some reason you can't manage to patch the IPL on your own. (you will need to write the result at 0x2000 in your file)



