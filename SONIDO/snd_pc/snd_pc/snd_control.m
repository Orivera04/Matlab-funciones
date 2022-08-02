% SND_CONTROL.DLL returns or sets controls of audio mixer devices
%
%     CONTROL_VALUE = SND_CONTROL(CONTROL_ID, VALUE, MIXER_ID) sets
%     the values of control with ID $CONTROL_ID of the audio mixer with
%     $ID MIXER_ID to $VALUE, reads it again and returns it in
%     CONTROL_VALUE (as a check). $CONTROL_VALUE and $VALUE might be 
%     vectors up to a length of (mxcd.cChannels * mxcd.cMultipleItems)
%     to set/read all values of the contol (see Win32 Multimedia API).
%
%     CONTROL_VALUE = SND_CONTROL(CONTROL_ID, VALUE) default $MIXER_ID  
%     is zero (first mixer device).                                    
%                                                                      
%     CONTROL_VALUE = SND_CONTROL(CONTROL_ID) returns the values of the 
%     of the audio mixer control with ID $CONTROL_ID.                   
%                                                                      
%     MIXER_IDs start from zero up to the number of devices minus one. 
%     Use SND_MIXER_INFO.DLL to get informations about mixer parameter 
%     and $CONTROL_IDs.
%     Caution! The use of $CONTROL_IDs outside the range of the audio
%     mixer device can cause segmentation violations and crash the 
%     system.                                           
%                                                                      
%     See also SND_MIXER_INFO and Win32 Multimedia API documentation.  
%                                                                      
% SND_CONTROL is part of the SND_PC toolbox (by Torsten Marquardt) 
% and works with Windows 95/98/NT and Matlab 5.x only.             
