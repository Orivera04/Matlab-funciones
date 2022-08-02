function y = subsref(m, S)
%SUBSREF Overloaded subsref method that allows evaluation of models
%
%  Y = MODEL( X ) Evaluates the NF input model at X.  X is a (N-by-NF) array,
%  where N the number of points to evaluate the model at.
%
%  See also XREGSTATSMODEL/EVALMODEL, XREGSTATSMODEL/GENTABLE, 
%  XREGSTATSMODEL/PEV, XREGSTATSMODEL/PEVGRID

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:58:00 $

if length(S)==1 && strcmp(S.type,'()')
    NF = nfactors( m );
    if NF==size(S.subs{:},2)
        y = EvalModel(m.mvModel,S.subs{:});
    else
        str = '';
        if NF>1
            str = 's';
        end            
        error('mbc:xregstatsmodel:InvalidSize', 'Incorrect number of inputs.  Model has %d input%s', NF, str );
    end
else
   error('mbc:xregstatsmodel:InvalidArgument', 'Invalid indexing operation. Model only supports evaluation via () indexing.');
end

