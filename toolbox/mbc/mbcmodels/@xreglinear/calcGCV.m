function GCV= calcGCV(m,x,y);
% xreglinear/CALCGCV compute GCV
% 
%  GCV= calcGCV(m,x,y);
%  GCV= calcGCV(m);  uses data in Store

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:49:14 $




if nargin==1 & ~isempty(m.Store)
	% use info from the store
	
	FX= m.Store.X;
	J= FX(:,Terms(m));
	y= m.Store.y;
    Q= m.Store.Q;
    R= m.Store.R;
	% get df from model stats
	[ri,mse,df]= var(m);
	
else
	FX= x2fx(m,x);
	J= FX(:,Terms(m));
    % compute df
    switch m.qr  
    case 'rols'
        % will compute df further down
        [Q,R,OK,df]= qrdecomp(m,J);
    case 'ols'
        df = length(y)-size(J,2);
    otherwise     % ridge
        [Q,R,OK,df]= qrdecomp(m,J);
    end
end

if strcmp(m.qr,'rols')
	% ROLS is more complicated
	
    % Q= W/diag(sqrt(lam+dw))
    % R= diag(sqrt(lam+dw))*B
    if ~isempty(R)
        dwlam= diag(R)'.^2;
        lam= m.lambda(:)';
        if ~(numel(m.lambda)==1)
            lam = lam(Terms(m));
        end    
        dw = dwlam-lam;
        % ee = (y-X*b)'*(y-X*b) + lam* b'* B'*B *b
        ee = sum(y.*y) - sum( (y'*Q).^2.*(lam+dwlam)./dwlam ) ;
        df = size(J,1) - sum(dw./(dwlam));% N - gamma
    else
        ee= sum(y.*y);
        df= size(J,1);
    end
else
	r= y - FX*double(m);% residual
	ee = sum(r.*r);
end

% calculate GCV
N = length(y); 
if  abs(df) > sqrt(eps) && ee > eps
	GCV = (N/(df)^2)*ee; 
elseif   ee < eps 
	GCV = 0;   
else
	GCV = Inf;   
end    


return



    



