function [con, ok] = fitglobal( con, X, rfd )
%FITGLOBAL Fits the global models to given response feature data
%
%  [C, OK] = FITGLOBAL(C,X,RFD) fits the global models in the two-stage
%  constraint object C to the given response feature data, RFD, at the
%  given global points, X.   

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/04/04 03:26:30 $ 

for i = 1:size( rfd, 2 );
    [gm, ok] = fitmodel( con.Global{i}, X, rfd(:,i) );
    if ok>0
        con.Global{i} = gm;
    end
end
