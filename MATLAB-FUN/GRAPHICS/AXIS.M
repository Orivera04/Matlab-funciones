function [ans1, ans2, ans3] = axis(arg1, arg2, arg3, arg4);
%AXIS	Plot axis scaling and appearance.
% 	AXIS([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes
% 	on the current plot.
% 
% 	AXIS([XMIN XMAX YMIN YMAX ZMIN ZMAX]) sets the scaling for the
% 	x-, y- and z-axes on the current 3-D plot.
% 
% 	AXIS('auto') returns the axis scaling to its default, automatic
% 	mode where, for each plot, xmin = min(x), xmax = max(x), etc.
% 
% 	V = AXIS returns a row vector containing the scaling for the
% 	current plot.  If the current plot is two-dimensional, V has
% 	four components; if it is three-dimensional, V has six components.
% 
% 	AXIS(AXIS) freezes the scaling at the current limits, so that if
%	HOLD is turned on, subsquent plots will use the same limits.
% 
% 	AXIS('ij') puts MATLAB into its "matrix" axes mode.  The coordinate
% 	system origin is at the upper left corner.  The i axis is vertical
% 	and is numbered from top to bottom.  The j axis is horizontal and
% 	is numbered from left to right.
% 
% 	AXIS('xy') puts MATLAB into its default "Cartesian" axes mode.
% 	The coordinate system origin is at the lower left corner.  The x axis
% 	is horizontal and is numbered from left to right.  The y axis is
% 	vertical and is numbered from bottom to top.
% 
% 	AXIS('equal') changes the current axis box size so that equal tick
%	mark increments on the x- and y-axis are equal in size. This makes
%	PLOT(SIN(X),COS(X)) look like a circle, instead of an oval.
% 	AXIS('square') makes the current axis box square in size.
% 	AXIS('image'), for images, makes the aspect ratio the same size as
% 	the image.  
%
% 	AXIS('normal') restores the current axis box to full size and
%	removes any restrictions on the scaling of the units.
%	This undoes the effects of AXIS('square') and AXIS('equal').
%
%	AXIS('image') sets the aspect ratio and the axis limits so the
%	image in the current axes has square pixels.
% 
% 	AXIS('off') turns off all axis labeling and tick marks.
% 	AXIS('on') turns axis labeling and tick marks back on.
% 
% 	[S1,S2,S3] = AXIS('state') returns strings indicating the
% 	current setting of three axis properties.  
% 
% 	   S1 = 'auto' or 'manual'.
% 	   S2 = 'on' or 'off'.
% 	   S3 = 'xy' or 'ij'.


%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;

if(nargin == 0)
    ans1 = [get(ax,'XLim') get(ax,'YLim')];
    v = get(ax,'View');
    if(v ~= [0 90])
        ans1 = [ans1 get(ax,'ZLim')];
    end
elseif(nargin == 1 & ~isstr(arg1))
    if((max(size(arg1)) == 4) | (max(size(arg1)) == 6))
        set(ax,'XLim',arg1(1:2),'YLim',arg1(3:4),...
            'XLimMode','manual','YLimMode','manual');
        if(max(size(arg1)) == 6)
            set(ax,'ZLim',arg1(5:6),'ZLimMode','manual');
        end
        if max(size(arg1)) == 4 & ~ishold
            view(2);
        elseif max(size(arg1)) == 6
            if (get(ax,'View') == [0 90] & ~ishold)
                view(3);
            end
        end
    else
        error('Vector must have 4 or 6 elements.')
    end
else
    for i = 1:nargin
        cur_arg = eval(['arg',num2str(i)]);

        %
        % handle AUTO, AUTO[XYZ]:
        %
        if(strcmp(cur_arg(1:min(4,max(size(cur_arg)))),'auto'))

            do_all = (max(size(cur_arg)) == max(size('auto')));
            do_x = max(size(find(cur_arg == 'x')));
            do_y = max(size(find(cur_arg == 'y')));
            do_z = max(size(find(cur_arg == 'z')));
            if(do_all | do_x)
                set(ax,'XLimMode','auto');
            else
                set(ax,'XLimMode','manual');
            end
            if(do_all | do_y)
                set(ax,'YLimMode','auto');
            else
                set(ax,'YLimMode','manual');
            end
            if(do_all | do_z)
                set(ax,'ZLimMode','auto');
            else
                set(ax,'ZLimMode','manual');
            end

        %
        % handle MANUAL:
        %
        elseif(strcmp(cur_arg, 'manual'))
            set(ax,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');

        %
        % handle IJ:
        %
        elseif(strcmp(cur_arg, 'ij'))
            set(ax,'XDir','normal');
            set(ax,'YDir','reverse');

        %
        % handle XY:
        %
        elseif(strcmp(cur_arg, 'xy'))
            set(ax,'XDir','normal');
            set(ax,'YDir','normal');

        %
        % handle SQUARE:
        %
        elseif(strcmp(cur_arg, 'square')) 
            a = get(ax,'Aspect');
            set(ax,'Aspect',[1,a(2)])

        %
        % handle EQUAL:
        %
        elseif(strcmp(cur_arg, 'equal')) 
            a = get(ax,'Aspect');
            set(ax,'Aspect',[a(1),1])

        %
        % handle NORMAL:
        %
        elseif(strcmp(cur_arg, 'normal'))
            set(ax,'Aspect',[nan nan])

        %
        % handle IMAGE:
        %
        elseif(strcmp(cur_arg,'image'))
            m = diff(get(ax,'Ylim'));
            n = diff(get(ax,'Xlim'));
            set(ax,'Aspect',[n/m 1])

        %
        % handle OFF:
        %
        elseif(strcmp(cur_arg, 'off'))
            set(ax,'Visible','off');
            set(get(ax,'Title'),'Visible','on');

        %
        % handle ON:
        %
        elseif(strcmp(cur_arg, 'on'))
            set(ax,'Visible','on');

        %
        % handle STATE:
        %
        elseif(strcmp(cur_arg, 'state'))
            str = '';
            if(strcmp(get(ax,'XLimMode'), 'auto'))
                str = 'x';
            end
            if(strcmp(get(ax,'YLimMode'), 'auto'))
                str = [str, 'y'];
            end
            if(strcmp(get(ax,'ZLimMode'), 'auto'))
                str = [str, 'z'];
            end
            if(max(size(str)) == 3)
                ans1 = 'auto';
            else
                ans1 = 'manual';
            end

            if(nargout > 1)
                if strcmp(get(ax,'Visible'),'on')
                    ans2 = 'on';
                else
                    ans2 = 'off';
                end
            end

            if(nargout > 2)
                ans3 = 'xy';
                if(    strcmp(get(ax,'XDir'),'normal') & ...
                    strcmp(get(ax,'YDir'),'reverse'))
                        ans3 = 'ij';
                end
            end

        %
        % handle ERROR (NONE OF THE ABOVE STRINGS FOUND):
        %
        else
            error(['Unknown command option ''',cur_arg,'''']);
        end
    end
end
