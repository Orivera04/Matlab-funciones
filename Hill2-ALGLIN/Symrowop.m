                                               %last updated 1/7/03
%SYMROWOP  Perform row reduction on symbolic matrix A by explicitly 
%        choosing row operations to use. A row operation can be "undone",
%        but this feature cannot be used in succession. Matrices can be
%        at most 5 by 5.
%
%        If a row operation involves the multiplication by a reciprocal
%        a warning is issued that the routine assumes that the
%        denominator is not zero. This must be acknowledged by clicking
%        on a continue button. After acknowledging, finish input of row
%        operation information to have the row operation performed.
%
%        Restriction: multipliers can not reference entries by location.
%                     That is, 1/A(2,3) can not be used. 
%                     You must explicitly enter the contents of the entry.
%
%        Use in the form ===>  symrowop  <===
%
%  This routine requires the Symbolic Math Toolbox.
%  This routine requires utilities: 
%          msym2str, symsizeh, symelem5, & findcomh from D. Hill.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu
  
%=======================================================================
%update 1/7/03
%   insert simplify command on symbolic matrix for screen display
%   put in scalar multiple of a row and linear combination of rows
%   this makes displays smaller.
%_____________________________________________________________
%Code for setting color definition to emulate MATLAB version 4
%within version 5.
%The idea is to try to use the same code for version 4 as 5 with the 
%m-files that accompany  LINEAR ALGEBRA LABS with MATLAB, Second Edition
%                      by Hill and Zitarelli
%                        Prentice Hall, 1996
vers=version;vers=vers(1);
specstr='colordef none';
specstr1='colordef white';
versnum=str2num(vers);
if vers=='5',eval(specstr),end
%=======================================================================

rowmax=5;%MAX number of rows & columns

%strings

s0=' ';
s1='Error: Row number out of range.';
s2='Error: Multiplier must be nonzero and real.';
s3='Executed row operation ';
s4='WARNING: multipliers can NOT use matrix addresses like 1/A(2,3).';
s5='Division; denominator assumed not ZERO.';
s6='Acknowledge restriction; click on CONTINUE.';
s7='Reminder: Press ENTER to execute the operation.';
header='   SYMBOLIC ROWOP for MATRIX REDUCTION';
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

%Check for division in multiplier
divcheck='divsig=''N'';';
divcheck=[divcheck 'for ik=1:length(kval),'];
divcheck=[divcheck 'if kval(ik)==''/'',divsig=''Y'';end,end,'];
divcheck=[divcheck 'if divsig==''Y'','];
divcheck=[divcheck 'if isempty(str2num(kval))~=1,divsig=''N'';end,end,'];
divcheck=[divcheck 'if divsig==''Y'','];
divcheck=[divcheck 'set(txtHndl,''string'',s5);'];
divcheck=[divcheck 'set(txtHndl1,''string'',s6);contsig=''N'';'];
divcheck=[divcheck 'eval(makecont);'];
divcheck=[divcheck 'end'];

%The continue button to acknowledge a divide
makecont='butfrmc=uicontrol(''style'',''frame'',''units'',''normal'',';
makecont=[makecont '''position'',[.69 .04 .12 .08],''backgroundcolor'',''r'');'];
makecont=[makecont 'contbut = uicontrol(''style'',''push'',''units'','];
makecont=[makecont '''normal'',''pos'',[.7 .05 .1 .06],''fontsize'',12,'];
makecont=[makecont '''string'',''CONTINUE'',''call'',contback);'];

%callback for continue button
contback='contsig=''Y'';set(txtHndl,''string'',s0);';
contback=[contback 'set(txtHndl1,''string'',s0);'];
contback=[contback 'delete(butfrmc),delete(contbut);'];

%Initially setting continue signal to YES
contsig='Y';

%STARTING THINGS for input
eval(setnoo)
clc
disp(s0),disp(header),disp(s0)
disp('Enter matrix A by entries between in the form sym(''[ ... ]'')')
disp('or use the name of an existing symbolic matrix.')
disp('NOTE: the entries of a symbolic matrix must be separated by commas.')
disp(s0)
A=input('Matrix A = '); %Any existing matrix A is destroyed.

%CHECKING valid input.

%IF NOT symbolic stop
if versnum<5
   if isstr(A)~=1
      disp('INPUT must be symbolic matrix.')
      if vers=='5',eval(specstr1),end
      return
   end
else %in version 5 symbolics are no longer strings
   chksym='if isa(A,''sym'')~=1,disp(''INPUT must be symbolic matrix.''),';
   chksym=[chksym 'if vers==''5'',eval(specstr1),end,return,end'];
   eval(chksym)
end

if versnum>=5  
   ASYM=A;
   oldASYM=ASYM;    %If in version 5, convert symbolic matrix to
   A=msym2str(A);   % a matrix of strings so old code is valid.
end                 %Besides we need the matrix to be text so that
                    %its entries can be displayed on the graphics
                    %screen using the text command.

a=A;oldA=A;
[m n]=symsizeh(A);

num=m;eval(rangeckz);%checking # of rows in input matrix
if errnum=='ONN'
   disp('Matrix too large; max size is 5 by 5.')
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
cbirowi=[cbirowi 'eval(dointchg),set(rinti,''string'',''     ''),'];
cbirowi=[cbirowi 'set(rintj,''string'',''     ''),'];
cbirowi=[cbirowi 'set(rmultk,''string'',''     ''),'];
cbirowi=[cbirowi 'set(rmulti,''string'',''     ''),'];
cbirowi=[cbirowi 'set(rcombk,''string'',''     ''),'];
cbirowi=[cbirowi 'set(rcombi,''string'',''     ''),'];
cbirowi=[cbirowi 'set(rcombj,''string'',''     ''),end'];
           %wiping out all editable text regions


%CALLBACK for getting value of j
cbirowj='havej1=''NOO'';rowj=str2num(get(rintj,''string''));num=rowj;';
cbirowj=[cbirowj 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbirowj=[cbirowj 'eval(rangeck);if errnum==''ONN'','];
cbirowj=[cbirowj 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbirowj=[cbirowj 'set(rintj,''string'',''     ''),havej1=''NOO'';else,'];
cbirowj=[cbirowj 'havej1=''YES'';end,if havei1==''YES'' & havej1==''YES'','];
cbirowj=[cbirowj 'eval(dointchg),set(rinti,''string'',''     ''),'];
cbirowj=[cbirowj 'set(rintj,''string'',''     ''),'];
cbirowj=[cbirowj 'set(rmultk,''string'',''     ''),'];
cbirowj=[cbirowj 'set(rmulti,''string'',''     ''),'];
cbirowj=[cbirowj 'set(rcombk,''string'',''     ''),'];
cbirowj=[cbirowj 'set(rcombi,''string'',''     ''),'];
cbirowj=[cbirowj 'set(rcombj,''string'',''     ''),end'];
           %wiping out all editable text regions


%Perform row interchange
dointchg='oldA=A;oldASYM=ASYM;';
dointchg=[dointchg 'if versnum<5,E=symelemh(m,1,rowi,rowj);E=msym2str(E);A=symmul(E,A);'];
dointchg=[dointchg 'else,E=symelem5(m,1,rowi,rowj);ASYM=E*ASYM;A=msym2str(ASYM);end;a=A;'];
dointchg=[dointchg 'eval(wipemat),'];
dointchg=[dointchg 'B=A;eval(dispmat),'];
dointchg=[dointchg 'eval(setnoo);'];
dointchg=[dointchg 'set(messhndl,''string'',s3);'];
dointchg=[dointchg 'set(meshndl2,''string'','];
dointchg=[dointchg ...
'[ '' ROW('' int2str(rowi) '') <==> ROW('' int2str(rowj) '')''])'];

%CALL BACKS for row multiples
%SCALAR k
cbrmultk='havek2=''NOO'';kval=get(rmultk,''string'');';
cbrmultk=[cbrmultk 'delete(messhndl),delete(meshndl2),eval(setmess),'];
%cbrmultk=[cbrmultk 'evkval=eval(kval);'];
%cbrmultk=[cbrmultk 'if evkval==0,set(txtHndl,''string'',s2);pause(4),'];
%cbrmultk=[cbrmultk 'set(txtHndl,''string'',s0),'];
%cbrmultk=[cbrmultk 'set(rmultk,''string'',''     '');else,'];
%cbrmultk=[cbrmultk 'havek2=''YES'';end,'];
cbrmultk=[cbrmultk 'havek2=''YES'';eval(divcheck);'];
cbrmultk=[cbrmultk 'if havek2==''YES'' & havei2==''YES''& contsig==''Y'','];
cbrmultk=[cbrmultk 'eval(dormult),set(rmultk,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(rmulti,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(rinti,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(rintj,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(rcombk,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(rcombi,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(rcombj,''string'',''     ''),end'];
%wiping out all editable text regions

%ROW i
cbrmulti='havei2=''NOO'';rowi=str2num(get(rmulti,''string''));num=rowi;';
cbrmulti=[cbrmulti 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrmulti=[cbrmulti 'eval(rangeck);if errnum==''ONN'','];
cbrmulti=[cbrmulti 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrmulti=[cbrmulti 'set(rmulti,''string'',''     ''),havei2=''NOO'';else,'];
cbrmulti=[cbrmulti 'havei2=''YES'';end,if havek2==''YES'' & havei2==''YES''& contsig==''Y'','];
cbrmulti=[cbrmulti 'eval(dormult),set(rmultk,''string'',''     ''),'];
cbrmulti=[cbrmulti 'set(rmulti,''string'',''     ''),'];
cbrmulti=[cbrmulti 'set(rinti,''string'',''     ''),'];
cbrmulti=[cbrmulti 'set(rintj,''string'',''     ''),'];
cbrmulti=[cbrmulti 'set(rcombk,''string'',''     ''),'];
cbrmulti=[cbrmulti 'set(rcombi,''string'',''     ''),'];
cbrmulti=[cbrmulti 'set(rcombj,''string'',''     ''),end'];
%wiping out all editable text regions

%Do row multiple
dormult='oldA=A;oldASYM=ASYM;';
dormult=[dormult 'if versnum<5,E=symelemh(m,2,rowi,rowi,kval);E=msym2str(E);A=symmul(E,A);'];
dormult=[dormult 'else,E=symelem5(m,2,rowi,rowi,kval);ASYM=E*ASYM;ASYM=simplify(ASYM);A=msym2str(ASYM);end;a=A;'];

dormult=[dormult 'eval(wipemat),B=A;eval(dispmat),'];
dormult=[dormult 'eval(setnoo);'];
dormult=[dormult 'set(messhndl,''string'',s3);'];
dormult=[dormult 'set(meshndl2,''string'','];
dormult=[dormult ...
'[ kval '' * ROW('' int2str(rowi) '')''])'];

%CALL BACKS for adding a multiple of one row to another
%SCALAR k
cbrcombk='havek3=''NOO'';kval=get(rcombk,''string'');';
cbrcombk=[cbrcombk 'delete(messhndl),delete(meshndl2),eval(setmess),'];
%cbrcombk=[cbrcombk 'for ij=1:length(str),if str(ij)==''A''|str(ij)==''a'','];
%cbrcombk=[cbrcombk 'tflag=1;end,end,if tflag==1,kval=eval(str);else,'];
%cbrcombk=[cbrcombk 'kval=str2num(str);end,'];
%cbrcombk=[cbrcombk 'kval=eval(str);'];
%cbrcombk=[cbrcombk 'if kval==0|imag(kval)~=0,set(txtHndl,''string'',s2);pause(4),'];
%cbrcombk=[cbrcombk 'set(txtHndl,''string'',s0),'];
%cbrcombk=[cbrcombk 'set(rcombk,''string'',''     '');else,'];
cbrcombk=[cbrcombk 'havek3=''YES'';eval(divcheck);'];
cbrcombk=[cbrcombk 'if havek3==''YES'' & havei3==''YES''&'];
cbrcombk=[cbrcombk 'havej3==''YES''& contsig==''Y'','];
cbrcombk=[cbrcombk 'eval(dorcomb),set(rcombk,''string'',''     ''),'];
cbrcombk=[cbrcombk 'set(rcombi,''string'',''     ''),'];
cbrcombk=[cbrcombk 'set(rcombj,''string'',''     ''),'];
cbrcombk=[cbrcombk 'set(rmultk,''string'',''     ''),'];
cbrcombk=[cbrcombk 'set(rmulti,''string'',''     ''),'];
cbrcombk=[cbrcombk 'set(rinti,''string'',''     ''),'];
cbrcombk=[cbrcombk 'set(rintj,''string'',''     ''),end'];
%wiping out all editable text regions

%ROW i
cbrcombi='havei3=''NOO'';rowi=str2num(get(rcombi,''string''));num=rowi;';
cbrcombi=[cbrcombi 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrcombi=[cbrcombi 'eval(rangeck);if errnum==''ONN'','];
cbrcombi=[cbrcombi 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrcombi=[cbrcombi 'set(rcombi,''string'',''     ''),havei3=''NOO'';else,'];
cbrcombi=[cbrcombi 'havei3=''YES'';end,if havek3==''YES'' & havei3==''YES''&'];
cbrcombi=[cbrcombi 'havej3==''YES''& contsig==''Y'','];
cbrcombi=[cbrcombi 'eval(dorcomb),set(rcombk,''string'',''     ''),'];
cbrcombi=[cbrcombi 'set(rcombi,''string'',''     ''),'];
cbrcombi=[cbrcombi 'set(rcombj,''string'',''     ''),'];
cbrcombi=[cbrcombi 'set(rmultk,''string'',''     ''),'];
cbrcombi=[cbrcombi 'set(rmulti,''string'',''     ''),'];
cbrcombi=[cbrcombi 'set(rinti,''string'',''     ''),'];
cbrcombi=[cbrcombi 'set(rintj,''string'',''     ''),end'];

%wiping out all editable text regions

%ROW j
cbrcombj='havej3=''NOO'';rowj=str2num(get(rcombj,''string''));num=rowj;';
cbrcombj=[cbrcombj 'delete(messhndl),delete(meshndl2),eval(setmess),'];
cbrcombj=[cbrcombj 'eval(rangeck);if errnum==''ONN'','];
cbrcombj=[cbrcombj 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrcombj=[cbrcombj 'set(rcombj,''string'',''     ''),havej3=''NOO'';else,'];
cbrcombj=[cbrcombj 'havej3=''YES'';end,if havek3==''YES'' & havei3==''YES''&'];
cbrcombj=[cbrcombj 'havej3==''YES''& contsig==''Y'','];
cbrcombj=[cbrcombj 'eval(dorcomb),set(rcombk,''string'',''     ''),'];
cbrcombj=[cbrcombj 'set(rcombi,''string'',''     ''),'];
cbrcombj=[cbrcombj 'set(rcombj,''string'',''     ''),'];
cbrcombj=[cbrcombj 'set(rmultk,''string'',''     ''),'];
cbrcombj=[cbrcombj 'set(rmulti,''string'',''     ''),'];
cbrcombj=[cbrcombj 'set(rinti,''string'',''     ''),'];
cbrcombj=[cbrcombj 'set(rintj,''string'',''     ''),end'];

%wiping out all editable text regions


%DO Add multiple of one row to another
dorcomb='oldA=A;oldASYM=ASYM;';
dorcomb=[dorcomb 'if versnum<5,E=symelemh(m,3,rowi,rowj,kval);E=msym2str(E);A=symmul(E,A);'];
dorcomb=[dorcomb 'else,E=symelem5(m,3,rowi,rowj,kval);ASYM=E*ASYM;ASYM=simplify(ASYM);A=msym2str(ASYM);end;a=A;'];
dorcomb=[dorcomb 'eval(wipemat),'];
dorcomb=[dorcomb 'B=A;eval(dispmat),'];
dorcomb=[dorcomb 'eval(setnoo);'];
dorcomb=[dorcomb 'set(messhndl,''string'',s3),'];
dorcomb=[dorcomb 'set(meshndl2,''string'','];
dorcomb=[dorcomb ...
'[kval '' * ROW('' int2str(rowi) '') + ROW('' int2str(rowj) '')''])'];

%CALL back for done button
done = ['close(gcf),if vers==''5'',eval(specstr1),end,'];
done=[done 'clc,disp(''SYMROWOP is over!'')'];

%callback for undo button
undoit = 'A=oldA;ASYM=oldASYM;a=A;eval(wipemat);delete(messhndl),delete(meshndl2),';
undoit = [undoit 'B=A;'];
undoit = [undoit 'eval(dispmat),eval(setmess)'];

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help symrowop,disp(cont),';
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
text(.3,1.03,'Current Matrix','color','red','fontsize',18,...
    'fontweight','bold','erasemode','none')
%screen title
text(-.15,1.05,'<SYMROWOP>','color','magenta','fontsize',20,...
    'fontweight','bold','erasemode','none')

%vanity
text(.55,-.07,'by D.R.Hill','color','black','fontsize',12,...
     'fontweight','bold',...
     'fontangle','oblique','erasemode','none')

%WARNING about multipliers
%
warnhndl=text(-.15,.22,s4,'color','blue','fontsize',12,...
               'fontweight','bold','erasemode','none');
reminder=text(-.15,.26,s7,'color','red','fontsize',12,...
               'fontweight','bold','erasemode','none');          


%setting up row op message
setmess=['messhndl=text(.23,.41,s0,''color'',''red'',''fontsize'',16,'];
setmess=[setmess '''fontweight'',''bold'',''string'',s0); '];
setmess=[setmess 'meshndl2=text(.23,.35,s0,''color'',''red'',''fontsize'',16,'];
setmess=[setmess '''fontweight'',''bold'',''string'',s0); '];
eval(setmess)   

%The initial display
B=A;eval(dispmat)

%Position for Row op labels
textpos=[.05 .85 .18 .05;   .05 .78 .18 .05;   .05 .71 .18 .05;
         .05 .64 .18 .05;  .05 .57 .18 .05;   .05 .50 .18 .05;
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
     'string',['Row(i)<==>Row(j)'],...
     'fore','white','back','blue','fontsize',12,'fontweight','bold');
trinti= uicontrol('style','text','units','normal','pos',textpos1(1,:), ...
     'string',[' i = '],...
     'fore','white','back','blue','fontsize',12,'fontweight','bold');
trintj= uicontrol('style','text','units','normal','pos',textpos1(2,:), ...
     'string',[' j = '],...
     'fore','white','back','blue','fontsize',12,'fontweight','bold');
rinti=uicontrol('Style','edit','units','normal',...
        'position',etextpos(1,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', ['eval(cbirowi)']);
rintj=uicontrol('Style','edit','units','normal',...
        'position',etextpos(2,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', ['eval(cbirowj)']);
%
%MUTIPLY A ROW
%
txtrmult = uicontrol('style','text','units','normal','pos',textpos(3,:), ...
     'string',['k * Row(i)'],...
     'fore','white','back','green','fontsize',12,'fontweight','bold');
trmultk= uicontrol('style','text','units','normal','pos',textpos1(3,:), ...
     'string',[' k = '],...
     'fore','white','back','green','fontsize',12,'fontweight','bold');
trmulti= uicontrol('style','text','units','normal','pos',textpos1(4,:), ...
     'string',[' i = '],...
     'fore','white','back','green','fontsize',12,'fontweight','bold');
rmultk=uicontrol('Style','edit','units','normal',...
        'position',etextpos(3,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', 'eval(cbrmultk)');
rmulti=uicontrol('Style','edit','units','normal',...
        'position',etextpos(4,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', 'eval(cbrmulti)');
%
%ADD A MULTIPLE OF ONE ROW TO ANOTHER
%  
txtrcomb = uicontrol('style','text','units','normal','pos',textpos(6,:), ...
     'string',['k*Row(i)+Row(j)'],...
     'fore','white','back','black','fontsize',11,'fontweight','bold');
trcombk=uicontrol('style','text','units','normal','pos',textpos1(5,:), ...
     'string',[' k = '],...
     'fore','white','back','black','fontsize',12,'fontweight','bold');
trcombi= uicontrol('style','text','units','normal','pos',textpos1(6,:), ...
     'string',[' i = '],...
     'fore','white','back','black','fontsize',12,'fontweight','bold');
trcombj= uicontrol('style','text','units','normal','pos',textpos1(7,:), ...
     'string',[' j = '],...
     'fore','white','back','black','fontsize',12,'fontweight','bold');
rcombk=uicontrol('Style','edit','units','normal',...
        'position',etextpos(5,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', 'eval(cbrcombk)');
rcombi=uicontrol('Style','edit','units','normal',...
        'position',etextpos(6,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', 'eval(cbrcombi)');
rcombj=uicontrol('Style','edit','units','normal',...
        'position',etextpos(7,:),'back',bkgray1,'fontsize',12,'fontweight','bold',...
       'call', 'eval(cbrcombj)');
%
%END OF ROW OP REGION
%
%
%START PUSH BUTTONS
butfrm1=uicontrol('style','frame','units','normal',...
                 'position',[.89 .04 .1 .32],'backgroundcolor','y');
undoh = uicontrol('style','push','units','normal','pos',[.9 .29 .08 .06], ...
        'string','UNDO','fontsize',12,'fontweight','bold','call',undoit);
helph = uicontrol('style','push','units','normal','pos',[.9 .21 .08 .06], ...
        'string','Help','fontsize',12,'fontweight','bold','call',helps);
endh = uicontrol('style','push','units','normal','pos',[.9 .05 .08 .06], ...
        'string','Quit','fontsize',12,'fontweight','bold','call',done);
rstarth = uicontrol('style','push','units','normal','pos',[.9 .13 .08 .06], ...
        'string','Restart','fontsize',12,'fontweight','bold','call','close(gcf),symrowop');

%MESSAGE area
    %===================================
    % Set up the Comment Window
    top=0.25;
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
        'String','Comment Window','fontsize',12);
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos, ...
        'String',promptStr,'foregroundcolor','red','fontsize',12,'fontweight','bold');
    %permits second line in comment window.
    txtPos1=[left bottom-6*spacing (right-left) top-bottom-labelHt-6*spacing];
    txtHndl1=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos1, ...
        'String',promptStr,'foregroundcolor','red','fontsize',12,'fontweight','bold');
