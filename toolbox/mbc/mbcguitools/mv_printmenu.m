function m = mv_printmenu(action,varargin)
%
% M = MV_PRINTMENU('CREATE',FIG_HAND)
%
% This function will add a menu item to a figure window
% The menu will be named 'FIGURE' and will have two sub-menus
% 'COPY' and 'PRINT...'
%
% It will return a handle to the menu item.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:33:39 $

% If one has an axes overlaid onto another axes, then if the two DO NOT have 
% the same UNITS, the hardcopy will be distorted.
% Make sure that in such a case, all axes have the same units.

switch action
case 'create'
   fH=varargin{1};
   m=uimenu('parent',fH,...
      'Label','&Figure');
   mm=uimenu('parent',m,...
      'Label','&Copy',...
      'Accelerator','C',...
      'callback',[mfilename,'(''copy'')']);
   mm=uimenu('parent',m,...
      'Label','&Print...',...
      'Accelerator','P',...
      'Callback',[mfilename,'(''print'')']);
case 'copy'
   print -dmeta -noui;
case 'print'
   mv_printdlg('-crossplatform',gcbf);
end
