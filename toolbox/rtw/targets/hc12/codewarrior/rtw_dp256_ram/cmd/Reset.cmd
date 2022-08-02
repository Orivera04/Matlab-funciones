// DO NOT DOWNLOAD, USE, COPY, MODIFY OR DISTRIBUTE THIS CODE OR ANY PORTIONS 
// THEREOF UNLESS YOU AGREE TO THE FOLLOWING:                                 
// This code is provided "AS IS" without warranty of any kind, to the full    
// extent permitted by law. You may copy, use modify and distribute the code  
// (including modifications) provided you agree to these terms and conditions,
// however you do so at your own risk and you agree to indemnify Metrowerks   
// for any claim resulting from your activities relating to the code. You must
// include all Metrowerks notices with the code. If you make any              
// modifications, you must identify yourself as co-author in the modified     
// code.                                                                      
// (C) Copyright. 2002 Metrowerks Corp. ALL RIGHTS RESERVED.                  
// 
// After reset write a byte to re-map RAM to start at 0xD000
// and reset the PC to execute startup code located at 0xE029
wb 0x10 0xC1
rs PC 0xE029
 