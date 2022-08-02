function [matrix]=makepins(a,L,supports)
%MAKEPINS subroutine for redundancy routine.
%   MAKEPINS(A,L,SUPPORTS) creates a submatrix for the redundancy routine.
%   Not useful as a stand-alone routine.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

a=a-supports(1);
b=L-a;
x=a;

for ROW=1:length(a)
  for COL=1:length(a)
    if ROW<= COL
      matrix(ROW,COL)=b(COL)*x(ROW)*(L^2-b(COL)^2-x(ROW)^2);
    else
     matrix(ROW,COL)=x(COL)*b(ROW)*(L^2-x(COL)^2-b(ROW)^2);
    end
  end
end
