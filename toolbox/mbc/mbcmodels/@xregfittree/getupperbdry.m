function upperbdry = getupperbdry( Tree, panel )
%XREGFITTREE/GETUPPERBDRY Get the upper boundary incidence vector
%  GETUPPERBDRY(T,PANEL) returns the upper boundary incidence vector for the 
%  given PANEL.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

upperbdry = Tree.UpperBdry(panel,:);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

