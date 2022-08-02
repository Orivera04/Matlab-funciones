function pm= modeldev(m,p_mdev,OpenDialog);
% XREGMODEL/MODELDEV creates new MODELDEV object with same type of model
% 
% pm= modeldev(m,p_mdev);
%   Used for creating children of one-stage and global (RF models)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.4 $  $Date: 2004/02/09 07:52:33 $



% get Xglobal,Y
Xglobal= p_mdev.dataptr('X');
Y= p_mdev.dataptr('Y');

% make model development object for Global Model
mdev= modeldev(name(m),{m,Xglobal,Y,'global'});

% copy outliers down level
pm= outliers(mdev,p_mdev.outliers);

% add new child
p_mdev.AddChild(pm.info);

% copy stats and status to child
pm.statistics(p_mdev.statistics);
pm.status(p_mdev.status~=0);

% set up modelstage: if parent mdev MS=0 then this is 1 stage
% else this is a child of another global model => MS=MS of parent

parentMS = p_mdev.modelstage;
if parentMS==0
   MS=1;
else
   MS=parentMS;
end
pm.info=pm.modelstage(MS);

