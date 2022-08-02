function plot_multiy(x,varargin)
%PLOT_MULTIY Graphs multiple y axes with staggered axes.
%   PLOT_MULTIY(X,Y1,Y2,Y3, ...) plots Y1, Y2, Y3, etc. vs X 
%   Note that X, Y1, etc. must be structures containing a Data field
%   and (optionally)  Label, Scale, and Color fields. 
%
%   Example:
%   time = 0:.01:20;
%   TIME_g    = struct('Data',time,'Label','time');
%   COS_g     = struct('Data',cos(time),'Label','cos t');
%   SIN_g     = struct('Data',sin(time),'Label','sin t');
%   TAN_g     = struct('Data',tan(time),'Label','tan t','Scale',[-5 5],'Color','k');
%   COS2_g    = struct('Data',cos(2*time),'Label','cos 2t','Color','r');
%   SIN2_g    = struct('Data',sin(2*time),'Label','sin 2t','Color','r');
%   SINxCOS_g = struct('Data',cos(time).*sin(time),'Label','sin t x cos t','Color','m');
%   SINCOS_g  = struct('Data',[sin(time); cos(time)],'Label','sin t, cos t');
%   plot_multiy(TIME_g,COS_g,SIN_g,TAN_g,COS2_g,SIN2_g,SINxCOS_g,SINCOS_g)
%   title('Trig functions')

% Dick Meisner, 2004

n_plots = length(varargin);

if n_plots < 2
    error(' *** This plot routine requires 2 or more y axes ***') 
end

% define axes boundaries
axleft=0.075;axright=0.952;
axtop=0.96;axbottom=0.08;

% calculate single axis height
axh = (axtop-axbottom)/n_plots;

% select font
if n_plots < 9
    font_size = 10;
else
    font_size = 8;
end

for i_plot = 1:n_plots
    
    y = varargin{i_plot};
    haxis = subplot('position',[axleft axtop-i_plot*axh axright-axleft axh]);
    hl = line(x.Data,y.Data);
    
    if isfield(y,'Label')
        hylbl = get(haxis,'ylabel');
        set(hylbl, 'FontSize', font_size, 'string', y.Label)
    end
    
    if isfield(y,'Color')
        set(hl,'Color',y.Color)
    end
    
    if isfield(y,'Scale')
        set(haxis,'YLim',y.Scale)
    end

    if isfield(x,'Scale')
        set(haxis,'XLim',x.Scale)
    end

    if rem(i_plot, 2) == 1
        posn = 'left';
    else
        posn = 'right';
    end
    
    set(haxis,'YAxisLocation',posn,'Box','Off','FontSize', font_size,'TickDir','out','TickLength',[0.005 0.025]);
    
    if i_plot ~= n_plots
        set(haxis,'XTickLabel','','XTick',[])
    end
    
end

if isfield(x,'Label')
    hxlbl = get(haxis,'xlabel');
    set(hxlbl, 'FontSize',   font_size, 'string', x.Label)
end

% prepare for possible ensuing 'title' command
subplot('position',[axleft axtop-axh axright-axleft axh])   

drawnow
