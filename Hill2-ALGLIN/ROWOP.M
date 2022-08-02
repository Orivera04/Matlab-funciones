                                               %last updated 9/1/98
%ROWOP   Perform row reduction on real matrix A by explicitly choosing
%        row operations to use. A row operation can be "undone", but
%        this feature cannot be used in succession. Matrices can be
%        at most 6 by 6.
%
%        To enter information, click in the gray boxes with your mouse
%        and then type in the desired numerical value followed by ENTER. 
%
%        Use in the form ===>  rowop  <===
%
%        If the matrix A is complex, the routine REDUCE is called.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu
  
%=======================================================================
%Code for setting color definition to emulate MATLAB version 4
%within version 5.
%The idea is to try to use the same code for version 4 as 5 with the 
%m-files that accompany  LINEAR ALGEBRA LABS with MATLAB, Second Edition
%                      by Hill and Zitarelli
%                        Prentice Hall, 1996
vers=version;vers=vers(1);
specstr='colordef none';
specstr1='colordef white';
if vers=='5',eval(specstr1),end
%=======================================================================

rowmax=6;%MAX number of rows & columns

%strings

s0=' ';
s1='Error: Row number out of range.';
s2='Error: Multiplier must be nonzero and real.';
s3='Executed row operation ';
header='           ROWOP for MATRIX REDUCTION';
cont='Press ENTER to continue.';

%checking range of row subscripts
rangeck='vnum=abs(fix(num));if vnum<=0 | vnum>m | vnum~=num,';
rangeck=[rangeck 'errnum=''ONN'';else,errnum=''OFF'';end'];

%checking range of matrix size
rangeckz='vnum=abs(fix(num));if vnum<=0 | vnum>rowmax | vnum~=num,';
rangeckz=[rangeckz 'errnum=''ONN'';else,errnum=''OFF'';end'];

%Setting switches for recognizing have complete rowop info to NOO
setnoo='havei1=''NOO'';havej1=''NOO'';';
setnoo=[setnoo 'havek2=''NOO'';havei2=''NOO'';'];
setnoo=[setnoo 'havei3=''NOO'';havej3=''NOO'';havek3=''NOO'';'];
eval(setnoo);

%wiping out all editable text regions
wipetext='set(rinti,''string'',''     ''),';
wipetext=[wipetext 'set(rintj,''string'',''     ''),'];
wipetext=[wipetext 'set(rmultk,''string'',''     ''),'];
wipetext=[wipetext 'set(rmulti,''string'',''     ''),'];
wipetext=[wipetext 'set(rcombk,''string'',''     ''),'];
wipetext=[wipetext 'set(rcombi,''string'',''     ''),'];
wipetext=[wipetext 'set(rcombj,''string'',''     '');'];
           

%STARTING THINGS for input
clc
disp(s0),disp(header),disp(s0)
disp('Enter matrix A by entries between square brackets [ ... ]')
disp('or use the name of an existing matrix.')
disp(s0)
A=input('Matrix A = '); %Any existing matrix A is destroyed.

a=A;oldA=A;
[m n]=size(A);

%CHECKING valid input.

%IF COMPLEX STOP and run REDUCE
if sum(sum(abs(imag(A))))>eps
   reduce(A);
   if vers=='5',eval(specstr1),end
   return
end
num=m;eval(rangeckz);%checking # of rows in input matrix
if errnum=='ONN'
   disp('Matrix too large; max size is 6 by 6.')
   if vers=='5',eval(specstr1),end
   return
end
num=n;eval(rangeckz);%checking # of columns in input matrix
if errnum=='ONN'
   disp('Matrix too large; max size is 6 by 6.')
   if vers=='5',eval(specstr1),end
   return
end


%
%COLOR settings
bkgr='white'; %background color
bkgray1=[.8 .8 .8]; %background for editable text



%callbacks for row interchange
%CALLBACK for getting value of i
cbirowi='havei1=''NOO'';rowi=str2num(get(rinti,''string''));num=rowi;';
cbirowi=[cbirowi 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbirowi=[cbirowi 'eval(rangeck);if errnum==''ONN'','];
cbirowi=[cbirowi 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbirowi=[cbirowi 'set(rinti,''string'',''     ''),havei1=''NOO'';else,'];
cbirowi=[cbirowi 'havei1=''YES'';end,if havei1==''YES'' & havej1==''YES'','];
cbirowi=[cbirowi 'eval(dointchg),end'];

%CALLBACK for getting value of j
cbirowj='havej1=''NOO'';rowj=str2num(get(rintj,''string''));num=rowj;';
cbirowj=[cbirowj 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbirowj=[cbirowj 'eval(rangeck);if errnum==''ONN'','];
cbirowj=[cbirowj 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbirowj=[cbirowj 'set(rintj,''string'',''     ''),havej1=''NOO'';else,'];
cbirowj=[cbirowj 'havej1=''YES'';end,if havei1==''YES'' & havej1==''YES'','];
cbirowj=[cbirowj 'eval(dointchg),end'];

%Perform row interchange
dointchg='oldA=A;temp=A(rowi,:);A(rowi,:)=A(rowj,:);A(rowj,:)=temp;a=A;';
dointchg=[dointchg 'eval(wipemat),if dmode==''RAT'',B=rats(A);else,'];
dointchg=[dointchg 'B=mat2strh(A,2);end,eval(dispmat),'];
dointchg=[dointchg 'eval(setnoo);eval(wipetext);'];
dointchg=[dointchg 'set(messhndl,''string'',s3);'];
dointchg=[dointchg 'set(meshndl2,''string'','];
dointchg=[dointchg ...
'[ '' ROW('' int2str(rowi) '') <==> ROW('' int2str(rowj) '')''])'];


%CALL BACKS for row multiples
%SCALAR k
cbrmultk='havek2=''NOO'';str2=get(rmultk,''string'');tflag=0;';
cbrmultk=[cbrmultk 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrmultk=[cbrmultk 'kval2=eval(str2);'];
cbrmultk=[cbrmultk 'if kval2==0|imag(kval2)~=0,set(txtHndl,''string'',s2);pause(4),'];
cbrmultk=[cbrmultk 'set(txtHndl,''string'',s0),'];
cbrmultk=[cbrmultk 'set(rmultk,''string'',''     '');else,'];
cbrmultk=[cbrmultk 'havek2=''YES'';end,if havek2==''YES'' & havei2==''YES'','];
cbrmultk=[cbrmultk 'eval(dormult),end'];
%ROW i
cbrmulti='havei2=''NOO'';rowi=str2num(get(rmulti,''string''));num=rowi;';
cbrmulti=[cbrmulti 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrmulti=[cbrmulti 'eval(rangeck);if errnum==''ONN'','];
cbrmulti=[cbrmulti 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrmulti=[cbrmulti 'set(rmulti,''string'',''     ''),havei2=''NOO'';else,'];
cbrmulti=[cbrmulti 'havei2=''YES'';end,if havek2==''YES'' & havei2==''YES'','];
cbrmulti=[cbrmulti 'eval(dormult),end'];

%Do row multiple
dormult='oldA=A;A(rowi,:)=kval2*A(rowi,:);a=A;';
dormult=[dormult 'eval(wipemat),if dmode==''RAT'',B=rats(A);else,'];
dormult=[dormult 'B=mat2strh(A,2);end,eval(dispmat),'];
dormult=[dormult 'eval(setnoo);eval(wipetext);'];
dormult=[dormult 'set(messhndl,''string'',s3);'];
dormult=[dormult 'set(meshndl2,''string'','];
dormult=[dormult ...
'[ str2 '' * ROW('' int2str(rowi) '')''])'];


%CALL BACKS for adding a multiple of one row to another
%SCALAR k
cbrcombk='havek3=''NOO'';str3=get(rcombk,''string'');tflag=0;';
cbrcombk=[cbrcombk 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrcombk=[cbrcombk 'kval3=eval(str3);'];
cbrcombk=[cbrcombk 'if kval3==0|imag(kval3)~=0,set(txtHndl,''string'',s2);pause(4),'];
cbrcombk=[cbrcombk 'set(txtHndl,''string'',s0),'];
cbrcombk=[cbrcombk 'set(rcombk,''string'',''     '');else,'];
cbrcombk=[cbrcombk 'havek3=''YES'';end,if havek3==''YES'' & havei3==''YES''&'];
cbrcombk=[cbrcombk 'havej3==''YES'','];
cbrcombk=[cbrcombk 'eval(dorcomb),end'];
%ROW i
cbrcombi='havei3=''NOO'';rowi=str2num(get(rcombi,''string''));num=rowi;';
cbrcombi=[cbrcombi 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrcombi=[cbrcombi 'eval(rangeck);if errnum==''ONN'','];
cbrcombi=[cbrcombi 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrcombi=[cbrcombi 'set(rcombi,''string'',''     ''),havei3=''NOO'';else,'];
cbrcombi=[cbrcombi 'havei3=''YES'';end,if havek3==''YES'' & havei3==''YES''&'];
cbrcombi=[cbrcombi 'havej3==''YES'','];
cbrcombi=[cbrcombi 'eval(dorcomb),end'];
%ROW j
cbrcombj='havej3=''NOO'';rowj=str2num(get(rcombj,''string''));num=rowj;';
cbrcombj=[cbrcombj 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrcombj=[cbrcombj 'eval(rangeck);if errnum==''ONN'','];
cbrcombj=[cbrcombj 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrcombj=[cbrcombj 'set(rcombj,''string'',''     ''),havej3=''NOO'';else,'];
cbrcombj=[cbrcombj 'havej3=''YES'';end,if havek3==''YES'' & havei3==''YES''&'];
cbrcombj=[cbrcombj 'havej3==''YES'','];
cbrcombj=[cbrcombj 'eval(dorcomb),end'];

%DO Add multiple of one row to another
dorcomb='oldA=A;A(rowj,:)=kval3*A(rowi,:)+A(rowj,:);a=A;';
dorcomb=[dorcomb 'eval(wipemat),if dmode==''RAT'',B=rats(A);else,'];
dorcomb=[dorcomb 'B=mat2strh(A,2);end,eval(dispmat),'];
dorcomb=[dorcomb 'eval(setnoo);eval(wipetext);'];
dorcomb=[dorcomb 'set(messhndl,''string'',s3),'];
dorcomb=[dorcomb 'set(meshndl2,''string'','];
dorcomb=[dorcomb ...
'[str3 '' * ROW('' int2str(rowi) '') + ROW('' int2str(rowj) '')''])'];

%CALL back for quit button
done = 'close(gcf);if vers==''5'',eval(specstr1),end,clc,';
done=[done 'disp(''The final matrix was:''),disp(A),'];
done=[done 'disp(''ROWOP is over!'')'];
       
%callback for undo button
undoit = 'A=oldA;a=A;eval(wipemat);delete(messhndl),delete(meshndl2),';
undoit = [undoit 'if dmode==''DEC'',B=mat2strh(A,2);'];
undoit = [undoit 'else,B=rats(A);end,eval(dispmat),eval(setmess)'];

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help rowop,disp(cont),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];
%

%Part of callback for radio buttons
wipemat='for jj=1:m,';   %delete old lines
wipemat=[wipemat 'if jj==1,delete(htl1);end,'];              
wipemat=[wipemat 'if jj==2,delete(htl2);end,'];
wipemat=[wipemat 'if jj==3,delete(htl3);end,'];
wipemat=[wipemat 'if jj==4,delete(htl4);end,'];
wipemat=[wipemat 'if jj==5,delete(htl5);end,'];
wipemat=[wipemat 'if jj==6,delete(htl6);end,'];
wipemat=[wipemat 'end']; 
% show lines
dispmat='for jj=1:m,';
dispmat=[dispmat 'if jj==1,'];
dispmat=[dispmat 'htl1=text(.25,vpos(jj),B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==2,'];
dispmat=[dispmat 'htl2=text(.25,vpos(jj),B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==3,'];
dispmat=[dispmat 'htl3=text(.25,vpos(jj),B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==4,'];
dispmat=[dispmat 'htl4=text(.25,vpos(jj),B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==5,'];
dispmat=[dispmat 'htl5=text(.25,vpos(jj),B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'if jj==6,'];
dispmat=[dispmat 'htl6=text(.25,vpos(jj),B(jj,:),''color'',''black'',''fontweight'',''bold'',''fontsize'',14);end,'];
dispmat=[dispmat 'end'];

%Vertical position of matrix display lines
vstart=.95;
for jj=1:6
  vpos(jj)=vstart-.07*(jj-1);%inc .07
end



%THE GUI STARTS HERE
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')
%matrix label
text(.3,1.03,'Current Matrix A','color','red','fontsize',16,...
    'fontweight','bold','erasemode','none')
%screen title
text(-.15,1.05,'<>ROWOP<>','color','magenta','fontsize',24,...
    'fontweight','bold','erasemode','none')

%vanity
text(.55,-.07,'by D.R.Hill','color','black','fontsize',10,'fontweight','bold',...
     'fontangle','oblique','erasemode','none')  

%setting up row op message
setmess=['messhndl=text(.23,.41,s0,''color'',''red'',''fontsize'',16,'];
setmess=[setmess '''fontweight'',''bold'',''string'',s0); '];
setmess=[setmess 'meshndl2=text(.23,.35,s0,''color'',''red'',''fontsize'',16,'];
setmess=[setmess '''fontweight'',''bold'',''string'',s0); '];
eval(setmess)   

%starting with display mode decimal
B=mat2strh(A,2);dmode='DEC';
eval(dispmat)

%Position for Row op labels
textpos=[.05 .85 .19 .05;   .05 .78 .18 .05;   .05 .71 .19 .05;
         .05 .64 .18 .05;  .05 .57 .18 .05;   .05 .50 .22 .05;
         .05 .43 .18 .05];
%Positions for Row op data names
textpos1=[.01 .78 .05 .05; .13 .78 .05 .05;
.01 .64 .05 .05; .01 .57 .05 .05;.01 .43 .05 .05;.01 .36 .05 .05;
.13 .36 .05 .05];
%Positions for editable text
etextpos=[.07 .78 .05 .05; .19 .78 .05 .05;
.07 .64 .15 .05; .07 .57 .05 .05;.07 .43 .15 .05;.07 .36 .05 .05;
.19 .36 .05 .05];
%ROW OPERATION UICONTROLS
%
%ROW INTERCHANGE
txtrint = uicontrol('style','text','units','normal','pos',textpos(1,:), ...
     'string',['Row(i)<==>Row(j)'],'fontsize',12,...
     'fore','white','fontweight','bold','back','blue');
trinti= uicontrol('style','text','units','normal','pos',textpos1(1,:), ...
     'string',[' i = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','blue');
trintj= uicontrol('style','text','units','normal','pos',textpos1(2,:), ...
     'string',[' j = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','blue');
rinti=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(1,:),'back',bkgray1,'fontweight','bold',...
       'call', ['eval(cbirowi)']);
rintj=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(2,:),'back',bkgray1,'fontweight','bold',...
       'call', ['eval(cbirowj)']);
%
%MUTIPLY A ROW
%
txtrmult = uicontrol('style','text','units','normal','pos',textpos(3,:), ...
     'string',['k * Row(i)'],'fontsize',12,...
     'fore','white','fontweight','bold','back','green');
trmultk= uicontrol('style','text','units','normal','pos',textpos1(3,:), ...
     'string',[' k = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','green');
trmulti= uicontrol('style','text','units','normal','pos',textpos1(4,:), ...
     'string',[' i = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','green');
rmultk=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(3,:),'back',bkgray1,'fontweight','bold',...
       'call', 'eval(cbrmultk)');
rmulti=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(4,:),'back',bkgray1,'fontweight','bold',...
       'call', 'eval(cbrmulti)');
%
%ADD A MULTIPLE OF ONE ROW TO ANOTHER
%  
txtrcomb = uicontrol('style','text','units','normal','pos',textpos(6,:), ...
     'string',['k * Row(i) + Row(j)'],'fontsize',12,...
     'fore','white','fontweight','bold','back','black');
trcombk=uicontrol('style','text','units','normal','pos',textpos1(5,:), ...
     'string',[' k = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','black');
trcombi= uicontrol('style','text','units','normal','pos',textpos1(6,:), ...
     'string',[' i = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','black');
trcombj= uicontrol('style','text','units','normal','pos',textpos1(7,:), ...
     'string',[' j = '],'fontsize',12,...
     'fore','white','fontweight','bold','back','black');
rcombk=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(5,:),'back',bkgray1,'fontweight','bold',...
       'call', 'eval(cbrcombk)');
rcombi=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(6,:),'back',bkgray1,'fontweight','bold',...
       'call', 'eval(cbrcombi)');
rcombj=uicontrol('Style','edit','units','normal','fontsize',12,...
        'position',etextpos(7,:),'back',bkgray1,'fontweight','bold',...
       'call', 'eval(cbrcombj)');
%
%END OF ROW OP REGION
%
%
%START PUSH BUTTONS
butfrm1=uicontrol('style','frame','units','normal',...
                 'position',[.89 .04 .1 .32],'backgroundcolor','y');
undoh = uicontrol('style','push','units','normal','pos',[.9 .29 .08 .06], ...
        'string','UNDO','fontweight','bold','call',undoit);
helph = uicontrol('style','push','units','normal','pos',[.9 .21 .08 .06], ...
        'string','Help','fontweight','bold','call',helps);
endh = uicontrol('style','push','units','normal','pos',[.9 .05 .08 .06], ...
        'string','Quit','fontweight','bold','call',done);
rstarth = uicontrol('style','push','units','normal','pos',[.9 .13 .08 .06], ...
        'string','Restart','fontweight','bold','call',...
        'close(gcf),rowop');

%
%Starting RADIO Buttons for display Mode + FRAME
%
butfrm=uicontrol('style','frame','units','normal',...
                 'position',[.69 .04 .17 .25],'backgroundcolor','y');

txtmode=uicontrol('style','text','string','Display Mode',...
                  'units','normal','position',[.7 .21 .15 .06],...
                  'backgroundcolor','y','fontweight','bold');
rbutrat=uicontrol('style','radio','string','Rational',...
                  'backgroundcolor','y','fontweight','bold',...
                  'units','normal','position',[.7 .13 .15 .06],...                
                  'callback',['set(rbutrat,''value'',1),'...
                              'set(rbutdec,''value'',0),'...
                              'B = rats(A);dmode=''RAT'';',...
                              'eval(wipemat),eval(dispmat)']);
rbutdec=uicontrol('style','radio','string','Decimal',...
                  'backgroundcolor','y','fontweight','bold',...
                  'units','normal','position',[.7 .05 .15 .06],...
                  'value',1,...
                  'callback',['set(rbutdec,''value'',1),'...
                              'set(rbutrat,''value'',0),'...
                              'B = mat2strh(A,2);dmode=''DEC'';',...
                              'eval(wipemat),eval(dispmat)']);

%MESSAGE area
    %===================================
    % Set up the Comment Window
    top=0.3;
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
	'ForegroundColor',[1 1 1], ...
        'String','Comment Window');
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos,'fontweight','bold','fontsize',14, ...
        'String',promptStr,'foregroundcolor','magenta');
