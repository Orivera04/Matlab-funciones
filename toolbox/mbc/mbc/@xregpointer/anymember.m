function tf = anymember(P1, P2)
%ANYMEMBER True for set member.
%
%  ANYMEMBER(A,S) for the array A returns true if any of the elements of A
%  are present in S.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:46:56 $ 

P1 = double(P1);
P2 = double(P2);
tf = false;
k=1;
while ~tf && k<=length(P1)
    tf = tf || any(P2(:)==P1(k));
    k=k+1;
end   