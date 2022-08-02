% mm3806.m

t = linspace(0,1);

x = sin(2*pi*t);
y = 1.2*cos(4*pi*t);
z = exp(-2*t).*sin(3*pi*t - pi/4);

plot(t,x,t,y,'-.',t,z,'--')
title('Figure 38.6: Picture in a Picture Zoom.');
xlabel 't'
ylabel('X, Y, Z')
p=[.5 .75 -1 0];
Ha=gca;
Hzl=line('Parent',Ha,'Xdata',p([1 1 2 2 1]),... % draw zoom box
   'Ydata',p([3 4 4 3 3]),...
   'Color',[0 0 0],...
   'LineStyle',':',...
   'Tag','MMZOOM');
Hf=get(Ha,'Parent');
Hz=copyobj(Ha,gcf);        % copy original axes
Pa=mmgetpos(Ha,'Normalized');
alpha=1/3; beta=.5;      % shrink and shift copy
Pa=[Pa(1)+beta Pa(2)+(1-alpha-.02)*Pa(4) alpha*Pa(3:4)];
Pf=mmgetsiz(Ha,'points');
set(Hz,'units','Normalized',...     % revise zoomed properties
   'Position',Pa,...                % position
   'Xlim',p(1:2),'Ylim',p(3:4),...  % axis limits
   'Box','on',...                   % axis box on
   'Xgrid','off','Ygrid','off',...  % grid lines off
   'FontUnits','points',...
   'FontSize',max(6,Pf-2),...       % shrink font size
   'ButtonDownFcn','selectmoveresize',...% enable drag
   'Tag','MMZOOM',...               % tag zoomed axes
   'UserData',Ha)                   % store original axes handle
[Htx,Hty,Htt]=mmget(Hz,'Xlabel','Ylabel','Title');
set([Htx,Hty,Htt],'String','')      % delete labels on zoomed axes
