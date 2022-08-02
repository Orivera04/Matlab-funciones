% SND_MIXER_INFO.DLL Print information about an audio mixer device. 
%
%     SND_MIXER_INFO.DLL(MIXER_ID) prints information about the audio
%     mixer with device the ID MIXER_ID into the Matlab command window.
%     MIXER_IDs start from zero up to the number of devices minus one.
%                                                                      
%     SND_MIXER_INFO   same as above, default MIXER_ID is zero. (first 
%     mixer device) 
%                                                                     
%     MIXER_NAME = SND_MIXER_INFO(MIXER_ID) returns the device name of 
%     the mixer device with the ID MIXER_ID in the string MIXERNAME    
%     without printing the other information. That might be useful to  
%     identify the audio device in use.                               
%                                                                      
%     Use SND_CONTROL.DLL to change control values of the sound mixer  
%                                                                      
%     See also SND_CONTROL and the Microsoft Multimedia API.           
%                                                                      
%     Bugs: The function relies on the number of controls per source       
%        which is returned by the driver. If that number is higher than
%        the  actual number of controls the function is likly to cause     
%        a segmentation fault (e.g.GINA soundcard's driver ver. 4.0       
%        and below). In that case the expected number of controls       
%        (Examine the function's output before the crash) must be set   
%        manually in the C-code. Recompilation will be necessary.       
%                                                                     
% SND_MIXER_INFO is part of the SND_PC toolbox (by Torsten Marquardt)  
% and works with Windows 95/98/NT and Matlab 5.x only.                 
