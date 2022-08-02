function [NewOrder,numorder,orderlabels] = termorder(m)
% xregcubic/EVAL evaluate xregcubic
% 
% y= eval(m,X)
% This code is vectorised and expects an nxm matrix where n is the number of data 
% points and m is the number of factors
%
% This is normally called from MODEL/SUBSREF rather than called directly.
% MODEL/SUBSREF does all model transformations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:43 $



if nfactors(m)>1
	MON= monomials(m);
	ord= cellfun('prodofsize',MON)';
	mord= length(m.N);
	NewOrder=[];
	for i=0:mord
		NewOrder= [ NewOrder; find(ord==i)];
	end
	if mord>4
		mord=4;
	end
	
	if nargout>1
		% include number of terms of each order
		for n=0:mord
			numorder(n+1)=sum(ord==n);
		end
		numorder(mord+1)=sum(ord>=n);
		% and the name for each section
		orderlabels={'Constant terms','Linear terms','Second order terms','Third order terms','Higher Order Terms'};
		orderlabels=orderlabels(numorder~=0);
		numorder(numorder==0)=[];
	end
	
else
	NewOrder= 1:size(m,1);
	orderlabels= {'Polynomial Terms'};
	numorder= size(m,1);
end


   