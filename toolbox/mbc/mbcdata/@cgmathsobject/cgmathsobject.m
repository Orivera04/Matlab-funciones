function cmo = cgmathsobject
%CGMATHSOBJECT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:59 $

% constructor for cgmathsobject class, an abstract class which serves as a way
% to access maths files 

cmo = struct('maths',[]);

cmo = class(cmo,'cgmathsobject');

return