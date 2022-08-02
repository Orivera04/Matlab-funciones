%MATRIXMAPS                                       LAST UPDATED 1/09/2003
%       A script to show the images of objects from 2-space when
%       mapped by a 3 by 3 matrix in homogeneous coordinate form.
%       Several objects are available and a composite mapping option
%       can be selected. Since we are using homogeneous coordinate form
%       translations can be used.
%
%       The graphics user interface is employed for 
%       object selection and the initiation of operations and options.
%
%       When a matrix is used to perform a mapping we always name it A.
%
%       Use in the form  ==>  matrixmaps  <==
%       and follow the screen directions.
%
%          Requires MATLAB 5.0 or higher. Uses utility mat2strh.
%          Uses file matrixmapshelp.m
%
%       A related files are mapit and planelt.
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%STRINGS
cont='Press ENTER to continue.';
mathead=['         MATRIX IMAGES of PLANE FIGURES            ';
         '                                                   ';
   'The matrix of the transformation must be compatible';
   'with vectors in HOMOGENEOUS COORDINATES. The third ';
   'row must be [0  0  1].                             ';
   '                                                   ';
   'Enter a 3 by 3 matrix A like [-3 4 7;5 -1 2;0 0 1] ';
   '                                                   '];
aprmt='     Matrix A =  ';
matwarn='Matrix A must be 3 by 3!';
matwarnhomog='Matrix A must have third row with entries [0 0 1]!';

%INITIALIZATION
A=zeros(3,3);
B=mat2strh(A,3);
m=3; %size of matrix; used as counter

%DIALOG BOX TEXT
refhelp=['                                     ';
         'Matrices that perform reflections.   ';
         '                                     ';
         'We are using HOMOGENEOUS COORDINATES ';
         'so the matrices must be 3 by 3 with  ';
         'the last row [0  0  1].              ';
         '                                     ';
         'For reflection about the X-axis use  ';
         '       1  0  0                       ';
         '       0 -1  0                       ';
         '       0  0  1                       ';
         '                                     ';
         'For reflection about the Y-axis use  ';
         '      -1  0  0                       ';
         '       0  1  0                       ';
         '       0  0  1                       ';
         '                                     ';
         'For reflection about the line y=x use';
         '       0  1  0                       ';
         '       1  0  0                       ';
         '       0  0  1                       ';
         '                                     ';];
sclhelp=['                                     ';
         '                                     ';
         'Matrices that perform scalings.      ';
         '                                     ';
         'We are using HOMOGENEOUS COORDINATES ';
         'so the matrices must be 3 by 3 with  ';
         'the last row [0  0  1].              ';
         '                                     ';
         'For scaling by factor h in the       '
         'X-direction use                      ';
         '       h  0  0                       ';
         '       0  1  0                       ';
         '       0  0  1                       ';
         '                                     ';
         'For scaling by factor k in the       '
         'Y-direction use                      ';
         '       1  0  0                       ';
         '       0  k  0                       ';
         '       0  0  1                       ';
         '                                     ';
         'For scaling by factor h in the       '
         'X-direction and factor k in the      ';
         'Y-direction use                      ';
         '       h  0  0                       ';
         '       0  k  0                       ';
         '       0  0  1                       ';
         '                                     ';];
rothelp=['                                     ';
         'Matrices that perform rotations.     ';
         '                                     ';
         'We are using HOMOGENEOUS COORDINATES ';
         'so the matrices must be 3 by 3 with  ';
         'the last row [0  0  1].              ';
         '                                     ';
         'A rotation by angle t, in radians,   '
         'uses the matrix                      ';
         '       cos(t)  -sin(t)  0            ';
         '       sin(t)  cos(t)   0            ';
         '         0       0      1            ';
         '                                     ';
         'If t is positive the rotation is     ';
         'counterclockwise.                    '];
tranhelp=['                                     ';
         'Matrices that perform translations.  ';
         '                                     ';
         'We are using HOMOGENEOUS COORDINATES ';
         'so the matrices must be 3 by 3 with  ';
         'the last row [0  0  1].              ';
         '                                     ';
         'A translation by a vector [a  b] uses';
         '       1  0  a                       ';
         '       0  1  b                       ';
         '       0  0  1                       ';
         '                                     ';];
shearhelp=['                                     ';
         'Matrices that perform shears.        ';
         '                                     ';
         'We are using HOMOGENEOUS COORDINATES ';
         'so the matrices must be 3 by 3 with  ';
         'the last row [0  0  1].              ';
         '                                     ';
         'To shear by factor k in the          '
         'X-direction use                      ';
         '       1  k  0                       ';
         '       0  1  0                       ';
         '       0  0  1                       ';
         '                                     ';
         'To shear by factor k in the          '
         'Y-direction use                      ';
         '       1  0  0                       ';
         '       k  1  0                       ';
         '       0  0  1                       ';
         '                                     ';];
%++++++++++++++++      
%
%CALL BACKS FOR HELP ON MATRICES
rfh='helpdlg(refhelp,''Matrices for Reflections''); set(helpref,''value'',0)';
sclh='helpdlg(sclhelp,''Matrices for Scalings''); set(helpscl,''value'',0)';
roth='helpdlg(rothelp,''Matrices for Rotations''); set(helprot,''value'',0)';
tranh='helpdlg(tranhelp,''Matrices for Translations''); set(helptran,''value'',0)';
shearh='helpdlg(shearhelp,''Matrices for Shears''); set(helpshear,''value'',0)';
%++++++++++++++++
%
%setting graphics window to full size
hfig=figure('units','normal','position',[0 0 1 1]);
axis('off')
%++++++++++++++++
%
%SUBPLOTS
axvan=subplot('position',[.85 .01 .1 .05]);axis('off') %vanity
ingrf=subplot('position',[0.05 .3 .35 .5]);          %input graph
outgrf=subplot('position',[.5 .3 .35 .5]);           %output graph
axhead=subplot('position',[.65 .90 .25 .1]);axis('off')   %header
axinlab=subplot('position',[0 .9 .1 .1]);axis('off')   %input label
axmat=subplot('position',[.17 .87 .3 .1]);axis('off')

%SWITCHES
havdat='N'; %Do we have a data set?
havmat='N'; %Do we have an input matrix?
havmap='N'; %Has mapit been selected?
havcomp='N'; %HAS composite been selected?
whobj='N';   %No object selected.
gridstat='N'; %No grid on input graph

%strings
%
header='Matrix Mappings';
header1='using homogeneous coordinates.';
inlabel='Matrix A =';
intitle='OBJECT';
outtitle='IMAGE';
outtitl2='IMAGE and COMPOSITE IMAGE(S)';
matname ='A = ';
pointer='==>';

%OBJECT DATA
%<><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%The unit circle.
%
step=.08;
t=0:step:2.05*pi;
xcirc=cos(t);ycirc=sin(t);

%The scalene triangle: PTS (0,0), (2,3), (4,4), (0,0)
tripts=[];
for cnt=1:3
   if cnt==1,triP=[0 0]';triQ=[2 3]';end
   if cnt==2,triP=[2 3]';triQ=[4 4]';end
   if cnt==3,triP=[4 4]';triQ=[0 0]';end
   for t=0:.01:1
      tripts=[tripts t*triQ+(1-t)*triP];
   end
end
xtri=tripts(1,:);ytri=tripts(2,:);

%HOUSE
%
hxb=-1:.05:1; %x-cord. of base
hyb=zeros(size(hxb)); %y-coord of base
hyl=0:.05:2; %y-coord of left side of house
hxl=-1*ones(size(hyl)); %x-coord of left side of house
hyr=hyl; %y-coord of right side of house
hxr=ones(size(hyr)); %x-coord of right side of house
hxtl=-1:.05:0; %x-coord of left side of roof
hytl=hxtl+3; %y-coord of left side of roof
hxtr=0:.05:1;%x-coord of right side of roof
hytr=-1*hxtr+3; %y-coord of right side of roof
hxm=hxb; %x-coord of midline of house
hym=2*ones(size(hxm)); %y-coord of midline of house
xhouse=[hxb hxl hxr hxtl hxtr hxm];
yhouse=[hyb hyl hyr hytl hytr hym];

% arrow
%
xarr=[zeros(size(0:.05:3)) [0:.05:.5] [-.5:.05:0]];
yarr=[[0:.05:3] [0:.05:.5] [.5:-.05:0]];

%rectangle  4 wide 3 high translated to (2,-5)
%
rbotx=-2:.05:2;rtopx=rbotx;
rleftx=-2*ones(size(0:.05:3));
rrightx=2*ones(size(0:.05:3));
rboty=zeros(size(rbotx));rtopy=3*ones(size(rtopx));
rlefty=0:.05:3;rrighty=rlefty;
xrect=[rbotx rtopx rleftx rrightx];
yrect=[rboty rtopy rlefty rrighty];
rectdata=[1 0 2;0 1 -5;0 0 0]*[xrect;yrect;ones(size(xrect))];
xrect=rectdata(1,:);yrect=rectdata(2,:);

%unit square
%
xsqbot=0:.01:1;xsqtop=xsqbot;
ysqbot=zeros(size(xsqbot));ysqtop=ones(size(xsqbot));
xsqleft=ysqbot;xsqright=ysqtop;
ysqleft=xsqbot;ysqright=ysqleft;
xsquare=[xsqbot xsqleft xsqtop xsqright];
ysquare=[ysqbot ysqleft ysqtop ysqright];

%Peaks
%
xmtn=[-7 -5 -4 -1 2 2 -7];
ymtn=[0 4 1 7 3 0 0];

%The unit semicircle.
%
step=.08;
t=0:step:1*pi;
xscirc=cos(t);yscirc=sin(t);%adjoin pts on x-axis
t=-1:.01:1;
xscirc=[xscirc t];yscirc=[yscirc zeros(size(t))];%now translate to (2,1)
semidata=[1 0 2;0 1 1;0 0 1]*[xscirc;yscirc;ones(size(xscirc))];
xscirc=semidata(1,:);yscirc=semidata(2,:);

%POLYGON
%
xpoly=[-7 -4 -3 -1 1 1 -1 -7];
ypoly=[0 2 5 6 5 2 -2 0];

%
%End of OBJECT DATA <><><><><><><><><><><><><><><><><><><><><><>


%ROUTINES that are evaled
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%routine to add axes of width 2 to plot
adax=['figure(gcf);hold on,gca;plot(Xlim,[0 0],''-k'',[0 0],Ylim,''-k'',''linewidth'',2);hold off'];
%

plotin= 'subplot(ingrf);';
plotin=[plotin 'objgrf=plot([-10 10],[0 0],''-k'',[0 0],[-10 10],''-k'',''linewidth'',2);'];
%plotin=[plotin '''erasemode'',''none''),'];
%plotin=[plotin 'set(ingrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
%plotin=[plotin 'axis(axis),axis(''square''),'];  
plotin=[plotin 'title(intitle,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];

plotout= 'subplot(outgrf);';
plotout=[plotout 'plot([-10 10],[0 0],''-k'',[0 0],[-10 10],''-k'',''linewidth'',2),axval(2)=10;'];
%plotout=[plotout '''erasemode'',''none''),'];
%plotout=[plotout 'set(outgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
%plotout=[plotout 'axis(axis),axis(''square''),hold on,'];
plotout=[plotout 'title(outtitle,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];
 


%Part of callback for composite button
wipemat='for jj=1:m,';    %delete old lines
wipemat=[wipemat 'if jj==1,delete(htl1);end,'];
wipemat=[wipemat 'if jj==2,delete(htl2);end,'];
wipemat=[wipemat 'if jj==3,delete(htl3);end,'];
wipemat=[wipemat 'end'];

%show lines of matrix A
dispmat='subplot(axmat);for jj=1:3,';
dispmat=[dispmat 'if jj==1,'];
dispmat=[dispmat 'htl1=text(0,.8,B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==2,'];
dispmat=[dispmat 'htl2=text(0,.4,B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==3,'];
dispmat=[dispmat 'htl3=text(0,0,B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'end'];

%CALL BACKS
%
domap='xdat=xdat(:)'';ydat=ydat(:)'';dat=[xdat;ydat;ones(size(xdat))];new1dat=A*dat;';
domap=[domap 'xdat1=new1dat(1,:);ydat1=new1dat(2,:);'];
domap=[domap 'xl=min(sort(xdat1)-1);xr=max(sort(xdat1)+1);'];
domap=[domap 'yb=min(sort(ydat1)-1);yt=max(sort(ydat1)+1);'];
domap=[domap 'axval=max([abs(xl),abs(xr),abs(yb),abs(yt)]);'];
domap=[domap 'axval=axval*[-1 1 -1 1];subplot(outgrf);'];
domap=[domap 'axis(axval);axis(axis),axis(''square'');hold on;'];
domap=[domap 'if whobj==''M'' | whobj==''P'',pltstyle=''-b'';else,pltstyle=''.b'';end;'];
domap=[domap 'objgrf1=plot([xl xr],[0 0],''-k'',[0 0],[yb yt],''-k'','];
domap=[domap 'xdat1,ydat1,pltstyle,''linewidth'',2);eval(adax);'];
domap=[domap 'title(outtitle,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];
%delete MAPIT button
domap=[domap 'delete(mapbut);delete(butfrmm);'];
%messages
domap=[domap 'set(txtHndl,''string'',''Image displayed. Use the'','];
domap=[domap '''fontweight'',''bold'',''fontsize'',14);'];
domap=[domap 'set(txtHndl1,''string'','];
domap=[domap '''COMPOSITE button to map the image.'','];
domap=[domap '''fontweight'',''bold'',''fontsize'',14);'];
%initiate composite button
domap=[domap 'butfrmc=uicontrol(''style'',''frame'',''units'',''normal'','];
domap=[domap '''pos'',[.70 .18 .12 .08],''backgroundcolor'',''b'');'];
domap=[domap 'compbut=uicontrol(''style'',''push'',''units'','];
domap=[domap '''normal'',''pos'',[.71 .19 .1 .06],'];
domap=[domap '''string'',''Composite'',''fontweight'',''bold'',''call'',''eval(docomp)'');'];

%THE COMPOSITE MAP
domap2='new2dat=A*new1dat;';
domap2=[domap2 'xdat2=new2dat(1,:);ydat2=new2dat(2,:);'];
domap2=[domap2 'xl=min(sort(xdat2)-1);xr=max(sort(xdat2)+1);'];
domap2=[domap2 'yb=min(sort(ydat2)-1);yt=max(sort(ydat2)+1);'];
domap2=[domap2 'subplot(outgrf);'];
domap2=[domap2 'axval2=max([abs(xl),abs(xr),abs(yb),abs(yt)]);'];
domap2=[domap2 'axval=max([axval,axval2]);']; %max of image & composite sizes
domap2=[domap2 'axval=axval*[-1 1 -1 1];'];
domap2=[domap2 'axis(axval);axis(axis),axis(''square'');hold on;'];
domap2=[domap2 'if whobj==''M'' | whobj==''P'',pltstyle=''-b'';else,pltstyle=''.b'';end;'];
domap2=[domap2 'objgrf1=plot(xdat1,ydat1,pltstyle,''linewidth'',2);'];
domap2=[domap2 'if whobj==''M'' | whobj==''P'',pltstyle=''-m'';else,pltstyle=''.m'';end;'];
domap2=[domap2 'objgrf2=plot([xl xr],[0 0],''-k'',[0 0],[yb yt],''-k'','];
domap2=[domap2 'xdat2,ydat2,pltstyle,''linewidth'',2);eval(adax);'];
domap2=[domap2 'title(outtitl2,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];
%delete MAPIT button
domap2=[domap2 'delete(mapbut);delete(butfrmm);'];
%messages
domap2=[domap2 'set(txtHndl,''string'',''Composite Image displayed.'','];
domap2=[domap2 '''fontweight'',''bold'',''fontsize'',14);'];
domap2=[domap2 'set(txtHndl1,''string'','];
domap2=[domap2 ''' '','];
domap2=[domap2 '''fontweight'',''bold'',''fontsize'',14);'];
%NEW CODE to CYCLE with Composites
domap2=[domap2 'new1dat=new2dat;xdat1=xdat2;ydat1=ydat2;'];
domap2=[domap2 'set(txtHndl,''string'',''Image displayed. Use the'','];
domap2=[domap2 '''fontweight'',''bold'',''fontsize'',14);'];
domap2=[domap2 'set(txtHndl1,''string'','];
domap2=[domap2 '''COMPOSITE button to map the image.'','];
domap2=[domap2 '''fontweight'',''bold'',''fontsize'',14);'];
%initiate composite button
domap2=[domap2 'butfrmc=uicontrol(''style'',''frame'',''units'',''normal'','];
domap2=[domap2 '''pos'',[.70 .18 .12 .08],''backgroundcolor'',''b'');'];
domap2=[domap2 'compbut=uicontrol(''style'',''push'',''units'','];
domap2=[domap2 '''normal'',''pos'',[.71 .19 .1 .06],'];
domap2=[domap2 '''string'',''Composite'',''fontweight'',''bold'',''call'',''eval(docomp)'');'];



%CALL back for composite button
docomp='delete(Aname);eval(wipemat);';%wipe  out old matrix & lines
%put up messages
docomp=[docomp 'set(txtHndl,''string'',''Click on MATRIX button'','];
docomp=[docomp '''fontweight'',''bold'',''fontsize'',14);'];
docomp=[docomp 'set(txtHndl1,''string'','];
docomp=[docomp '''to get next matrix.'','];
docomp=[docomp '''fontweight'',''bold'',''fontsize'',14);'];
docomp=[docomp 'delete(compbut);delete(butfrmc);'];
%put up matrix button
docomp=[docomp 'matfrm=uicontrol(''style'',''frame'',''units'',''normal'','];
docomp=[docomp '''position'',[.87 .29 .12 .08],''backgroundcolor'',''r'');'];
docomp=[docomp 'matbut = uicontrol(''style'',''push'',''units'','];
docomp=[docomp '''normal'',''pos'',[.88 .3 .1 .06],'];
docomp=[docomp '''string'',''MATRIX'',''fontweight'',''bold'',''call'',''eval(getmat2)'');'];


%map the current image in color magenta
%wipe out composite button

%callback for matrix button
getmat='set(gcf,''visible'',''off'');havmat=''N'';while havmat==''N'';';
getmat=[getmat 'matrixmapshelp,disp(mathead),A=input(aprmt);'];
%checking matrix size
getmat=[getmat '[nr nc]=size(A);if nr~=3 | nc~=3,disp(matwarn),'];
getmat=[getmat 'disp(cont),pause,else,'];
%checking homogeneous form
getmat=[getmat 'if A(3,1)==0 & A(3,2)==0 & A(3,3)==1,havmat=''Y'';'];
getmat=[getmat 'else,disp(matwarnhomog),disp(cont),pause,end,end,'];
getmat=[getmat 'end,'];
getmat=[getmat 'set(gcf,''visible'',''on'');'];
%input label
getmat=[getmat 'subplot(axinlab);Aname=text(0,0,inlabel,''color'',''r'','];
getmat=[getmat '''fontweight'',''bold'',''fontsize'',18);'];
%writing the matrix rows
getmat=[getmat 'B = mat2strh(A,3);eval(dispmat);'];
%messages
getmat=[getmat 'set(txtHndl,''string'',''We have a matrix and an object.'','];
getmat=[getmat '''fontweight'',''bold'',''fontsize'',14);'];
getmat=[getmat 'set(txtHndl1,''string'',''Click on MAP IT.'','];
getmat=[getmat '''fontweight'',''bold'',''fontsize'',14);'];
%deleting buttons no longer needed
getmat=[getmat 'delete(matfrm);delete(matbut);'];
%generating mapit button
getmat=[getmat 'butfrmm=uicontrol(''style'',''frame'',''units'',''normal'','];
getmat=[getmat '''pos'',[.54 .18 .12 .08],''backgroundcolor'',''b'');'];
getmat=[getmat 'mapbut=uicontrol(''style'',''push'',''units'',''normal'','];
getmat=[getmat '''pos'',[.55 .19 .1 .06],''string'',''MAP IT'',''fontweight'',''bold'',''call'','];
getmat=[getmat '''eval(domap)'');'];


%callback for second matrix button
getmat2='set(gcf,''visible'',''off'');havmat=''N'';while havmat==''N'';';
getmat2=[getmat2 'matrixmapshelp,disp(mathead),A=input(aprmt);'];
getmat2=[getmat2 '[nr nc]=size(A);if nr~=3 | nc~=3,disp(matwarn),'];
getmat2=[getmat2 'disp(cont),pause,else,'];
getmat2=[getmat2 'if A(3,1)==0 & A(3,2)==0 & A(3,3)==1,havmat=''Y'';'];
getmat2=[getmat2 'else,disp(matwarnhomog),disp(cont),pause,end,end,'];
getmat2=[getmat2 'end,'];
getmat2=[getmat2 'set(gcf,''visible'',''on'');'];
%input label
getmat2=[getmat2 'subplot(axinlab);Aname=text(0,0,inlabel,''color'',''r'','];
getmat2=[getmat2 '''fontweight'',''bold'',''fontsize'',18);'];
%writing the matrix rows
getmat2=[getmat2 'B = mat2strh(A,3);eval(dispmat);'];
%messages
getmat2=[getmat2 'set(txtHndl,''string'',''We have a another matrix.'','];
getmat2=[getmat2 '''fontweight'',''bold'',''fontsize'',14);'];
getmat2=[getmat2 'set(txtHndl1,''string'',''Click MAP IT for composite image.'','];
getmat2=[getmat2 '''fontweight'',''bold'',''fontsize'',14);'];
%deleting buttons no longer needed
getmat2=[getmat2 'delete(matfrm);delete(matbut);'];
%generating mapit button
getmat2=[getmat2 'butfrmm=uicontrol(''style'',''frame'',''units'',''normal'','];
getmat2=[getmat2 '''pos'',[.54 .18 .12 .08],''backgroundcolor'',''b'');'];
getmat2=[getmat2 'mapbut=uicontrol(''style'',''push'',''units'',''normal'','];
getmat2=[getmat2 '''pos'',[.55 .19 .1 .06],''string'',''MAP IT'',''fontweight'',''bold'',''call'','];
getmat2=[getmat2 '''eval(domap2)'');'];




%CALL back for VIEW Button
%
doview='if havmap==''N'' & havcomp==''N'' & havdat==''Y'',';
doview=[doview 'xl=min(sort(xdat)-1);xr=max(sort(xdat)+1);'];
doview=[doview 'yb=min(sort(ydat)-1);yt=max(sort(ydat)+1);'];
doview=[doview 'subplot(ingrf);'];
doview=[doview 'axis([xl,xr,yb,yt]);'];
doview=[doview 'if whobj==''M'' | whobj==''P'',pltstyle=''-r'';else,pltstyle=''.r'';end;'];
doview=[doview 'objgrf=plot([xl xr],[0 0],''-k'',[0 0],[yb yt],''-k'','];
doview=[doview 'xdat,ydat,pltstyle,''linewidth'',2);eval(adax);if gridstat==''Y'',grid on,end;'];
doview=[doview 'title(intitle,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];
doview=[doview 'set(txtHndl,''string'',''Click on MATRIX'','];
doview=[doview '''fontweight'',''bold'',''fontsize'',14);'];
doview=[doview 'set(txtHndl1,''string'','' or RESTART to change objects.'','];
doview=[doview '''fontweight'',''bold'',''fontsize'',14);'];
doview=[doview 'delete(butfrmv);delete(viewbut);']; %<<< deleting view button>>>>
doview=[doview 'matfrm=uicontrol(''style'',''frame'',''units'',''normal'','];
doview=[doview '''position'',[.87 .29 .12 .08],''backgroundcolor'',''r'');'];
doview=[doview 'matbut = uicontrol(''style'',''push'',''units'','];
doview=[doview '''normal'',''pos'',[.88 .3 .1 .06],'];
doview=[doview '''string'',''MATRIX'',''fontweight'',''bold'',''call'',''eval(getmat)'');'];
%doview=[doview 'else,'];
doview=[doview 'end;'];

%callback for the grid button
gridsit='if gridstat==''N'',set(ingrf,''xtick'',[-10:1:10],''ytick'',[-10:1:10],';
gridsit=[gridsit '''xgrid'',''on'',''ygrid'',''on'');gridstat=''Y'';'];
gridsit=[gridsit 'set(gridh,''string'',''Grid Off'');'];
%gridsit=[gridsit 'if axval(2)<=10,set(outgrf,''xtick'',[-10:1:10],''ytick'',[-10:1:10],'];
%gridsit=[gridsit '''xgrid'',''on'',''ygrid'',''on'');end;'];
%gridsit=[gridsit 'if axval(2)>10,set(outgrf,''xgrid'',''on'',''ygrid'',''on'');end;'];
gridsit=[gridsit 'set(outgrf,''xgrid'',''on'',''ygrid'',''on'');'];
gridsit=[gridsit 'else,set(ingrf,''xgrid'',''off'',''ygrid'',''off'');'];
gridsit=[gridsit 'set(outgrf,''xgrid'',''off'',''ygrid'',''off'');'];
gridsit=[gridsit 'set(gridh,''string'',''Grid On'');'];
gridsit=[gridsit 'gridstat=''N'';end'];
%NOTE: no tick marks set on image graph; therefore, self scaling for grid  3/15/00

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help matrixmaps,disp(cont),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];

%CALL back for QUIT button
done = 'close(gcf),clc,disp(''MATRIXMAPS is over!'')';

%HELP FOR MATRIX STYLES
helpmat=['helpfrm=uicontrol(''style'',''frame'',''units'',''normal'','];
helpmat=[helpmat '''position'',[.87 .41 .11 .36],''backgroundcolor'',''y'');'];
helpmat=[helpmat 'helptitle=uicontrol(''style'',''text'',''string'','];
helpmat=[helpmat '''HELP ON'',''fontweight'',''bold'',''fontsize'',12,'];
helpmat=[helpmat '''units'',''normal'',''position'',[.86 .78 .13 .04]);'];
helpmat=[helpmat 'helpref=uicontrol(''style'',''radio'',''string'',''Reflections'','];
helpmat=[helpmat '''units'',''normal'',''position'',[.88 .7 .09 .06],''value'',0,'];
helpmat=[helpmat '''callback'',''eval(rfh)'');'];
helpmat=[helpmat 'helpscl=uicontrol(''style'',''radio'',''string'',''Scaling'','];
helpmat=[helpmat '''units'',''normal'',''position'',[.88 .63 .09 .06],''value'',0,'];
helpmat=[helpmat '''callback'',''eval(sclh)'');'];
helpmat=[helpmat 'helprot=uicontrol(''style'',''radio'',''string'',''Rotation'','];
helpmat=[helpmat '''units'',''normal'',''position'',[.88 .56 .09 .06],''value'',0,'];
helpmat=[helpmat '''callback'',''eval(roth)'');'];
helpmat=[helpmat 'helptran=uicontrol(''style'',''radio'',''string'',''Translation'','];
helpmat=[helpmat '''units'',''normal'',''position'',[.88 .49 .09 .06],''value'',0,'];
helpmat=[helpmat '''callback'',''eval(tranh)'');'];
helpmat=[helpmat 'helpshear=uicontrol(''style'',''radio'',''string'',''Shears'','];
helpmat=[helpmat '''units'',''normal'',''position'',[.88 .42 .09 .06],''value'',0,'];
helpmat=[helpmat '''callback'',''eval(shearh)'');'];


%use to delete buttons after object selected
%
delbut='delete(objmode);delete(rbutfrm);delete(rbuttri);';
delbut=[delbut 'delete(rbuthou);delete(rbutrect);delete(rbutarr);'];
delbut=[delbut 'delete(rbutsq);delete(rbutsemi);delete(rbutpoly);'];
delbut=[delbut 'eval(helpmat);'];

%RADIO Buttons CALLBACKS ===============================
cirset='eval(delbut);';
cirset=[cirset 'xdat=xcirc;ydat=ycirc;havdat=''Y'';whobj=''C'';'];
cirset=[cirset 'set(txtHndl,''string'',''CIRCLE selected.'','];
cirset=[cirset '''fontweight'',''bold'',''fontsize'',14);'];
cirset=[cirset 'set(txtHndl1,''string'',''Click on VIEW.'','];
cirset=[cirset '''fontweight'',''bold'',''fontsize'',14);'];

triset='eval(delbut);';
triset=[triset 'xdat=xtri;ydat=ytri;havdat=''Y'';whobj=''T'';'];
triset=[triset 'set(txtHndl,''string'',''TRIANGLE selected.'','];
triset=[triset '''fontweight'',''bold'',''fontsize'',14);'];
triset=[triset 'set(txtHndl1,''string'',''Click on VIEW.'','];
triset=[triset '''fontweight'',''bold'',''fontsize'',14);'];


houset='eval(delbut);';
houset=[houset 'xdat=xhouse;ydat=yhouse;havdat=''Y'';whobj=''H'';'];
houset=[houset 'set(txtHndl,''string'',''HOUSE selected.'','];
houset=[houset '''fontweight'',''bold'',''fontsize'',14);'];
houset=[houset 'set(txtHndl1,''string'',''Click on VIEW.'','];
houset=[houset '''fontweight'',''bold'',''fontsize'',14);'];

rectset='eval(delbut);';
rectset=[rectset 'xdat=xrect;ydat=yrect;havdat=''Y'';whobj=''R'';'];
rectset=[rectset 'set(txtHndl,''string'',''RECTANGLE selected.'','];
rectset=[rectset '''fontweight'',''bold'',''fontsize'',14);'];
rectset=[rectset 'set(txtHndl1,''string'',''Click on VIEW.'','];
rectset=[rectset '''fontweight'',''bold'',''fontsize'',14);'];

arrset='eval(delbut);';
arrset=[arrset 'xdat=xarr;ydat=yarr;havdat=''Y'';whobj=''A'';'];
arrset=[arrset 'set(txtHndl,''string'',''ARROW selected.'','];
arrset=[arrset '''fontweight'',''bold'',''fontsize'',14);'];
arrset=[arrset 'set(txtHndl1,''string'',''Click on VIEW.'','];
arrset=[arrset '''fontweight'',''bold'',''fontsize'',14);'];

sqset='eval(delbut);';
sqset=[sqset 'xdat=xsquare;ydat=ysquare;havdat=''Y'';whobj=''S'';'];
sqset=[sqset 'set(txtHndl,''string'',''UNIT SQUARE selected.'','];
sqset=[sqset '''fontweight'',''bold'',''fontsize'',14);'];
sqset=[sqset 'set(txtHndl1,''string'',''Click on VIEW.'','];
sqset=[sqset '''fontweight'',''bold'',''fontsize'',14);'];

mtnset='eval(delbut);';
mtnset=[mtnset 'xdat=xmtn;ydat=ymtn;havdat=''Y'';whobj=''M'';'];
mtnset=[mtnset 'set(txtHndl,''string'',''Peaks selected.'','];
mtnset=[mtnset '''fontweight'',''bold'',''fontsize'',14);'];
mtnset=[mtnset 'set(txtHndl1,''string'',''Click on VIEW.'','];
mtnset=[mtnset '''fontweight'',''bold'',''fontsize'',14);'];

semiset='eval(delbut);';
semiset=[semiset 'xdat=xscirc;ydat=yscirc;havdat=''Y'';whobj=''S'';'];
semiset=[semiset 'set(txtHndl,''string'',''Semi-circle selected.'','];
semiset=[semiset '''fontweight'',''bold'',''fontsize'',14);'];
semiset=[semiset 'set(txtHndl1,''string'',''Click on VIEW.'','];
semiset=[semiset '''fontweight'',''bold'',''fontsize'',14);'];


polyset='eval(delbut);';
polyset=[polyset 'xdat=xpoly;ydat=ypoly;havdat=''Y'';whobj=''P'';'];
polyset=[polyset 'set(txtHndl,''string'',''POLYGON selected.'','];
polyset=[polyset '''fontweight'',''bold'',''fontsize'',14);'];
polyset=[polyset 'set(txtHndl1,''string'',''Click on VIEW.'','];
polyset=[polyset '''fontweight'',''bold'',''fontsize'',14);'];

%========================================================
%END of evaled routines
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


%BEGIN GUI ==================================================
%header
subplot(axhead)
text(0,.5,header,'color','m',...
   'erasemode','none','fontweight','bold','fontsize',22);
text(0,0,header1,'color','m',...
   'erasemode','none','fontweight','bold','fontsize',12);


%DRAWING THE GRAPHS
eval(plotin),eval(plotout)


%text(.33,.55,pointer,'color','k',...
%     'erasemode','none','fontweight','bold','fontsize',18);


%vanity
subplot(axvan);
text(0,0,'by D.R.Hill','color','black','fontsize',8,...
'fontweight','bold','fontangle','oblique','erasemode','none')


%
% Push buttons
%

butfrm=uicontrol('style','frame','units','normal',...
                 'position',[.54 .09 .45 .08],'backgroundcolor','y');

gridh = uicontrol('style','push','units','normal','pos',[.55 .1 .1 .06], ...
        'string','Grid On','fontweight','bold','call',gridsit);

helph = uicontrol('style','push','units','normal','pos',[.66 .1 .1 .06], ...
        'string','Help','fontweight','bold','call',helps);

rstarth = uicontrol('style','push','units','normal','pos',[.77 .1 .1 .06], ...
        'string','Restart','fontweight','bold','call','close(gcf),matrixmaps');

endh = uicontrol('style','push','units','normal','pos',[.88 .1 .1 .06], ...
        'string','Quit','fontweight','bold','call',done);

%Special Buttons
%
butfrmv=uicontrol('style','frame','units','normal',...
                 'position',[.81 .18 .12 .08],'backgroundcolor','b');
viewbut=uicontrol('style','push','units','normal','pos',[.82 .19 .1 .06], ...
        'string','View','fontweight','bold','call',doview);




%
%Starting RADIO Buttons for display Mode + FRAME
%
rbutfrm=uicontrol('style','frame','units','normal',...
                'position',[.87 .27 .12 .52],'backgroundcolor','c');

objmode=uicontrol('style','text','string','OBJECTS',...
                  'fontweight','bold','fontsize',14,...
                  'units','normal','position',[.86 .78 .13 .04]);

%rbutcir=uicontrol('style','radio','string','Circle',...
%                  'units','normal','position',[.88 .7 .09 .06],... 
%                  'value',0,...               
%                  'callback','eval(cirset)');

rbuttri=uicontrol('style','radio','string','Triangle','fontweight','bold',...
                  'units','normal','position',[.88 .7 .10 .06],... 
                  'value',0,...               
                  'callback','eval(triset)');

rbuthou=uicontrol('style','radio','string','House','fontweight','bold',...
                  'units','normal','position',[.88 .63 .10 .06],...
                  'value',0,...
                  'callback','eval(houset)');
rbutrect=uicontrol('style','radio','string','Rectangle','fontweight','bold',...
                  'units','normal','position',[.88 .56 .10 .06],...
                  'value',0,...
                  'callback','eval(rectset)');
rbutarr=uicontrol('style','radio','string','Arrow','fontweight','bold',...
                  'units','normal','position',[.88 .49 .10 .06],...
                  'value',0,...
                  'callback','eval(arrset)');
rbutsq=uicontrol('style','radio','string','Square','fontweight','bold',...
                  'units','normal','position',[.88 .42 .10 .06],...
                  'value',0,...
                  'callback','eval(sqset)');
%rbutmtn=uicontrol('style','radio','string','Peaks',...
%                  'units','normal','position',[.88 .35 .09 .06],...
%                  'value',0,...
%                  'callback','eval(mtnset)');

rbutsemi=uicontrol('style','radio','string','Semi-circle','fontweight','bold',...
                  'units','normal','position',[.88 .35 .10 .06],...
                  'value',0,...
                  'callback','eval(semiset)');

rbutpoly=uicontrol('style','radio','string','Polygon','fontweight','bold',...
                  'units','normal','position',[.88 .28 .10 .06],...
                  'value',0,...
                  'callback','eval(polyset)');


%
%MESSAGE area    Borrowed from a MathWorks Routine
    %===================================

    % Set up the Comment Window
    top=0.2;
    left=0.05;
    right=0.5;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    promptStr= ' ';

    % First, the Comment Window frame
    frmBorder=0.02;
    frmPos=[left-frmBorder bottom-frmBorder ...
	(right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);
    % Then the text label
    labelPos=[left top-labelHt (right-left) labelHt];
    uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',[0.50 0.50 0.50], ...
	'ForegroundColor','black', ...
        'String','Comment Window');
    % Then the text field(s)
    
    txtPos=[left top-labelHt-2*frmBorder (right-left) labelHt];
    txtPos1=[left top-2*labelHt-2*frmBorder (right-left) labelHt];
    txtHndl=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos, ...
        'String',promptStr,'foregroundcolor','red');
    txtHndl1=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos1, ...
        'String',promptStr,'foregroundcolor','red');
%First Message

set(txtHndl,'string','Select an OBJECT.',...
   'fontweight','bold','fontsize',14);
set(txtHndl1,'string','Then click on VIEW.',...
    'fontweight','bold','fontsize',14);

 

