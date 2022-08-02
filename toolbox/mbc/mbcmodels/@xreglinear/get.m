function Value=get(m,Property);
% xreglinear/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:49:32 $

if nargin==1;
   Value= [{'status','store','order','lamda', 'qr', 'pev'}'; get(m.xregmodel)];
else
   switch lower(Property)
   case 'status'
      Value= m.TermStatus;
   case 'store'
      Value= m.Store;
   case 'order'
      Value= ones(1,nfactors(m));
	case 'lambda'
		Value= m.lambda;
	case 'qr'
		Value= m.qr;
   case 'pev'
         Value= calcRi(m);
   		if ~isempty(m.Store.mse)
            Value= sqrt(m.Store.mse)*Value;
         end
   otherwise
		try
			Value= get(m.xregmodel,Property);
		catch
			error('xreglinear/GET invalid property');
		end
	end   
end