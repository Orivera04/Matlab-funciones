function y = EvalModel(M,x,varargin)
%EVALMODEL Evaluate a model
%
% Y = EVALMODEL( MODEL, X ) Evaluates the model at X
% X is a (N-by-NF) array, where NF is the number of inputs, and N the number of
% points to evaluate the model at.
%
% This the same as Y = MODEL( X ) 
%
% See also XREGSTATSMODEL/GENTABLE, XREGSTATSMODEL/PEV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:57:40 $

% check the number of inputs and outputs
error(nargchk(2,2, nargin, 'struct'));
error(nargoutchk(1,1, nargout, 'struct'));

m=M.mvModel;
if iscell(x)
   
   bigLength = -Inf;
   for i = 1:length(x)
      if length(x{i}) > bigLength
         bigLength = length(x{i});
      end
   end
   
   Xg = zeros(bigLength,length(x));   
   
   for i = 1:length(x)
      if length(x{i}) == 1
         Xg(:,i) = x{i}(:);
      else
         Xg(1:length(x{i}),i)= x{i}(:);
      end
   end
   
else
    % we are passed a numeric array - check it has the right size
    NF = nfactors( m );
    if NF==size(x,2)
        Xg = x;
    else
        str = '';
        if NF>1
            str = 's';
        end            
        error('mbc:xregstatsmodel:InvalidSize', 'Incorrect number of inputs.  Model has %d input%s', NF, str );
    end
end


y = EvalModel( m, Xg, varargin{:} );