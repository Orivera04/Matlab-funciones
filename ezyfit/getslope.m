function [n,a]=getslope(opt)
%GETSLOPE  Slope of the current line.
%   GETSLOPE displays the equation of the current line of the figure. Use
%   the menu 'Insert > Line' to draw a line first. GETSLOPE allows for
%   rough curve fitting "by eye". Use the shortcut Ctrl+G if the Ezyfit
%   menu is installed (see EFMENU).
%
%   Depending of the axis types, the equation of the line will be:
%        Y = N*X+A         for X linear and Y linear
%        Y = A*X^N         for X log and Y log
%        Y = A*EXP(N*X)    for X linear and Y log
%        Y = A+N*LOG(X)    for X log and Y linear (LOG = natural logarithm)
%
%   [N, A] = GETSLOPE also returns the parameters N and A of the equation.
%
%   [N, A] = GETSLOPE(OPT) specifies the display mode:
%        'eq'       displays the full equation (by default).
%        'slope'    displays only the slope N.
%        'nodisp'   displays nothing.
%
%   See also SHOWSLOPE, PLOTSAMPLE, RMFIT, EFMENU.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.33,  Date: 2006/05/09
%   This function is part of the EzyFit Toolbox


% History:
% 2005/02/17: First version.
% 2005/02/23: uses the current active line
% 2005/02/24: bug 'nodisp' fixed
% 2005/05/21: standard error messages
% 2005/05/24: option 'draw' suppressed; works in linear or log coordinates.
% 2005/05/26: Bug fixed (zero slope in semilogx mode)
% 2005/06/16: Displays the fit parameters with the correct number of digits.
% 2005/06/22: v1.23, bug fixed in semilogx mode; 3 digits.
% 2005/07/27: v1.24, correctly displays the negative values (without '+').
% 2005/11/02: v1.30, works also when one extremity of the line is selected.
%                    the equation is now in an annotation box, that follows
%                    the line.
% 2006/02/08: v1.31, use the number of digits defined in fitparam
% 2006/03/08: v1.32, option 'dialog' added, when called from efmenu
% 2006/05/09: v1.33, bug fixed for exponential fits (annotation box too
%                    small)


% loads the default fit parameters:
try
    fp=fitparam;
catch
    fp.numberofdigit=3;
end;

if ~exist('opt','var'), opt=''; end;

if isequal(opt,''), opt='eq'; end; %displays fhe full equation by default

if isempty(get(0,'CurrentFigure'))
    error('No figure.');
end;

% get infos about the current line
if ishandle(gco),
    h=gco; % currently active line (but it does not work
    % if the line is just being drawn!)
end;
if ishandle(gco)
    if ~isfield(get(gco),'XData')
        % gco is a handle, but there is no XData field in it
        if (gco==gcf),
            % nothing is selected...
            if strfind(lower(opt),'dialog'),
                errordlg('First select a line (Menu Insert > Line)','GetSlope');
                return;
            end;
            error('First select a line (Menu Insert > Line).');
        else
            % this is the case when the line was just being drawn.
            % (h(1) is the XAxis, h(2) and h(3) are the first and second points,
            % and h(4) is the line itself).
            h=findall(gcf,'Type','line');
            if length(h)<4,
                if strfind(lower(opt),'dialog'),
                    errordlg('First select a line (Menu Insert > Line)','GetSlope');
                    return;
                end;
                error('First select a line (Menu Insert > Line).');
            else
                h=h(4);
            end;
        end;
    else
        % the object has a XData field in it
        h=gco;
        o=get(gco);
        if ~(length(o.XData)==2),
            if (length(o.XData)==1),
                % One point of the line was being moved.
                % go back to its parent and take the 3rd child:
                % here you will find the line itself.
                o=get(o.Parent);
                h=o.Children(3);
            else
                if strfind(lower(opt),'dialog'),
                    errordlg('First select a line (Menu Insert > Line)','GetSlope');
                    return;
                end;
                error('First select a line (Menu Insert > Line).');
            end;
        end;
    end;
else
    if strfind(lower(opt),'dialog'),
        errordlg('First select a line (Menu Insert > Line)','GetSlope');
        return;
    end;
    error('First select a line (Menu Insert > Line).');
end;

% this is the coord of the line, normalized to the window (between 0 and 1):
o=get(h);
xw1=o.XData(1); xw2=o.XData(2);
yw1=o.YData(1); yw2=o.YData(2);

icg=get(gca); % get infos about the current axes

% computes the coordinates of the line
% normalized to the axes of the figure (between 0 and 1):
%   icg.Position(1:2) = coordinates (x,y) relative to the window
%   icg.Position(3:4) = width and height of the windows
xr1=(xw1-icg.Position(1))/(icg.Position(3));
xr2=(xw2-icg.Position(1))/(icg.Position(3));

yr1=(yw1-icg.Position(2))/(icg.Position(4));
yr2=(yw2-icg.Position(2))/(icg.Position(4));

if isequal(icg.XScale,'log') && isequal(icg.YScale,'log'),
    % Fit by a power law, y=a*x^n.

    % computes the coordinates of the line in 'physical' units (those of
    % the axes):
    x1=icg.XLim(1)*(icg.XLim(2)/icg.XLim(1))^xr1;
    x2=icg.XLim(1)*(icg.XLim(2)/icg.XLim(1))^xr2;

    y1=icg.YLim(1)*(icg.YLim(2)/icg.YLim(1))^yr1;
    y2=icg.YLim(1)*(icg.YLim(2)/icg.YLim(1))^yr2;

    n=log(y2/y1)/log(x2/x1);
    a=y1/(x1^n);

    if strfind(lower(opt),'eq'),
        str=[num2str(a, fp.numberofdigit) ' x^{' num2str(n, fp.numberofdigit) '}'];
    else
        str=num2str(n, fp.numberofdigit);
    end;

elseif isequal(icg.XScale,'linear') && isequal(icg.YScale,'linear'),
    % Fit by an affine law, y=nx+a.

    x1=icg.XLim(1)+(icg.XLim(2)-icg.XLim(1))*xr1;
    x2=icg.XLim(1)+(icg.XLim(2)-icg.XLim(1))*xr2;

    y1=icg.YLim(1)+(icg.YLim(2)-icg.YLim(1))*yr1;
    y2=icg.YLim(1)+(icg.YLim(2)-icg.YLim(1))*yr2;

    n=(y2-y1)/(x2-x1);
    a=y1-n*x1;

    if strfind(lower(opt),'eq'),
        if a>0 % changed 27/07/2005, v1.24
            str=[num2str(n, fp.numberofdigit) ' x + ' num2str(a, fp.numberofdigit)];
        else
            str=[num2str(n, fp.numberofdigit) ' x ' num2str(a, fp.numberofdigit)];
        end;
    else
        str=num2str(n, fp.numberofdigit);
    end;

elseif isequal(icg.XScale,'linear') && isequal(icg.YScale,'log'),
    % Fit by an exponential law, y=a*exp(nx).

    x1=icg.XLim(1)+(icg.XLim(2)-icg.XLim(1))*xr1;
    x2=icg.XLim(1)+(icg.XLim(2)-icg.XLim(1))*xr2;

    y1=icg.YLim(1)*(icg.YLim(2)/icg.YLim(1))^yr1;
    y2=icg.YLim(1)*(icg.YLim(2)/icg.YLim(1))^yr2;

    n=log(y2/y1)/(x2-x1);
    a=y1/exp(n*x1);

    if strfind(lower(opt),'eq'),
        str=[num2str(a, fp.numberofdigit) ' e^{' num2str(n, fp.numberofdigit) ' x}'];
    else
        str=num2str(n, fp.numberofdigit);
    end;

elseif isequal(icg.XScale,'log') && isequal(icg.YScale,'linear'),
    % Fit by a logarithmic law, y=a+n*log(x).

    x1=icg.XLim(1)*(icg.XLim(2)/icg.XLim(1))^xr1;
    x2=icg.XLim(1)*(icg.XLim(2)/icg.XLim(1))^xr2;

    y1=icg.YLim(1)+(icg.YLim(2)-icg.YLim(1))*yr1;
    y2=icg.YLim(1)+(icg.YLim(2)-icg.YLim(1))*yr2;

    n=(y2-y1)/log(x2/x1);
    if n,
        a=y1-n*log(x1);
    else
        a=NaN;
    end;
    if strfind(lower(opt),'eq'),
        str=[num2str(a, fp.numberofdigit) ' ln (' num2str(n, fp.numberofdigit) ' x)'];
    else
        str=num2str(n, fp.numberofdigit);
    end;
end;

if ~length(strfind(lower(opt),'nodisp')),
    % if the current line has a textbox previously attached to it, kill it:
    if ishandle(get(h,'UserData')), delete(get(h,'UserData')); end;
    textlocation=[(xw1+xw2)/2 (yw1+yw2)/2-0.075-sign(n)*0.025 0.3 0.1];  % changed v1.33
    htext=annotation('textbox',textlocation,'LineStyle','none','UserData','getslopetextbox','String',str);
    % says to the line that the textbox htext is attached to it:
    set(h,'UserData',htext);
end;

if nargout==0,
    clear n;
end;
