function mmfigpos(arg,b)
%MMFIGPOS Position Figure Windows. (MM)
% MMFIGPOS full  changes the current figure to full screen.
% MMFIGPOS(H,'full') changes the figures having handles in H
% to full screen.
%
% MMFIGPOS default  changes the current figure position to the
% default size and screen placement.
% MMFIGPOS(H,'default') changes the figures having handles H
% to the default size and screen placment.
%
% MMFIGPOS tile  tiles visible figures around the screen.
%
% MMFIGPOS cascade  cascades visible figures down and to the
% left from the default position.
%
% MMFIGPOS off  restores all visible figures to the default
% size and position.
%
% MMFIGPOS set  places a figure in the default location and
% prompts the user to change its size and placement as desired.
% When the figure is closed, the final figure position is
% displayed in the command window.
%
% MMFIGPOS with no arguments simply brings forward all visible
% figures.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 1/20/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

hf=[];
if nargin==0
   hf=findobj(0,'Type','figure','Visible','on');
   for k=1:length(hf)
      figure(hf(k))
   end
   return
elseif all(ishandle(arg))
   ht=char(get(arg,'Type'));
   if strcmp(ht(1,:),'figure')&all(all(diff(ht,1)==0))
      hf=arg;
      arg=b;
   else
      error('H Must Contain Handles to Figures Only.')
   end
elseif ~ischar(arg)
   error('String Argument Expected.')
elseif isnumeric(arg)
   error('H Contains Invalid Handles.')
end

if strcmpi(arg,'full')
   if isempty(hf)
      hf=get(0,'CurrentFigure');
   end
   punits=get(hf,{'Units'});
   set(hf,'Units','normalized',...
      'OuterPosition',[0 0 1 1])
   set(hf,{'Units'},punits)
   
elseif strncmpi(arg,'def',3)
   if isempty(hf)
      hf=get(0,'CurrentFigure');
   end
   set(hf,'Units',get(0,'DefaultFigureUnits'),...
      'Position',get(0,'DefaultFigurePosition'))
   
elseif strcmpi(arg,'tile')
   hf=findobj(0,'Type','figure','Visible','on');
   if isempty(hf), return, end
   ss=mmgetpos(0,'pixels');
   [defu,defp]=mmget(0,'DefaultFigureUnits','DefaultFigurePosition');
   po=50;
   wi=(ss(3)-po-10)/2;
   he=(ss(4)-po-10)/2;
   lb=[po po+he;po+wi po+he;...
      po po;po+wi po];
   if strcmp(defu,'pixels') & defp(3)<=wi & defp(4)<=he
      wi=defp(3);
      he=defp(4);
      lb=[ss(3)-2*wi ss(4)-he; ss(3)-wi ss(4)-he;...
          ss(3)-2*wi ss(4)-2*he; ss(3)-wi ss(4)-2*he]; 
   end
   lb(5:8,:)=lb-po/2;
   
   for k=min(length(hf),8):-1:1
      punits=get(hf(k),'Units');
      set(hf(k),'Units','pixels',...
         'OuterPosition',[lb(k,:) wi he],...
         'Units',punits)
   end   
   
elseif strncmpi(arg,'cas',3)
   hf=findobj(0,'Type','figure','Visible','on');
   if isempty(hf), return, end
   pdef=get(0,'DefaultFigurePosition');
   po=25;
   cascade=[po po 0 0];
   Nf=length(hf);
   for k=1:Nf
      punits=get(hf(k),'Units');
      set(hf(k),'Units','pixels',...
         'Position',pdef-(k-1)*cascade,...
         'Units',punits)
      figure(hf(k))
   end
   
elseif strncmpi(arg,'off',3)
   hf=findobj(0,'Type','figure','Visible','on');
   set(hf,'Units',get(0,'DefaultFigureUnits'),...
      'Position',get(0,'DefaultFigurePosition'))
   
elseif strncmpi(arg,'set',3)
   hf=figure('DeleteFcn','mmfigpos delfcn');
   axes('Position',[0 0 1 1],'Visible','off')
   text(.5,.5,'Move and Resize as Desired','horizontal','center','fontsize',16)
   text(.50,.42,'Then Close','horizontal','center','fontsize',16);
   drawnow
   
elseif strcmpi(arg,'delfcn')
   pdef=mmgetpos(gcbf,'pixels');
   disp(' ')
   disp('Place the following command in your startup.m file')
   disp('to set the default figure position rectangle.')
   disp('Evaluate it in the command window now to set the')
   disp('figure position for this MATLAB session only.')
   disp(' ')
   fprintf('set(0,''DefaultFigurePosition'',[%d %d %d %d]',pdef)
   
else
   error('Unknown String Input.')
end

   