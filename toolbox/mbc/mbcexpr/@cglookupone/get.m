function out = get(LT, property);
% LookUpOne\get
%	get(l)	returns list of properties
%  val=get(l,'property') returns the value of the named property of the object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:12:20 $

if nargin == 1
    out = get(LT.cgnormfunction);
elseif nargin == 2
    if ~isa(property , 'char')
        error('LookupOne\get: Non character array property name.');
    end
    switch lower(property)
        case {'x','axesptrs'}
            % return the xinput to the dummy normaliser
            % we don't give the dummy normaliser itself to the outside world
            dummyNorm = get(LT.cgnormfunction,'x');
            if ~isempty(dummyNorm)
                out = dummyNorm.get('x');
            else
                out = [];
            end
        case {'breakpoints','axes','allbreakpoints'}
            % return the breakpoints from the dummy normaliser
            dummyNorm = get(LT.cgnormfunction,'x');
            if ~isempty(dummyNorm)
                out = dummyNorm.get('Breakpoints');
            else
                out = [];
            end
        case 'bplocks'
            % return the breakpoints locks from the dummy normaliser
            dummyNorm = get(LT.cgnormfunction,'x');
            if ~isempty(dummyNorm)
                out = dummyNorm.get('BPLocks');
            else
                out = [];
            end
        case 'type'
            out = '1D Table';
        otherwise
            try
                out =get(LT.cgnormfunction,property);
            catch
                error(['LookUpOne\get: Unknown property name: ''' property '''.']);
            end
    end
else
    error('LookUpOne\get: Insufficient arguments.');
end

