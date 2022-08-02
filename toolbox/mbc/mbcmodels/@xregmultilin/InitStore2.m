function [m,OK]= InitStore2(m,varargin);
% xreglinear/INITSTORE2 initialises model useing display order deined in TERMORDER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:08 $

[m2,OK]= InitStore2(get(m,'currentmodel'),varargin{:});
set(m,'currentmodel',m2);