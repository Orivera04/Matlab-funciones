function watchoff(figNumber);
%WATCHOFF Sets the current figure pointer to the arrow.
%	WATCHOFF(figNumber) will set the figure figNumber's pointer
%	to a watch. If no argument is given, figNumber is taken to
%	be the current figure.
%
%	See also WATCHON.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    figNumber=gcf;
end;

% If watchon is used before a window has been opened, it will 
% set the figNumber to the flag NaN, which is why the next line
% checks to make sure that the figNumber is not NaN before resetting
% the pointer.
if ~isnan(figNumber),
    set(figNumber,'Pointer','arrow');
end
