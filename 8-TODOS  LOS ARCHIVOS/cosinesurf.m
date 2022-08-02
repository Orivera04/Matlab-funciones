function cosinesurf
% Makes a waving cosine-sine surface
% Ooooooooo, pretty  :-)

%% Setup surface function to display
x = -2*pi:.1:2*pi;
[xx,yy] = meshgrid(x);
z = cos(xx.^2) + sin(yy.^2); % start with function #1

%% Setup figure window and handles
h1 = figure('Units','Normalized','Position',[0.1 0.1 0.4 0.4]);
set(h1,'color','k');
subplot('Position',[0 0 1 1]);
h2 = surf(z,'EdgeColor','none');
axis([0 130 0 130 -2 5],'off');
[a,e] = view; view(a,e+90);

% Setup UI controls
h3 = uicontrol(h1,'Style','pushbutton','String','Stop'...
    ,'Position',[5 5 40 20],'Callback','close(gcbf)');
h4 = uicontrol(h1,'Style','pushbutton','String','Change'...
    ,'Position',[50 5 45 20],'Callback',...
    'set(gcbf,''userdata'',1+get(gcbf,''userdata''))');

%% Main process loop
idx = 50*pi;
set(h1,'userdata',1)
while ishandle(h1)
    idx = idx - 0.1;
    if rem(get(h1,'userdata'),2)==1
        z = cos(xx.^2+idx) + sin(yy.^2+idx); % function #1
    else
        z = sin((xx-.5*idx).^2 + (yy-.5*idx).^2 + idx); % function #2
    end
    set(h2,'zdata',z);
    [a,e] = view; view(a+.2,e);
    drawnow;
    if idx <= -50*pi
        idx = -1*idx;
    end
end
