function h = defaultplots(h)
% DEFAULTPLOTS Create the default plots drawn when GUI loads
%    h = DEFAULTPLOTS(h) creates the initial plots drawn in the GUI
%    from data given in structure h.  Returns the structure with new
%    fields set.

% Gregory Krudysz, 15-Oct-01 adapted from original code that was in 
%                   'Initialize' case.  Made minor adjustments.
%    Rev. 15-Oct-01: Minor adjustment to work in Matlab 5.1
%    Rev. 21-Nov-01: Commented out uistack so it will work on MAC
%====================================================
% DEFINITIONS
%====================================================
Xlimit = 0.50;		 % x-axis limits for Axes 1 and 2
YSPMAX = 1.05;     % max height of the spectrum display
xMAX = 1.05;

Fo = 8;      % continuous freq 
Fs = 20;     % sampling freq: Fo <Fs< 3*Fo
Xsp = 1/2;   %  make this P = pi; for the FOURIER TRANFORM CASE
R = Fo/Fs;

set(gcf,'menubar','none');
deffontsize = get(0,'DefaultAxesFontSize');
set(0,'UserData',[deffontsize 0]);

%DEFINITIONS
h.time1 = 0:0.0001:Xlimit;			
c1 = cos(2*pi*Fo*h.time1);
h.wflag = 0;                     % RADIAN FREQ FLAG
h.w_hat_flag = 0;                % DISCRETE RADIAN FREQ FLAG
h.LineWidth   = 3;  	         % LINE PROPERTIES
h.Fourier = 0;              % if TRUE scale spectrum by 2*pi
h.MarkerSize  = 6;
h.FontSize = 11;%10;				   % AXES PROPERTIES
h.FontSizeSym = h.FontSize + 0.2*h.FontSize;
h.phaseN = 0;							% Note: Assume initial phase = 0
set(h.Editbox1,'String',Fo,'FontSize',9);     % EDIT BOX 
set(h.Editbox2,'String',Fs,'FontSize',9);
set(h.Editbox3,'String',0,'FontSize',9);
MaxS1 = 1.49*Fs;                  % SLIDERS
MaxS2 = 1.5*Fs;
set(h.Slider1,'Min',0,'Max',MaxS1,'Value',Fo);
set(h.Slider2,'Min',0.5*Fs,'Max',MaxS2,'Value',Fs);
set([h.RButton2,h.RButton22],'Value',0);
set([h.ShowLF,h.ShowW,h.ShowW_hat],'Checked','off');
set(h.Text,'String',Fs);

% PLOT AXIS 
set(gcf,'CurrentAxes',h.AxisRef);
h.TextPh = text(6.5,2.1,sprintf('Phase = %.2f',h.phaseN),'FontSize',12, ...
    'units','normalized','Fontweight','bold');
h.TextFo = text(0,2,sprintf('f_o = %.1f (Hz)',Fo),...
    'FontSize',12,'units','normalized','Fontweight','bold');
h.TextFs = text(11.5,2,sprintf('f_s = %.1f (Hz)',Fs),... 
    'FontSize',12,'units','normalized','Fontweight','bold');

%====================================================================
% Axis 1
set(gcf,'CurrentAxes',h.Axis1);  
h.Line1 = plot(h.time1,c1,'linewidth',h.LineWidth);
set(gca,'NextPlot','ReplaceChildren' ...
    ,'FontSize',h.FontSize,'FontWeight','bold'...
    ,'YLim',xMAX*[-1 1],'XLim',[0 Xlimit]);
h.TextIn = text(Xlimit/2,1.25,sprintf('Input: cos(2%s %.1f t)','\pi',Fo) ...
    ,'FontSize',14, 'FontWeight', 'bold' ...
    ,'Color',[0 0 1],'HorizontalAlignment','center');
xlabel('Time (sec)')

%====================================================================
% Axis 2
time2i  = 0:1/Fs:Xlimit;
set(gcf,'CurrentAxes',h.Axis2);
set(gca,'XLimMode','manual' ... %PROBLEM (BLACK SPOT)% ,'FontSize',h.FontSize ... %
    ,'FontWeight','bold'...
    ,'XLim',[0 Xlimit] ...
    ,'YLim',xMAX*[-1 1] ...
    ,'XTick',time2i ...
    ,'XTickLabel',(0:length(time2i)-1)');
h.TextMiddle = text(Xlimit/2,1.25,sprintf('x[n] = cos(2%s %.2f n)','\pi',R) ...
    ,'FontSize',14, 'FontWeight', 'bold' ...
    ,'Color',[0 0 0],'HorizontalAlignment','center');

xlabel('Time (samples)','FontSize',11)
hold on
h.Line11 = plot(h.time1,c1,'linewidth',h.LineWidth,'Color',[0.77 0.77 1]); 
h.Line52 = plot(h.time1,c1,'linewidth',h.LineWidth,...
    'visible','off','Color',[0.77 0.77 1]); 
if h.MATLABVER >= 7
    h.Line2 = stem('v6',time2i,cos(2*pi*Fo*time2i) + h.phaseN,'r','filled'); 
else
    h.Line2 = stem(time2i,cos(2*pi*Fo*time2i) + h.phaseN,'r','filled'); 
end

%
%ln2Prop.MarkerSize = h.MarkerSize;
%ln2Prop.MarkerFaceColor = 'y';
%ln2Prop.MarkerEdgeColor = 'b';
%set(h.Line2(1),lnl2Prop);
%
set(h.Line2(1),'markersize',h.MarkerSize,'markerfacecolor','r','markeredgecolor','k');
set(h.Line2(2),'LineWidth',h.LineWidth+2,'clipping','on');
%%% uistack(h.Line2(1),'top');
hold off
set([h.Line52,h.Line11],'ButtonDownFcn','con2dis showLF')
set(h.Line2,'ButtonDownFcn','con2dis showLF')
h.TextClick = text(Xlimit/2, 0, 'Click on this plot to see aliases',...
    'Visible', 'Off', 'Rotation', 30, 'FontSize', 12, 'FontWeight', 'bold',...
    'Color',[0,0,0.4],'HorizontalAlignment','center');
set(h.TextClick,'ButtonDownFcn','con2dis showLF')

%====================================================================
% Axis 4
set(gcf,'CurrentAxes',h.Axis4);
hold on
h.Patch4 = patch([-Fs/2 Fs/2 Fs/2 -Fs/2],[0 0 YSPMAX YSPMAX],'y');
h.Line4d = line([-Fs -Fs nan 0 0 nan Fs Fs],...
    [0 YSPMAX nan 0 YSPMAX nan 0 YSPMAX],'LineStyle',':');
if h.MATLABVER >= 7
    h.Line4 = stem('v6',Fo,Xsp,'.b');
    h.Line4c = stem('v6',-Fo,Xsp,'*b');
else
    h.Line4 = stem(Fo,Xsp,'.b');
    h.Line4c = stem(-Fo,Xsp,'*b');
end

set(h.Line4,'ButtonDownFcn','con2dis LineDragStart','linewidth',h.LineWidth);
set(h.Line4c,'ButtonDownFcn','con2dis LineDragStart','linewidth',h.LineWidth);
hold off
set(h.Axis4,'NextPlot','ReplaceChildren'...
    ,'FontSize',h.FontSize,'FontWeight','bold'...
    ,'XLim',[-1.5*Fs 1.5*Fs] ...
    ,'YLim',[0 YSPMAX] ...
    ,'XTick',Fs*(-1:0.5:1) ...
    ,'XTickLabel',Fs*(-1:0.5:1) );
xlabel('f (Hz)')
title('Continuous Time Spectrum','FontWeight','bold')

%====================================================================
% Axis 3
set(gcf,'CurrentAxes',h.Axis3);
hold on
h.Patch3 = patch([-0.5 0.5 0.5 -0.5],[0 0 YSPMAX YSPMAX],'y');              
if h.MATLABVER >= 7
    h.Line3in = stem('v6',R,Xsp,'.b');
    h.Line3inC = stem('v6',-R,Xsp,'*b');
    h.Line3out = stem('v6',[-2+R -1+R 1+R 2+R], ...
        Xsp*[1,1,1,1],'.r');
    h.Line3outC = stem('v6',[-2-R -1-R 1-R 2-R], ...
        Xsp*[1,1,1,1],'*r');
else
    h.Line3in = stem(R,Xsp,'.b');
    h.Line3inC = stem(-R,Xsp,'*b');
    h.Line3out = stem([-2+R -1+R 1+R 2+R], ...
        Xsp*[1,1,1,1],'.r');
    h.Line3outC = stem([-2-R -1-R 1-R 2-R], ...
        Xsp*[1,1,1,1],'*r');
end              

set([h.Line3in,h.Line3inC,h.Line3out,h.Line3outC],'linewidth',h.LineWidth);
set(h.Axis3,'NextPlot','ReplaceChildren' ...
    ,'FontWeight','bold'...
    ,'FontSize',h.FontSize...
    ,'XLim',[-1.5 1.5] ...
    ,'YLim',[0 YSPMAX] ...
    ,'XTick',[-1 -0.5 0 0.5 1] ...
    ,'XTickLabel',[-1 -0.5 0 0.5 1]);
hold off
%xlabel('{}_{^{\fontsize{10}f = f_o / f_s}}^{\^}')
xlabel('f = f_o / f_s');
%h.hat = text(-0.21,-0.12,'^');
title('Discrete Time Spectrum','FontWeight','bold')

% Get Reference Positions
A1pos = get(h.Axis1,'position');
A3pos = get(h.Axis3,'position');

%====================================================================
% Axis 5
A5pos = A1pos + [(2*(A3pos(1)-A1pos(1))) 0 0 0];
h.Axis5 = axes('units','normalized','position',A5pos, ...
    'NextPlot','ReplaceChildren'...
    ,'FontSize',h.FontSize,'FontWeight','bold'...
    ,'box','on','YLim',xMAX*[-1 1],'XLim',[0 0.5]);
h.Line5 = plot(h.time1,c1,'linewidth',h.LineWidth);
h.TextOut = text(Xlimit/2,1.25,sprintf('Output: cos(2%s %.1f t)','\pi',Fo) ...
    ,'FontSize',14, 'FontWeight', 'bold' ...
    ,'Color',[0 0 1],'HorizontalAlignment','center');
xlabel('Time (sec)')

%====================================================================
% Axis 6
A6pos = A3pos + [(A3pos(1)-A1pos(1)) 0 0 0];
h.Axis6 = axes('units','normalized','position',A6pos);
set(h.Axis6,'NextPlot','ReplaceChildren' ...
    ,'FontSize',h.FontSize,'FontWeight','bold'...
    ,'Box','On' ...
    ,'XLim',[-1.5*Fs 1.5*Fs] ...
    ,'YLim',[0, YSPMAX] ...
    ,'XTick',Fs*(-1:0.5:1) ...
    ,'XTickLabel',Fs*(-1:0.5:1) );
title('Continuous Time Spectrum','FontWeight','bold')     
xlabel('f (Hz)')
hold on        
h.Patch6 = patch([-0.5*Fs 0.5*Fs 0.5*Fs -0.5*Fs],[0 0 YSPMAX YSPMAX],'y');
if h.MATLABVER >= 7
    h.Line6  = stem('v6',Fo,Xsp,'.b');
    h.Line6c = stem('v6',-Fo,Xsp,'*b');
else
    h.Line6  = stem(Fo,Xsp,'.b');
    h.Line6c = stem(-Fo,Xsp,'*b');
end
hold off

h.TextAlie = text(0,0.85,'A L I A S I N G !','Visible','Off', ...
    'FontSize',14,'FontWeight','Bold','HorizontalAlignment','center','Color','r');

%====================================================================
h.Hide = [h.Axis5,h.Axis6,h.Line5,h.Patch6,h.TextOut];
set([h.Line6,h.Line6c],'LineWidth',h.LineWidth);
h.Group = [h.AxisRef,h.Axis1,h.Axis2,h.Axis3,h.Axis4,h.Editbox1,h.Editbox2, ...
        h.Editbox3,h.Slider1,h.Slider2,h.Text,h.TextFo,h.TextFs,h.TextRB1,h.TextRB12, ... 
        h.Check,h.UnfoldB,h.Axis5,h.Axis6,...
        h.RButton2,h.RButton22];

set(h.AllMenu,'Checked','on');
set(h.Group,'Units','Characters');
FigSize = get(gcf,'Position');
FigSizeNew = [1 1 1.5 1].* FigSize;
set(gcf, 'Position', FigSizeNew);

%set(h.Group,'Units','normalized'); % MAC
%set(h.Hide,'Visible','On');
%set([h.Line6,h.Line6c],'Visible','On');
%------------------------------------
set(h.ShowW_hat,'Checked','on'); 
% change text labels
set(gcf,'CurrentAxes',h.Axis3);
%xlabel('{}_{^{\fontsize{11}\omega = 2\pi (f_o / f_s)}}^{\^}')
xlabel('\omega = 2\pi (f_o / f_s)');
%set(h.hat,'position',[-0.24 -0.12]);
set(h.Axis3,'FontName','Symbol'...
    ,'XTick',0.5*(-2:2)...
    ,'XTickLabel',{'-2p';'-p';'0';'p';'2p'}... 
    ,'FontSize',h.FontSizeSym ...
    ,'FontWeight','bold');
set(h.RButton22,'Value',1);
h.w_hat_flag = 1;

set(gcf,'WindowButtonMotionFcn','con2dis WindowButtonMotionFcn');

