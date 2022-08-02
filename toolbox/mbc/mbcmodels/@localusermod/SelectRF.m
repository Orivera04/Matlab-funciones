function [selrf,rfcond]=SelectRF(u,p)
% USERLOCAL/SELECTRF select valid combinations of response features

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:43:37 $


b0= double(u);
n= norm(b0);
if n==0
   n=1;
end

[selrf,rfcond]= SelectRF(u.localmod,size(u,1));
%% each row of selrf gives indices of child-nodes that allow reconstruction
if ~isempty(selrf)
	ok= zeros(size(selrf,1),1);
	ok(1)=1;
% we need to pass in the indices of rfTypes, not indices of tree nodes    
    rfTypes = get(u,'feat.index');
	for i=2:size(selrf,1);
		% try reconstructing local model 
		Ur= SelFeat(u,selrf(i,:));
		Yrf= evalfeatures(Ur);
		br= reconstruct(Ur.userdefined,Yrf,delG(Ur),rfTypes(selrf(i,:)));
		% check whether reconstruction gives original model
		ok(i)= norm(br(:)-b0(:))/n < 1e-3;
	end
	ok= (ok~=0);
	
	selrf= selrf(ok,:);
	rfcond= rfcond(ok);
end
