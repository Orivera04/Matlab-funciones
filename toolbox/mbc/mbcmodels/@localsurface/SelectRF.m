function [selrf,rfcond]=SelectRF(u,p)
% USERLOCAL/

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:41:53 $


b0= double(u);
n= norm(b0);
if n==0
   n=1;
end

[selrf,rfcond]= SelectRF(u.localmod,size(u,1));
if ~isempty(selrf)
	ok= zeros(size(selrf,1),1);
	ok(1)=1;
	for i=2:size(selrf,1);
		Ur= SelFeat(u,selrf(i,:));
		Yrf= evalfeatures(Ur);
		br= reconstruct(Ur.userdefined,Yrf,delG(Ur),selrf(i,:));
		ok(i)= norm(br(:)-b0(:))/n < 1e-3;
	end
	ok= (ok~=0);
	
	selrf= selrf(ok,:);
	rfcond= rfcond(ok);
end
