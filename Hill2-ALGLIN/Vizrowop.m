%last updated 4/4/00
%VIZROWOP   Perform row operations on a 2 by 2 linear
%           system and see the corresponding graphics operation.
%           After clicking on the row operation you want to perform
%           enter the information for that row operation in the boxes
%           that appear in the 'INPUT REGION'. Push Enter to send the
%           information you type to MATLAB. Note that a row operation
%           can be "undone", but this feature cannot be used in succession.
% 
%        Use in the form ===>  vizrowop  <===
%
%           Uses utility mat2strh.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

%            <><><><><><><><><><><><><><><><><><><><><><><><><>
%            <> This is a command script, not a function.    <>
%            <> Uses utility mat2strh.                       <>
%            <> For ver 4.2 or higher on a PC.               <>
%            <><><><><><><><><><><><><><><><><><><><><><><><><>
%

%INITIALIZATION  
rowmax=2;% number of rows must be this
colmax = 3; % number of columns must be this
sig=[0 0 0]; %signals for i, j, k input areas
numrowop=0; %setting number of row ops performed
            %to zero for first time signal
currad=[.6 .55 .35 .35]; %address of graph of current system
prevad=[.6 .15 .35 .35]; %address of graph of previous system

%codes for zero rows intialized to NO
orow1zip='N';nrow1zip='N';
orow2zip='N';nrow2zip='N';

%strings
havei='NOO';havej='NOO';havek='NOO';
s0=' ';
s1='Error: Row number out of range.';
s2='Error: Multiplier must be nonzero.';
s3='Executed row op ';
header='          Visualizing Row Operations';
cont='Press ENTER to continue.';

%checking range of row subscripts
rangeck='vnum=abs(fix(num));if vnum<=0 | vnum>m | vnum~=num,';
rangeck=[rangeck 'errnum=''ONN'';else,errnum=''OFF'';end'];



%STARTING THINGS for input
clc
disp(s0),disp(header),disp(s0)
disp('Enter an augmented matrix for a system of 2 equations in 2 unknowns;')
disp('put the entries between square brackets [ ... ]')
disp('or use the name of an existing augmented matrix for such a system.')
disp('For convenience we call name the augmented matrix A.')
disp(s0)
A=input('Matrix A = '); %Any existing matrix A is destroyed.

a=A;oldA=A;
[m n]=size(A);

%CHECKING valid input.
   %checking # of rows in input matrix
if m~=2,errnum='ONN';else,errnum='OFF';end
if errnum=='ONN'
   disp('Matrix must have exactly 2 rows and 3 columns.')
   return
end
   %checking # of columns in input matrix
if n~=3,errnum='ONN';else,errnum='OFF';end
if errnum=='ONN'
   disp('Matrix must have exactly 2 rows and 3 columns.')
   return
end

%Solving the system and setting type of solution.
coeff=A(:,1:2);rhside=A(:,3);rrefA=rref(A);
if sum(sum(rref(coeff)-zeros(2)))==0
   disp('Coefficient matrix of all zeros. Enter another system.')
   disp('VISUALIZING ROW OPERATIONS is over!')
   return
end
if A(1,1)==0 & A(1,2)==0, orow1zip='Y';nrow2zip='Y';end
if A(2,1)==0 & A(2,2)==0, orow2zip='Y';nrow2zip='Y';end

types='XX'; %Initializing type of system to nothing
            %This code is called types so we do not override type command

if sum(sum(rref(coeff)-eye(2)))==0
   types = 'UN';  %unique soln
   soln=coeff\rhside; %solving the system
   ptx=soln(1);pty=soln(2); %value to plot for graphs
   spread=[soln(1)-2 soln(1)+2 soln(2)-2 soln(2)+2];
   %spread is the graphing window settings
   %Construct two pts for each line.
   l1x1=.9*spread(1);l1x2=.9*spread(2);
   l2x1=.9*spread(1);l2x2=.9*spread(2);
   if A(1,2)~=0
      l1y1=(A(1,3)-A(1,1)*l1x1)/A(1,2);
   else %first eqn is horiz
      l1x1=A(1,3)/A(1,1);
      l1y1=.9*spread(3);
   end
   if A(1,2)~=0
      l1y2=(A(1,3)-A(1,1)*l1x2)/A(1,2);
   else %first eqn is horiz
      l1x2=A(1,3)/A(1,1);
      l1y2=.9*spread(4);
   end
   if A(2,2)~=0
      l2y1=(A(2,3)-A(2,1)*l2x1)/A(2,2);
   else %first eqn is horiz
      l2x1=A(2,3)/A(2,1);
      l2y1=.9*spread(3);
   end
   if A(2,2)~=0
      l2y2=(A(2,3)-A(2,1)*l2x2)/A(2,2);
   else %first eqn is horiz
      l2x2=A(2,3)/A(2,1);
      l2y2=.9*spread(4);
   end
   %thus we have for line #1 (l1x1,l1y1),(l1x2,l1y2)
   %thus we have for line #2 (l2x1,l2y1),(l2x2,l2y2)
end
if types=='XX' & abs(rank(coeff)-rank(rref(A)))==0
   types='CC'; %implying coincident lines
   if rrefA(1,2)==0
      types='CV'; %implying vertical coincident
   end
   if rrefA(1,1)==0
      types='CH'; %implying horizontal coincident
   end
   if types=='CC'
      xintcpt=rrefA(1,3)/rrefA(1,1);
      yintcpt=rrefA(1,3)/rrefA(1,2);
      xmin=min([0 xintcpt])-1;
      xmax=max([0 xintcpt])+1;
      ymin=min([0 yintcpt])-1;
      ymax=max([0 yintcpt])+1;
      spread=[xmin xmax ymin ymax];
      l1x1=xmin;l1y1=(rrefA(1,3)-l1x1*rrefA(1,1))/rrefA(1,2);
      l2x1=l1x1;l2y1=l1y1;
      l1x2=xmax;l1y2=(rrefA(1,3)-l1x2*rrefA(1,1))/rrefA(1,2);
      l2x2=l1x2;l2y2=l1y2;  %change made 12/18/94
      %l1x1=xintcpt;l1y1=0;l2x1=xintcpt;l2y1=0;
      %l1x2=0;l1y2=yintcpt;l2x2=0;l2y2=yintcpt;
   end
   if types=='CV'
      xintcpt=rrefA(1,3);
      xmin=min([0 xintcpt])-1;
      xmax=max([0 xintcpt])+1;
      ymin=-1;
      ymax=1;
      spread=[xmin xmax ymin ymax];
      l1x1=xintcpt;l1y1=-1;l1x2=xintcpt;l1y2=1;
      l2x1=xintcpt;l2y1=-1;l2x2=xintcpt;l2y2=1;
   end
   if types=='CH'
      yintcpt=rrefA(1,3);
      ymin=min([0 yintcpt])-1;
      ymax=max([0 yintcpt])+1;
      xmin=-1;
      xmax=1;
      spread=[xmin xmax ymin ymax];
      l1x1=-1;l1y1=yintcpt;l1x2=1;l1y2=yintcpt;
      l2x1=-1;l2y1=yintcpt;l2x2=1;l2y2=yintcpt;
   end      
end
if types=='XX' 
   types='IN'; %implying parallel lines
   if A(1,2)==0 & A(2,2)==0
      types='IV'; %implying parallel vertical lines
   end
   if A(1,1)==0 & A(2,1)==0
      types='IH'; %implying parallel horizontal lines
   end
   if types=='IN'
      xintcpt1=A(1,3)/A(1,1);
      yintcpt1=A(1,3)/A(1,2);
      xintcpt2=A(2,3)/A(2,1);
      yintcpt2=A(2,3)/A(2,2);
      xmin=min([0 xintcpt1 xintcpt2])-1;
      xmax=max([0 xintcpt1 xintcpt2])+1;
      ymin=min([0 yintcpt1 yintcpt2])-1;
      ymax=max([0 yintcpt1 yintcpt2])+1;
      spread=[xmin xmax ymin ymax];
     %     l1x1=xintcpt1;l1y1=0;l1x2=0;l1y2=yintcpt1;
     %     l2x1=xintcpt2;l2y1=0;l2x2=0;l2y2=yintcpt2;
      l1x1=xmin;l1y1=(-yintcpt1/xintcpt1)*xmin+yintcpt1; %change 6/12/95
      l1x2=xmax;l1y2=(-yintcpt1/xintcpt1)*xmax+yintcpt1;
      l2x1=xmin;l2y1=(-yintcpt2/xintcpt2)*xmin+yintcpt2;
      l2x2=xmax;l2y2=(-yintcpt2/xintcpt2)*xmax+yintcpt2;
   end
   if types=='IV'
      xintcpt1=A(1,3)/A(1,1);
      xintcpt2=A(2,3)/A(2,1);
      xmin=min([0 xintcpt1 xintcpt2])-1;
      xmax=max([0 xintcpt1 xintcpt2])+1;
      ymin=-1;
      ymax=1;
      spread=[xmin xmax ymin ymax];
      l1x1=xintcpt1;l1y1=-1;l1x2=xintcpt1;l1y2=1;
      l2x1=xintcpt2;l2y1=-1;l2x2=xintcpt2;l2y2=1;
   end
   end
   if types=='IH'
      yintcpt1=A(1,3)/A(1,2);
      yintcpt2=A(2,3)/A(2,2);
      ymin=min([0 yintcpt1 yintcpt2])-1;
      ymax=max([0 yintcpt1 yintcpt2])+1;
      xmin=-1;
      xmax=1;
      spread=[xmin xmax ymin ymax];
      l1x1=-1;l1y1=yintcpt1;l1x2=1;l1y2=yintcpt1;
      l2x1=-1;l2y1=yintcpt2;l2x2=1;l2y2=yintcpt2;
   end    
%end

%Previous System Graph
pfig='pgrf=axes(''position'',grfad);';
pfig=[pfig 'plot(spread(1:2),[0 0],''-k'',[0 0],spread(3:4),''-k'');'];
pfig=[pfig 'set(pgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
pfig=[pfig 'axis(spread);axis(''square'');axis(axis);'];
pfig=[pfig 'hold on;'];
pfig=[pfig 'if types==''UN'';'];
pfig=[pfig 'plot(ptx,pty,''*k'',ptx,pty,''ok'');end;'];
pfig=[pfig 'if orow1zip==''N'','];
pfig=[pfig 'plot([l1x1 l1x2],[l1y1 l1y2],'':b'');end,'];
pfig=[pfig 'if orow2zip==''N'','];
pfig=[pfig 'plot([l2x1 l2x2],[l2y1 l2y2],''-.r'');end,'];
%pfig=[pfig 'plot([l1x1 l1x2],[l1y1 l1y2],'':b'',[l2x1 l2x2],[l2y1 l2y2],''-.r'');'];
pfig=[pfig 'hold off;'];



%Current System Graph
cfig='cgrf=axes(''position'',grfad);';
cfig=[cfig 'plot(spread(1:2),[0 0],''-k'',[0 0],spread(3:4),''-k'');'];
cfig=[cfig 'set(cgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
cfig=[cfig 'axis(spread);axis(''square'');axis(axis);'];
cfig=[cfig 'hold on;'];
cfig=[cfig 'if types==''UN'';'];
cfig=[cfig 'plot(ptx,pty,''*k'',ptx,pty,''ok'');end;'];
cfig=[cfig 'if nrow1zip==''N'','];
cfig=[cfig 'plot([l1x1 l1x2],[l1y1 l1y2],'':b'');end,'];
cfig=[cfig 'if nrow2zip==''N'','];
cfig=[cfig 'plot([l2x1 l2x2],[l2y1 l2y2],''-.r'');end,'];
cfig=[cfig 'hold off;'];
   

%Construct NEW GRAPH; ie graph of system after a row op.
calcngrf='ol1y1=l1y1;ol1y2=l1y2;ol2y1=l2y1;ol2y2=l2y2;'; %saving old info
calcngrf=[calcngrf 'ol1x1=l1x1;ol1x2=l1x2;ol2x1=l2x1;ol2x2=l2x2;'];
calcngrf=[calcngrf 'if types==''UN'','];
calcngrf=[calcngrf 'l1x1=.9*spread(1);l1x2=.9*spread(2);'];
calcngrf=[calcngrf 'l2x1=.9*spread(1);l2x2=.9*spread(2);'];
calcngrf=[calcngrf 'if A(1,2)~=0, l1y1=(A(1,3)-A(1,1)*l1x1)/A(1,2);'];
calcngrf=[calcngrf 'else,l1x1=A(1,3)/A(1,1);l1y1=.9*spread(3);end,'];
calcngrf=[calcngrf 'if A(1,2)~=0,l1y2=(A(1,3)-A(1,1)*l1x2)/A(1,2);'];
calcngrf=[calcngrf 'else,l1x2=A(1,3)/A(1,1);l1y2=.9*spread(4);end,'];
calcngrf=[calcngrf 'if A(2,2)~=0,l2y1=(A(2,3)-A(2,1)*l2x1)/A(2,2);'];
calcngrf=[calcngrf 'else,l2x1=A(2,3)/A(2,1);l2y1=.9*spread(3);end,'];
calcngrf=[calcngrf 'if A(2,2)~=0,l2y2=(A(2,3)-A(2,1)*l2x2)/A(2,2);'];
calcngrf=[calcngrf 'else,l2x2=A(2,3)/A(2,1);l2y2=.9*spread(4);end;'];
%calcngrf=[calcngrf 'end;'];
calcngrf=[calcngrf 'elseif optype==''I'','];
calcngrf=[calcngrf 'tl1x1=l1x1;tl1y1=l1y1;tl1x2=l1x2;tl1y2=l1y2;'];
calcngrf=[calcngrf 'l1x1=l2x1;l1y1=l2y1;l1x2=l2x2;l1y2=l2y2;'];
calcngrf=[calcngrf 'l2x1=tl1x1;l2y1=tl1y1;l2x2=tl1x2;l2y2=tl1y2;'];
calcngrf=[calcngrf 'end;'];
calcngrf=[calcngrf 'end;'];
   %thus we have for line #1 (l1x1,l1y1),(l1x2,l1y2)
   %thus we have for line #2 (l2x1,l2y1),(l2x2,l2y2)


%
%COLOR settings
bkgr='white'; %background color
%

%callbacks for row interchange

%Perform row interchange
dointchg='optype=''I'';rowi=1;rowj=2;oldA=A;temp=A(rowi,:);eval(inptarea);';
dointchg=[dointchg 'set(txtHndl,''string'',s0),'];
dointchg=[dointchg 'orow1zip=nrow1zip;orow2zip=nrow2zip;'];
dointchg=[dointchg 'if numrowop~=0,eval(wipepmat),delete(pgrf),end,'];
dointchg=[dointchg 'if dmode==''RAT'',B=rats(A);else,'];
dointchg=[dointchg 'B=mat2strh(A,2);end,eval(disppmat),'];
dointchg=[dointchg 'grfad=prevad;eval(pfig);'];
dointchg=[dointchg 'eval(wipecmat);delete(cgrf);'];
dointchg=[dointchg 'A(rowi,:)=A(rowj,:);A(rowj,:)=temp;a=A;'];
dointchg=[dointchg 'if dmode==''RAT'',B=rats(A);else,'];
dointchg=[dointchg 'B=mat2strh(A,2);end,eval(dispcmat),'];
dointchg=[dointchg 'eval(calcngrf);grfad=currad;eval(cfig);'];
dointchg=[dointchg 'havei=''NOO'';havej=''NOO'';numrowop=1;'];
dointchg=[dointchg 'set(txtHndl,''string'','];
dointchg=[dointchg ...
'[s3 '' ROW('' int2str(rowi) '') <==> ROW('' int2str(rowj) '')''])'];


%CALL BACKS for row multiples
%SCALAR k
cbrmultk='havek=''NOO'';str=get(ektext,''string'');tflag=0;';
cbrmultk=[cbrmultk 'set(txtHndl,''string'',s0),'];
cbrmultk=[cbrmultk 'for ij=1:length(str),if str(ij)==''A''|str(ij)==''a'','];
cbrmultk=[cbrmultk 'tflag=1;end,end,if tflag==1,kval=eval(str);else,'];
cbrmultk=[cbrmultk 'kval=str2num(str);end,'];
cbrmultk=[cbrmultk 'if kval==0,set(txtHndl,''string'',s2);pause(4),'];
cbrmultk=[cbrmultk 'set(txtHndl,''string'',s0),'];
cbrmultk=[cbrmultk 'set(ektext,''string'',''     '');else,'];
cbrmultk=[cbrmultk 'havek=''YES'';end,if havek==''YES'' & havei==''YES'','];
cbrmultk=[cbrmultk 'eval(dormult),set(ektext,''string'',''     ''),'];
cbrmultk=[cbrmultk 'set(eitext,''string'',''     ''),end'];

%ROW i
cbrmulti='havei=''NOO'';rowi=str2num(get(eitext,''string''));num=rowi;';
cbrmulti=[cbrmulti 'eval(rangeck);if errnum==''ONN'','];
cbrmulti=[cbrmulti 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrmulti=[cbrmulti 'set(eitext,''string'',''     ''),havei=''NOO'';else,'];
cbrmulti=[cbrmulti 'havei=''YES'';end,if havek==''YES'' & havei==''YES'','];
cbrmulti=[cbrmulti 'eval(dormult),end'];

%Do row multiple
dormult='optype=''M'';oldA=A;eval(inptarea);';
dormult=[dormult 'set(txtHndl,''string'',s0),'];
dormult=[dormult 'orow1zip=nrow1zip;orow2zip=nrow2zip;'];
dormult=[dormult 'if numrowop~=0,eval(wipepmat),delete(pgrf),end,'];
dormult=[dormult 'if dmode==''RAT'',B=rats(A);else,'];
dormult=[dormult 'B=mat2strh(A,2);end,eval(disppmat),'];
dormult=[dormult 'grfad=prevad;eval(pfig);'];
dormult=[dormult 'eval(wipecmat);delete(cgrf);'];
dormult=[dormult 'A(rowi,:)=kval*A(rowi,:);a=A;'];
dormult=[dormult 'if dmode==''RAT'',B=rats(A);else,'];
dormult=[dormult 'B=mat2strh(A,2);end,eval(dispcmat),'];
dormult=[dormult 'eval(calcngrf);grfad=currad;eval(cfig);'];
dormult=[dormult 'havek=''NOO'';havei=''NOO'';numrowop=1;'];
dormult=[dormult 'set(txtHndl,''string'','];
dormult=[dormult ...
'[s3 num2str(kval) '' * ROW('' int2str(rowi) '')''])'];


%CALL BACKS for adding a multiple of one row to another
%SCALAR k
cbrcombk='havek=''NOO'';str=get(ektext,''string'');tflag=0;';
cbrcombk=[cbrcombk 'for ij=1:length(str),if str(ij)==''A''|str(ij)==''a'','];
cbrcombk=[cbrcombk 'tflag=1;end,end,if tflag==1,kval=eval(str);else,'];
cbrcombk=[cbrcombk 'kval=str2num(str);end,'];
cbrcombk=[cbrcombk 'if kval==0,set(txtHndl,''string'',s2);pause(4),'];
cbrcombk=[cbrcombk 'set(txtHndl,''string'',s0),'];
cbrcombk=[cbrcombk 'set(ektext,''string'',''     '');else,'];
cbrcombk=[cbrcombk 'havek=''YES'';end,if havek==''YES'' & havei==''YES''&'];
cbrcombk=[cbrcombk 'havej==''YES'','];
cbrcombk=[cbrcombk 'eval(dorcomb),end'];
%ROW i
cbrcombi='havei=''NOO'';rowi=str2num(get(eitext,''string''));num=rowi;';
cbrcombi=[cbrcombi 'eval(rangeck);if errnum==''ONN'','];
cbrcombi=[cbrcombi 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrcombi=[cbrcombi 'set(eitext,''string'',''     ''),havei=''NOO'';else,'];
cbrcombi=[cbrcombi 'havei=''YES'';end,if havek==''YES'' & havei==''YES''&'];
cbrcombi=[cbrcombi 'havej==''YES'','];
cbrcombi=[cbrcombi 'eval(dorcomb),end'];
%ROW j
cbrcombj='havej=''NOO'';rowj=str2num(get(ejtext,''string''));num=rowj;';
cbrcombj=[cbrcombj 'eval(rangeck);if errnum==''ONN'','];
cbrcombj=[cbrcombj 'set(txtHndl,''string'',s1),pause(4),set(txtHndl,''string'',s0),'];
cbrcombj=[cbrcombj 'set(ejtext,''string'',''     ''),havej=''NOO'';else,'];
cbrcombj=[cbrcombj 'havej=''YES'';end,if havek==''YES'' & havei==''YES''&'];
cbrcombj=[cbrcombj 'havej==''YES'','];
cbrcombj=[cbrcombj 'eval(dorcomb),end'];

%DO Add multiple of one row to another
dorcomb='optype=''L'';oldA=A;eval(inptarea);';
dorcomb=[dorcomb 'set(txtHndl,''string'',s0),'];
dorcomb=[dorcomb 'orow1zip=nrow1zip;orow2zip=nrow2zip;'];
dorcomb=[dorcomb 'if numrowop~=0,eval(wipepmat),delete(pgrf),end,'];
dorcomb=[dorcomb 'if dmode==''RAT'',B=rats(A);else,'];
dorcomb=[dorcomb 'B=mat2strh(A,2);end,eval(disppmat),'];
dorcomb=[dorcomb 'grfad=prevad;eval(pfig);'];
dorcomb=[dorcomb 'eval(wipecmat);delete(cgrf);'];
dorcomb=[dorcomb 'A(rowj,:)=kval*A(rowi,:)+A(rowj,:);a=A;'];

%CHECKING if get zeros in rowj's first two entries
dorcomb=[dorcomb 'nrow1zip=''N'';nrow2zip=''N'';'];
dorcomb=[dorcomb 'if A(rowj,1)==0 & A(rowj,2)==0,'];
dorcomb=[dorcomb 'if rowj==1,nrow1zip=''Y'';end,'];
dorcomb=[dorcomb 'if rowj==2,nrow2zip=''Y'';end,end,'];


dorcomb=[dorcomb 'if dmode==''RAT'',B=rats(A);else,'];
dorcomb=[dorcomb 'B=mat2strh(A,2);end,eval(dispcmat),'];
dorcomb=[dorcomb 'eval(calcngrf);grfad=currad;eval(cfig);'];
dorcomb=[dorcomb 'havek=''NOO'';havei=''NOO'';havej=''NOO'';numrowop=1;'];
dorcomb=[dorcomb 'set(txtHndl,''string'','];
dorcomb=[dorcomb ...
'[s3 num2str(kval) '' * ROW('' int2str(rowi) '') + ROW('' int2str(rowj) '')''])'];



%CALL back for done button
done = 'close(gcf),clc,disp(''VIZROWOP is over!'')';%callback for quit button

%callback for undo button
undoit = 'A=oldA;a=A;set(txtHndl,''string'',s0);eval(inptarea);';
undoit = [undoit 'if numrowop~=0,numrowop=0;eval(wipepmat);delete(pgrf);'];
undoit = [undoit 'eval(wipecmat);delete(cgrf);'];
undoit = [undoit 'if dmode==''DEC'',B=mat2strh(A,2);'];
undoit = [undoit 'else,B=rats(A);end,eval(dispcmat),'];
undoit = [undoit 'nrow1zip=orow1zip;nrow2zip=orow2zip;'];
undoit = [undoit 'l1x1=ol1x1;l1x2=ol1x2;l2x1=ol2x1;l2x2=ol2x2;'];
undoit = [undoit 'l1y1=ol1y1;l1y2=ol1y2;l2y1=ol2y1;l2y2=ol2y2;'];
undoit = [undoit 'grfad=currad;eval(cfig);'];
undoit = [undoit 'set(txtHndl,''string'',''UNDO Step Performed.'');'];
undoit = [undoit 'else,set(txtHndl,''string'',''Nothing to UNDO.'');end'];

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help vizrowop,disp(cont),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];
%

%Part of callback for radio buttons
wipepmat='for jj=1:m,';   %delete old lines of previous matrix
wipepmat=[wipepmat 'if jj==1,delete(prevl1);end,'];
wipepmat=[wipepmat 'if jj==2,delete(prevl2);end,'];
wipepmat=[wipepmat 'end'];

wipecmat='for jj=1:m,';   %delete old lines of current matrix
wipecmat=[wipecmat 'if jj==1,delete(currl1);end,'];
wipecmat=[wipecmat 'if jj==2,delete(currl2);end,'];
wipecmat=[wipecmat 'end'];

% show lines of previous matrix
disppmat='axes(basehndl);for jj=1:m,';
disppmat=[disppmat 'if jj==1,'];
disppmat=[disppmat 'prevl1=text(.2,vpos(jj),B(jj,:),''color'',''blue'',''fontweight'',''bold'',''fontsize'',12);end,'];
disppmat=[disppmat 'if jj==2,'];
disppmat=[disppmat 'prevl2=text(.2,vpos(jj),B(jj,:),''color'',''red'',''fontweight'',''bold'',''fontsize'',12);end,'];
disppmat=[disppmat 'end'];

% show lines of current matrix
dispcmat='axes(basehndl);for jj=1:m,';
dispcmat=[dispcmat 'if jj==1,'];
dispcmat=[dispcmat 'currl1=text(.2,vposcur(jj),B(jj,:),''color'',''blue'',''fontweight'',''bold'',''fontsize'',12);end,'];
dispcmat=[dispcmat 'if jj==2,'];
dispcmat=[dispcmat 'currl2=text(.2,vposcur(jj),B(jj,:),''color'',''red'',''fontweight'',''bold'',''fontsize'',12);end,'];
dispcmat=[dispcmat 'end'];

%Vertical position of previous matrix display lines
pstart=.4;
for jj=1:6
  vpos(jj)=pstart-.07*(jj-1);%inc .07
end

%Vertical position of current matrix display lines
cstart=.9;
for jj=1:6
  vposcur(jj)=cstart-.07*(jj-1);%inc .07
end

%THE GUI STARTS HERE
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')

%Having done a graphics command the axes for that graphics screen have been
%given a handle. We label it basehndl.
basehndl=gca;

%Screen Title
axes(basehndl);
text(.2,1.05,header,'color','magenta','fontsize',20,...
    'fontweight','bold','erasemode','none')

%op title
axes(basehndl);
text(-.15,1.05,'Operations','color','black','fontsize',16,...
    'fontweight','bold','erasemode','none')

%Matrix titles
axes(basehndl)
text(.2,.47,'Previous System','color','k','fontsize',14,...
    'fontweight','bold','erasemode','none')
text(.2,.97,'Current System','color','k','fontsize',14,...
    'fontweight','bold','erasemode','none')

%vanity
axes(basehndl);
text(.55,-.07,'by D.R.Hill','color','black','fontsize',10,...
     'fontweight','bold','fontangle','oblique','erasemode','none')

%INPUT area Signal Table
%sig has 3 entries;  i,j,k resp
inptarea='if sig(1)==1;delete(itext);delete(eitext);sig(1)=0;end,';
inptarea=[inptarea 'if sig(2)==1;delete(jtext);delete(ejtext);sig(2)=0;end,'];
inptarea=[inptarea 'if sig(3)==1;delete(ktext);delete(ektext);sig(3)=0;end'];
%

%starting with display mode decimal & showing original system
B=mat2strh(A,2);dmode='DEC';
eval(dispcmat)%first matrix displayed     <=============
grfad=currad;eval(cfig)    %first graph displayed      <=============

%Position of Operation Buttons with frame
%

kmult='set(txtHndl,''string'',s0);code=''kmult'';';
kmult=[kmult 'eval(inptarea),'];
kmult=[kmult 'set(txtHndl,''string'',''Enter values for scalar k and row i. '');'];
kmult=[kmult 'eval(idat),eval(kdat),sig(1)=1;sig(3)=1;'];

kcomb='set(txtHndl,''string'',s0);code=''kcomb'';';
kcomb=[kcomb 'eval(inptarea),'];
kcomb=[kcomb 'set(txtHndl,''string'',''Enter values for scalar k, & rows i & j.'');'];
kcomb=[kcomb 'eval(idat),eval(jdat),eval(kdat),sig=[1 1 1];'];

opbutpos=[.04 .70 .22 .21;
          .05 .85 .2 .05;
          .05 .78 .2 .05;
          .05 .71 .2 .05];
opframe=uicontrol('style','frame','units','normal','pos',opbutpos(1,:),...
                  'backgroundcolor','y');
opinter=uicontrol('style','push','units','normal','pos',opbutpos(2,:),...
                  'string','ROW(1) <==> ROW(2)','call',dointchg);
opmult=uicontrol('style','push','units','normal','pos',opbutpos(3,:),...
                  'string','k * ROW(i)','call',kmult);   
opcomb=uicontrol('style','push','units','normal','pos',opbutpos(4,:),...
                  'string','k * ROW(i) + ROW(j)','call',kcomb);


%END OF ROW OP PUSH Button REGION
%
%Position of Input names & editable text regions
%
axes(basehndl);
text(-.15,.67,'<>Input Regions<>','color','black','fontsize',16,...
    'fontweight','bold','erasemode','none')
geti='if code==''kmult'',eval(cbrmulti),else,eval(cbrcombi),end';
getj='if code==''kcomb'',eval(cbrcombj),end';
getk='if code==''kmult'',eval(cbrmultk),else,eval(cbrcombk),end ';
innampos=[.04 .50 .05 .05;.16 .50 .05 .05;.08 .57 .05 .05];

intexpos=[.10 .50 .05 .05;.22 .50 .05 .05;.14 .57 .15 .05];

idat='itext=uicontrol(''style'',''text'',''units'',''normal'',';
idat=[idat '''pos'',innampos(1,:),''string'',['' i = ''],'];
idat=[idat '''fore'',''white'',''back'',''blue'');'];
idat=[idat 'eitext=uicontrol(''style'',''edit'',''units'','];
idat=[idat '''normal'',''pos'',intexpos(1,:),''back'',''y'',''call'',''eval(geti)'');'];

jdat='jtext=uicontrol(''style'',''text'',''units'',''normal'',';
jdat=[jdat '''pos'',innampos(2,:),''string'',['' j = ''],'];
jdat=[jdat '''fore'',''white'',''back'',''blue'');'];
jdat=[jdat 'ejtext=uicontrol(''style'',''edit'',''units'','];
jdat=[jdat '''normal'',''pos'',intexpos(2,:),''back'',''y'',''call'',''eval(getj)'');'];

kdat='ktext=uicontrol(''style'',''text'',''units'',''normal'',';
kdat=[kdat '''pos'',innampos(3,:),''string'',['' k = ''],'];
kdat=[kdat '''fore'',''white'',''back'',''blue'');'];
kdat=[kdat 'ektext=uicontrol(''style'',''edit'',''units'','];
kdat=[kdat '''normal'',''pos'',intexpos(3,:),''back'',''y'',''call'',''eval(getk)'');'];

%End of editable text for row input information

%
%START PUSH BUTTONS for Utility Functions
%
utfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .24 .45 .08],'backgroundcolor','y');
undoh = uicontrol('style','push','units','normal','pos',[.05 .25 .1 .06], ...
        'string','UNDO','call',undoit);
helph = uicontrol('style','push','units','normal','pos',[.16 .25 .1 .06], ...
        'string','Help','call',helps);
rstarth = uicontrol('style','push','units','normal','pos',[.27 .25 .1 .06], ...
        'string','Restart','call','close(gcf),vizrowop');
endh = uicontrol('style','push','units','normal','pos',[.38 .25 .1 .06], ...
        'string','QUIT','call',done);
%
%Starting RADIO Buttons for display Mode + FRAME
%
butfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .33 .14 .15],'backgroundcolor','y');


rbutrat=uicontrol('style','radio','string','Rational',...
                  'backgroundcolor','white',...
                  'units','normal','position',[.05 .34 .12 .06],...                
                  'callback',['set(rbutrat,''value'',1),'...
                              'set(rbutdec,''value'',0),'...
                              'dmode=''RAT'';B = rats(A);',...
                              'if numrowop==0,',...
                              'eval(wipecmat),eval(dispcmat),',...
                              'else,eval(wipecmat),eval(dispcmat),',...
                              'eval(wipepmat),B = rats(oldA);eval(disppmat),end']);
rbutdec=uicontrol('style','radio','string','Decimal',...
                  'backgroundcolor','white',...
                  'units','normal','position',[.05 .41 .12 .06],...
                  'value',1,...
                  'callback',['set(rbutdec,''value'',1),'...
                              'set(rbutrat,''value'',0),'...
                              'B = mat2strh(A,2);dmode=''DEC'';',...
                              'if numrowop==0,',...
                              'eval(wipecmat),eval(dispcmat),',...
                              'else,eval(wipecmat),eval(dispcmat),',...
                              'eval(wipepmat),B = mat2strh(oldA,2);eval(disppmat),end']);
                              

%MESSAGE area
    %===================================
    % Set up the Comment Window
    top=0.20;
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
        'ForegroundColor','white', ...
        'String','Comment Window');

%	'ForegroundColor','black', ...
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos, ...
        'String',promptStr,'foregroundcolor','red');

%First Message
set(txtHndl,'string','ORIGINAL SYSTEM of EQUATIONS.','fontweight','bold','fontsize',12);


