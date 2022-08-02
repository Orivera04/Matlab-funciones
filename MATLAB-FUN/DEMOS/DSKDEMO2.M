%DSKDEMO2 Control Toolbox demonstration
%	This Expo demo adapted from ...
% 	DISKDEMO.M Demonstration design of a hard disk digital controller.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

if ssinit(figNumber),

    % Draw a little picture
    cla reset
    wheel(.5,.5,.25); 
    hold on
    x1=0.2609;
    y1=0.2670;
    wheel(x1,y1,.05);
    x=[
    0.2487
    0.5563
    0.5685
    0.2701
    0.2518
    ];
    y=[
    0.2853
    0.3980
    0.3736
    0.2457
    0.2853
    ];
    fill(x,y,'w');
    plot(0.5,0.5,'k.','MarkerSize',20);
    text(0.5,0.42,'Read/Write Head', ...
	'HorizontalAlignment','center', ...
	'Color','k');
    text(0.5,0.6,'Disk Platen', ...
	'HorizontalAlignment','center', ...
	'Color','k');
    axis square
    hold on
    set(gca,'XTick',[],'YTick',[],'Box','on');

    str= ...                                                          
    [' Press the "Start" button to see an example of the       '  
     ' Control System Toolbox being used to design a controller'  
     ' for a disk drive read/write head.                       '];
    ssdisp(figNumber,str);                                            
    if figNumber, return; end
end

% Beginning of the demo ==================

str= ...                                                                 
    [' Our task is to design a digital controller that can be used to '  
     ' provide accurate positioning of the read/write head.           '  
     ' Conceptually, this is very similar to moving (as quickly as    '  
     ' possible) the tone-arm of a record-player to a certain track.  '  
     '                                                                '  
     ' The task is tricky because there is always some flexibility in '  
     ' the mechanism, and bad control law design can lead to poor     '  
     ' performance (slow track-finding) or even instability, where the'  
     ' read/write head hopelessly flails back and forth.              '];
ssdisp(figNumber,str);                                                   

if sspause(figNumber), return; end;

str= ...                                                               
    [' First we will enter the mathematical model for the plant. We '  
     ' will model this system as a simple second order plant. The   '  
     ' inertia of the head assembly I=0.01 kg-m^2, the viscous      '  
     ' damping coefficient C=0.004 N-m/(rad/sec), the return spring '  
     ' constant K=10 N-m/rad, and the motor torque constant         '  
     ' Ki=0.05 N-m/rad.                                             '  
     '                                                              '  
     ' >> I=0.01; C=0.004; K=10; Ki=0.05;                           '  
     ' >> NUM=[Ki];                                                 '  
     ' >> DEN=[I C K];                                              '];
ssdisp(figNumber,str);                                                 

if sspause(figNumber), return; end;

% Using the values I=.01 Kg m^2, C=.004 Nm/(rad/sed), K=10 Nm/rad,  and
% Ki=.05 Nm/rad form the transfer function description of this system

I = .01; C = 0.004; K = 10; Ki = .05;
NUM = [Ki];
DEN = [I C K];

Ts = 0.005;
w = logspace(0,3);
%[mag,phase] = bode(NUM,DEN,w);
[num,den] = c2dm(NUM,DEN,Ts,'zoh');
%[mzoh,pzoh,wzoh] = dbode(num,den,Ts);

% Now analyze the discrete system.
% Plot step response
cla reset
dstep(num,den); 
drawnow

str= ...                                                               
    [' First we must discretize our plant since it is continuous.   '  
     ' Since our plant will have a digital-to-analog-converter (with'  
     ' a zero-order hold) connected to its input, use the "zoh"     '  
     ' discretization method of the function C2DM. Use sample       '  
     ' time Ts = 0.005  (5 ms). A step response plot is shown.      '  
     '                                                              '  
     ' >> Ts=0.005;                                                 '  
     ' >> [num,den]=c2dm(NUM,DEN,Ts,''zoh'');                         '  
     ' >> dstep(num,den);                                           '];
ssdisp(figNumber,str);                                                 

if sspause(figNumber), return; end;

str= ...                                                             
    [' Clearly the damping is far too light! The system oscillates'  
     ' quite a bit. We can check this by computing and plotting   '  
     ' the open loop eigenvalues with the PZMAP command.          '  
     '                                                            '  
     ' >> zgrid(''new''), pzmap(1,den);                             '  
     ' >> axis square                                             '];
ssdisp(figNumber,str);                                                    

zgrid('new'), pzmap(1,den); 
axis square;
hold off;
drawnow

if sspause(figNumber), return; end;

str= ...                                                             
    [' Note that the poles are very lightly damped and near the   '  
     ' unit circle. We need to design a compensator that increases'  
     ' the damping of this system. Let''s try the most basic       '  
     ' compensator: a simple gain.                                '  
     '                                                            '  
     ' >> zgrid(''new'')                                            '  
     ' >> axis square                                             '  
     ' >> rlocus(num,den);                                        '];
ssdisp(figNumber,str);                                               

zgrid('new');
axis square
rlocus(num,den); 
hold off; 
drawnow 

if sspause(figNumber), return; end;

str= ...                                                              
    [' As shown in the root locus, the poles quickly leave the unit'  
     ' circle and go unstable. We need to introduce some lead or   '  
     ' a compensator with some zeros.                              '  
     '                                                             '  
     ' We will try the compensator D(z)=K(z+a)/(z+b), where        '  
     ' a=-0.85 and b=0 and connect the compensator in series with  '  
     ' the plant.                                                  '  
     '                                                             '  
     ' >> [numc,denc]=zp2tf(0.85,0,1);                             '  
     ' >> [num2,den2]=series(numc,denc,num,den);                   '  
     '                                                             '];
ssdisp(figNumber,str);                                                

% Try the compensator:        K(z + a)
%                      D(z) = --------  where a < b
%                             (z + b)
drawnow

% Form compensator and connect in series with our plant
% Use a = -.85 and b = 0.
[numc,denc] = zp2tf([.85 ]',[0]',1);
[num2,den2] = series(numc,denc,num,den);

if sspause(figNumber), return; end;

str= ...                                                               
    [' Here is another root locus plot. This time the poles stay    '  
     ' within the unit circle for some time. By choosing a gain with'  
     ' reasonable damping, we can arrive at a suitable design.      '  
     ' The "+" symbol shows the final location of the closed-loop   '  
     ' roots.                                                       '  
     '                                                              '  
     ' >> zgrid(''new''); axis square                                 '  
     ' >> rlocus(num2,den2);                                        '  
     ' >> k=4100; r=rlocus(num2,den2,k);                            '  
     ' >> plot(r,''+'')                                               '];
ssdisp(figNumber,str);                                                 

% Now let's try the root locus again with our compensator
zgrid('new');
axis square;
rlocus(num2,den2); hold off; 
drawnow

k=4100;
r=rlocus(num2,den2,k);
hold on;
plot(r,'+');
hold off;

if sspause(figNumber), return; end;

str= ...                                                                  
    [' So here at last is the closed loop step response for our        '  
     ' disk drive. So the response looks pretty good and settles       '  
     ' in about 14 samples (which is 14*Ts, or 0.07 secs). At this     '  
     ' point, we can consider the design complete, or try to refine it.'  
     '                                                                 '  
     ' >> [numc,denc]=feedback(num2,den2,k,1);                         '  
     ' >> dstep(numc,denc);                                            '];
ssdisp(figNumber,str);                                                    

% Let's form the closed loop system so that we can analyze the design.
[numc,denc] = feedback(num2,den2,k,1);

% Closed loop time response
dstep(numc,denc); 
drawnow

% End of the demo ========================
