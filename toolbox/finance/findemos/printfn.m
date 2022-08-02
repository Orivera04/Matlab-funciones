function printfn(FigHandle)
% PRINTFN Set up defaults for printing from BLSDEMOS, ONEOPT, PAYOFF, and SMILE.

%       Copyright 1995-2003 The MathWorks, Inc.
%       $Revision: 1.6.2.2 $   $Date: 2004/04/06 01:07:05 $ 

% Created by Greg Portmann (1997)

if nargin < 1
   FigHandle = gcf;
end


set(FigHandle,'PaperUnits','Normalized');
%set(FigHandle,'PaperPositionMode','auto');
set(FigHandle,'PaperPositionMode','manual');

%get(FigHandle,'PaperOrientation')
%get(FigHandle,'PaperPositionMode')

if strcmp(lower(get(FigHandle,'PaperOrientation')),'portrait')
   set(FigHandle,'PaperPosition',[.1 .1 .8 .8]);
else
   set(FigHandle,'PaperPosition',[.1 .1 .8 .8]);   
end

% Print options based on architecture
if ispc
    print -dwin -noui
else
    print -dps -noui
end

% [EOF]
