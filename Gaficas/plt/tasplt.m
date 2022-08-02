% tasplt.m (aircraft performance chart)
alt = (0:4:32)';                       % altitudes (thousands of feet);
sigma = (1-alt/145.442).^4.25588;      % density ratio
ymin=50; ymax=186; tas = ymin:.1:ymax; % airspeed range
Pdrag = 44.072e-7;                     % parasitic drag coefficient
Idrag = 269.46;                        % induced drag coefficient
gph = sigma * Pdrag * tas.^3 + Idrag./(sigma * tas);
traceID =  ['sea level';' 4,000 ft';' 8,000 ft';
            '12,000 ft';'16,000 ft';'20,000 ft';
            '24,000 ft';'28,000 ft';'32,000 ft'];

% Now do efficiency and range chart ----------------------------------------------

mpg = repmat(tas,length(alt),1) ./ gph; % compute efficency (tas/gph)
xmn = 5;  xmx = 16;  ymx = 14.7;
plt(gph(1,:),mpg(1,:),...
    gph(2,:),mpg(2,:),...
    gph(3,:),mpg(3,:),...
    gph(4,:),mpg(4,:),...
    gph(5,:),mpg(5,:),...
    gph(6,:),mpg(6,:),...
    gph(7,:),mpg(7,:),...
    gph(8,:),mpg(8,:),...
    gph(9,:),mpg(9,:),...
    'Position',[10 60 900 600],...
    'FigName','Cessna 185 Efficiency & Range - standard temp (N3946Q)',...
    'Xlim',[xmn xmx],'LabelX','Fuel flow (gph)','AxisPos',[1 1 .94 .96],...
    'Ylim',[9 ymx],'LabelY','Nautical miles per gallon','TraceID',traceID);

% Display 'Percent Power' as alternative x-axis units above the graph
clbl = get(findobj('Rotation',90),'color');
s1 = text(0,0,'Percent Power');
set(s1,'Pos',[10 ymx+.28]);
x = get(gca,'xtick')';       % bottom x axis ticks
t1 = text(x,x,num2str(5*x));  % top x axis ticks (gph times 5)
set(t1,{'Pos'},num2cell([x-.1, 0*x+ymx+.1],2));

% Display 'Range' as alternative y-axis units to the right of the graph
s2 = text(0,0,'Range (nm) - 80 gallons, No reserve'); % right axis label
set(s2,'Rotation',90,'Pos',[16.8 10.5]);
y = get(gca,'ytick')';         % left side ticks
t2 = text(y,y,num2str(80*y));   % right side ticks (times 80 gallons)
set(t2,{'Pos'},num2cell([0*y + xmx*1.01, y],2));

% Now do true air speed chart -------------------------------------------------

plt(gph,tas,'Position',[10 120 880 600],...
    'FigName','Cessna 185 True Airspeed Chart - standard temp (N3946Q)',...
    'Xlim',[10 17],'LabelX','Fuel flow (gph)','AxisPos',[1 1 1 .96],...
    'Ylim',[115 ymax],'LabelY','True Airspeed (Knots)','TraceID',traceID);
set(gca,'ytick',ymin:5:ymax); % twice as many y-axis ticks than the default

% Display 'Percent Power' as alternative x-axis units above the graph
s3 = text(0,0,'Percent Power');
set(s3,'Pos',[13.2 ymax+3.7]);
x = get(gca,'xtick')';       % bottom x axis ticks
t3 = text(x,x,num2str(5*x));  % top x axis ticks (gph times 5)
set(t3,{'Pos'},num2cell([x-.07, 0*x+ymax+1.4],2));

t = [text(13.1,132,'gph  =  \sigma p V^3  +   i  /  \sigma V')
     text(13.5,128.5,'where:')
     text(13.5,126,sprintf('p = parasite drag coef = %7.5f\\times10^{-6}',Pdrag*1e6));
     text(13.5,122,sprintf('i = induced drag coef = %7.3f',Idrag));
     text(13.5,118,'\sigma = air density ratio = \rho / \rho_{SL}')];
set(t,'fontsize',13);
set(t(2),'fontsize',10);
set(t(1),'fontsize',14);
set([s2; t2],'fontsize',8);
set([s1; s2; s3; t],'color',clbl);
set([t1; t2; t3],'color','white');
set([s1; t1; s3; t3],'fontsize',9);
