                                      %last updated 2/10/96
%LINCOMBO  Graphics game to express one vector as a linear
%          combination of two others. Geometrically 'size' a
%          parallelogram to force a vector to be its diagonal.
%          Sliders are used to change coefficients on the 'basis'
%          vectors. Coefficients can also be entered manually.  
%          There is an option to check your geometric solution.
%          There is a help button.
%          (Coefficients are between -4 and 4 in tenths.)
%
%  Use in the form    ==> lincombo  <==
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%
cont='Press ENTER to continue.';

checksw = 'ONN'; %settting for new button after user is close enough
%following is a 'solution button' which is displayed when user
%presses check & is close enough
newbut=['ansbut = uicontrol(''style'',''push'',''units'',''normal'','];
newbut =[newbut '''pos'',[.88 .58 .08 .07],''string'',''Solution'',''call'''];
newbut=[newbut ',dispsoln);'];
newbut=[newbut 'ansfrm=uicontrol(''style'',''frame'',''units'','];
newbut=[newbut '''normal'',''position'',[.87 .57 .1 .09],'];
newbut=[newbut '''backgroundcolor'',''r'');'];

%
%display the solution when 'solution button' is pressed
dispsoln='mess=[''Answer: '' num2str(cf1(c1)) '' * u + ''];';
dispsoln = [dispsoln 'mess1=[num2str(cf2(c2)) '' * v''];'];
dispsoln = [dispsoln 'axes(basehndl);'];
dispsoln = [dispsoln 'ans1=text(.3,.9,[mess mess1],''color'',''black'',''fontsize'',14,''fontweight'',''bold'');'];
dispsoln = [dispsoln 'pause(6),delete(ans1);'];

%Setting up COEFFICIENT CHOICES
cf1=[3.2 -1 2.4 -2 -3 1.5 2.5 -2.5 -.5 -1.5];   %coefficients
cf2=[2 -1.5 1.5 3.1 4 -3 2.5 .5 -2.3 3];

vmat=[3 3 2 -2 5 -4 2 1 -2 2;2 -2 3 1 -1 1 -3 2 -3 2];   %vectors
umat=[2 1 -2 4 -1 -2 -1 3 1 2;4 3 4 2 3 -4 2 1 3 1];

%Slider text
sldir1='To move a slider click';
sldir2='on its button and drag it;';
sldir3='then release the mouse button.';

again='Y';
while again=='Y'   %Select a good looking pair of vectors.
   c=clock;n1=c(5)+c(6);n1=rand('seed',n1);   %generating random values
   n1=fix((fix(round(100*rand))+1)/10)+1;     %between 1 and for vector
                                              %and coefficient selection
   c=clock;n2=c(5)+c(6);n2=rand('seed',n1);
   n2=fix((fix(round(100*rand))+1)/10)+1;

   c=clock;c1=c(5)+c(6);c1=rand('seed',n1);
   c1=fix((fix(round(100*rand))+1)/10)+1;

   c=clock;c2=c(5)+c(6);c2=rand('seed',n1);
   c2=fix((fix(round(100*rand))+1)/10)+1;

   v=vmat(:,n1);u=umat(:,n2);p=cf1(c1)*u+cf2(c2)*v;
   vx=[0 v(1)];vy=[0 v(2)];
   ux=[0 u(1)];uy=[0 u(2)];

   scoeff=1;tcoeff=1;
   lincomb=scoeff*v+tcoeff*u;
   ang=abs(acos(dot(u,v)/(norm(u)*norm(v))));       %Selecting vectors
   if  ang> .45 & ang < 2.4                         %so that angle between
      again='N';                                    %is > than about 25
   end                                              %degrees and  < than
end                                                 %about 135.
%clf  %clearing figure
darkgray = [.8 .8 .8];%Really a light gray

%
%COLOR settings
bkgr='white'; %background color
%

%Setting figure to full screen
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);

%Having done a graphics command the axes for that graphics screen have been
%given a handle. We label it basehndl.
basehndl=gca;

%header
%
axes(basehndl)
head=text(.17,1,'Linear Combination Game','color','green',...
'erasemode','none','fontweight','bold','fontsize',22);

%vanity
text(.65,-.07,'by D.R.Hill','color','black','fontsize',12,...
'fontweight','bold','fontangle','oblique','erasemode','none')

%Slider Directions
text(-.15,.15,sldir1,'color','green','erasemode','none')
text(-.15,.1,sldir2,'color','green','erasemode','none')
text(-.15,.05,sldir3,'color','green','erasemode','none')

plotit='lincomb=scoeff*v+tcoeff*u;s=scoeff;t=tcoeff; sv=s*v;tu=t*u;';
plotit=[plotit 'if sw==''Y'',axes(pgrf);cla,end,'];
plotit=[plotit 'pgrf=axes(''position'',[.2 .2 .6 .6]);'];
plotit=[plotit 'plot([-20 20],[0 0],''-k'',[0 0],[-20 20],''-k'',''erasemode'',''none''),'];
plotit=[plotit 'set(pgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
plotit=[plotit 'axis(axis),axis(''square''),hold on,'];
%plotit=[plotit 'axes(pgrf);'];
plotit=[plotit 'plot(t*ux,t*uy,''r-'',s*vx,s*vy,''b-'',''linewidth'',2);'];
plotit=[plotit 'plot([tu(1) lincomb(1)],'];
plotit=[plotit '[tu(2) lincomb(2)],'':b'','];
plotit=[plotit '[sv(1) lincomb(1)],[sv(2) lincomb(2)],'':r''),'];
plotit=[plotit 'plot([0 p(1)],[0 p(2)],''-m'',''linewidth'',2),'];
plotit=[plotit 'hold off'];

sw='N';
eval(plotit)
sw='Y';
% Callback strings
%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help lincombo,disp(cont),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];

%CHECKING for exact solution or close enough to display 'solution button'
check = 'ckdist=sqrt((tcoeff-cf1(c1))^2 + (scoeff-cf2(c2))^2);'
check = [check 'if ckdist==0,'];
check = [check 'mess=[''Problem Solved: '' num2str(scoeff) '' * v + ''];'];
check = [check 'mess1=[num2str(tcoeff) '' * u''];'];
check = [check 'axes(basehndl);'];
check = [check 'ans1=text(.3,.9,[mess mess1],''color'',''black'',''fontsize'',14,''fontweight'',''bold'');'];
check = [check 'elseif ckdist < .3,'];
check = [check 'axes(basehndl);'];
check = [check 'ans1=text(.3,.9,''Close; try again.'',''color'',''black'',''fontsize'',14,''fontweight'',''bold'');'];
check = [check 'pause(4),'];
check = [check 'delete(ans1);'];
check = [check 'else,' ];
check = [check 'axes(basehndl);'];
check = [check 'ans1=text(.3,.9,''Keep trying.'',''color'',''black'',''fontsize'',14,''fontweight'',''bold''),'];
check = [check 'pause(4), delete(ans1),end,'];
check = [check 'if ckdist <= .2 & checksw == ''ONN'',eval(newbut);'];
check = [check 'checksw=''OFF'';end'];

%The call back for the quit button.
done = 'close(gcf);clc,';
done=[done 'disp(''LINCOMBO is over!'')'];

%
% Sliders for analog selection of coefficients
%
sc = uicontrol('style','slider','units','normal','pos',[.3 .05 .25 .035], ...
     'min',-4,'max',4,'val',scoeff, ...
     'call',['scoeff = get(sc,''value'');',...
     'set(curs,''string'', num2str(get(sc,''value''))), eval(plotit)']);
sct = uicontrol('style','text','units','normal','pos',[.3 .09 .1 .04], ...
     'string',['Vector v * '],...
     'fore','blue','back',darkgray);
curs=uicontrol('style','text','units','normal','pos',[.4 .09 .1 .04], ...
     'string',num2str(get(sc,'value')),...
     'fore','blue','back',darkgray);
scmin=uicontrol('style','text','units','normal','pos',[.27 .05 .03 .035],...
      'string',num2str(get(sc,'min')),'back',darkgray);
scmax=uicontrol('style','text','units','normal','pos',[.55 .05 .03 .035],...
      'string',num2str(get(sc,'max')),'back',darkgray);


tc = uicontrol('style','slider','units','normal','pos',[.125 .3 .035 .25], ...
     'min',-4,'max',4,'val',tcoeff, ...
     'call',['tcoeff = get(tc,''value'');',...
     'set(curt,''string'', num2str(get(tc,''value''))), eval(plotit)']);
tct = uicontrol('style','text','units','normal','pos',[0 .6 .1 .04], ...
     'string',['Vector u * ' num2str(get(tc,'value'))],...
     'fore','red','back',darkgray);
curt=uicontrol('style','text','units','normal','pos',[.1 .6 .1 .04], ...
     'string',num2str(get(tc,'value')),...
     'fore','red','back',darkgray);
tcmin=uicontrol('style','text','units','normal','pos',[.125 .265 .03 .035],...
      'string',num2str(get(tc,'min')),'back',darkgray);
tcmax=uicontrol('style','text','units','normal','pos',[.125 .55 .03 .035],...
      'string',num2str(get(tc,'max')),'back',darkgray);
%
% Push buttons
%

butfrm=uicontrol('style','frame','units','normal',...
                 'position',[.87 .66 .1 .29],'backgroundcolor','y');
helph = uicontrol('style','push','units','normal','pos',[.88 .88 .08 .06], ...
        'string','Help','call',helps);

testsol=uicontrol('style','push','units','normal','pos',[.88 .81 .08 .06], ...
        'string','Check','call',check);

rstarth = uicontrol('style','push','units','normal','pos',[.88 .74 .08 .06], ...
        'string','Restart','call','close(gcf),lincombo');

endh = uicontrol('style','push','units','normal','pos',[.88 .67 .08 .06], ...
        'string','Quit','call',done);

% Editable Text
%
%User can type in values for the coefficients.
 stext=uicontrol('Style','edit','units','normal',...
        'position',[.835 .05 .08 .06],'back',darkgray,...
       'call',...
       ['scoeff=str2num(get(stext,''string''));'...
        'set(curs,''string'', get(stext,''string'')), eval(plotit)']);

stxtlab = uicontrol('style','text','units','normal','pos',[.8 .12 .15 .04], ...
     'string',['Enter Coeff '],...
     'fore','blue','back',darkgray);

ttext=uicontrol('Style','edit','units','normal',...
        'position',[.05 .8 .08 .06],'back',darkgray,...
       'call',...
       ['tcoeff=str2num(get(ttext,''string''));'...
       'set(curt,''string'', get(ttext,''string'')), eval(plotit)']);

ttxtlab = uicontrol('style','text','units','normal',...
          'pos',[.02 .87 .15 .04], ...
          'string',['Enter Coeff '],...
          'fore','red','back',darkgray);



