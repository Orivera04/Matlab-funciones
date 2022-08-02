function cgwinlist(fig)
%CGWINLIST Create submenu for "Window" menu item.
%  CGWINLIST constructs a submenu under the "Window" menu item
%  of the current figure.  The submenu can then be used to
%  change the current figure.  To use WINLIST, the "Window"
%  menu item must have its 'Tag' property set to a string which is
%  common between all of the windows being gathered together
%
%  CGWINLIST(FIG) constructs the "Window" menu and it's subitems for figure
%  FIG.  If a window menu exists then it is used as the base and it's tag is
%  used for searching for other windows.  The default tag is 'cgWinList'.
%
%
%  Example:
%    fig_handle = figure;
%    cgwinlist(fig_handle);  % Initialize the submenu

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 08:39:48 $
    

if (nargin == 0)
   fig = gcf;
end

h=findobj(allchild(fig),'flat','type','uimenu', 'Label','Window');
if isempty(h)
   h=uimenu('parent',fig,'Label','&Window','callback',@i_createsublist,....
      'tag','cgWinList'); 
   % this menu prevents the first-time failure to show
   uimenu('parent',h,'label','init');
end

return




function i_createsublist(h,evt)
HiddenVal = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
tg=get(h,'tag');
% only get items from figures with similar window menus
figs=get(findobj('type','uimenu','tag',tg,'Label','&Window'),{'parent'});
figs=[figs{:}];
figs=findobj(figs,'flat','visible','on');
figs=-sort(-figs);
set(0,'ShowHiddenHandles',HiddenVal);

% get list of text and filter out blanks etc
figName = get(figs,{'Name'});
intHandle = get(figs,{'IntegerHandle'});
numTitle = get(figs,{'NumberTitle'});

N=length(figs);
lbls=cell(N,1);
for k=1:N
   if (strcmp(numTitle{k},'on'))
      if strcmp(intHandle{k},'on'),    
         if (isempty(figName))
            lbls(k)={sprintf('&%d Figure No. %d',N-k+1,figs(k))};
         else          
            lbls(k)= {sprintf('&%d Figure No. %d: %s',N-k+1,figs(k),i_dotokenise(figName{k}))};
         end
      else
         if (isempty(figName))
            lbls(k)={sprintf('&%d Figure No. %.8f',N-k+1,figs(k))};

         else
            lbls(k)= {sprintf('&%d Figure No. %.8f: %s',N-k+1,figs(k),i_dotokenise(figName{k}))};
         end
      end      
   else
      % numTitle is off.
      if (isempty(figName{k}))
         lbls(k)={''};
      else
         % Filter names for the string ' - ' and only take everything before this
         lbls(k)={sprintf('&%d %s',N-k+1,i_detokenise(figName{k}))};
      end
   end
end

FigsToDo=find(~cellfun('isempty',lbls));

% Create/delete sub-uimenus as needed
N=length(FigsToDo);
winds=get(h,'children');
if N>length(winds)
   for k=N:-1:(length(winds)+1)
      uimenu('parent',h);   
   end
   winds=get(h,'children');
elseif N<length(winds)
   delete(winds(N+1:end));
   winds=winds(1:N);
end

MyPrnt=get(h,'parent');
for k=FigsToDo(:)'
   set(winds(k),'Label',lbls{k},'Callback',sprintf('figure(%.16f);',figs(k)));   
   if figs(k)==MyPrnt
      set(winds(k),'checked','on');
   else
      set(winds(k),'checked','off');
   end
end
return




function str=i_detokenise(str)
tok=findstr(str, ' - ');
if ~isempty(tok)
   str= str(1:tok(1)-1);
end
return
