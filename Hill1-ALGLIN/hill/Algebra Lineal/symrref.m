function [A,R]=symrref(A)                      %last updated 2/18/95
%SYMRREF  Symbolic reduced row echelon form.
%         The input matrix A must be symbolic or an error message is 
%         displayed. If a row operation of the form (1/k)*Row(i) is
%         performed where k is symbolic a restriction that k is assumed
%         not zero is recorded. The restrictions are displayed in matrix
%         R when the routine is used in the form  [B,R]=symrref(A).
%
%         Other forms are ===>  symrref(A)  or  B=symrref(A)  <===
%
%  This routine requires the Symbolic Math Toolbox.
%  This routine requires utility: symelemh   by D. Hill.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

[m,n]=symsize(A);
%IF NOT symbolic stop
if isstr(A)~=1
   disp('INPUT must be symbolic matrix.')
   return
end
i=1;j=1;k=0;rcnt=4;
R1=sym('[ ; ]');R=R1;for jj=2:(fix((m+3)/2) + 1);R=[R;R1];end
R=sym(R,1,1,'RESTRICTIONS:');
R=sym(R,2,1,'The following');
R=sym(R,3,1,'are assumed not zero.');
while (i<=m) & (j<=n)
   k=i;
   %i,j,k
   val=str2num(sym(A,i,j));
   if val==0 %(i,j)entry is zero; check below for nonzero
      im=i;
      while k==i & im<=m
          p=str2num(sym(A,im,j));
          if p~=0   %symbolic or nonzero numeric entry in (im,j)-entry
             k=im;im=m+1
          else
             im=im+1;
          end    
      end
      if k==i
         j=j+1; %zero entries from ith thru mth entries in col j
      else      %move to next column
         A([i k],:)=A([k i],:);%interchange row i and row k
      end
   else
      %i,j,k,A
      %Multiply row i by one over the pivot
      E=symelemh(m,2,i,i,['1/(' sym(A,i,j) ')']);  
      %if the pivot is not numeric store denominator in R    
      if isempty(str2num(sym(A,i,j)))==1,R=sym(R,rcnt,1,sym(A,i,j));rcnt=rcnt+1;end
      A=symmul(E,A); %doing 1/k * row(i)
      %Perform row ops above and below the pivot in column j
      for kk=[1:i-1 i+1:m]
         E=symelemh(m,3,i,kk,['-(' sym(A,kk,j) ')']);
         A=symmul(E,A); %doing (-A(kk,j)*row(i) + row(kk)
      end
      %i,j,A
      i=i+1;j=j+1;
   end
end %while doing matrix