function rabbits(action)
% RABBITS  Fibonacci's rabbit pen.
%   Create immature pushbuttons that age after one click.

if nargin == 0
   clf reset
   shg
   uicontrol('style','text','fontsize',12,'fontweight','bold', ...
      'units','normal','position',[.47 .94 .06 .04])
   R = imread('rabbit.jpg');
   set(gcf,'userdata',R);
   action = 'mature';
end

R = get(gcf,'userdata');
switch action
   case 'immature'
      p = get(gcbo,'position');
      p = [p(1:2)-15 60 60];
      c = 'rabbits(''mature'')';
      set(gcbo,'cdata',R,'position',p,'callback',c,'enable','off');
   case 'mature'
      f = get(gcf,'position');
      p = [.90*f(3:4).*rand(1,2) 30 30];
      c = 'rabbits(''immature'')';
      r = R(1:2:end,1:2:end,:);
      uicontrol('style','pushbutton','position',p,...
         'cdata',r,'callback',c,'enable','off')
      if nargin > 0
         set(gcbo,'enable','off')
      end
end

b = findobj(gcf,'style','pushbutton');
if ~any(any(char(get(b,'enable')) == 'n'))
   set(b,'background','w','enable','on')
end
set(findobj(gcf,'style','text'),'string',length(b))
