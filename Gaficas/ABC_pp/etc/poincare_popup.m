function f = poincare_popup(decide)
% Run Poincaré Application
global h a

switch decide
    case 0 % Set up Poincaré GUI 
        %Background Color
        back_clr = [0.7529 0.7929 0.97];
        % Figure
        f(1) = figure('Color',[0.83137 0.81569 0.78431], ...
            'Color',back_clr, ...
            'Name','Attractor Poincaré Section **BETA VERSION**', ...
            'NumberTitle','off', ...
            'Units','normalized','Position',[.01 .044 .974 .897], ...
            'Resize','off', ...
            'Menubar','none',...
            'Visible','off', ...
            'WindowStyle','normal');
        
        h(1) = axes('Parent',f(1), ...
            'Color',[1 1 1],'CameraUpVector',[0 1 0],...
            'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
            'Units','normalized','Position',[0.049 0.065 0.56 0.74]);
        
        h(2) = axes('Parent',f(1), ...
            'Color',[1 1 1],'CameraUpVector',[0 1 0],...
            'XColor',[0 0 0],'YColor',[0 0 0],'ZColor',[0 0 0],...
            'Units','normalized','Position',[0.64 0.065 0.35 0.48]);
        
        h(3) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Frame 
            'Units','normalized','Position',[0.03 0.83 0.95 0.15],'Style','frame');
        
        h(4) = uicontrol('Parent',f(1), ... % B Slider
            'Style','slider','Min',-100,'Max',100,... 
            'Units','normalized','Position',[0.128 0.87 0.3 0.024],...
            'SliderStep',[0.01 0.1],...
            'Value',2,...
            'Visible','on',...
            'CallBack','poincare_popup(1)');
        h(5) = uicontrol('Parent',f(1), ... % D Slider
            'Style','slider','Min',-100,'Max',100,... 
            'Units','normalized','Position',[0.6 0.87 0.3 0.024],...
            'SliderStep',[0.01 0.1],...
            'Value',0,...
            'Visible','on',...
            'CallBack','poincare_popup(1)');
        h(6) = uicontrol('Parent',f(1), ... % A Slider
            'Style','slider','Min',-100,'Max',100,... 
            'Units','normalized','Position',[0.128 0.91 0.3 0.024],...
            'SliderStep',[0.01 0.1],...
            'Value',1,...
            'Visible','on',...
            'CallBack','poincare_popup(1)');
        h(7) = uicontrol('Parent',f(1), ... % C Slider
            'Style','slider','Min',-100,'Max',100,... 
            'Units','normalized','Position',[0.6 0.91 0.3 0.024],...
            'SliderStep',[0.01 0.1],...
            'Value',3,...
            'Visible','on',...
            'CallBack','poincare_popup(1)');
        
        % Update Min/Max values
        H_ABC_pp(10) = uicontrol('Parent',f(1),'Style','pushbutton',...
            'Units','normalized','Position',[0.04 0.835 0.18 0.03125],...
            'ForegroundColor',[0 0 0],...
            'FontWeight','bold',...
            'String','Update Min/Max slider values',...
            'Visible','on',...
            'CallBack','poincare_popup(2)');
        
        a(1) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.04 0.91 0.02 0.023],'String','A:-','Style','text');
        a(2) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.04 0.87 0.02 0.023],'String','B:-','Style','text');
        a(3) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.51 0.91 0.02 0.023],'String','C:-','Style','text');
        a(4) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.51 0.87 0.02 0.023],'String','D:-','Style','text');
        
        a(5) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% amin Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.062 0.907 0.06 0.028],'Style','edit','String','-100');
        
        a(6) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% bmin Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.062 0.867 0.06 0.028],'Style','edit','String','-100');
        
        a(7) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% amax Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.436 0.907 0.06 0.028],'Style','edit','String','100');
        
        a(8) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% bmax Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.436 0.867 0.06 0.028],'Style','edit','String','100');
        
        a(9) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% cmin Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.532 0.907 0.06 0.028],'Style','edit','String','-100');
        
        a(10) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% dmin Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.532 0.867 0.06 0.028],'Style','edit','String','-100');
        
        a(11) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% cmax Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.906 0.907 0.06 0.028],'Style','edit','String','100');
        
        a(12) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% dmax Input Box
            'HorizontalAlignment','left','Units','normalized','Position',[0.906 0.867 0.06 0.028],'Style','edit','String','100');
        
        a(4) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'FontWeight','bold','ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.04 0.947 0.234 0.024],'String','Plane Equation {Ax+By+Cz+D=0} ->','Style','text');
        
        a(4) = uicontrol('Parent',f(1),'BackgroundColor',[1 1 1],...% Text
            'FontName','Helvetica','HorizontalAlignment','left',...
            'FontSize',10,'ForegroundColor',[0 0 0],...
            'Units','normalized','Position',[0.28 0.947 0.234 0.024],'String',[num2str(get(h(6),'Value')),'x+',num2str(get(h(4),'Value')),'y+',num2str(get(h(7),'Value')),'z+',num2str(get(h(5),'Value')),'=0'],'Style','text');
        
        set(f(1),'Visible','on');
        % Read in the variables passed to poincaré_popup that were temp saved to disk!!
        S = load('data\temp.mat');
        Timeseries = S.Timeseries;
        sys_variables = S.sys_variables;
        integ_variables = S.integ_variables;
        view_angle = S.view_angle;
        plane = [get(h(6),'Value'),get(h(4),'Value'),get(h(7),'Value'),get(h(5),'Value')];
        poincare_points = poincare(Timeseries,plane,sys_variables,integ_variables);
        if isreal(poincare_points)
            axes(h(2));
            for i=1:length(poincare_points(:,1))
                if poincare_points(i,4) == 1
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'or');
                    hold on;
                else
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'ob');
                    hold on;
                end
            end  
            hold off;
            xmax = max(poincare_points(:,1));
            xmin = min(poincare_points(:,1));
            zmax = max(poincare_points(:,3));
            zmin = min(poincare_points(:,3));
            if xmax > 0
                xmax=xmax*1.1;
            else
                xmax=xmax*.9;
            end
            if xmin > 0
                xmin=xmin*.9;
            else
                xmin=xmin*1.1;
            end
            if zmax > 0
                zmax=zmax*1.1;
            else
                zmax=zmax*.9;
            end
            if zmin > 0
                zmin=zmin*.9;
            else
                zmin=zmin*1.1;
            end
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),xmin,xmax,zmin,zmax);
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor','g','FaceAlpha',.2,'EdgeAlpha',0.1);
            set(h(2),'CameraUpVector',[plane(1) plane(2) plane(3)]);
            view(0,0);axis tight;
            rotate3d off;
            
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),-plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10));
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor','g','FaceAlpha',1,'EdgeAlpha',0.1);
            view(view_angle);%axis off;
            rotate3d(h(1));
        else
            % Read in warning image and place it Small Axes
            warning off all % Suppress Warning
            axes(h(2));
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),-plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10));
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor','g','FaceAlpha',1,'EdgeAlpha',0.1);
            view(view_angle);%axis off;
            rotate3d(h(1));
        end
            
    case 1
        clear('poincare_points');
        S = load('data\temp.mat');
        Timeseries = S.Timeseries;
        sys_variables = S.sys_variables;
        integ_variables = S.integ_variables;
        set(a(4),'String',[num2str(get(h(6),'Value')),'x+',num2str(get(h(4),'Value')),'y+',num2str(get(h(7),'Value')),'z+',num2str(get(h(5),'Value')),'=0']);
        plane = [get(h(6),'Value'),get(h(4),'Value'),get(h(7),'Value'),get(h(5),'Value')];
        if plane(1) == 0
            plane(1) = 0.001; % Avoid Divide By Zero Error
        end
        if plane(2) == 0
            plane(2) = 0.001; % Avoid Divide By Zero Error
        end
        if plane(3) == 0
            plane(3) = 0.001; % Avoid Divide By Zero Error
        end
        if plane(4) == 0
            plane(4) = 0.001; % Avoid Divide By Zero Error
        end
        poincare_points = poincare(Timeseries,plane,sys_variables,integ_variables);
        if isreal(poincare_points)
            axes(h(2));
            for i=1:length(poincare_points(:,1))
                if poincare_points(i,4) == 1
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'or');
                    hold on;
                else
                    plot3(poincare_points(i,1),poincare_points(i,2),poincare_points(i,3),'ob');
                    hold on;
                end
            end  
            hold off;   
            
            xmax = max(poincare_points(:,1));
            xmin = min(poincare_points(:,1));
            zmax = max(poincare_points(:,3));
            zmin = min(poincare_points(:,3));
            if xmax > 0
                xmax=xmax*1.1;
            else
                xmax=xmax*.9;
            end
            if xmin > 0
                xmin=xmin*.9;
            else
                xmin=xmin*1.1;
            end
            if zmax > 0
                zmax=zmax*1.1;
            else
                zmax=zmax*.9;
            end
            if zmin > 0
                zmin=zmin*.9;
            else
                zmin=zmin*1.1;
            end
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),plane(4),xmin,xmax,zmin,zmax);
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor','g','FaceAlpha',.2,'EdgeAlpha',0.1);
            set(h(2),'CameraUpVector',[plane(1) plane(2) plane(3)]);
            view(0,0);axis tight;
            rotate3d off;
            
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),-plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10));
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor','g','FaceAlpha',1,'EdgeAlpha',0.1);
            %view(view_angle);%axis off;
            rotate3d(h(1));
        else
            % Read in warning image and place it Small Axes
            warning off all % Suppress Warning
            axes(h(2));
            imagen=imread('etc\warning.png');
            image(imagen);
            axis off;
            warning on all % Turn back on warnings
            axes(h(1)); % Point to main stage            
            plot3(Timeseries(1,:),Timeseries(2,:),Timeseries(3,:),'Color','k');
            xmin=min(Timeseries(1,:));
            xmax=max(Timeseries(1,:));
            zmin=min(Timeseries(3,:));
            zmax=max(Timeseries(3,:));
            
            vertex_matrix = plotplane(plane(1),plane(2),plane(3),-plane(4),(xmin+xmin/10),(xmax+xmax/10),(zmin+zmin/10),(zmax+zmax/10));
            patch('Vertices',vertex_matrix,'Faces',[1 2 4 3],'EdgeColor','r','FaceColor','g','FaceAlpha',1,'EdgeAlpha',0.1);
            %view(view_angle);%axis off;
            rotate3d(h(1));
        end
        
    case 2
        set(h(6),'Min',str2num(get(a(5),'String')));
        set(h(6),'Max',str2num(get(a(7),'String')));
        set(h(4),'Min',str2num(get(a(6),'String')));
        set(h(4),'Max',str2num(get(a(8),'String')));
        set(h(7),'Min',str2num(get(a(9),'String')));
        set(h(7),'Max',str2num(get(a(11),'String')));
        set(h(5),'Min',str2num(get(a(10),'String')));
        set(h(5),'Max',str2num(get(a(12),'String')));
                
end

%%%%%%%%%%%%%%%%%%%&
% SubFunction  Tom %
%%%%%%%%%%%%%%%%%%%%

function regional = intersection_finder(time_series,plane)

% 'regional' each row of this returned matrix details the intersection of the trajectory 'time_Series' 
% with the input 'plane'
% The first three columns (n,1:3) of each row are the xyz co-ordinates of the point one side of the plane.
% The next three columns (n,4:6) detail the first point in the data set after the intersection with the plane.
% The seventh column (n,10)is updated every time an intersection is found and details the total number of 
% intersections in that data set.

% Consider two point vectors P1(x1,y1,z1) and P2(x2,y2,z2) taken from the time_series data set
% Now consider a plane of the form (aX + bY + cZ - d = 0)
% If the vector P1P2 intersects the plane then one of the following
% conditions will be true
% condition1:
%  (a*x1 + b*y1 + c*z1 -d > 0) and (a*x2 + b*y2 + c*z2 -d < 0)
% condition2:
%  (a*x1 + b*y1 + c*z1 -d > 0) and (a*x2 + b*y2 + c*z2 -d < 0)
% To complete the algorithm the condition where one of the points lies upon the
% plane is accounted for
% condition3:
% (a*x1 + b*y1 + c*z1 -d == 0) or (a*x2 + b*y2 + c*z2 -d == 0)

a=plane(1);
b=plane(2);
c=plane(3);
d=plane(4);

check='voido';
time_series=time_series';
index=1;
for n=2:length(time_series)
    
    cond11=(a*time_series(n-1,1) + b*time_series(n-1,2) + c*time_series(n-1,3) -d > 0);
    cond12=(a*time_series(n,1) + b*time_series(n,2) + c*time_series(n,3) -d < 0);
    cond1=cond11 && cond12;
    % Checks on direction of the vector for intersection
    
    cond21=(a*time_series(n-1,1) + b*time_series(n-1,2) + c*time_series(n-1,3) -d < 0);
    cond22=(a*time_series(n,1) + b*time_series(n,2) + c*time_series(n,3) -d > 0);
    cond2=cond21 && cond22;
    % Checks the opposite direction of the vector for intersection
    
    cond3=(a*time_series(n,1) + b*time_series(n,2) + c*time_series(n,3) -d == 0);
    % Checks if either point lies upon the plane
    
    if(cond1)
        regional(index,1:3)=time_series(n-1,1:3);
        regional(index,4:6)=time_series(n,1:3);
        regional(index,7)=1;
        index=index+1;
        check='valid';
    end;
    
    if(cond2)
        regional(index,1:3)=time_series(n-1,1:3);
        regional(index,4:6)=time_series(n,1:3); 
        regional(index,7)=0;
        index=index+1;
        check='valid';
    end;    
    
    if(cond3)
        
        regional(index,1:3)=time_series(n,1:3);
        regional(index,4:6)=time_series(n,1:3);
        
        cond23=(a*time_series(n+1,1) + b*time_series(n+1,2) + c*time_series(n+1,3) -d > 0);
        cond25=cond21&&cond23;       
        cond13=(a*time_series(n+1,1) + b*time_series(n+1,2) + c*time_series(n+1,3) -d < 0);
        cond15=cond11 && cond13;
        
        if(cond15)
            regional(index,7)=1;
        end;
        if(cond25)
            regional(index,7)=0;
        end;    
        index=index+1;
        check='valid';
    end;   
end;


if(check=='voido')
    clear regional;
    regional(1,1:7)=i;
end

%%%%%%%%%%%%%%%%%%%&
% SubFunction  Tom %
%%%%%%%%%%%%%%%%%%%%

function poin = poincare(time_series_1,plane,sys_variables,integ_variables)

% 'time_series' is Nx1 matrix where N is the length of the timeseries
% 'plane' is the plane equation coefficients in matrix form
%  if a plane is desccribed by ax+by+cz-d=0 then the matrix is of the form [a b c d]
%  sys_variables = [L,R0,C2,G,Ga,Gb,C1,E];
%  integ_variables = [x0,y0,z0,dataset_size,step_size];

a=plane(1,1);
b=plane(1,2);
c=plane(1,3);
d=-plane(1,4);

execute_flag=1;

step_size_reduction=100;
number_of_steps=100;

approx_1=intersection_finder(time_series_1,plane);

approx_1(:,4)=approx_1(:,7);

poin=approx_1;

%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function TimeSeries = chua(sys_variables,integ_variables)
% Syntax: TimeSeries=chua(sys_variables,integ_variables)
% sys_variables = [L,R0,C2,G,Ga,Gb,E,C1];
% integ_variables = [x0,y0,z0,dataset_size,step_size];


% Models Initial Variables
%-------------------------

L  =           sys_variables(1);
R0 =           sys_variables(2);
C2 =           sys_variables(3);
G  =           sys_variables(4);
Ga =           sys_variables(5);
Gb =           sys_variables(6);
E  =           sys_variables(7);
C1 =           sys_variables(8);
x0 =           integ_variables(1);
y0 =           integ_variables(2);
z0 =           integ_variables(3);
dataset_size = integ_variables(4);
step_size =    integ_variables(5);

TimeSeries = [x0, y0, z0]'; % models initial conditions

% Optimized Runge-Kutta Variables
%--------------------------------

h = step_size*G/C2;
h2 = (h)*(.5);
h6 = (h)/(6);

anor = Ga/G;
bnor = Gb/G;
bnorplus1 = bnor + 1;
alpha = C2/C1;
beta = C2/(L*G*G);
gammaloc = (R0*C2)/(L*G);

bh = beta*h;
bh2 = beta*h2;
ch = gammaloc*h;
ch2 = gammaloc*h2;
omch2 = 1 - ch2;

k1 = [0 0 0]';
k2 = [0 0 0]';
k3 = [0 0 0]';
k4 = [0 0 0]';
M = [0 0 0]';

% Calculate Time Series
%----------------------

M(1) = TimeSeries(3)/E;
M(2) = TimeSeries(2)/E;
M(3) = TimeSeries(1)/(E*G);

for i=1:dataset_size
    % Runge Kutta
    % Round One
    k1(1) = alpha*(M(2) - bnorplus1*M(1) - (.5)*(anor - bnor)*(abs(M(1) + 1) - abs(M(1) - 1)));
    k1(2) = M(1) - M(2) + M(3);
    k1(3) = -beta*M(2) - gammaloc*M(3);
    % Round Two
    temp = M(1) + h2*k1(1);
    k2(1) = alpha*(M(2) + h2*k1(2) - bnorplus1*temp - (.5)*(anor - bnor)*(abs(temp + 1) - abs(temp - 1)));
    k2(2) = k1(2) + h2*(k1(1) - k1(2) + k1(3));
    k2(3) = omch2*k1(3) - bh2*k1(2);
    % Round Three
    temp = M(1) + h2*k2(1);
    k3(1) = alpha*(M(2) + h2*k2(2) - bnorplus1*temp - (.5)*(anor - bnor)*(abs(temp + 1) - abs(temp - 1)));
    k3(2) = k1(2) + h2*(k2(1) - k2(2) + k2(3));
    k3(3) = k1(3) - bh2*k2(2) - ch2*k2(3);
    % Round Four
    temp = M(1) + h*k3(1);
    k4(1) = alpha*(M(2) + h*k3(2) - bnorplus1*temp - (.5)*(anor - bnor)*(abs(temp + 1) - abs(temp - 1)));
    k4(2) = k1(2) + h*(k3(1) - k3(2) + k3(3));
    k4(3) = k1(3) - bh*k3(2) - ch*k3(3);
    
    M = M + (k1 + 2*k2 + 2*k3 + k4)*(h6);
    
    TimeSeries(3,i+1) = E*M(1);
    TimeSeries(2,i+1) = E*M(2); 
    TimeSeries(1,i+1) = (E*G)*M(3);
    
    i=i+1;
end

%%%%%%%%%%%%%%%%%%%%%%
% SubFunction (James)%
%%%%%%%%%%%%%%%%%%%%%%

function vertex_matrix = plotplane(a,b,c,d,xmin,xmax,zmin,zmax)
% Uses simple geometry:'plane equation' manipulation to return a vertex
% matrix using plane equation ax+by+cz+d=0 coefficients to calculate
% unknown vertices - ymin ymax
if a == 0
    a = 0.001; % Avoid Divide By Zero Error
end
if b == 0
    b = 0.001; % Avoid Divide By Zero Error
end
if c == 0
    c = 0.001; % Avoid Divide By Zero Error
end
if d == 0
    d = 0.001; % Avoid Divide By Zero Error
end
vertex_matrix = [xmin ((-d-a*xmin-c*zmin)/b) zmin; xmin ((-d-a*xmin-c*zmax)/b) zmax; xmax ((-d-a*xmax-c*zmin)/b) zmin; xmax ((-d-a*xmax-c*zmax)/b) zmax];