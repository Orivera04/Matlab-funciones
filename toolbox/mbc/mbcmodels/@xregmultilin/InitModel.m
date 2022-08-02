function [m,OK]= InitModel(m,varargin);
% xreglinear/INITSTORE initialises model for use by stats and leastsq 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:06 $

[m2,OK]= InitModel(get(m,'currentmodel'),varargin{:});
set(m,'currentmodel',m2);