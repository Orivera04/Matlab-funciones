function [L,U] = lupr(A)                       %last updated 1/19/96
%LUPR    Perform LU-factorization on matrix A by explicitly choosing
%        row operations to use. No row interchanges are permitted,
%        hence it is possible that the factorization can not be found.
%        It is recommended that the multilpiers be constructed in terms
%        of the elements of matrix U, like -U(3,2)/U(2,2), since the
%        displays of matrices L and U do not show all the decimal
%        places available. A row operation can be "undone", but this
%        feature can not be used in succession.
%
%        This routine uses the utilities mat2strh and blkmat.
%
%        Use in the form ==> [L,U] = lupr(A)  <==
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu
format compact
[m,n]=size(A);
oldA=A;
L=eye(size(A));oldL=L;
myeps=1e-14; %my tolerance for zero in rational display
%Set up strings to be used as messages.
utitle='U = ';
ltitle='L = ';
s0='     ';
s1='Enter first row number.  ';
s2='Enter L-value.  ';
s3='Enter multiplier.  ';
s4='Enter column number of L to change.  ';
s5='Enter row number of L to change.  ';
s6='Enter number of row that changes.  ';
s7='Last row operation "undone". ';
s8='          ***** Find an LU-FACTORIZATION by Row Reduction *****';
s9=s0;
s10='     ENTER your choice ---> ';
s11='Press  ENTER  to continue';
s12='*****  -->  LUPR is over. Your final matrix is:';
s13='** Improper row number! **';
s16='Replacement by Linear Combination Complete.';
s20='You just performed operation ';
%menu=['            OPTIONS                           ';
%      ' <1>  Replace a row by linear combination of  ';
%      '               itself with another row.       ';
%      '<-1>  "Undo" previous row operation.          ';
%      ' <0>  Quit lupr!                              '];
menu=...
['                                  OPTIONS                             ';
 '<1> Do row op k*Row(i)+Row(j). <-1> Undo previous operation. <0> Quit.'];
%menu1= ['            OPTIONS                           ';
%      ' <1>  Construct an element of matrix L.       ';
%      '<-1>  "Undo" previous row operation.          ';
%      ' <0>  Quit lupr!                              '];
menu1=...
['                                OPTIONS                               ';
 '<1>  Insert element into L.  <-1> Undo previous operation.  <0>  Quit.'];
mess=s8;
i=sqrt(-1);
while 1
  clc,disp(mess),disp(s9)
  a=A;u=A;U=A;l=L;%to prevent case mismatch in multiplier choice
    stu=mat2strh(U,2);[mu,nu]=size(stu);
    stl=mat2strh(L,2);[ml,nl]=size(stl);
    st1=[ltitle;blkmat(m,4)];
    st2=[blkmat(1,nl);stl];
    disp([st1 st2])
    %st3=blkmat(m+1,2);
    st4=[utitle;blkmat(m,4)];
    st5=[blkmat(1,nu);stu];
    disp([st4 st5])
%   disp([st1 st2 st3 st4 st5])
  disp(s0),disp(menu)
  ch=input(s10);
  if ch==-1
    A=oldA;L=oldL;
    mess=s7;
  end
  if ch==0
    clc,disp(s12),disp(s0),format
    break
  end
  if ch==1
    sig='Y';
    t=input(s3);
    k=input(s1);
    j=input(s6);
    aj=abs(fix(j));ak=abs(fix(k));
    if j~=aj | j>m | k~=ak | k>m | k==0 | j==0
      disp(s13)
      disp(s11)
      pause
      sig='N';
      mess=s0;
    end
    if sig=='Y'
      oldA=A;oldL=L;
      A(j,:)=t*A(k,:)+A(j,:);
      for ii=1:n,if abs(A(j,ii))<=myeps,A(j,ii)=0;end,end
      mess=s16;
    end
  msig='F'; %setting things up to get entry of L
  while msig=='F'
  clc
  disp(mess)
  disp(s9)
  a=A;l=L;u=A;U=A; %to prevent case mismatch in multiplier choice
    stu=mat2strh(U,2);[mu,nu]=size(stu);
    stl=mat2strh(L,2);[ml,nl]=size(stl);
    st1=[ltitle;blkmat(m,4)];
    st2=[blkmat(1,nl);stl];
    disp([st1 st2])
    %st3=blkmat(m+1,2);
    st4=[utitle;blkmat(m,4)];
    st5=[blkmat(1,nu);stu];
    disp([st4 st5])
    %disp([st1 st2 st3 st4 st5])
    %here we fill in the appropriate multiplier in matrix L
  disp(s0)
  disp([s20 num2str(t) '*Row(' num2str(k) ') + Row(' num2str(j) ')'])
  disp(s0)
%new stuff......
  newch='F';
  while newch=='F'
  disp(menu1)
  ch1=input(s10);
  if ch1==-1
    A=oldA;L=oldL;
    mess=s7;newch='T';msig='Y';
  end
  if ch1==0
    clc,disp(s12),disp(s0),format
    return
  end
  if ch1==1
     clc,disp(mess),disp(s0)
     %disp([st1 st2 st3 st4 st5])
     disp([st1 st2]),disp([st4 st5])
     disp(s0)
     disp([s20 num2str(t) '*Row(' num2str(k) ') + Row(' num2str(j) ')'])
     disp(s0)
     num=t;
     disp('Insert a value in L in the position you just eliminated in U.')
     disp('Let the multiplier you just used be called num.')
     disp(['It has the value ' num2str(t) '.'])
     %st=['Using the symbol num assign an appropriate'];
     %st=[st ' element to lower triangular matrix L.'];
     %disp(st)
  rnum=input(s5);
  cnum=input(s4);
  val=input(['Value of L(', int2str(rnum), ',' int2str(cnum) ') = ']);
  if rnum==j & cnum==k & val==(-num)
     disp(['Correct:  L(' num2str(rnum) ',' num2str(cnum) ') = ' num2str(val)])
     msig='T';newch='T';L(j,k)=val;pause(3)
  else
     disp('Incorrect: Try again.'),disp(s11),pause
     clc,disp(mess),disp(s0)
     %disp([st1 st2 st3 st4 st5])
     disp([st1 st2]),disp([st4 st5])
     disp(s0)
     disp([s20 num2str(t) '*Row(' num2str(k) ') + Row(' num2str(j) ')'])
     disp(s0)
  end
  end
  end %while newch
  end %while msig
  end %ch==1
end

