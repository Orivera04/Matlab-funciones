function out = get(relexp,property)
%GET Standard get method
%
%  Gets the properties of the cgrelexpr object.
%
%  Usage: get(cgrelexpr) returns property list
%	 	  get(cgrelexpr , 'property_name') returns value of property

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $  $Date: 2004/02/09 07:15:18 $

if nargin == 1
    out.Left = 'Left hand side argument';
    out.Right = 'Right hand side argument';
    out.Relation = 'Logical relation';
    out.type = 'Description string for GUI';
elseif nargin == 2
    if ~ischar(property)
        error('mbc:cgrelexpr:InvalidArgument', 'Property name must be a string.');
    end  
    out='';
    switch lower(property) 
        case 'left'
            inputs = getinputs(relexp);
            out = inputs(1);
        case 'right'
            inputs = getinputs(relexp);
            out = inputs(2);
        case 'relation'
            out = relexp.rel;
        case 'type'
            out = 'Relational operator';
        otherwise
            error('mbc:cgrelexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
    end
else
    error('mbc:cgrelexpr:InvalidArgument','Insufficient arguments.');
end
