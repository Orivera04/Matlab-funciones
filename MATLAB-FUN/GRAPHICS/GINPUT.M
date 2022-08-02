function [out1,out2,out3] = ginput(arg1, arg2)
%GINPUT	Graphical input from a mouse or cursor.
% 	[X,Y] = GINPUT(N) gets N points from the current axes and returns 
% 	the X- and Y-coordinates in length N vectors X and Y.  The cursor
% 	can be positioned using a mouse (or by using the Arrow Keys on some 
% 	systems).  Data points are entered by pressing a mouse button
% 	or any key on the keyboard.  A carriage return terminates the 
% 	input before N points are entered.
% 
% 	[X,Y] = GINPUT gathers an unlimited number of points until the
% 	return key is pressed.
% 
% 	[X,Y,BUTTON] = GINPUT(N) returns a third result, BUTTON, that 
% 	contains a vector of integers specifying which mouse button was
% 	used (1,2,3 from left) or ASCII numbers if a key on the keyboard
% 	was used.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

c = computer;
if ~strcmp(c(1:2),'PC') & ~strcmp(c(1:2),'MA')
    tp = get(0,'TerminalProtocol');
else
    tp = 'micro';
end

if ~strcmp(tp,'none') & ~strcmp(tp,'x') & ~strcmp(tp,'micro'),
    if nargout == 1,
        if nargin == 1,
            eval('out1 = trmginput(arg1);');
        elseif nargin == 2
            eval('out1 = trmginput(arg1,arg2);');
        else
            eval('out1 = trmginput;');
        end
    elseif nargout == 2 | nargout == 0,
        if nargin == 1,
            eval('[out1,out2] = trmginput(arg1);');
        elseif nargin == 2
            eval('[out1,out2] = trmginput(arg1,arg2);');
        else
            eval('[out1,out2] = trmginput;');
        end
		if  nargout == 0
			out1 = [ out1 out2 ];
		end
    elseif nargout == 3,
        if nargin == 1,
            eval('[out1,out2,out3] = trmginput(arg1);');
        elseif nargin == 2
            eval('[out1,out2,out3] = trmginput(arg1,arg2);');
        else
            eval('[out1,out2,out3] = trmginput;');
        end
    end
else

    fig = gcf;
    figure(gcf);
    ax = gca;

    if nargin == 0
        how_many = -1;
        b = [];
    else
        how_many = arg1;
        b = [];
            if isstr(how_many), error('Requires a positive integer.'),end
        if how_many == 0
            ptr_fig = 0;
            while(ptr_fig ~= fig)
                ptr_fig = get(0,'PointerWindow');
            end
            scrn_pt = get(0,'PointerLocation');
            loc = get(fig,'Position');
            pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
            out1 = pt(1); y = pt(2);
        elseif how_many < 0
            error('Argument must be a positive integer.')
        end
    end

    pointer = get(gcf,'pointer');
    set(gcf,'pointer','crosshair');
    fig_units = get(fig,'units');
    set(fig,'units','normalized');
    axu = get(ax,'units');
    set(ax,'units','normalized')
    xlin = strcmp('linear',get(ax,'xscale'));
    ylin = strcmp('linear',get(ax,'yscale'));
    if nargin > 1
        norm_rect = [0 0 1 1];
        handle = fig;
    else
        norm_rect = get(ax,'Position');
        handle = ax;
        ydir = get(ax,'ydir');
        ax_lim  = axis;
        if ~xlin, ax_lim(1:2) = log(ax_lim(1:2)); end
        if ~ylin, ax_lim(3:4) = log(ax_lim(3:4)); end
        d_h = ax_lim(4) - ax_lim(3);
        if strcmp(ydir,'reverse'), ax_lim(3) = ax_lim(4); d_h = -d_h; end
        d_w = ax_lim(2) - ax_lim(1);
    end
    char = 0;

    while how_many ~= 0
        keydown = waitforbuttonpress;
        ptr_fig = get(0,'CurrentFigure');
        if(ptr_fig == fig)
            axes(ax); % Protects against user selecting another axis
            if keydown
                char = get(fig, 'CurrentCharacter');
                scrn_pt = get(0, 'PointerLocation');
                set(fig,'units','pixels')
                loc = get(fig, 'Position');
                set(fig,'units','normalized')
                pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
                ax_rect = [fix(norm_rect(1)*loc(3)),fix(norm_rect(2)*loc(4)),...
                    fix(norm_rect(3)*loc(3)),fix(norm_rect(4)*loc(4))];
                pt(1) = (pt(1) - ax_rect(1))/ax_rect(3);
                pt(2) = (pt(2) - ax_rect(2))/ax_rect(4);
                if nargin < 2
                    pt(1) = ax_lim(1) + pt(1) * d_w;
                    pt(2) = ax_lim(3) + pt(2) * d_h;
                    if ~xlin, pt(1) = exp(pt(1)); end
                    if ~ylin, pt(2) = exp(pt(2)); end
                end
                button = abs(char);
            else
                pt = get(handle, 'CurrentPoint');
                button = get(fig, 'SelectionType');
                if strcmp(button,'open')
                    button = b(max(size(b)));
                elseif strcmp(button,'normal')
                    button = 1;
                elseif strcmp(button,'extend')
                    button = 2;
                elseif strcmp(button,'alt')
                    button = 3;
                else
                    error('Invalid mouse selection.')
                end
            end

            how_many = how_many - 1;

            if(char == 13 & how_many ~= 0)
                % if the return key was pressed, char will == 13,
                % and that's our signal to break out of here whether
                % or not we have collected all the requested data
                % points.  
                % If this was an early breakout, don't include
                % the <Return> key info in the return arrays.
                % If this was the last expected event, then do
                % include the <Return> key info.  This is
                % exactly how 3.5 does it, and therefore its
                % how 4.0 is going to do it...
                break;
            end

            out1 = [out1;pt(1,1)];
            y = [y;pt(1,2)];
            b = [b;button];
        end
    end

    if nargout > 1
        out2 = y;
        if nargout > 2
            out3 = b;
        end
    else
        out1 = [out1 y];
    end
    set(fig,'pointer',pointer,'units',fig_units);
    set(ax,'units',axu)
end
