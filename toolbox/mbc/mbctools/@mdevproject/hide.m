function [View,ok]=Hide(MP, mbH, View)
% HIDE Perform shutdown operations
%
%  [View,OK]=Hide(P, mbH)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:03:31 $



% Create 10/4/2001
ok=1;

p = getpref(mbcprefs('mbc'), 'mdevproject');
p.SnapSplitLayoutState = get(View.layout, 'state');
setpref(mbcprefs('mbc'), 'mdevproject', p);

return