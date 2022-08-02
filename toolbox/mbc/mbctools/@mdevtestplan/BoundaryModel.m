function [c] = BoundaryModel( T, m )
%BOUNDARYMODEL The boundary constraint associated with a testplan
%
%  C = BOUNDARYMODEL(T,M) is the boundary constraint that is associated
%  with the testplan T that is appropriate for the model M.
%  
%  See also XREGBDRYROOT/GETCONSTRAINT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.2 $  $Date: 2004/02/09 08:07:00 $

if isempty(T.ConstraintData) || T.ConstraintData==0 
    c=[];
else
    if isa(m,'localmod') % || isa(m,'xregtwostage')
        Type= 1; % local model
    elseif numstages(T)>1 && nfactors(m)<nfactors(HSModel(T.DesignDev))
        Type= 2; % global model
    else
        Type= 0; % response model
    end
    c= T.ConstraintData.getconstraint( nfactors(m), Type );
    
end
