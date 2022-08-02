function GUO = addchildguo(GUO, ChildGUO);

% function GUO = addchildguo(GUO, ChildGUO);
% 
% Inserts "ChildGUO" within "GUO", whereby both "ChildGUO" and "GUO" are 
% graphicuserobjects.  Child GUOs are positioned relative to the GUO frame of 
% their parent, and sized relative to this GUO frame if the Units property of
% the child GUO is 'normalized' (the default here).  Specifying the Tag property
% for the child GUO allows it to be referenced by name;  child GUOs may also be
% referenced by number (in order of their creation, starting with 1).  Child 
% GUOs are numbered separately from child objects (uicontrols and axes).
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

n = length(GUO.ChildGUOs) + 1;
if n == 1
   GUO.ChildGUOs = {ChildGUO};  % Ensure that ChildGUOs remains a cell array
else
   GUO.ChildGUOs{n} = ChildGUO;
end
GUO = PositionInFrame(GUO, ChildGUO, n);
