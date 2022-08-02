function ret=cancopy(nd)
% CANCOPY  Indicate whether node can copy data
%
%  OUT=CANCOPY(NODE)  returns 1/0 to indicate whether the node
%  is currently in a state to return copied data.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:21:38 $

ret=~isempty(info(getdata(nd)));