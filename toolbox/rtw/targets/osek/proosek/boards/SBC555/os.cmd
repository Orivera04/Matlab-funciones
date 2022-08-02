
MEMORY
{
ram : org = 0x3f9800, l = 0x6800
rom : org = 0x002000, len = 0x6e000
vectab : org = 0x500, len = 0x100
decr : org = 0x900, len = 0x100
reset : org = 0x100, len = 0x100
}


SECTIONS
{
	.debug_abbrev 0 : { *(.debug_abbrev) } 
	.debug_info 0 : { *(.debug_info) }
	.debug_line 0 : { *(.debug_line) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	.debug_aranges 0 : { *(.debug_aranges) }
	.start : { *(.start) } > reset
	.vect : { *(.vect) } > vectab
	.dec : { *(.dec) } > decr
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
}

