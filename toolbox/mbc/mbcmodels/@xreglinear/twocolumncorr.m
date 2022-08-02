function X=twocolumncorr(m)
%xreglinear/TWOCOLUMNCORR   Correlation for columns in regression
%   Method that returns the two column correlation for the regression matrix

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:50:20 $


if ~isfield(m.Store,'Q')
   error('Use initstore first to initialise qr data in model');
end

x=m.Store.X(:,Terms(m));


if all(x(:,1)==1)
   x=x(:,2:end);
end

xjbar=repmat((sum(x)./size(x,1)),size(x,1),1);
X=(x-xjbar)./(repmat((sum(((x-xjbar).^2))).^0.5,size(x,1),1));
X=X'*X;


