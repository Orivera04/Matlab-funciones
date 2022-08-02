% standard plot
eopen('demo2.eps')                      % open eps-file and write eps-head
eglobpar                                % get access to global parameters
eXAxisSouthLabelText='Sector [No]';     % set South Label of XAxis
eXAxisSouthScaleType=1;                 % set classes scaling
eYAxisWestLabelText='Range [km]';       % set West Label of YAxis
eYAxisEastLabelText='Outlook';          % set East Label of YAxis
eXAxisNorthVisible=0;                   % switch North-XAxis off
eYAxisEastValueVisible=0;               % switch East-YAxis Values off
eXGridVisible=1;                        % switch x-Grid on
eYGridVisible=1;                        % switch y-Grid on

% background
[im cm]=eimgread; % read standard image
cm=econtra(cm,200,[1 2]);  % change contrast of image
cm=ebright(cm,60);  % change brightness of image
im=eimgrot(im,90);  % rotate image 
eframe(0,0,eWinWidth,eWinHeight,0,im,cm,0,10); % print background image

% frame 
eframe(0,0,eWinWidth,eWinHeight,0.5,0,[0 0 0],0,10); % draw frame around window 
etext('demo only',eWinWidth/2,eWinHeight/2,40,0,1,...   %print demo text
     atan(eWinHeight/eWinWidth)*180/pi,[0.8 0.8 0.8])
eXAxisSouthScale=[0 0 6];  %set scale x-axis
eYAxisWestScale=[0 10 60]; %set scale y-axis

etitle('Standard Plot',25,9,[0 0.3 0])         % print title

% 1. plot lines
x=0:0.1:2*pi;
eplot(x,sin(x)*15+30,'street',0,[0.8 0.8 0],3) %solid line 
eplot(x,sin(x)*15+33,'power line',5,[1 0 1]) % dash plot
eplot(x,sin(x)*15+36,'railway',0,[0.3 0.3 0.4],1) % solid line

% 2. plot symbols 
x=0:0.5:2*pi;
edsymbol('spire','spire.psd',0.3,0.3,0,0,90) % define symbol with name 'spire'
eplot(x,cos(x)*10+20,'tree','spire',[0 0.7 0]) % plot trees

% 3. plot area
lake=[1 30;1.3 35;1.5 32;2 40;2.5 25;1.6 15;1.4 17;1.2 24;1 30];
eplot(lake(:,1),lake(:,2),'water',-1,[0.5 0.5 1]); % filled area,dash<0
eplot(lake(:,1),lake(:,2),'water limit',0,[0 0 0]); % solid line around the area

% 4. plot image 
x1=0:pi/3:pi;
x1=x1';
x2=flipud(x1);
girl=[x1+2.5 sin(x1)*10+50;x2+2.5 -sin(x2)*10+50];
im=eimgread;
eplot(girl(:,1),girl(:,2),'girl',im,-1); % fill area with image
eplot(girl(:,1),girl(:,2),'',0,[0 0.4 0]); % solid line around the image

% 5. plot bars 
x=0.5:1:5.5;
[xb yb]=ebar(sin(x)*8+9,0,1,3);     % 1. bars
eplot(xb,yb,'forest',-1,[0.5 0.7 0])
eplot(xb,yb,'',0,[0 0 0]) 
[xb yb]=ebar(cos(x)*8+5,0,2,3);     % 2. bars
eplot(xb,yb,'town',-1,[0.8 0 0])
eplot(xb,yb,'',0,[0 0 0])
[xb yb]=ebar(cos(x)*8+9,0,3,3);     % 3. bars
eplot(xb,yb,'sea',-1,[0 0 1])
eplot(xb,yb,'',0,[0 0 0])
eplot

% write parameters
eParamPos=[80,70];
eParamFontSize=5;
eparam('Altitude','232 m')
eparam('Power','100 W')
valuePos=eYAxisEastValuePos;
posNo=1;
etext('Start of EastAxis',valuePos(posNo,1),valuePos(posNo,2),4,4);
posNo=2;
etext('2. Value',valuePos(posNo,1),valuePos(posNo,2),4,4);
posNo=7;
etext('End of EastAxis',valuePos(posNo,1),valuePos(posNo,2),4,4);

% axis
eYAxisEastScaleType=0;                 % set linear scaling
eYAxisEastValueVisible=0;              % no values visible
angle=-55;
eaxis(80,30,100,'e',[0 1 10],angle,[1 0 0]);
valuePos=eYAxisEastValuePos;
posNo=1;
etext('Start',valuePos(posNo,1),valuePos(posNo,2),4,1,1,angle,[1 0 0]);
posNo=4;
etext('3 cm',valuePos(posNo,1),valuePos(posNo,2),4,4,1,angle,[0 0.5 0]);
etext(' or 30 mm',0,0,4,4,1,angle,[0 0 1]);
posNo=6;
etext('5 cm',valuePos(posNo,1),valuePos(posNo,2),4,4,1,angle,[0.3 0 1]);
posNo=11;
etext('10 cm',valuePos(posNo,1),valuePos(posNo,2),4,4,1,angle,[0 0 1]);

eclose                                  % close ps output
eview                                   % start ghostview with eps-file
