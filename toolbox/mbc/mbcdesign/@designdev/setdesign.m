function D = setDesign(D,des)
%SETDESIGN Set new best design
%
%  D = SETDESIGN(D, DES) sets DES as the new best design

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:04:09 $

% Ensure design has correct lock status
des = setlock(des, getlock(D.DesignTree.designs{D.DesignTree.chosen}));
D.DesignTree.designs{D.DesignTree.chosen} = des;
