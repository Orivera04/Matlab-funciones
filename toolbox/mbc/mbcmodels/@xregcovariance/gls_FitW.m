function [c,Wc]= gls_FitW(c,varargin);
%XREGCOVMODEL/GLS_FITW
%
% [c,Wc]= gls_FitW(c,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:46:17 $


% covariance model parameters
Wp= double(c);

if ~isempty(Wp)
    % have some parameters to estimate
    
    % constraints for covariance parameters
    bnds=[];
    if ~isempty(c.wfunc)
        [nw,bnds]= feval(c.wfunc,c);
    end
    lsqalg=1;
    
    if isempty(bnds)
        bnds= zeros(0,2);
    end
    A=[];b=[];
    if ~isempty(c.cfunc)
        % constraints for correlation parameters
        [nw,bnds2,Ac,bc,nl]= feval(c.cfunc,c);
        if ~isempty(bnds2)      
            bnds= [bnds;bnds2];
        end
        if ~isempty(Ac) | ~isempty(nl)
            lsqalg=0;
            if ~isempty(Ac)
                % augment with covariance parameters
                A= [zeros(size(Ac,1),length(c.wparam)),Ac];
                b= bc;
            end
        end
    end

    % set up optimmgr to estimate paramters
    omParam =xregoptmgr(@nlleastsq,c,c.costFunc);
    set(omParam,'LargeScale','on');
    set(omParam,'Jacobian','off');
    omParam= setConstraints(omParam,bnds(:,1),bnds(:,2),A,b,'');
    set(omParam,'MaxFunEvals',10000); 
    
    % run fitting algorithm
    [c,cost,OK,Wp]= run(omParam,c,Wp,varargin{:});
end

% obtain new errors, object, weights
[e,c,Wc]= feval(c.costFunc,Wp,c,varargin{:},1);

