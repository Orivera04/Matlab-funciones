function [View,ok]=Hide(TP, mbH, View)
% HIDE Perform shutdown operations
%
%  [View,OK]=Hide(TP, mbH)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:54 $

% Create 5/12/2000
TP.Notes= get(View.Notes,'string');
pointer(TP);
ok=1;

