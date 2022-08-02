function N = NumberOfTests(mdev)
%NUMBEROFTESTS Number of tests in fit data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:42 $

X = getdata(mdev, 'X');
N = size(X, 3);
