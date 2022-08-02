function kfm(dataID)
% KFM Kohonen's feature map with 2-D output units.
%	KFM2 is Kohonen's feature map with 2-D outputs.
%	KFM2(1) --> data set in a square region.
%	KFM2(2) --> data set in a triangular region.
%	KFM2(3) --> data set in a circle.
%	KFM2(4) --> data set in a cross.
%	KFM2(5) --> data set in a donut-shaped region.

%	KFM is a synonym for KFM2.

if nargin == 0,
	kfm2;
else
	kfm2(dataID);
end
