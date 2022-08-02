function [c] = unstruct_corr2cov(c,s)
% COVMODEL/UNSTRUCT_CORR2COV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:30 $

w= unstruct(c);
% size of matrix
nc= size(w,1); 

% turn into upper triangular
U= logical( triu( ones(nc) ) );
wc= zeros(nc);
wc(U)= c.cparam;
wc= wc/s;

c.cparam= wc(U);

