function [w]= unstruct(c,varargin);
% COVMODEL/UNSTRUCT unstructured covariance model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:46:29 $



nw= length(c.cparam);

% size of matrix
nc= ( -1 + sqrt(1+8*nw) )/2; 
% turn into upper triangular
U= triu( ones(nc) ) ;
U(U~=0)= c.cparam;

w= U'*U;


