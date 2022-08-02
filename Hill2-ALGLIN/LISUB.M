function S = lisub(A,code)               %last updated 10/3/93
%LISUB  Find a linearly independent subset of vectors.
%       If code = 'r' the vectors are the rows of A.
%       If code = 'c' the vectors are the columns of A.
%       Any other value in code causes an error.
%       The routine returns a subset of linearly independent vectors
%       from the original set.
%
%       Use in the form  -->  S = lisub(A,'r')  or  lisub(A,'c')  <--
%
% By: David R. Hill, Math., Dept.,
%     Temple University, Philadelphia, Pa. 19122
err='ERROR: Improper code; second argument must be ''r'' or ''c''';
if code=='r'
   B=A';
elseif code == 'c'
   B=A;
else
   disp(err)
   return
end
[m,n]=size(B);
B=rref(B);
l1=[];
for ki=1:m
   z=find(B(ki,:)>0);
   if isempty(z)==0,
      l1=[l1 z(1)];
   end
end %now l1 contains the column #s with leading 1's
if length(l1)~=0
   if code=='r'
      S=A(l1,:); %rows of S are a L.I. subset
   else
      S=A(:,l1); %columns of S are a L.I. subset
   end
else
   S=[];  %empty matrix returned only if A is the zero matrix
end
