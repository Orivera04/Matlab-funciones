function s= BestModelString(mdev);
% MDEVMLERF/BESTMODELSTRING message about best mle rf model
%
% s= BestModelString(mdev);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:05:25 $



if status(mdev)==1
	s= 'MLE Response Feature requires updating';
else
	s= [name(mdev) ' is a MLE Response Feature for ',peval('name',Parent(mdev))];
end
