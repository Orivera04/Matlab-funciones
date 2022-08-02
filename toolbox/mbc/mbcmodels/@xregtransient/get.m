function Value=get(D,Property);
%XREGTRANSIENT/GET
% fields supported 'param','simname','state0','simVars'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:52 $

if nargin==1;
    Value= [{'param', 'simName','state0','simVars'}';...
            get(D.xregusermod)];
else
    switch lower(Property)
        case 'nfactors'
            Value= nfactors(D);
        case 'param'
            Value= double(D);
        case 'simname'
            Value= D.simName;
        case 'state0'
            Value= D.state0;
        case 'simvars'
            Value = D.simVars;
        otherwise
            try
                Value= get(D.localmod,Property);
            catch
                try
                    Value=get(D.xregusermod,Property);
                catch
                    error('XREGTRANSIENT/GET invalid property');
                end
            end  
    end   
end