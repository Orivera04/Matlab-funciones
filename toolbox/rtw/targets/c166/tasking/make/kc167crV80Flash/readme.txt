Additional Steps To Configure EDE For Flash Build on Phytec kitCON-C167CR
-------------------------------------------------------------------------

- Project/Project Options/Linker Locator Options/Memory, set the following memory areas
     ROM: start 0x0000000, end 0x000DFFF
     RAM: start 0x000F000, end 0x000FFFF
     RAM: start 0x0100000, end 0x0103FFF

- Project/Project Options/Application/Memory Model, set Linear and set the start
  page to 040h

- Project/Project Options/Application/Startup, set values for
  ADDRSEL1, BUSCON0 and BUSCON1; be sure to check the box 'Include in
  project startup code'. Taking suggested values from the kitcon 167 manual:
     ADDRSEL1 = 0x0404
     BUSCON0  = 0x04AF
     BUSCON1  = 0x04AF

- To test, re-build the application then use Phytec Flash Tools 16W to burn it
  into flash. Note that Flash Tools may fail to load the .hex file if the total
  filename + path is too long.


