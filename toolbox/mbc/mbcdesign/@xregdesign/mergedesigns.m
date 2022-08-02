function des = mergedesigns(des, varargin)
%MERGEDESIGNS Merge design points from many designs
%
%  DES = MERGEDESIGNS(DES, D1, D2, ..,Dn) merges the points from D1...Dn
%  into DES.  All designs must have the same number of factors.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:07:06 $ 

nDes = length(varargin);
nFactors = nfactors(des);
hModel = model(des);
for n = 1:nDes
    dNewPoints = invcode(model(varargin{n}), factorsettings(varargin{n}));
    if size(dNewPoints,2)~=nFactors
        error('mbc:xregdesign:InvalidArgument', 'All designs must have the same number of factors.');
    end
    des.design =  [des.design; code(hModel, dNewPoints)];
    des.designpointflags = [des.designpointflags; varargin{n}.designpointflags];
end

des.npoints = size(des.design,1);
desind = zeros(des.npoints,1);
desind(1:length(des.designindex)) = des.designindex;
des.designindex = desind;
des = DesignType(des,0,[]);
des = timestamp(des,'stamp');
des.designstate = des.designstate+1;