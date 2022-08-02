%%
%% Routine: Cdrom cover
%% (see demo9.png) 
%%
eopen('demo9.eps')                      % open eps-file and write eps-head
eglobpar;

titleFile='demo_title.ppm';
backgrFile='demo_backgr.ppm';
logoFile='demo_logo.ppm';
contentFile='demo_content.txt';

%make title image 
[titleImg titleCM]=eimgread([ePath 'default.jpg']); % read image
[imgH imgW]=size(titleImg);
imgMask=eimgmask(imgH,imgW,1);
imgMask=circshift(imgMask,50);
swCM=titleCM(:,1)+titleCM(:,2)+titleCM(:,3);
swCM=swCM/max(swCM);
swCM=[swCM swCM swCM]; % color -> gray
swImg=eidx2rgb(titleImg,swCM);
colorImg=eidx2rgb(titleImg,titleCM);
titleImg=eimgmix(swImg,colorImg,imgMask);
eimgwrit(titleFile,titleImg,-1); % save image

%make background image
[backImg backCM]=eshadoi; % get default shadow image
backCM(:,[2 3])=0.1;
eppmwrit(backgrFile,backImg,backCM); % save image

%make logo image
[logoImg logoCM]=eshadois; % get default shadow image
eppmwrit(logoFile,logoImg,logoCM); % save image

%content
lf=setstr(10); %linefeed
contenttext=[
  'New features:' lf ...
  '#HTML documentation###'  lf ...
  '#encryption tools###'  lf ...
  '#auto data reduction of plot data ###'  lf ...
  '#more dash styles###'  lf ...
  '#more character codes###'  lf ...
  '#many bugs removed###' lf ...
  ];
etxtwrit(contenttext,contentFile);

% make cover

ecdcover('The EpsTk',...
         sprintf('Graphic for Octave & Matlab\\256'),...
         'Stefan Mueller',...
         'Version 2.2',...
         sprintf('\\251 2007'),...
         [1 1 0],...
         titleFile,backgrFile,...
         logoFile,contentFile);
         

eclose
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
