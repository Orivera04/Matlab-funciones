function GAD(GAn)
%GAD: run sample code.
global GADtalkname GADn
if nargin==0
  GAn=GADn;
  GADn=GADn+1;
end

eval([GADtalkname, '(', num2str(GAn), ')']);
