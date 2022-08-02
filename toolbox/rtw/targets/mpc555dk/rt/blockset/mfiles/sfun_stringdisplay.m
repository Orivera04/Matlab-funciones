function [sys,x0,str,ts] = sfun_stringdisplay(t,x,u,flag,varargin)
%SFUN_STRINGDISPLAY

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/19 01:30:04 $

% Dispatch the flag. The switch function controls the calls to 
% S-function routines at each simulation stage.
switch flag,
   case 0
     [sys,x0,str,ts] = mdlInitializeSizes; % Initialization
   case 3
     sys = mdlOutputs(t,x,u,varargin{:}); % Calculate outputs
  case 2
    sys=mdlUpdate(t,x,u);
   case { 1, 4, 9 }
     sys = []; % Unused flags
   otherwise
     error(['Unhandled flag = ',num2str(flag)]); % Error handling
end;
% End of function timestwo.
% Below are the S-function subroutines that timestwo.m calls.

%============================================================== 
% Function mdlInitializeSizes initializes the states, sample 
% times, state ordering strings (str), and sizes structure.
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes
% Call function simsizes to create the sizes structure.
sizes = simsizes;
% Load the sizes structure with the initialization information.
sizes.NumContStates= 0;
sizes.NumDiscStates= 0;
sizes.NumOutputs=    0;
sizes.NumInputs=     -1;
sizes.DirFeedthrough=1;
sizes.NumSampleTimes=1;
% Load the sys vector with the sizes information.
sys = simsizes(sizes);
%
x0 = []; % No continuous states
% 
str = []; % No state ordering
% 
ts = [-1 0]; % Inherited sample time

 set_param(gcb,'userdata',[]);
% End of mdlInitializeSizes.
%==============================================================
% Function mdlOutputs performs the calculations.
%==============================================================
function sys = mdlOutputs(t,x,u,varargin)
uold = get_param(gcb,'userdata');
if isempty(uold) | any(uold~=u)
    set_param(gcb,'userdata',u);
    s = char(u');
    set_param(varargin{1},'S',s);
end
%disp(s);
sys=[];

% End of mdlOutputs.

%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

