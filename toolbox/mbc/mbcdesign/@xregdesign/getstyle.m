function [s,info] = getstyle(des)
%GETSTYLE Return style code for design
%
%  [S,INFO] = GETSTYLE(DES) returns the style code, S, and its associated
%  information.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:06:40 $

% If all points are marked as data points, the style is modified to be an
% experimental data design
isDP = getdatapoint(des);
if isempty(isDP) || ~all(isDP)
    s = des.style.base;
    if nargout>1
        info = des.style.baseinfo;
    end
else
    s = 4;
    info = 'Experimental data';
end