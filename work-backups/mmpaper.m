function mmpaper(arg1,arg2,arg3,arg4,arg5,arg6)
%MMPAPER Set Default Paper Properties. (MM)
% MMPAPER name value ...
% sets default paper properties for the current figure and
% succeeding figures based on name value pairs. 
% Properties:
% NAME		VALUE
% units		[{inch},centimeters,points,normal]
% orient	[{portrait},landscape]
% type      [{usletter},uslegal,a3,a4letter,a5,b4,tabloid]
%
% Examples:
% MMPAPER units inch orient landscape
% MMPAPER type tabloid
%
% MMPAPER with no arguments returns the current paper defaults.

% Calls: mmgcf 

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 4/25/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9


Hf=mmgcf;
flag=0;
if isempty(Hf)
   flag=1;
   Hf=figure('Visible','off');
end
if nargin
   for i=1:2:max(nargin-1,1)
      name=eval(sprintf('arg%.0f',i),[]); % get name argument
      value=eval(sprintf('arg%.0f',i+1),[]); % get value argument
      if name(1)=='o'
         set(0,'DefaultFigurePaperOrientation',value)
         set(Hf,'PaperOrientation',value)
      elseif name(1)=='t'
         set(0,'DefaultFigurePaperType',value)
         set(Hf,'PaperType',value)
      elseif name(1)=='u'
         set(0,'DefaultFigurePaperUnits',value)
         set(Hf,'PaperUnits',value)
      else
         disp(['Unknown Property Name: ' name])
      end
   end
end
disp(['Paper Orientation: ' get(Hf,'PaperOrientation')])
disp(['Paper Type: ' get(Hf,'PaperType')])
disp(['Paper Units: ' get(Hf,'PaperUnits')])
if flag, delete(Hf); end

