function mdev=InitStore(mdev,ind);
% MDEV_LOCAL/INITSTORE initialises twostage models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:04:02 $

if nargin==1
	ind= BMIndex(mdev);
end
if ind==0
	return
end

X= getdata(mdev,'FIT');
XG = X{end};

TS= mdev.TwoStage{ind};

Xcode= gcode(TS,double(XG));

L= model(mdev);
RF1= RFstart(L);
DatumType= get(L,'DatumType');
switch DatumType
case {1,2}
   prf= children(mdev);
   Yd= double(prf(1).getdata('Y'));
case 3
   pdatum= datumlink(mdev);
   Yd= double(pdatum.getdata('Y'));
end

selrf= mdev.ResponseFeatures(ind,:);


Yrf= mdev.RFData.double;
Yrf= Yrf(:,selrf+RF1);
if RF1
   Yrf= [Yd Yrf];
end

TS= InitStore(TS,Xcode,Yrf);
ri= var(TS);
if isempty(ri);
	mdev.TwoStage{ind}= TS;
	TS= pevinit(mdev,ind);
end
mdev.TwoStage{ind}= TS;
if ind==2 & ismle(TS)
	mdev.MLE.Model= TS;
end

pointer(mdev);
