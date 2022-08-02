function mouse_rotate(command)
% MOUSE_ROTATE: This function gives less RSI than rotate3D
%
% The mouse 'up' function switches between rotating and not
% rotating the figure.  The mouse move function, when enabled,
% rotates the figure in the direction of mouse movement 
% within the figure.
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Licence:            GNU GPL, no implied or express warranties
%Created:  10/1995 - Eric Soroos
%Modified: 02/2002 - Darren.Weber@flinders.edu.au
%                  - integrated all commands into one function .m file
%                  - changed rotation to mouse direction rather than
%                    anti-mouse direction and during mouse up rather
%                    than mouse down.
%                  - changed target to the 'view' property of gca
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('command','var'), command = 'init'; end

switch command,
    
case 'init',
    
    set(gcf,'WindowButtonUpFcn','mouse_rotate(''up''); ');
    
    H.exit  = uicontrol('Parent',gcf,'Style','pushbutton',...
        'Units','Normalized','Position',[.9 .0 .1 .05],...
        'String','Exit','Value',0,...
        'TooltipString','Exit figure rotation.',...
        'Callback',strcat('H = get(gcbf,''userdata'');',...
                          'delete(H.exit); ',...
                          'delete(H.El); ',...
                          'delete(H.Az); ',...
                          'set(gcbf,''WindowButtonMotionFcn'',[]); ',...
                          'set(gcbf,''WindowButtonDownFcn'',[]); ',...
                          'set(gcbf,''WindowButtonUpFcn'',[]); ',...
                          'clear H;'));
    H.El  = uicontrol('Parent',gcf,'Style','text',...
        'Units','Normalized','Position',[.9 .06 .2 .05],...
        'String','','Visible','off',...
        'TooltipString','Elevation','HorizontalAlignment','left');
    H.Az  = uicontrol('Parent',gcf,'Style','text',...
        'Units','Normalized','Position',[.9 .11 .2 .05],...
        'String','','Visible','off',...
        'TooltipString','Azimuth','HorizontalAlignment','left');
    
    set(gcf,'userdata',H);
    
    % Add gui controls with tooltips for help
    
case 'up',
    
    %This switches between rotation and no rotation.
	%On a button press, it checks whether the motion function is
    %set - if yes, it clears it, otherwise it adds it.
    if isempty(get(gcbf,'WindowButtonMotionFcn')),
        set(gcbf,'WindowButtonMotionFcn','mouse_rotate(''rotate'');');
    else
        pos.current = get(gca,'View');
        fprintf('\nCurrent Figure View: Az = %6.4f\tEl = %6.4f\n\n',pos.current);
        set(gcbf,'WindowButtonMotionFcn',[]);
    end
    
case 'rotate',
    
    % rotates the figure in the direction of mouse movement
	% i.e. in the center, 0 altitude, 0 azimuth. Going up and down
	% changes the altitude, left and right changes the azimuth.
	pos.fig = get(gcf,'position');
    pos.mouse = get(0,'pointerlocation');
    pos.relative = -1 * (((pos.mouse(1:2) - pos.fig(1:2))./ pos.fig(3:4))-.5).*[360,190];
    set(gca,'View',pos.relative);
    
    H = get(gcf,'userdata');
    set(H.Az,'Visible','on','String',sprintf('Az = %6.2f',pos.relative(1)));
    set(H.El,'Visible','on','String',sprintf('El = %6.2f',pos.relative(2)));
    

otherwise,
    
end
    
return
