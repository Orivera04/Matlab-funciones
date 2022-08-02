function A = editline(varargin)
%EDITLINE/EDITLINE Edit editline object
%   This file is an internal helper function for plot annotation.

%   Copyright 1984-2004 The MathWorks, Inc. 
%   $Revision: 1.17.4.2 $  $Date: 2004/01/15 21:12:18 $


switch nargin
case 0
   A.Class = 'editline';
   A.blank = [];
   A = class(A,'editline',axischild);
   return
case 1
   l = varargin{1};
otherwise
   l = line(varargin);
end

if ~ishandle(l)
   error('argument is not a valid HG handle');
end

axischildObj = axischild(l);
A.Class = 'editline';
A.blank = 1;

A = class(A,'editline',axischildObj);
AH = scribehandle(A);

fig = ancestor(l,'Figure');
u = findall(fig,'Tag','ScribeEditlineObjContextMenu');

if ishandle(u)
   % set(l,'UIContextMenu',u(1));
   setscribecontextmenu(l,u(1));
else
   u = uicontextmenu(...
           'Parent',fig,...
           'Serializable','off', ...
           'HandleVisibility','off',...
           'Callback','domymenu update',...
           'Tag','ScribeEditlineObjContextMenu');
   % set(l,'UIContextMenu',u);
   setscribecontextmenu(l,u);

   
   ucut = uimenu(...
           'Label','Cu&t',...
           'Callback', 'domymenu cut',...
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjCutMenu');
   ucopy = uimenu(...
           'Label','&Copy',...
           'Callback', 'domymenu copy',...
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjCopyMenu');
   upaste = uimenu(...
           'Label','&Paste',...
           'Callback', 'domymenu paste',...
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjPasteMenu');
   uclear = uimenu(...
           'Label','Clea&r',...
           'Callback', 'domymenu clear',...
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjClearMenu');
   
   u1 = uimenu(...
           'Label','Line &Width',...
           'Callback', 'domymenu size',...
           'Separator','on',...           
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjSizeMenu');
   u2 = uimenu(...
           'Label','Line &Style',...
           'Callback', 'domymenu style',...        
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjStyleMenu');
   u3 = uimenu(...
           'Label','Color...',...
           'Callback', 'domymenu color',...        
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjColorMenu');
   
   u4 = uimenu(...
           'Label','Properties...',...
           'Callback', 'domymenu more',...
           'Separator','on',...
           'Parent',u,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjMoreMenu');

   u10 =  uimenu(...
           'Label','0.5',...
           'Callback', 'domymenu size 0.5',...        
           'Parent',u1,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjSizeMenu0.5');
   sizes = [1 2 3 4 5 6 7 8 9 10];
   for i = 1:length(sizes)
      val = num2str(sizes(i));
      uimenu(...
           'Label',val,...
           'Callback', ['domymenu size ' val],...        
           'Parent',u1,...
           'HandleVisibility','off',...
           'Tag',['ScribeEditlineObjSizeMenu' val]);
   end
   u1more = uimenu(...
           'Label', 'more...',...
           'Callback', 'domymenu more',...        
           'Parent',u1,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjSizeMenuMore');

   
   u21 =  uimenu(...
           'Label','solid',...
           'Callback', 'domymenu style solid',...        
           'Parent',u2,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjStyleMenuSolid');
   u22 =  uimenu(...
           'Label','dash',...
           'Callback', 'domymenu style dash',...        
           'Parent',u2,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjStyleMenuDash');
   u23 =  uimenu(...
           'Label','dot',...
           'Callback', 'domymenu style dot',...        
           'Parent',u2,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjStyleMenuDot');
   u24 =  uimenu(...
           'Label','dash-dot',...
           'Callback', 'domymenu style dashdot',...        
           'Parent',u2,...
           'HandleVisibility','off',...
           'Tag','ScribeEditlineObjStyleMenuDashDot');
   
end
