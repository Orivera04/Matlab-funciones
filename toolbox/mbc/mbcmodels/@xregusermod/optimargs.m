function [om,optparams]= optimargs(U,varargin);
%XREGUSERMOD/OPTIMARGS input arguments for least squares optimisation
% 
% [om,optparams]= optimargs(U,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:34 $

[LB,UB,A,c,nlcon,optparams]=constraints(U,varargin{:});

if isNumJac(U) 
    % don't use analytic jacobians for transient
   % no analytic jacobian
   Jcalc='off';
else
   Jcalc='on';
end

if isempty(A) | nlcon>0
    fopts= optimset(optimset('fmincon'),'display','off','GradObj',Jcalc);
else
    fopts= optimset(optimset('lsqnonlin'),'display','off','Jacobian',Jcalc);
end

try
    om= foptions(U,fopts);
catch
    om= fopts;
end
if isa(om,'xregoptmgr')
    % foptions defines an xregoptmgr add a constraints
    om=setConstraints(om,constrArgs{:});
else
    fopts= om;
    % make an optmgr object 
    if nlcon
        constrArgs= {LB,UB,A,c,@nlconstraints};
    else
        constrArgs= {LB,UB,A,c,''};
    end
    
    om= xregoptmgr(@nlleastsq,U,@lsqopt);
    om=setConstraints(om,constrArgs{:});
    props=fieldnames(get(om));
    for i=1:length(props)-2
        if ~isempty(fopts.(props{i}))
            try
                set(om,props{i},fopts.(props{i}))
            end
        end
    end

end

