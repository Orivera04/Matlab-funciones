function AEQ = reduce(A)                             %last updated 5/7/94
%REDUCE  Perform row reduction on matrix A by explicitly choosing
%        row operations to use. A row operation can be "undone", but
%        this feature cannot be used in succession.
%
%        Use in the form ===>  reduce(A)  <===
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu
rsig='F'; %Setting switch for rational display off initially.
[m,n]=size(A);
oldA=A;
%
imck=sum(sum(abs(imag(A)))); %checking if any complex entries
if imck<1.e-10,imck=0;else,imck=1;end %setting switch for complex
%if imck =1 then rational display option not available
%
myeps=1e-14; %my tolerance for zero in rational display
%Set up strings to be used as messages.
s0='     ';
s1='Enter first row number.  ';
s2='Enter second row number.  ';
s3='Enter scalar multiplier.  ';
s4='Enter nonzero scalar multiplier.  ';
s5='Enter row number.  ';
s6='Enter number of row that changes.  ';
s7='Last row operation "undone". ';
s8='               ***** "REDUCE" a Matrix by Row Reduction *****';
s9='         The current matrix is:';
s10='     ENTER your choice ===> ';
s11='Press  ENTER  to continue';
s12='*****  ==>  REDUCE is over. Your final matrix is:';
s13='** Improper row number! **';
s14='Interchange Complete: ';
s15='Row Multiplication Complete: ';
s16='Replacement by Linear Combination Complete: ';
arrow=[setstr(60) setstr(45) setstr(45) setstr(62)];
menureal=...
['            OPTIONS                 ';
 ' <1>  Row(i) <==> Row(j)            ';
 ' <2>  k*Row(i)    (k not zero)      ';
 ' <3>  k*Row(i) + Row(j)  ==>  Row(j)';
 ' <4>  Turn on rational display.     ';
 ' <5>  Turn off rational display.    ';
 '<-1>  "Undo" previous row operation.';
 ' <0>  Quit reduce!                  '];

oldreal=...
['            OPTIONS                                                      ';
 ' <1>  Row(i) <==> Row(j)                           <4>  Turn on rational ';
 ' <2>  k*Row(i)    (k not zero)                          display.         ';
 ' <3>  k*Row(i) + Row(j)  ==>  Row(j)                                     ';
 '                                                   <5>  Turn off rational';
 '<-1>  "Undo" previous row operation.                    display.         ';
 ' <0>  Quit reduce!                                                       '];
menuimag=...
['            OPTIONS                          ';
 ' <1>  Row(i) <==> Row(j)                     ';
 ' <2>  k*Row(i)    (k not zero)               ';
 ' <3>  k*Row(i) + Row(j)  ==>  Row(j)         ';
 '                                             ';
 '<-1>  "Undo" previous row operation.         ';
 ' <0>  Quit reduce!                           '];
if imck==0,menu=menureal;else,menu=menuimag;end  %setting up menu
                                                     %for real & complex
                                                     %matrices
mess=s8;
i=sqrt(-1);j=i; %setting complex units
while 1
%
imck=sum(sum(abs(imag(A)))); %checking if any complex entries
if imck<1.e-10,imck=0;else,imck=1;end %setting switch for complex
%if imck =1 then rational dislay option not available
if imck==0,menu=menureal;else,menu=menuimag;end  %setting up menu
                                                     %for real & complex
                                                     %matrices
%
  clc,home,format compact
  disp(mess)
  disp(s9)
  a=A; %to prevent case mismatch in multiplier choice
  if imck==0 & rsig=='T'
     format rational
     A
     format,format compact
  else
     A
  end
  disp(menu)
  ch=input(s10);
  if ch==-1
    A=oldA;
    mess=s7;
  end
  if ch==0
    clc
    disp(s12)
    %disp(s0)
    if imck==0 & rsig=='T'
       format rational
       A
       format
    else
       A
    end
    AEQ=A;format loose
    break
  end
  if ch==4 & imck==0, rsig='T';end
  if ch==5 & imck==0, rsig='F';end
  if ch==1
    sig='Y';
    jj=input(s1);
    k=input(s2);
    aj=abs(fix(jj));ak=abs(fix(k));
    if jj~=aj | jj>m | k~=ak | k>m | jj==0 | k==0
      disp(s13)
      disp(s11)
      pause
      sig='N';
      mess=s0;
    end
    if sig=='Y'
      oldA=A;
      temp=A(jj,:);
      A(jj,:)=A(k,:);
      A(k,:)=temp;
      mess= [s14 ' Row ' int2str(jj) ' ' arrow ' Row ' int2str(k) '.'];
    end
  end
  if ch==2
    sig='Y';
    k=input(s3);
    while (k==0)
      k=input(s4);
    end
    jj=input(s5);
    aj=abs(fix(jj));
    if jj~=aj | jj>m | jj==0
      disp(s13)    
      disp(s11)
      pause
      sig='N';
      mess=s0;
    end
    if sig=='Y'
      oldA=A;
      A(jj,:)=k*A(jj,:);
      %determine if multiplier is complex
      if abs(imag(k))< 1.e-10
         mess=[s15 num2str(k) ' * Row ' int2str(jj) '.']; %k is real
      else
         kr=real(k);ki=imag(k); %k is truly complex
         if ki<0, sg=' - ', else, sg=' + ';end
      mess=[s15 num2str(kr) sg num2str(abs(ki)) 'i' ' * Row ' int2str(jj) '.'];
      end
    end
  end
  if ch==3
    sig='Y';
    t=input(s3);
    k=input(s1);
    jj=input(s6);
    aj=abs(fix(jj));ak=abs(fix(k));
    if jj~=aj | jj>m | k~=ak | k>m | k==0 | jj==0
      disp(s13)
      disp(s11)
      pause
      sig='N';
      mess=s0;
    end
    if sig=='Y'
      oldA=A;
      A(jj,:)=t*A(k,:)+A(jj,:);
      for ii=1:n,if abs(A(jj,ii))<=myeps,A(jj,ii)=0;end,end
      %determine if multiplier t is complex
      if abs(imag(t))< 1.e-10
         mess=[s16 num2str(t) ' * Row ' int2str(k) ' + Row '];
         mess=[mess int2str(jj) '.']; %multiplier t is real
      else
         tr=real(t);ti=imag(t); %t is truly complex
         if ti<0, sg=' - ', else, sg=' + ';end
         mess=[s16 num2str(tr) sg num2str(abs(ti)) 'i'];
         mess=[mess  ' * Row ' int2str(k) ' + Row '];
         mess=[mess int2str(jj) '.'];
      end
    end
  end
end
