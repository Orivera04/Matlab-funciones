function [flag,fig] = figflag(str,silent)
%FIGFLAG True if figure is currently displayed on screen.
%       [FLAG,FIG] = FIGFLAG(STR,SILENT) checks to see if any figure 
%       with Name STR is presently on the screen. If such a figure is 
%       presently on the screen, FLAG=1, else FLAG=0.  If SILENT=0, the
%       figures are brought to the front.

%	Author: A. Potvin, 12-1-92
%	Modified: E.W. Gulley, 8-9-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/25 15:57:13 $

ni = nargin;
if ni==0,
   error('FIGFLAG must have at least one argument.');
elseif ni==1,
   silent = 0;
end

fig = [];
flag = 0;
rchi = get(0,'Children');
for i = 1:length(rchi),
   if strcmp(get(rchi(i),'type'),'figure'), % If the object is a figure
      figureName=get(rchi(i),'Name');
      if strcmp(figureName,str),
         fig = [fig rchi(i)];
         flag = 1; 
         if ~silent,
            figure(rchi(i));
         end
      end 
   end 
end

% end figflag
