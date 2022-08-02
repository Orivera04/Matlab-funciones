function demo3(action)

% DEMO3 - DBMA-based coverage region animation.
% demo3(action)
%
% This demo displays and animates the DBMA-based coverage 
% region of a typical LEO satellite.  The "region of eligibility" 
% for DBMA coverage is symmetric about the sub-satellite point 
% and is given by the intersection of three larger regions:
%
%   (1) Visibility cone around the subsatellite point - the region 
%       in which the elevation to the satellite from the ground exceeds 
%       a given angle, given by 'elev1' in degrees.  Nodes may transmit 
%       at a given time only if the satellite is above this elevation.
%   (2) Orbital swath - the region defined by a lower bound to the 
%       maximum elevation angle to the satellite, given by 'elev2' in 
%       degrees.  Only nodes that have observed, or will observe, an 
%       elevation angle greater than this value upon closest passage 
%       of the satellite during the current orbital cycle are permitted 
%       to transmit.
%   (3) Orbital time window - the region observing closest passage of 
%       the satellite within a given time window, given by 'tmax' in 
%       seconds.  Only nodes that have observed (will observe) maximum 
%       elevation within this interval from the given time are 
%       permitted to transmit.  (NOTE: A negative value for 'tmax' 
%       specifies use of the full time window during which the 
%       visibility criteria above are met.)
%
% The satellite in this demo follows a 53-deg inclined circular orbit 
% at 1000 km altitude. 
%
% Possible button actions:
%  'initialize' - initialize UI and graphics
%  'start'      - start animation
%  'stop'       - stop animation
%  'info'       - display help info
%  'close'      - close graphics window
%
% P.G. Bonanni / Irfan Ali  7/17/00

% (Modeled after Matlab "Lorenz" demo)

% Information regarding the play status will be held in
% the axis user data according to the following table:
play= 1;
stop=-1;


global JT XECF VECF OMAP

% Constants
day2sec = 24*3600;
sec2day = 1/day2sec;


if nargin<1,
    action='initialize';
end;


if strcmp(action,'initialize'),

    oldFigNumber=watchon;

    %=========================================================================================
    % Generate simulation time vector (Note: For convenience in selecting 'ran0' 
    % parameter below, choose start time such that Greenwich right ascension is near 0)
    tstart = '01-Jan-2000 17:17:18.2';   % start date/time
    ndays  = 2;                          % number of days
    dt     = 10;                         % sample time (sec)
    time   = (0:dt:ndays*day2sec)';      % elapsed orbit time (sec)
    JT = str2jt(tstart) + time*sec2day;  % Julian time vector (days)

    % Generate Walker constellation orbits
    nsat     = 6;     % number of satellites
    radius   = 7378;  % orbit radius (km)
    inclin   = 53;    % inclination angle (deg)
    nplanes  = 3;     % number of planes
    harmonic = 1/2;   % harmonic factor
    ran0     = -90;   % right ascension of the ascending node for first orbit (deg)
    anom0    = 0;     % initial true anomaly for first orbit (deg)
    [XECI,VECI] = walker(nsat,radius,inclin,nplanes,harmonic,ran0,anom0,time);

    % Convert orbits to ECF coordinates
    XECF = cell(size(XECI));  % pre-allocate space
    VECF = cell(size(VECI));  % pre-allocate space
    for k=1:nsat, [XECF{k},VECF{k}] = eci2ecf2(JT,XECI{k},VECI{k}); end

    % Calculate sub-satellite ground tracks
    for k = 1:nsat
      [elon,nlat] = lonlat(XECF{k});
      OMAP{k} = [elon,nlat];
    end
    %=========================================================================================

    figNumber=figure( ...
        'Name','DBMA-Based Coverage Animation', ...
        'NumberTitle','off', ...
        'Visible','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.05 0.10 0.75 0.95], ...
        'Visible','off');

    text(0,0,'Press the "Start" button to see the animation', ...
        'HorizontalAlignment','center');
    axis([-1 1 -1 1]);

    %===================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    xPos=0.85;
    btnLen=0.10;
    btnWid=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;

    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[xPos-frmBorder yPos btnLen+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50]);

    %====================================
    % The START button
    btnNumber=1;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Start';
    cmdStr='start';
    callbackStr='demo3(''start'');';

    % Generic button information
    btnPos=[xPos yPos-spacing btnLen btnWid];
    startHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callbackStr);

    %====================================
    % The STOP button
    btnNumber=2;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Stop';
    % Setting userdata to -1 (=stop) will stop the demo.
    callbackStr='set(gca,''Userdata'',-1)';

    % Generic  button information
    btnPos=[xPos yPos-spacing btnLen btnWid];
    stopHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'Enable','off', ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='demo3(''info'')';
    infoHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'position',[xPos 0.20 btnLen 0.10], ...
        'string',labelStr, ...
        'call',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'position',[xPos 0.05 btnLen 0.10], ...
        'string',labelStr, ...
        'call',callbackStr);

    % Uncover the figure
    hndlList=[startHndl stopHndl infoHndl closeHndl];
    set(figNumber,'Visible','on', ...
        'UserData',hndlList);

    watchoff(oldFigNumber);
    figure(figNumber);


elseif strcmp(action,'start'),

    axHndl=gca;
    figNumber=gcf;
    hndlList=get(figNumber,'UserData');
    startHndl=hndlList(1);
    stopHndl=hndlList(2);
    infoHndl=hndlList(3);
    closeHndl=hndlList(4);
    set([startHndl closeHndl infoHndl],'Enable','off');
    set(stopHndl,'Enable','on');

    % ====== Start of Demo
    set(figNumber,'Backingstore','off');
    set(axHndl, ...
        'Drawmode','fast', ...
        'Visible','on', ...
        'NextPlot','add', ...
        'Userdata',play);

    %==================================================================================
    % Simulation parameters
    elev1 = 10;                   % Visibility threshold angle (deg)
    elev2 = [10,30,50,70];        % Closest-passage visibility threshold angle (deg)
    tmax  = [-1,300,240,180,60];  % Time window half-width (sec)
                                  %   NOTE: A negative value for 'tmax' specifies 
                                  %   use of the full time window during which the 
                                  %   visibility criteria are met.

    % Time between orbit samples (sec)
    dt = mean(diff(JT))*day2sec;
    %==================================================================================

    cla;

    % Draw background map
    s = load('maps');
    ax = [-175 175 -90 90];
    drawmap(s.egrid,ax,'k:');
    drawmap(s.globe,ax,'k-');
    title('LEO Satellite Orbit: 53 deg inclination at 1000 km altitude')

    head = line( ...
        'color','r', ...
        'LineStyle','none', ...
        'LineWidth',1, ...
        'Marker','.', ...
        'MarkerSize',25, ...
        'erase','xor', ...
        'xdata',OMAP{1}(1,1),'ydata',OMAP{1}(1,2));
    body = line( ...
        'color','y', ...
        'LineStyle','none', ...
        'LineWidth',1, ...
        'Marker','.', ...
        'MarkerSize',5, ...
        'erase','none', ...
        'xdata',[],'ydata',[]);
    tail = line( ...
        'color','b', ...
        'LineStyle','none', ...
        'LineWidth',1, ...
        'Marker','.', ...
        'MarkerSize',5, ...
        'erase','none', ...
        'xdata',[],'ydata',[]);
    contour1 = line( ...
        'color','y', ...
        'LineStyle','none', ...
        'LineWidth',1, ...
        'Marker','.', ...
        'MarkerSize',4, ...
        'erase','xor', ...
        'xdata',[],'ydata',[]);
    contour2 = line( ...
        'color','b', ...
        'LineStyle','-', ...
        'LineWidth',2, ...
        'Marker','.', ...
        'MarkerSize',4, ...
        'erase','xor', ...
        'xdata',[],'ydata',[]);

    % Save L steps and plot like a comet tail.
    L=50; index=L; k=1; l=1;

    % Display initial DBMA parameter values
    h1 = text('Position',[0,-0.3],'Units','normalized');
    h2 = text('Position',[0,-0.4],'Units','normalized','erase','xor');
    set(h1,'String', 'DBMA parameters [elev1(deg), elev2(deg), tmax(sec)] = ');
    set(h2,'String', mat2str([elev1,elev2(k),tmax(l)]));

    % The main loop
    while (get(axHndl,'Userdata')==play)

      % Step forward in time
      index = rem(index+1, size(OMAP{1},1));
      if index<L, index=L+1; end;

      %===========================================================================
      % Modify DBMA protocol at defined intervals
      if rem(index,10)==0
         l = rem(l,length(tmax))+1;
         if l==1, k=rem(k,length(elev2))+1; end

         % Display modified parameter values
         set(h2,'String', mat2str([elev1,elev2(k),tmax(l)]));
      end

      % Calculate visibility contour
      [elonv,nlatv] = perimvis(XECF{1}(index,:),elev1,100);

      % Calculate DBMA coverage contour
      [elond,nlatd] = dbmacover(XECF{1},VECF{1},index,dt,elev1,elev2(k),tmax(l));
      %===========================================================================

      % Update the plot
      set(    head,'xdata',OMAP{1}(index,1), ...
                   'ydata',OMAP{1}(index,2));
      set(    body,'xdata',OMAP{1}(index-1:index,1)', ...
                   'ydata',OMAP{1}(index-1:index,2)');
      set(    tail,'xdata',OMAP{1}(index-L:index-L+1,1)', ...
                   'ydata',OMAP{1}(index-L:index-L+1,2)');
      set(contour1,'xdata',elonv, ...
                   'ydata',nlatv);
      set(contour2,'xdata',elond, ...
                   'ydata',nlatd);
      drawnow;
    end;

    % ====== End of Demo
    set([startHndl closeHndl infoHndl],'Enable','on');
    set(stopHndl,'Enable','off');


elseif strcmp(action,'info');
    helpwin(mfilename);

end
