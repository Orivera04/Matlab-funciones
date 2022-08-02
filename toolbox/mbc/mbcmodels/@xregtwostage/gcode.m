function [X,m,Code]= gcode(TS,X);
%GCODE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:39 $

nl= nlfactors(TS);
nf=nfactors(TS);
X= code(TS,X,nl+1:nf);

