function v = mbcmonotonic(v)
%MBCMONOTONIC Converts a non-decreasing vector to an increasing one
%
% v = mbcmonotonic(v)
%
% The input is a non-decreasing vector (either a row or column vector).
% The output is a monotonically increasing vector of the same size as the
% input.
% This is achieved by very slightly increasing any element which is the
% same as the one before it.  This is repeated until every element is
% greater than the one before it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

while 1
    d = diff(v);
    i = find(d==0); % find the index of the first of any two matching elements
    if isempty(i)
        return; % finished.  no repeated values
    end
    i = i+1; % we add to the *latter* element where two are the same
    v(i) = v(i) + eps(v(i));
end

