%===========================================================================
% Fourier Series Demo  (fseriesdemo.m)
%===========================================================================
%
% Installation Instructions:
% --------------------------
%    There are no special installation instructions required.  The archive
%    just needs to be unpacked with the original directory structure 
%    preserved.
%
% To Run:
% -------
%    The GUI is started by running the fseriesdemo.m file.  For further help,
%    use the help menu.
%
% Contact Information:
% --------------------
% If you find and wish to report a bug or have any questions you can contact
%
%   James H. McClellan
%   james.mcclellan@ece.gatech.edu
%
%===========================================================================
% Revision Summary
%===========================================================================
%----------------------------------------------------------------------------  
% G Krudysz 17-Dec-2004 (ver. 1.20) , Final Release for Spring 2005 semester
%---------------------------------------------------------------------------- 
% G Krudysz 10-Dec-2004 (ver. 1.10) , added movietool, recenterd objects,
%                                   , added 'Exit' and 'Help' to the menu
% G Krudysz 01-Sep-2004 (ver. 1.09) , updated linewidthdlg
% G Krudysz 29-Jan-2004 (ver. 1.08) , changed text over Phase axes to symbolic 
% G Krudysz 23-Jan-2004 (ver. 1.07) , added color to value over, clean up 
% G Krudysz 13-Jan-2004 (ver. 1.06) , added value over Mag & Phase, clean up
%----------------------------------------------------------------------------  
% Rajbabu, 20-Dec-2003 (ver. 1.05), 
%   Added/Modified signals (Full and half wave rectified sine/cosine wave)
%----------------------------------------------------------------------------  
% G Krudysz 11-Dec-2003 (ver. 1.04) , added Show Error radiobutton
% G Krudysz 02-Dec-2003 (ver. 1.03) , added Period Slider
%                                   , added Coeff/Freq radiobutton
%----------------------------------------------------------------------------  
% Rajbabu, 3-Dec-2003 (ver 1.02)    , fixed 'ak' for Full-wave
%----------------------------------------------------------------------------
% J McClellan, 5-Dec-2002 (ver 1.01), renamed & added comments
%----------------------------------------------------------------------------
% Mustayeen Nayeem, Aug-2002 (ver 1.0) 
%----------------------------------------------------------------------------
% Known Problems: 
% G Krudysz 23-Jan-2004: Axes fontsize differs in Phase axes with norm
% units