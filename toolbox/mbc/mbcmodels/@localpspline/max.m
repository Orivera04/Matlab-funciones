function [m,tp]=max(ps)
% localpspline/MAX maximum of quadspline
%
%  [m,tp]=max(ps)
%  m is empty if ps doesn't have a maximum

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:41:24 $



tp= ps.knot;
m=eval(ps,tp);
% Check 2nd derivatives
qsL= eval(ps,tp-1);
qsH= eval(ps,tp+1);
if qsL>=m | qsH>=m
   m=[];
   tp=[];
end

