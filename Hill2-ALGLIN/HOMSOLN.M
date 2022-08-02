function NS = homsoln(A,code)               %<<last updated 8/15/91>>
%HOMSOLN  Find the general solution of a homogeneous system of
%         equations.The routine returns a set of basis vectors for
%         the null space of Ax = 0. Use in the form
%
%                      -->  ns = homsoln(A)  <--
%
%         If there is a second argument the general solution is
%         displayed. Use in the form
%
%                      -->  homsoln(A,1)  <--
%
%         This option assumes that the general solution has at
%         most 10 arbitrary constants.
%
% By: David R. Hill, Math., Dept.,
%     Temple University, Philadelphia, Pa. 19122
s0=' ';
s1=['The columns of the following matrix are a basis';
    'for the solution space of homogeneous system   ';
    'Ax = 0.                                        ';];
s2='The general solution is:';
s3='The only solution is the zero vector.';
var='rstuvwabcd'; %variable names for general solution
[m,n]=size(A);
A=rref(A);
l1=[];
for ki=1:m
   z=find(A(ki,:)>0);
   if isempty(z)==0,
      l1=[l1 z(1)];
   end
end %now l1 contains the column #s with leading 1's
la=1:n;  %all numbers from 1 to n
la(l1)=zeros(1,length(l1));
lv=find(la>0); %lv contains the numbers of the arbitrary variables 
if isempty(lv)==1
   NS=zeros(n,1);
else
   %build the columns that span the null space
   I=eye(n); 
   NS=[];
   r=rank(A);
   for ki=1:length(lv)
      c=I(:,lv(ki));
      for kj = 1:r
         c(l1(kj)) = -A(kj,lv(ki));
      end
      NS = [NS c];
   end
end
if nargin > 1   %display general solution
   clc
   s=[];
   for ki = 1:length(lv)
     s=[s var(ki) ' * col(' num2str(ki) ') '];
     if ki~=length(lv)
        s=[s '+ '];
     end
   end
   if isempty(s)==1
      disp(s3),disp(s0)
   else
      disp(s1),disp(s0),disp(NS)
      disp(s0),disp(s2),disp(s0),disp(s)
   end
end
