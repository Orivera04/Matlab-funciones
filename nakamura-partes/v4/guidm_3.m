% GuiDm_3  Displaying numeric value in text.
% Copyright S. Nakamura, 1995
close; clg
h1=figure(1);
set(h1,'Position',[300,300,400,100],...
'NumberTitle','off',...
'Name','GuiDm_3  Numeric Value in ui_text')
k1=uicontrol('Style','text',...
            'String',num2str(pi),...
            'Position',[ 20,10,140,30]);

