function pf3(fname)
% pf3.m   01-25-96
% print figure to an eps file
%
%  Spatial Error Analysis ToolBoxc Version 1.0,  October 5, 1997
%  Copyright 1997-1998 by David Y. Hsu  All rights reserved.
%  dhsu@littongcs.com
%
fname=['c:\bookeps\' fname '.eps'];
s1=['printsto -deps ' fname];
eval(s1)
