function T= augmentdesign(T,NewData)
% T = AUGMENTDESIGN(T,NEWDATA)
% 
% This function augments the points in a 
% data design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:07:33 $
D= T.DesignDev(end);
X=smean(NewData(:,factorNames(D)) );
Y=NewData;
% get the number of design points

% get the model
m= model(T);

% code the data
Xdesign= code(m,double(X));

dTree= T.DesignDev(end).DesignTree;

% append design to end of design tree
ind= dTree.chosen;
des= dTree.designs{ind};
np= npoints(des);

des= augment(des,Xdesign,'points');

dTree.designs{ind}= des;

T.DesignDev(end).DesignTree= dTree;

xregpointer(T);
