function lowerbdry = getlowerbdry( Tree, panel )
%XREGFITTREE/GETLOWERBDRY Get the lower boundary incidence vector
%  GETLOWERBDRY(T,PANEL) returns the lower boundary incidence vector for the 
%  given PANEL.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 


lowerbdry = Tree.LowerBdry(panel,:);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

