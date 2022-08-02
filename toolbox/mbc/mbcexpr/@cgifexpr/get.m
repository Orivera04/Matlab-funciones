function out = get(ifexp,property)
%GET Ifexpr get method
%
%  Gets the properties of the IfExpr object.
%
%  Usage: get(IfExpr) returns property list
%	 	  get(IfExpr , 'property_name') returns value of property

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:11 $

if nargin == 1
    out.Left = 'If left < ';
    out.Right = '         right THEN';
    out.Out1 = '                     out = out1 ELSE';
    out.Out2 = '                     out = out2 ';
    out.LeftName = 'name of left cgexpr';
    out.RightName = 'name of right cgexpr';
    out.Out1Name = 'name of out1 cgexpr';
    out.Out2Name = 'name of out2 cgexpr';
    out.type = 'Description string for GUI';
elseif nargin == 2
    if ~ischar(property)
        error('mbc:cgifexpr:InvalidArgument', 'Property name must be a string.');
    end  
    out = [];
    inputs = getinputs(ifexp);
    switch lower(property) 
        case 'left'
            out = inputs(1);
        case 'leftname'
            if isvalid(inputs(1))
                out = inputs(1).getname;
            else
                out = '';
            end
        case 'right'
            out = inputs(2);
        case 'rightname'
            if isvalid(inputs(2))
                out = inputs(2).getname;
            else
                out = '';
            end
        case 'out1'
            out = inputs(3);
        case 'out1name'
            if isvalid(inputs(3))
                out = inputs(3).getname;
            else
                out = '';
            end
        case 'out2'
            out = inputs(4);
        case 'out2name'
            if isvalid(inputs(4))
                out = inputs(4).getname;
            else
                out = '';
            end
        case 'type'
            out = 'Conditional Equation';
        otherwise
            error('mbc:cgifexpr:InvalidPropertyName', 'Unknown property name.');
    end
else
    error('mbc:cgifexpr:InvalidArgument', 'Insufficient arguments.');
end