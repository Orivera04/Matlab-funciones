function varargout= stats(m,opt,x,y);
%STATS   Get statistics for xreginterprbf object 
%   STATS(M,'Summary',X,Y).
%   [O1,O2]=STATS(M,'Validate',X,Y).
%   STATS(M,'Stepwise').
%
%   See also COLHEAD.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:48:56 $ 



switch lower(opt)
case 'summary'
    % [N p lam PRESS_RMSE RMSE]
    
    % p = m + k + 1
    
    n= length(y);
    p= numParams(m);
    bc= get(m,'boxcox');
    
    % natural
    yhat = eval( m, x ); 
    resr = y - yhat;
    if n > p,
        sse =  sqrt(sum( resr.^2 )/(n-p));
        %          possible non-zero residual if there are coincident nodes
    else
        sse = NaN;
    end

    %  {'No. Observations','No. Parameters','Box-Cox','RMSE'};
    s = [n p bc sse];
    varargout{1}=s;
    
case 'validate'
    %[cookd,leverage,residuals,response,Xv,studres,yhat,ci_hi,ci_lo]= deal(dstats{:});
    %[rn,studres]= stats(m.mv3xspline,'validate');
    if nargin < 4
        p= get(MBrowser,'CurrentNode');
        [x,y]= getdata(p.info);
    end
    varargout{1}= y(isfinite(y));
    varargout{2}= y(isfinite(y));
    
case 'stepwise'
    
    s= NaN*zeros(4,3);
    
    varargout{1}= s;
    
otherwise
    varargout=cell(1,nargout);
end

% EOF
