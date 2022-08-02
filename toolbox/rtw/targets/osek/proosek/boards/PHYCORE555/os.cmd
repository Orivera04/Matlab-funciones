
MEMORY
{
     /* Exception Vector Table sections */
     except_0000 : org = 0x0000, len = 0x100
     except_0100 : org = 0x0100, len = 0x100
     except_0200 : org = 0x0200, len = 0x200
     except_0300 : org = 0x0300, len = 0x100
     except_0400 : org = 0x0400, len = 0x100
     except_0500 : org = 0x0500, len = 0x100
     except_0600 : org = 0x0600, len = 0x100
     except_0700 : org = 0x0700, len = 0x100
     except_0800 : org = 0x0800, len = 0x100
     except_0900 : org = 0x0900, len = 0x100
     except_0A00 : org = 0x0A00, len = 0x100
     except_0B00 : org = 0x0B00, len = 0x100
     except_0C00 : org = 0x0C00, len = 0x100
     except_0D00 : org = 0x0D00, len = 0x100
     except_0E00 : org = 0x0E00, len = 0x100
     except_0F00 : org = 0x0F00, len = 0x100
     except_1000 : org = 0x1000, len = 0x100
     except_1100 : org = 0x1100, len = 0x100
     except_1200 : org = 0x1200, len = 0x100
     except_1300 : org = 0x1300, len = 0x100
     except_1400 : org = 0x1400, len = 0x100
     except_1500 : org = 0x1500, len = 0x100
     except_1600 : org = 0x1600, len = 0x100
     except_1700 : org = 0x1700, len = 0x100
     except_1800 : org = 0x1800, len = 0x100
     except_1900 : org = 0x1900, len = 0x100
     except_1A00 : org = 0x1A00, len = 0x100
     except_1B00 : org = 0x1B00, len = 0x100
     except_1C00 : org = 0x1C00, len = 0x100
     except_1D00 : org = 0x1D00, len = 0x100
     except_1E00 : org = 0x1E00, len = 0x100
     except_1F00 : org = 0x1F00, len = 0x100

    /******************************************************
     * RAM and ROM memory regions:
     *
     * This linker file shows some examples of different memory 
     * maps that can be chosen. The default map can be used for
     * either a FLASHable image or loading into RAM.
     * The naming convention is to call the read-only sections
     * 'rom' and the read/write sections 'ram'.
     *****************************************************/
     /* DEFAULT memory map: Put 'ram_as_rom' region at address:
        0 + 0x2000(account for above vector table). This map allows 
        placement in either on-chip FLASH or external RAM
        depending upon FLEN bit in IMMR. Note, to use external RAM,
        CS1 is setup using BR1/OR1 registers in the procinit.c
        function of the BSP, but when FLEN is 1, the processor
        ignores this and maps addresses 0 to 0x2fbfff to on-chip
        flash. Additionally, 'ram' is placed in on-chip RAM(26KB)
        to allow image to be used from RAM or FLASH. */
     rom : org = 0x2000,    len = 0x3e000
     ram : org = 0x3f9800,  len = 0x6800 

     /* 256K(0x40000) Off-chip RAM memory map, divided evenly
        between 'ram_as_rom' and 'ram' sections.
     rom : org = 0x2000,    len = 0x1e000
     ram : org = 0x20000,  len = 0x20000 */

     /* 1MB(0x100000) Off-chip RAM memory map, divided evenly
        between 'ram_as_rom' and 'ram' sections. Also, ensure
        solder connections on J18 of phycore daughter board
        are setup per Table 5 in Phycore manual.
     rom : org = 0x2000,   len = 0x7e000
     ram : org = 0x80000,  len = 0x80000 */
}


SECTIONS
{
	.debug_abbrev 0 : { *(.debug_abbrev) } 
	.debug_info 0 : { *(.debug_info) }
	.debug_line 0 : { *(.debug_line) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	.debug_aranges 0 : { *(.debug_aranges) }

	.sdata2 : { _SDA2_BASE = . + 32768; *(.sdata2) } > rom
	.sbss2 : { *(.sbss2) } > rom
 	.text : { *(.text) } > rom
	.rodata : { *(.rodata) } > rom
	.got : { *(.got) } > rom
	.init : { *(.init) } > rom
	_INIT_ = .;
	.bss : { _BSS_START_ = .; *(.bss) } > ram
	.sbss : { _SDA_BASE_ = . + 32768; *(.sbss) ; _BSS_END_ = .; } > ram
	.sdata : AT(_INIT_) { _DATA_START_ = . ; *(.sdata) } > ram
	.data : AT(_INIT_ + ADDR(.data)-ADDR(.sdata)) { *(.data); _DATA_END_ = . ; } > ram

	.start : { *(.start) } > except_0100
	.vect : { *(.vect) } > except_0500

	.decrementer : { *(.decrementer) } > except_0900

	.except_0000 : { *(.except_0000) } > except_0000

	.except_0200 : { *(.except_0200) } > except_0200
	.except_0300 : { *(.except_0300) } > except_0300
	.except_0400 : { *(.except_0400) } > except_0400

	.except_0600 : { *(.except_0600) } > except_0600
	.except_0700 : { *(.except_0700) } > except_0700
	.except_0800 : { *(.except_0800) } > except_0800

	.except_0A00 : { *(.except_0A00) } > except_0A00
	.except_0B00 : { *(.except_0B00) } > except_0B00
	.except_0C00 : { *(.except_0C00) } > except_0C00
	.except_0D00 : { *(.except_0D00) } > except_0D00
	.except_0E00 : { *(.except_0E00) } > except_0E00
	.except_0F00 : { *(.except_0F00) } > except_0F00
	.except_1000 : { *(.except_1000) } > except_1000
	.except_1100 : { *(.except_1100) } > except_1100
	.except_1200 : { *(.except_1200) } > except_1200
	.except_1300 : { *(.except_1300) } > except_1300
	.except_1400 : { *(.except_1400) } > except_1400
	.except_1500 : { *(.except_1500) } > except_1500
	.except_1600 : { *(.except_1600) } > except_1600
	.except_1700 : { *(.except_1700) } > except_1700
	.except_1800 : { *(.except_1800) } > except_1800
	.except_1900 : { *(.except_1900) } > except_1900
	.except_1A00 : { *(.except_1A00) } > except_1A00
	.except_1B00 : { *(.except_1B00) } > except_1B00
	.except_1C00 : { *(.except_1C00) } > except_1C00
	.except_1D00 : { *(.except_1D00) } > except_1D00
	.except_1E00 : { *(.except_1E00) } > except_1E00
	.except_1F00 : { *(.except_1F00) } > except_1F00



}
