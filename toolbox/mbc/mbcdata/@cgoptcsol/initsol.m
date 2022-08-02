function cgc = initsol(cgc, solno, N)
%INITSOL Initialise a custom solution
%
%  CGC = INITSOL(CGC, SOLNO, N) where SOLNO is the solution number to
%  initialise to and N is the number of points to initialise with.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:52:28 $ 

cgc.solutionNo = repmat(solno,N,1);