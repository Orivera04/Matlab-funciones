function B = invert(A)                      %last updated 7/8/94
%INVERT   Compute the inverse of a matrix A by using the reduced
%         row echelon form applied to [A I]. If A is singular a
%         warning is given.
%
%         Use in the form   -->  B = invert(A)  <--
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%Note: Previously in the first edition of the Lab Manual this
%      routine was called inverse. However in MATLAB 4 in the symbolic
%      toolbox is a routine called inverse.
[m n]=size(A);
if m~=n,disp('>>>>>> Error: matrix is not square.')
        return
end

C=rref([A eye(size(A))]);
D=C(:,1:m);BB=C(:,m+1:2*m);
if(det(D)==0)
   disp('>>>>>> Error: Matrix is singular.')
else
   B=BB;
end

