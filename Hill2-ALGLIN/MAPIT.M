%MAPIT                                       LAST UPDATED 11/05/01
%       A script to show the images of objects from 2-space when
%       mapped by a 2 by 2 matrix. Several objects are available
%       and a composite mapping option can be selected. The graphics
%       user interface is employed for object selection and
%       the initiation of operations and options.
%
%       When a matrix is used to perform a mapping we always name it A.
%
%       Use in the form  ==>  mapit  <==
%       and follow the screen directions.
%
%          Requires MATLAB 5.0 or higher. Uses utility mat2strh.
%
%       A related file is planelt.
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%STRINGS
cont='Press ENTER to continue.';
mathead=['                MAPIT: MATRIX IMAGES of FIGURES';
         '                                               ';
         'Enter a 2 by 2 matrix A like [-3 4;5 -1]       ';
         '                                               '];
aprmt='     Matrix A =  ';
matwarn='Matrix A must be 2 by 2!';
%INITIALIZATION
A=zeros(2,2);
B=mat2strh(A,3);
m=2; %size of matrix; used as counter

%setting graphics window to full size
hfig=figure('units','normal','position',[0 0 1 1]);
axis('off')


%SUBPLOTS
axvan=subplot('position',[.85 .01 .1 .05]);axis('off') %vanity
ingrf=subplot('position',[0.05 .3 .35 .5]);          %input graph
outgrf=subplot('position',[.5 .3 .35 .5]);           %output graph
axhead=subplot('position',[.65 .95 .25 .1]);axis('off')   %header
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
header='Matrix Mapping';
inlabel='Matrix A =';
intitle='OBJECT';
outtitle='IMAGE';
outtitl2='IMAGE and COMPOSITE IMAGE';
matname ='A = ';
pointer='==>';

%OBJECT DATA
%<><<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%The unit circle.
%
step=.08;
t=0:step:2.05*pi;
xcirc=cos(t);ycirc=sin(t);

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

%rectangle  4 wide 3 high
%
rbotx=-2:.05:2;rtopx=rbotx;
rleftx=-2*ones(size(0:.05:3));
rrightx=2*ones(size(0:.05:3));
rboty=zeros(size(rbotx));rtopy=3*ones(size(rtopx));
rlefty=0:.05:3;rrighty=rlefty;
xrect=[rbotx rtopx rleftx rrightx];
yrect=[rboty rtopy rlefty rrighty];

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

%POLYGON
%
xpoly=[-7 -4 -3 -1 1 1 -1 -7];
ypoly=[0 2 5 6 5 2 -2 0];

%
%End of OBJECT DATA <><><><><><><><><><><><><><><><><><><><><><>


%ROUTINES that are evaled
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

plotin= 'subplot(ingrf);';
plotin=[plotin 'objgrf=plot([-10 10],[0 0],''-k'',[0 0],[-10 10],''-k'',''linewidth'',2);'];
%plotin=[plotin '''erasemode'',''none''),'];
%plotin=[plotin 'set(ingrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
%plotin=[plotin 'axis(axis),axis(''square''),'];  
plotin=[plotin 'title(intitle,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];

plotout= 'subplot(outgrf);';
plotout=[plotout 'plot([-10 10],[0 0],''-k'',[0 0],[-10 10],''-k'',''linewidth'',2),'];
%plotout=[plotout '''erasemode'',''none''),'];
%plotout=[plotout 'set(outgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
%plotout=[plotout 'axis(axis),axis(''square''),hold on,'];
plotout=[plotout 'title(outtitle,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];
 


%Part of callback for composite button
wipemat='for jj=1:m,';    %delete old lines
wipemat=[wipemat 'if jj==1,delete(htl1);end,'];
wipemat=[wipemat 'if jj==2,delete(htl2);end,'];
wipemat=[wipemat 'end'];

%show lines of matrix A
dispmat='subplot(axmat);for jj=1:2,';
dispmat=[dispmat 'if jj==1,'];
dispmat=[dispmat 'htl1=text(0,.5,B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==2,'];
dispmat=[dispmat 'htl2=text(0,0,B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'end'];

%CALL BACKS
%
domap='xdat=xdat(:)'';ydat=ydat(:)'';dat=[xdat;ydat];new1dat=A*dat;';
domap=[domap 'xdat1=new1dat(1,:);ydat1=new1dat(2,:);'];
domap=[domap 'xl=min(sort(xdat1)-1);xr=max(sort(xdat1)+1);'];
domap=[domap 'yb=min(sort(ydat1)-1);yt=max(sort(ydat1)+1);'];
domap=[domap 'axval=max([abs(xl),abs(xr),abs(yb),abs(yt)]);'];
domap=[domap 'axval=axval*[-1 1 -1 1];subplot(outgrf);'];
domap=[domap 'axis(axval);axis(axis),axis(''square'');hold on;'];
domap=[domap 'if whobj==''M'' | whobj==''P'',pltstyle=''-b'';else,pltstyle=''.b'';end;'];
domap=[domap 'objgrf1=plot([xl xr],[0 0],''-k'',[0 0],[yb yt],''-k'','];
domap=[domap 'xdat1,ydat1,pltstyle,''linewidth'',2);'];
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
domap=[domap '''string'',''Composite'',''call'',''eval(docomp)'');'];

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
domap2=[domap2 'xdat2,ydat2,pltstyle,''linewidth'',2);'];
domap2=[domap2 'title(outtitl2,''erasemode'',''none'',''color'',''k'',''fontweight'',''bold'');'];
%delete MAPIT button
domap2=[domap2 'delete(mapbut);delete(butfrmm);'];
%messages
domap2=[domap2 'set(txtHndl,''string'',''Composite Image displayed.'','];
domap2=[domap2 '''fontweight'',''bold'',''fontsize'',14);'];
domap2=[domap2 'set(txtHndl1,''string'','];
domap2=[domap2 ''' '','];
domap2=[domap2 '''fontweight'',''bold'',''fontsize'',14);'];
%delete composite button
%domap2=[domap2 'delete(compbut);delete(butfrmc);'];



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
docomp=[docomp '''string'',''MATRIX'',''call'',''eval(getmat2)'');'];


%map the current image in color magenta
%wipe out composite button



%callback for matrix button
getmat='set(gcf,''visible'',''off'');havmat=''N'';while havmat==''N'';';
getmat=[getmat 'clc,disp(mathead),A=input(aprmt);'];
getmat=[getmat '[nr nc]=size(A);if nr~=2 | nc~=2,disp(matwarn),'];
getmat=[getmat 'disp(cont),pause,else,havmat=''Y'';end,end,'];
getmat=[getmat 'set(gcf,''visible'',''on'');'];
%input label
getmat=[getmat 'subplot(axinlab);Aname=text(0,0,inlabel,''color'',''r'','];
getmat=[getmat '''fontweight'',''bold'',''fontsize'',18);'];
%writing the matrix rows
getmat=[getmat 'B = mat2strh(A,3);eval(dispmat);'];
%messages
getmat=[getmat 'set(txtHndl,''string'',''We have a matrix and an object.'','];
getmat=[getmat '''fontweight'',''bold'',''fontsize'',14);'];
getmat=[getmat 'set(txtHndl1,''string'',''Click on MAPIT.'','];
getmat=[getmat '''fontweight'',''bold'',''fontsize'',14);'];
%deleting buttons no longer needed
getmat=[getmat 'delete(matfrm);delete(matbut);'];
%generating mapit button
getmat=[getmat 'butfrmm=uicontrol(''style'',''frame'',''units'',''normal'','];
getmat=[getmat '''pos'',[.54 .18 .12 .08],''backgroundcolor'',''b'');'];
getmat=[getmat 'mapbut=uicontrol(''style'',''push'',''units'',''normal'','];
getmat=[getmat '''pos'',[.55 .19 .1 .06],''string'',''MAP IT'',''call'','];
getmat=[getmat '''eval(domap)'');'];


%callback for second matrix button
getmat2='set(gcf,''visible'',''off'');havmat=''N'';while havmat==''N'';';
getmat2=[getmat2 'clc,disp(mathead),A=input(aprmt);'];
getmat2=[getmat2 '[nr nc]=size(A);if nr~=2 | nc~=2,disp(matwarn),'];
getmat2=[getmat2 'disp(cont),pause,else,havmat=''Y'';end,end,'];
getmat2=[getmat2 'set(gcf,''visible'',''on'');'];
%input label
getmat2=[getmat2 'subplot(axinlab);Aname=text(0,0,inlabel,''color'',''r'','];
getmat2=[getmat2 '''fontweight'',''bold'',''fontsize'',18);'];
%writing the matrix rows
getmat2=[getmat2 'B = mat2strh(A,3);eval(dispmat);'];
%messages
getmat2=[getmat2 'set(txtHndl,''string'',''We have a second matrix.'','];
getmat2=[getmat2 '''fontweight'',''bold'',''fontsize'',14);'];
getmat2=[getmat2 'set(txtHndl1,''string'',''Click MAPIT for composite image.'','];
getmat2=[getmat2 '''fontweight'',''bold'',''fontsize'',14);'];
%deleting buttons no longer needed
getmat2=[getmat2 'delete(matfrm);delete(matbut);'];
%generating mapit button
getmat2=[getmat2 'butfrmm=uicontrol(''style'',''frame'',''units'',''normal'','];
getmat2=[getmat2 '''pos'',[.54 .18 .12 .08],''backgroundcolor'',''b'');'];
getmat2=[getmat2 'mapbut=uicontrol(''style'',''push'',''units'',''normal'','];
getmat2=[getmat2 '''pos'',[.55 .19 .1 .06],''string'',''MAP IT'',''call'','];
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
doview=[doview 'xdat,ydat,pltstyle,''linewidth'',2);'];
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
doview=[doview '''string'',''MATRIX'',''call'',''eval(getmat)'');'];
doview=[doview 'else,'];
doview=[doview 'end;'];

%callback for the grid button
gridsit='if gridstat==''N'',set(ingrf,''xtick'',[-10:1:10],''ytick'',[-10:1:10],';
gridsit=[gridsit '''xgrid'',''on'',''ygrid'',''on'');gridstat==''Y'';'];
gridsit=[gridsit 'set(outgrf,'];
gridsit=[gridsit '''xgrid'',''on'',''ygrid'',''on'');end'];
%NOTE: no tick marks set on image graph; therefor, self scaling for grid  3/15/00

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help mapit,disp(cont),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];

%CALL back for QUIT button
done = 'close(gcf),clc,disp(''MAPIT is over!'')';

%use to delete buttons after object selected
%
delbut='delete(objmode);delete(rbutfrm);delete(rbutcir);';
delbut=[delbut 'delete(rbuthou);delete(rbutrect);delete(rbutarr);'];
delbut=[delbut 'delete(rbutsq);delete(rbutmtn);delete(rbutpoly);'];


%RADIO Buttons CALLBACKS ===============================
cirset='eval(delbut);';
cirset=[cirset 'xdat=xcirc;ydat=ycirc;havdat=''Y'';whobj=''C'';'];
cirset=[cirset 'set(txtHndl,''string'',''CIRCLE selected.'','];
cirset=[cirset '''fontweight'',''bold'',''fontsize'',14);'];
cirset=[cirset 'set(txtHndl1,''string'',''Click on VIEW.'','];
cirset=[cirset '''fontweight'',''bold'',''fontsize'',14);'];

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
text(0,0,header,'color','m',...
     'erasemode','none','fontweight','bold','fontsize',22);

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
        'string','Grid On','call',gridsit);

helph = uicontrol('style','push','units','normal','pos',[.66 .1 .1 .06], ...
        'string','Help','call',helps);

rstarth = uicontrol('style','push','units','normal','pos',[.77 .1 .1 .06], ...
        'string','Restart','call','close(gcf),mapit');

endh = uicontrol('style','push','units','normal','pos',[.88 .1 .1 .06], ...
        'string','Quit','call',done);

%Special Buttons
%
butfrmv=uicontrol('style','frame','units','normal',...
                 'position',[.81 .18 .12 .08],'backgroundcolor','b');
viewbut=uicontrol('style','push','units','normal','pos',[.82 .19 .1 .06], ...
        'string','View','call',doview);




%
%Starting RADIO Buttons for display Mode + FRAME
%
rbutfrm=uicontrol('style','frame','units','normal',...
                'position',[.87 .27 .11 .52],'backgroundcolor','c');

objmode=uicontrol('style','text','string','OBJECTS',...
                  'fontweight','bold','fontsize',14,...
                  'units','normal','position',[.86 .78 .13 .04]);

rbutcir=uicontrol('style','radio','string','Circle',...
                  'units','normal','position',[.88 .7 .09 .06],... 
                  'value',0,...               
                  'callback','eval(cirset)');
rbuthou=uicontrol('style','radio','string','House',...
                  'units','normal','position',[.88 .63 .09 .06],...
                  'value',0,...
                  'callback','eval(houset)');
rbutrect=uicontrol('style','radio','string','Rect.',...
                  'units','normal','position',[.88 .56 .09 .06],...
                  'value',0,...
                  'callback','eval(rectset)');
rbutarr=uicontrol('style','radio','string','Arrow',...
                  'units','normal','position',[.88 .49 .09 .06],...
                  'value',0,...
                  'callback','eval(arrset)');
rbutsq=uicontrol('style','radio','string','Square',...
                  'units','normal','position',[.88 .42 .09 .06],...
                  'value',0,...
                  'callback','eval(sqset)');
rbutmtn=uicontrol('style','radio','string','Peaks',...
                  'units','normal','position',[.88 .35 .09 .06],...
                  'value',0,...
                  'callback','eval(mtnset)');
rbutpoly=uicontrol('style','radio','string','Polygon',...
                  'units','normal','position',[.88 .28 .09 .06],...
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

 

