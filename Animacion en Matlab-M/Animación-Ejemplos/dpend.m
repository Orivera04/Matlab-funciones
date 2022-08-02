% dpend, a function to model the motion of a Double PENdulum. 
% Author: LiHong Huang Herman
% Differential equaitons project mfile
% 2002, spring
% last changed: 05/08/02
% Deep appreciation to David Arnold, 2002 spring D.E instructor.


% yorke, a function contains the equations of the double pendulum.
%==================================================================
% cases:
%
%          wait, after open the figure, wait for the users to use.
%          init, to create the fiugre window.
%          start, after hit the start button, the function is 
%          being called.
%==================================================================
% variables:
%         
%          play, to hold the value for playing the path of the pendula.
%          stop, relates to the stop button, to hold the value of stop button.
%          Hf, to check the exsiting of the Double Pendulum figure.
%          status, the arguments of the function dpend.
%          mainfig, to hold the value of the main figure, Double Pendulum
%          btnNumber, the number of the buttons.
%          label, the label of each button.
%          btnPos, the position of each button.
%          callbackstr, let the buttons to callback the functions.
%          startHndl, handling of the start button.
%          closeHndl, handling of the close button.
%          stopHndl, handling of the stop button.
%=================================================================          






function physics=dpend(status)
%==================================================================
% cases:
%
%          wait, after open the figure, wait for the users to use.
%          init, to create the fiugre window.
%          start, after hit the start button, the function is 
%          being called.
%==================================================================
% variables:
%         
%          play, to hold the value for playing the path of the pendula.
%          stop, relates to the stop button, to hold the value of stop button.
%          Hf, to check the exsiting of the Double Pendulum figure.
%          status, the arguments of the function dpend.
%          mainfig, to hold the value of the main figure, Double Pendulum
%          btnNumber, the number of the buttons.
%          label, the label of each button.
%          btnPos, the position of each button.
%          callbackstr, let the buttons to callback the functions.
%          startHndl, handling of the start button.
%          closeHndl, handling of the close button.
%          stopHndl, handling of the stop button.
%          MASS1Hndl, to show the text MASS1.
%          MASS2Hndl, to show the text MASS2.
%          MASS1EditHndl, let the user to input the value of the first mass.
%          MASS2EditHndl, let the user to input the value of the second mass.
%          LENGTH1Hndl, to show the text L1 (m).
%          LENGTH2Hndl, to show the text L2 (m).
%          LENGTH1EditHndl, let the user to input the value of first length.
%          LENGTH2EditHndl, let the user to input the value of second length.
%          ANMO1, to show the text ANGUV1, the angular velocity of first bob.
%          ANMO2, to show the text ANGUV2, the angular velocity of second bob.
%          ANMO1EditHndl, let the user to input the velocity of first bob.
%          ANMO2EditHndl, let the user to input the velocity of second bob.
%          ANGLE1, to show the text ANGLE1.
%          ANGLE2, to show the text ANGLE2.
%          ANGLE1EditHndl, let the user to input the angle of first length.
%          ANGLE2EditHndl, let the user to input the angle of second length.
%          TimeInterValHndl, show the text of time interval.
%          betime, let the user to input the beginning time.
%          entime, let the user to input the ending time.
%          hndlList, the hand list of start, stop and close
%          g, the gravitation accerlation
%          M1, relates to the mass of first bob.
%          M2, relates to the mass of second bob.
%          L1, relates to the length of first stick.
%          L2, relates to the length of seond stick.
%          P1, relates to the angular velocity of first bob.
%          P2, relates to the angular velocity of seond bob.
%          ti, relates to the initail time value.
%          tf, relates to the end time value.
%          A1, relates to the angle 1.
%          A2, relates to the angle 2.
%==================================================================


play=1;
stop=-1;
if nargin==0
    Hf=findobj(get(0,'children'),'tag','dpendFig');
    if isempty(Hf) % check for multiple instances
        status='init';
    else
        status='wait';
    end
    
   
end

% goto correct function
switch status
    
    
case 'wait'
    shg;
    % wait for the user...
    
    
    
    
    
    % initialize    
case 'init'
    
    oldFigNumber=watchon; % set up the buttons on and off
    i=0.015625;% set the unit of the figure to be 0.015625
    
    % set up the figure       
    mainfig=figure(...
        'Name','Double Pendulum',...
        'numberTitle','off',...
        'Visible','on',...
        'tag','dpendFig');
    colordef(mainfig,'white')
    
    % set up the axes     
    axes(...
        'Units','normalized',...
        'Position',[2*i,3*i,0.73,0.8],...
        'Visible','off',...
        'tag','dpendAxes');
    		
    % set up the first console frame 
    h=uicontrol(...
        'Style','frame',...
        'Units','normalized',...
        'Position',[0.77,i,i*14,1-2*i],...
        'BackgroundColor',[0.30 0.20 0.7]);
    
    % set up the start button
    btnNumber=1;
    label='start';
    btnPos=[0.75+2*i,3*i,5*i,0.125-2*i];
    callbackstr='dpend(''start'')';
    startHndl=uicontrol(...
        'Style','pushbutton',...
        'Parent', mainfig,...
        'Units','normalized',...
        'Position',btnPos,...
        'String',label,...
        'Interruptible','on',...
        'Tag','StartButton',...
        'Callback',callbackstr);     % NEED CALL BACK TO THE FUNCTION 
    
    % set up the close button
    btnNumber=2;
    label='close';
    btnPos=[0.875+2*i,3*i,5*i,0.125-2*i];
    callbackstr='close(''Double Pendulum'')';
    closeHndl=uicontrol(...
        'Style','pushbutton',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPos,...
        'String',label,...
        'Interruptible','on',...
        'Callback',callbackstr,...
        'Tag','CloseButton');   % CLOSE THE FIGURE DOUBLE PENDULUM
    
    % set up the stop button
    btnNumber=3;
    label='stop';
    btnPose=[0.75+3*i, 0.175,10*i,3*i];
    callbackstr='set(gca,''userdata'',-1)';
    stopHndl=uicontrol(...
        'style','pushbutton',...
        'units','normalized',...
        'position',btnPose,...
        'enable','off',...
        'string',label,...
        'callback',callbackstr); % relates the -1, the value of stop
    
        
    % set up the MASS1
    btnNumber=4;
    label='MA1(kg)';
    btnPose=[0.75+2*i,0.95-2*i,5*i,2*i];
    MASS1Hndl=uicontrol(...
        'Style','Text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'String',label,...
        'Tag','MASS1');
    
    % set up the MASS2
    btnNumber=5;
    label='MA2(kg)';
    btnPose=[0.875+i,0.95-2*i,5*i,2*i];
    MASS2Hndl=uicontrol(...
        'Style','Text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'String',label,...
        'Tag','MASS2');
    
    % set up the MASS1 edit
    btnNumber=6;
    btnPose=[0.75+2*i,0.95-6*i,5*i,3*i];
    MASS1EditHndl=uicontrol(...
        'Style','edit',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',3,...         % relates to the M1
        'Tag','MASS1EDIT');   % NEED CALL BACK TO THE FUNCTION, 
    
    % set up the MASS2 edit
    btnNumber=7;
    btnPose=[0.875+i,0.95-6*i,5*i,3*i];
    MASS2EditHndl=uicontrol(...
        'Style','edit',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',3,...         % relates to the M2
        'Tag','MASS2EDIT');   % NEED CALL BACK TO THE FUNCTION
    
    % set up the LENGTH1
    btnNumber=8;
    label='L1(m)';
    btnPose=[0.75+2*i,0.83-i,5*i,2*i];
    LENGTH1Hndl=uicontrol(...
        'Style','text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',label,...
        'Tag','LENGTH1');
    
    
    % set up the LENGTH2
    btnNumber=9;
    label='L2(m)';
    btnPose=[0.875+i,0.83-i,5*i,2*i];
    LENGTH1Hndl=uicontrol(...
        'Style','text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',label,...
        'Tag','LENGTH2');
    
    % set up the LENGTH1 edit
    btnNumber=10;
    btnPose=[0.75+2*i,0.83-5*i,5*i,3*i];
    LENGTH1EditHndl=uicontrol(...
        'Style','edit',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',4,...           % relates to the L1
        'Tag','LENGTH1EDIT');   % NEED CALL BACK TO THE FUNCTION
    
    
    % set up the LENGTH2 edit
    btnNumber=11;
    btnPose=[0.875+i,0.83-5*i,5*i,3*i];
    LENGTH2EditHndl=uicontrol(...
        'Style','edit',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',3,...            % relates to the L2
        'Tag','LENGTH2EDIT');   % NEED CALL BACK TO THE FUNCTION
    
    
    % set up the ANGUV1, the angular velocity of first angle
    btnNumber=12;
    label='AnVe1';
    btnPose=[0.75+2*i,0.7,5*i,2*i];
    ANMO1=uicontrol(...
        'Style','text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',label,...
        'Tag','ANGUV1');    
    
    
    % set up the ANGUV2, the angular velocity of second angle
    btnNumber=13;
    label='AnVe2';  
    btnPose=[0.875+i,0.7,5*i,2*i];
    ANMO2=uicontrol(...
        'Style','text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',label,...
        'Tag','ANGUV2');    
    
    
    % set up the ANGUV1 eidt
    btnNumber=14;
    btnPose=[0.75+2*i,0.7-4*i,5*i,3*i];
    ANMO1EditHndl=uicontrol(...
        'Style','edit',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',0,...         % relates to P1
        'Tag','ANGUV1EDIT');   % NEED CALL BACK TO THE FUNCTION
    
    
    
    % set up the ANGUV2 edit
    btnNumber=15;
    btnPose=[0.875+i,0.7-4*i,5*i,3*i];
    ANMO2EditHndl=uicontrol(...
        'Style','edit',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',0,...         % relates to P2
        'Tag','ANGUV2EDIT');   % NEED CALL BACK TO THE FUNCTION
    
    % set up the ANGLE1 
    btnNumber=16;
    label='Angle1';
    btnPose=[0.75+2*i,0.6-i,5*i,2*i];
    ANGlE1=uicontrol(...
        'style','text',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',label,...
        'Tag','ANGLE1');
    
    % set up the ANGLE2
    btnNumber=17;
    label='Angle2';
    btnPose=[0.875+i,0.6-i,5*i,2*i];
    ANGLE2=uicontrol(...
        'style','text',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',label,...
        'tag','ANGLE2');
    
    % set up the ANGLE1 EDIT
    btnNumber=18;
    btnPose=[0.75+2*i,0.525,5*i,3*i];
    ANGLE1EditHndl=uicontrol(...
        'style','edit',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',pi/2,...         % relates to A1
        'tag','ANGLE1EDIT');     % need to call back to the function
    
    % set up the ANGLE2 EDIT
    btnNumber=19;
    btnPose=[0.875+i,0.525,5*i,3*i];
    ANGLE2EditHndl=uicontrol(...
        'style','edit',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',-pi/2,...         % relates to A2
        'tag','ANGLE2EDIT');       % need to call back to the fuction
    
    
    % set up time interval
    btnNumber=20;
    label='Time (s)';
    btnPose=[0.75+3*i,0.5-2*i,10*i,2*i];
    TimeIntervalHndl=uicontrol(...
        'style','text',...
        'Parent',mainfig,...
        'Units','normalized',...
        'Position',btnPose,...
        'string',label,...
        'Tag','TimeInterval');
    
    
    % set up the betime
    btnNumber=21;
    btnPose=[0.75+2*i,0.375+2*i,5*i,3*i];
    betimeEditHndl=uicontrol(...
        'style','edit',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',0,...       % relates to ti 
        'tag','betime');     % NEED CALL BACK TO THE FUNCTION
    
    
    % set up the entime
    btnNumber=22;
    btnPose=[0.875+i, 0.375+2*i,5*i,3*i];
    entimeEditHndl=uicontrol(...
        'style','edit',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',230,...      % relates to tf, 230 it is a good entime
        'tag','entime');      % NEED CALL BACK TO THE FUNCTION
    
    % set up the popupmenu
    btnNumber=23;
    btnPose=[0.75+2*i,0.3,12*i,3*i];
    popupmenu=uicontrol(...
        'style','popupmenu',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string','SecondBobPath|PendulumFigure',...
        'tag','popupmenu');
    
    % set up the popupmenu text
    btnNumber=24;
    btnPose=[0.75+2*i,0.36,12*i,2*i];
    popupmenutext=uicontrol(...
        'style','text',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string','Drawing Method');
    
    
    % set up the second console frame 
    h=uicontrol(...
        'Style','frame',...
        'Units','normalized',...
        'Position',[2*i,0.9-3*i,47*i+0.1*i,8.3*i],...
        'BackgroundColor',[0.30 0.20 0.7]);
    
    % set up the tol text
    btnNumber=25;
    btnPose=[5*i, 0.97-2*i,6*i,2*i];
    toltex=uicontrol(...
        'style','text',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string','tolerance');
    % set up the toledit 
    btnNumber=26;
    btnPose=[5*i,0.87,6*i,3*i];
    tol=uicontrol(...
        'style','edit',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',0.000001,...
        'tag','tol');
    
    % set up the pow text
    btnNumber=27;
    btnPose=[12*i,0.97-2*i,6*i,2*i];
    powtex=uicontrol(...
        'style','text',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string','power');
    
    % set up the powedit
    btnNumber=28;
    btnPose=[12*i,0.87,6*i,3*i];
    pow=uicontrol(...
        'style','edit',...
        'parent',mainfig,...
        'units','normalized',...
        'position',btnPose,...
        'string',1/3,...
        'tag','pow');
    
    
    
    
    
    % uncover the figure
    hndlList=[startHndl, stopHndl, closeHndl];    % get the handl list of the buttons
    set(mainfig,'Visible','on',...
        'userData',hndlList);
    
    watchoff(oldFigNumber);     
    figure(mainfig);



% plot curves
case 'start'
    
    
    
    axHndl=gca;
    figNumber=gcf;
    hndlList=get(figNumber,'Userdata');
    startHndl=hndlList(1);
    stopHndl=hndlList(2);
    closeHndl=hndlList(3);
    set([startHndl closeHndl],...
        'Enable','off');
    set(stopHndl,'Enable','on');
    
    
    % global the parameters
    global g M1 M2 L1 L2
    g=9.8;
        
    %get figure handle
    Hf=findobj(get(0,'Children'),'Tag','dpendFig');
    
    % get children
    Hc=get(Hf,'Children');
    
    % get axes handle
    Ha=findobj(Hc,'flat','tag','dpendAxes');
    
    % get parameters
    H=findobj(Hc,'flat','tag','MASS1EDIT');
    M1=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','MASS2EDIT');
    M2=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','LENGTH1EDIT');
    L1=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','LENGTH2EDIT');
    L2=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','ANGUV1EDIT');
    P1=eval(get(H,'string'));
   
    H=findobj(Hc,'flat','tag','ANGUV2EDIT');
    P2=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','betime');
    ti=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','entime');
    tf=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','ANGLE1EDIT');
    A1=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','ANGLE2EDIT');
    A2=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','popupmenu');
    MENU=get(H,'value');
    
    H=findobj(Hc,'flat','tag','tol');
    tol=eval(get(H,'string'));
    
    H=findobj(Hc,'flat','tag','pow');
    pow=eval(get(H,'string'));
    
    % set up the axes
    set(axHndl,...
        'xlim',[-(L1+L2+1),L1+L2+1],...
        'ylim',[-(L1+L2+1),L1+L2+1],...
        'userdata',play,...
        'xtick',[],'ytick',[],...
        'YGrid','on','XGrid','on',...
        'drawmode','fast',...
        'visible','on',...
        'YDir','reverse',...   % it is reverse, because of the modeling of the 
        'nextplot','add');     % the equations
    xlabel('x-axis');
    ylabel('y-axis');

    FunFcn='yorke';

    x0=[A1,P1,A2,P2];    
    x=x0(:);        % obtain the vector of initial value
    
    

    t = ti;        
    tfinal=tf;
    hmax = (tfinal - t)/5;
    hmin = (tfinal - t)/200000;
    h = (tfinal - t)/100;
    x = x0(:);        
    tau = tol * max(norm(x,'inf'),1);
if (MENU==1);
    %y=[0;0]; the testing value
    y=[L1*sin(x(1))+L2*sin(x(3));L1*cos(x(1))+L2*cos(x(3))];
    % to obtain a vector contains the information of the displacement
    % of seond mass
    
    % Save L steps and plot like a comet tail.
    L = 50;
    Y = y*ones(1,L);
 
    cla;
    head = line( ...
        'color','r', ...
        'Marker','.', ...
        'markersize',25, ...
        'erase','xor', ...
        'xdata',y(1),'ydata',y(2));
    body = line( ...
        'color','y', ...
        'LineStyle','-', ...
        'erase','none', ...
        'xdata',[],'ydata',[]);
    tail=line( ...
        'color','b', ...
        'LineStyle','-', ...
        'erase','none', ...
        'xdata',[],'ydata',[]);
 
    % The main loop
    while (get(axHndl,'Userdata')==play) & (h >= hmin)
        if t + h > tfinal, h = tfinal - t; end
        % Compute the slopes
        s1 = feval(FunFcn, t, x);
        s2 = feval(FunFcn, t+h, x+h*s1);
        s3 = feval(FunFcn, t+h/2, x+h*(s1+s2)/4);
 
        % Estimate the error and the acceptable error
        delta = norm(h*(s1 - 2*s3 + s2)/3,'inf');
        tau = tol*max(norm(x,'inf'),1.0);
 
        % Update the solution only if the error is acceptable
        %ts = t;
        %ys = y;
        if delta <= tau
            t = t + h;
            x = x + h*(s1 + 4*s3 + s2)/6;
 
            % Update the plot
            y=[L1*sin(x(1))+L2*sin(x(3));L1*cos(x(1))+L2*cos(x(3))];
            Y = [y Y(:,1:L-1)];
            set(head,'xdata',Y(1,1),'ydata',Y(2,1));
            set(body,'xdata',Y(1,1:2),'ydata',Y(2,1:2));
            set(tail,'xdata',Y(1,L-1:L),'ydata',Y(2,L-1:L));
            drawnow;
        end
        
        
        
        % Update the step size
        if delta ~= 0.0
            h = min(hmax, 0.9*h*(tau/delta)^pow);
        end
    
    
    end;   
    % Main loop ...
    % ====== End of Demo
    set([startHndl closeHndl],'Enable','on');
    set(stopHndl,'Enable','off');
    
    
    
    
    
    
elseif (MENU==2);
        
 
   
    %y=[0;0]; the testing value
    y=[L1*sin(x(1)); L1*cos(x(1)); ...
            L1*sin(x(1))+L2*sin(x(3));L1*cos(x(1))+L2*cos(x(3))];
    % to obtain a vector contains the information of the displacement
    % of seond mass
    
    % Save L steps and plot like a comet tail.
    L = 50;
    Y = y*ones(1,L);
    first=line(...
        'xdata',[0,y(1)],...
        'ydata',[0,y(2)],...
        'erasemode','xor',...
        'color','r',...
        'linestyle','-');
            
    second=line(...
        'xdata',[y(1),y(3)],...
        'ydata',[y(2), y(4)],...
        'erasemode','xor',...
        'color','r',...
        'linestyle','-');
            
    cla;
    
 
    % The main loop
    while (get(axHndl,'Userdata')==play) & (h >= hmin)
        if t + h > tfinal, h = tfinal - t; end
        % Compute the slopes
        s1 = feval(FunFcn, t, x);
        s2 = feval(FunFcn, t+h, x+h*s1);
        s3 = feval(FunFcn, t+h/2, x+h*(s1+s2)/4);
 
        % Estimate the error and the acceptable error
        delta = norm(h*(s1 - 2*s3 + s2)/3,'inf');
        tau = tol*max(norm(x,'inf'),1.0);
 
        % Update the solution only if the error is acceptable
%        ts = t;
%        ys = y;
        if delta <= tau
            t = t + h;
            x = x + h*(s1 + 4*s3 + s2)/6;
 
            % Update the plot
            y=[L1*sin(x(1)); L1*cos(x(1)); ...
                L1*sin(x(1))+L2*sin(x(3));L1*cos(x(1))+L2*cos(x(3))];
            Y = [y Y(:,1:L-1)];
            first=line(...
                'xdata',[0,Y(1,1)],...
                'ydata',[0,Y(2,1)],...
                'color','r',...
                'linestyle','-',...
                'erasemode','xor',...
                'busyaction','queue',...
                'markersize',5,...
                'marker','o');
            
            second=line(...
                    'xdata',[Y(1,1),Y(3,1)],...
                    'ydata',[Y(2,1), Y(4,1)],...
                    'erasemode','xor',...
                    'color','r',...
                    'linestyle','-',...
                    'busyaction','queue',...
                    'markersize',5,...
                    'marker','o');
            drawnow;
            cla
                
        end
        
        
        
     
        % Update the step size
        if delta ~= 0.0
             h = min(hmax, 0.9*h*(tau/delta)^pow);
        end
	
        end;    % Main loop ...
        % ====== End of Demo
        set([startHndl closeHndl],'Enable','on');
        set(stopHndl,'Enable','off');
end
otherwise
    error('invalid argument')
end;    % if strcmp(action, ...

function xprime = yorke(t,x)
% a call by function
global g M1 M2 L1 L2
% the equations describe the motion of the double pendulum

xprime=zeros(4,1);

dt=x(1)-x(3);

u=1+M1/M2;

xprime(1)=x(2);

xprime(2)=(g*(sin(x(3))*cos(dt)-u*sin(x(1)))-(L2*x(4)^2+L1*x(2)^2*cos(dt))*sin(dt))/...
    (L1*(u-(cos(dt))^2));

xprime(3)=x(4);

xprime(4)=(g*u*(sin(x(1))*cos(dt)-sin(x(3)))+(u*L1*x(2)^2+L2*x(4)^2*cos(dt))*sin(dt))/...
    (L2*(u-(cos(dt))^2));

