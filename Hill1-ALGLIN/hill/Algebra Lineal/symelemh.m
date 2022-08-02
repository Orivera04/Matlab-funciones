function E=symelemh(size,type,i,j,k)           % last updated 1/17/95
%SYMELEMH  Symbolic elementary matrix constructor.
%          Form a size by size elementary matrix of type 1,2 or 3.
%               type = 1   interchange rows i and j
%               type = 2   take k times row i  (k is a string)
%               type = 3   form k*row(i) + row(j) ==> row(j)
%                          (k is a string)
%
%          Use in the form ==>  E = symelemh(size,type,i,j,k)  <==
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

E=sym(eye(size));
%check that k is a string
if  nargin==5
   if isstr(k)~=1
      disp('Error in symelemh: last argument must be a string.')
      E=[];
      return
   end
end

%check range of type
if fix(abs(type))==0 | fix(abs(type))~=type | fix(abs(type))>3
   disp('Error in symelemh: type of operation is incorrectly specified.')
   disp('Type must be 1,2, or 3.')
   E=[];
   return
end
% ASSUME i and j are range checked prior to calling this routine
%

if type==1,temp=E(i,:);E(i,:)=E(j,:);E(j,:)=temp;end
if type==2,E=sym(E,i,i,k);end
if type==3,E=sym(E,j,i,k);end
