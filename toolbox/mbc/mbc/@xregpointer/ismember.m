function [tf, loc] = ismember(P1, P2)
%ISMEMBER True for set member.
%
%  ISMEMBER(A,S) for the array A returns an array of the same size as A
%  containing 1 where the elements of A are in the set S and 0 otherwise.
%
%  [TF,LOC] = ISMEMBER(...) also returns an index array LOC containing the
%  highest absolute index in S for each element in A which is a member of S
%  and 0 if there is no such index.
    
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 06:47:17 $ 

P1 = double(P1);
P2 = double(P2);
if nargout==1
    tf = false(size(P1));
    for k = 1:numel(P1)
        tf(k) = any(P2(:)==P1(k));
    end
else
    [tf, loc] = ismember(P1, P2);
end