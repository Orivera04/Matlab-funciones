function OK= SimulinkModel(mdev,name,DO_PEV);
%SIMULINKMODEL construct a simulink model from an mbc model
%
% OK= SimulinkModel(mdev,name,DO_PEV,mlist);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:54 $


if nargin<2
    % use node name
    name= varname(mdev);
end
if nargin<3
    DO_PEV= 1;
end

mlist= {model(MakeEXM(mdev))};

sys_out=mv2sl(mdev, mlist, name , [], DO_PEV);
OK= 1;