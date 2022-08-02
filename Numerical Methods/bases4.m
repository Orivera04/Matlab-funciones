function [bnull,brange,brow,bnullat]=bases4(A)
%BASES4	Gives bases for four fundamental subspaces of A.
%	The command is [bnull,brange,brow,bnullat]=BASES4(A).
%	The columns of the output are the bases for the 
%       null space, range, row space, and null space of  
%       the transpose. The routine calls gauss.

%	Copyright 1993 Terry Lawson
%	Terry Lawson, Math Department, Tulane University, 11/93
	
[U,O1,R,O,bcol,fcol]=gauss(A);
[m,n]=size(A);
[r0,r]=size(bcol);
R=R(1:r,:);
if r== n
bnull=[];
else
bnull= zeros(n,n-r);
  for i = 1:n-r
    for j = 1:r
    bnull(bcol(j),i)=-R(j,fcol(i));
    end
    bnull(fcol(i),i)=1;
  end
end
brange = A(:,bcol);
brow = U(1:r,:)'; 
if r == m
bnullat = [];
else
bnullat = O(r+1:m,:)';
end
