function AEQ = reduce(A)                             %last updated 5/23/02
%REDUCE  Perform row reduction on matrix A by explicitly choosing
%        row operations to use. A row operation can be "undone", but
%        this feature cannot be used in succession. This routine is
%        for small matrices, real or complex.
%
%        Use in the form ===>  reduce   <===  to select a demo or 
%                                             enter your own matrix A
%        or in the form  ===>  reduce(A)  <===
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

%STRINGS
%
myeps=1e-14; %my tolerance for zero in rational display
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
s17=['You need to select an input matrix from the available demos';
     'or enter one of your own. Matrices with real or complex    ';
     'entries can be used. For a linear system Ax = b, be sure to';
     'enter the augmented matrix.                                '];
s18=['            <<OPTIONS>>                      ';
     '                                             ';
     ' <1> Select a matrix from the built-in demos.';
     '                                             ';
     ' <2> Enter your own matrix.                  ';
     '                                             ';
     ' <0> Quit.                                   '];

arrow=[setstr(60) setstr(45) setstr(45) setstr(62)];
menureal=...
['                                    ';
 '          <<OPTIONS>>               ';
 '                                    ';
 ' <1>  Row(i) <==> Row(j)            ';
 ' <2>  k*Row(i)    (k not zero)      ';
 ' <3>  k*Row(i) + Row(j)  ==>  Row(j)';
 '                                    ';
 ' <4>  Turn on rational display.     ';
 ' <5>  Turn off rational display.    ';
 '<-1>  "Undo" previous row operation.';
 ' <0>  Quit reduce!                  ';
 '                                    '];

oldreal=...
['          <<OPTIONS>>                                                    ';
 ' <1>  Row(i) <==> Row(j)                           <4>  Turn on rational ';
 ' <2>  k*Row(i)    (k not zero)                          display.         ';
 ' <3>  k*Row(i) + Row(j)  ==>  Row(j)                                     ';
 '                                                   <5>  Turn off rational';
 '<-1>  "Undo" previous row operation.                    display.         ';
 ' <0>  Quit reduce!                                                       '];
menuimag=...
['                                             ';
 '          <<OPTIONS>>                        ';
 '                                             ';
 ' <1>  Row(i) <==> Row(j)                     ';
 ' <2>  k*Row(i)    (k not zero)               ';
 ' <3>  k*Row(i) + Row(j)  ==>  Row(j)         ';
 '                                             ';
 '<-1>  "Undo" previous row operation.         ';
 ' <0>  Quit reduce!                           ';
 '                                             '];
demomenu=['<1> Linear system   2x1 + 3x2 = 11             ';
          '                     x1 + 4x2 = 18             ';
          '                                               ';
          '                     3x1 + 4x2 + 5x3 = -8      ';
          '<2> Linear system   -2x1 +  x2       =  3      ';
          '                    -1x1 + 3x2 +  x3 =  5      ';
          '                                               ';
          '                      x1 + 2x2 +  x3 = 5       ';
          '<3> Linear system     x1 +     +  x3 = 5       ';
          '                           2x2       = 0       ';
          '                                               ';
          '                    -2x1 +  x2 + 3x3 =  5      ';
          '<4> Linear system    4x1       + 2x3 = 10      ';
          '                     2x1 +  x2 + 5x3 = 12      ';
          '                                               ';
          '<5> Linear system   (1+i)x1 + (3-2i)x2 = 6+5i  ';
          '                        -x1 +  (2-i)x2 = 4+2i  '];
%END of strings

%BEGIN process code

if nargin==0  %no input matrix
   gdcode='N';
   while gdcode=='N'
      clc,disp(s8),disp(s0),disp(s17),disp(s0)
      disp(s18),disp(s0),ch=input(s10);
      if ch==0,clc,disp('REDUCE is over!'),return,end
      if ch==1,clc,disp(s8),disp(s0),disp(demomenu),disp(s0)
         democh=input(s10);
         if democh==1,A=[2 3 11;1 4 18];gdcode='Y';end
         if democh==2,A=[3 4 5 -8;-2 1 0 3;-1 3 1 5];gdcode='Y';end
         if democh==3,A=[1 2 1 5;1 0 1 5;0 2 0 0];gdcode='Y';end
         if democh==4,A=[-2 1 3 5;4 0 2 10;2 1 5 12];gdcode='Y';end
         if democh==5,A=[1+i 3-2i 6+5i;-1 2-i 4+2i];gdcode='Y';end
      end
      if ch==2,gdcode='Y';clc,disp(s8),disp(s0)
         disp('Enter your matrix in the form [1 2 3;4 5 6] etc.')
         disp(s0),A=input('   Your matrix A =   ');
     end
      if gdcode=='N',disp('Improper choice; TRY again.'),disp(s11),pause,end
   end
end


rsig='F'; %Setting switch for rational display off initially.
[m,n]=size(A);
oldA=A;
if m>5,menureal=oldreal;end %for more that 5 rows use horiz. menu
%
imck=sum(sum(abs(imag(A)))); %checking if any complex entries
if imck<1.e-10,imck=0;else,imck=1;end %setting switch for complex
%
if imck==0,menu=menureal;else,menu=menuimag;end  %setting up menu
                                                     %for real & complex
                                                     %matrices
mess=s8;
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
