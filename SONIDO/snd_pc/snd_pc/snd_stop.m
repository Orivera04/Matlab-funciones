% SND_STOP.DLL Stop sound output and free resources. (See SND_MULTI)
%
%     SND_STOP(RESOURCES) stops sound output and frees the resources 
%     specified by $RESOURCES.
%     The sound output has been started previously with:
%
%        RESOURCES = SND_MULTI([1 0 ...
%
%     (If NCH_IN=0 in the SND_MULTI call the control returns
%     immediately to Matlab after output started.)
%
%     Caution! Failing to free an audio device makes it unavailable. 
%     Termination of Matlab will be necessary to free device.
%
%     See also SND_MULTI
%
% SND_STOP is part of the SND_PC toolbox (by Torsten Marquardt)
% and works with Windows 95/98/NT and Matlab 5.x only.
