function [Q,R,df,Rinv]= qrdelete(m,ColNum)
%XREGLINEAR/QRDELETE
%
% [Q,R,df,Rinv]= qrdelete(m,ColNum)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:49:58 $

Q= m.Store.Q;
R= m.Store.R;
Rinv= [];

switch m.qr
    case 'rols'
        if numel(m.lambda)==1
            lam= m.lambda;
        else% local rols
            termsin = Terms(m);
            if any(termsin)
                lam= m.lambda(termsin);
                lam= lam(:);
            else
                lam = 0;    
            end       
        end
        
        % make orthonormal ?
        n= size(Q,2);
        D1ind= 1:n;
        DR= diag(R);
        D1= sqrt(sum(Q.*Q))';
        B= sparse(D1ind,D1ind,D1,n,n)*R;
        W= Q*sparse(D1ind,D1ind,1./D1,n,n);
        
        % qrdelete
        [B2,W2]= xregrdel(B,ColNum,W);
        % normalise again
        n= n-1;
        D2ind= 1:n;
        D2= diag(B2);
        dw= D2.*D2;
        
        Q= W2*sparse(D2ind,D2ind,1./sqrt(dw+lam).*D2,n,n);
        R= sparse(D2ind,D2ind,sqrt(dw+lam)./D2,n,n)*B2;
        
        df = size(Q,1) - sum(dw./(dw+lam));
        
        if nargout>3
            [ri,mse,dfold]= var(m);
            % update Rinv
            ri= ri/sqrt(mse);
            % normalise Rinv
            ri= ri*sparse(D1ind,D1ind,1./diag(ri)./DR./D1,n+1,n+1);
            % use qrdelete to do update
            [B3,Rinv]= xregrdel(B,ColNum,ri);
            Rinv(ColNum,:)= [];
            Rinv= Rinv*sparse(D2ind,D2ind,sqrt(dw)./(lam+dw)./diag(Rinv),n,n);
        end
    case 'ols'
        R1= R;
        % update qr 
        [R,Q]= xregrdel(R,ColNum,Q);
        df= -diff(size(Q));
        if nargout>3
            [ri,mse,dfold]= var(m);
            % update Rinv
            ri= ri/sqrt(mse);
            [R2,Rinv]= xregrdel(R1,ColNum,ri);
            % delete rows
            Rinv(ColNum,:)=[];
        end
    case 'ridge'
            R1= R;
    % update qr 
    [R,Q]= xregrdel(R,ColNum,Q);
    dq = sum(Q.*Q,2);
    df = size(Q,1) - sum(dq);
    if nargout>3
        Rinv= R\Q';
    end
end
    



