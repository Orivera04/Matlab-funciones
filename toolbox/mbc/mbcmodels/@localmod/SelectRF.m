function [selrf,rfcond]=SelectRF(L,p)
% LOCALMOD/SELECTRF select possible response feature combinations
% 
% Only combinations which can be used for reconstruction
%  [selrf,rfcond]=SelectRF(L)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:38:46 $


delG= L.delG;
if nargin < 2
   p=size(L,1);
end
n= size(delG,1);
if n==0 || n<p
	% not enough rfs
	selrf=[];
	rfcond=[];
else
	selrf= nchoosek([1:size(delG,1)]',p);
	
	OK= zeros(size(selrf,1),1);
	rfcond= OK;
	for i=1:size(selrf,1)
		% try each combination
		dG= delG(selrf(i,:),:);
		if all(isfinite(dG(:))) && rank(dG)==size(dG,2)
			% check responses
			OK(i)= 1;
			rfcond(i)=cond(dG);
		end
	end
	OK=(OK~=0);
	selrf=selrf(OK,:);
	rfcond= rfcond(OK);
end
