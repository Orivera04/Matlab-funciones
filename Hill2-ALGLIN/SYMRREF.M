function [A,R]=symrref(A,ncol)                      %last updated 10/05/02
%SYMRREF  Symbolic reduced row echelon form.
%         The input matrix A must be symbolic or an error message is 
%         displayed. To define a symbolic matrix use the form
%               A = sym('[a,b,c;d,e,f]')
%         where a,b,c,d,e,f are your entries. Use as may rows and 
%         columns as needed. (Note: entries must be separated by a comma.)
%
%         To have obtain the reduced row echelon form use
%         ===>  symrref(A)  or  B = symrref(A) 
%                                or  [B,R] = symrref(A)   <===
%
%         To have the reduction produce leading ones in only the first
%         ncol columns use in the form
%         ===>  symrref(A,ncol)  or  B = symrref(A,ncol)  
%                                or  [B,R] = symrref(A,ncol)   <===
%
%         If a row operation of the form (1/k)*Row(i) is
%         performed where k is symbolic a restriction that k is assumed
%         not zero is recorded. The restrictions are displayed in matrix
%         R when the routine is used in the form  [B,R]=symrref(A,ncol) or
%         [B,R]=symrref(A).
%         
%  This routine requires the Symbolic Math Toolbox.
%  This routine requires utility: symelemh   by D. Hill.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

warning off
[m,n]=size(A);
%IF NOT symbolic stop. 
if isa(A,'sym')~=1
   disp('INPUT must be a symbolic matrix.')
   return
end

if nargin==2  %checking for number of columns to reduce
   if ncol>n,ncol=n;end
   numcol=ncol;
else
   numcol=n;
end

i=1;j=1;k=0;rcnt=4;
R1=sym('[ ; ]');
R=R1;
for jj=2:(fix((m+3)/2) + 1)
   R=[R;R1];
end
R(1,1)=sym(['RESTRICTIONS:']);
R(2,1)=sym(['The_following']);
R(3,1)=sym(['are_assumed_not_zero']);
while (i<=m) & (j<=numcol)
   k=i;
   %i,j,k
   val=str2num(char(A(i,j))); %empty if not a number
   if isempty(val)==1 %says not numeric so it is not exactly zero
      valisnumber='N';
   else
      valisnumber='Y';
   end
   if valisnumber=='Y'
      if val==0 %(i,j)entry is zero; check below for nonzero
          im=i;
          while k==i & im<=m
             p=str2num(char(A(im,j)));
             if isempty(p)==1
                k=im;im=m+1;
             else   
                if p~=0   %symbolic or nonzero numeric entry in (im,j)-entry
                   k=im;im=m+1;
                else
                   im=im+1;
                end 
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
         E=symelemh(m,2,i,i,['1/(' char(A(i,j)) ')']);  
         %if the pivot is not numeric store denominator in R    
         if isempty(str2num(char(A(i,j))))==1
            R(rcnt,1)=A(i,j);
            rcnt=rcnt+1;
         end
         A=symmul(E,A); %doing 1/k * row(i)
         %Perform row ops above and below the pivot in column j
         for kk=[1:i-1 i+1:m]
            E=symelemh(m,3,i,kk,['-(' char(A(kk,j)) ')']);
            A=E*A; %doing (-A(kk,j)*row(i) + row(kk)
         end
         %i,j,A
         i=i+1;j=j+1;
      end
   else
      %i,j,k,A
         %Multiply row i by one over the pivot
         E=symelemh(m,2,i,i,['1/(' char(A(i,j)) ')']);  
         %if the pivot is not numeric store denominator in R    
         if isempty(str2num(char(A(i,j))))==1
            R(rcnt,1)=A(i,j);
            rcnt=rcnt+1;
         end
         A=symmul(E,A); %doing 1/k * row(i)
         %Perform row ops above and below the pivot in column j
         for kk=[1:i-1 i+1:m]
            E=symelemh(m,3,i,kk,['-(' char(A(kk,j)) ')']);
            A=E*A; %doing (-A(kk,j)*row(i) + row(kk)
         end
         %i,j,A
         i=i+1;j=j+1;
   end
   
end %while doing matrix

%simlify the expressions in output A and R.
for i=1:m,for j=1:n,A(i,j)=simplify(A(i,j));end,end
%NOTE: rcnt-1 is the number of rows of matrix R containing information
%blank rows cause simplify command difficulty
for jj=4:rcnt-1,s=R(jj);R(jj)=simplify(s);end
warning on
