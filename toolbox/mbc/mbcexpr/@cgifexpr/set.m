function varargout = set(varargin)
%SET Ifexpr set method
%
%  Sets the properties of the if expression object.
%
%  Usage: set(ifexpr , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:14 $

if nargin == 1
    varargout{1} = i_ShowFields;   
else
    ifexp = varargin{1};
    if nargin < 3
        error('IfExpr::set: Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgifexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'left'
                %Check to see that the new name is a xregpointer.
                if isa(new_value , 'xregpointer') && ~isempty(new_value)
                    ifexp = setinputs(ifexp, new_value, 1);
                else
                    error('mbc:cgifexpr:InvalidPropertyValue', ' Inputs must be xregpointers.');
                end
                
            case 'right'
                %Check to see that the new name is a xregpointer.
                if isa(new_value , 'xregpointer') && ~isempty(new_value)
                    ifexp = setinputs(ifexp, new_value, 2);
                else
                    error('mbc:cgifexpr:InvalidPropertyValue', ' Inputs must be xregpointers.');
                end
                
            case 'out1'
                %Check to see that the new name is a xregpointer.
                if isa(new_value , 'xregpointer') && ~isempty(new_value)
                    ifexp = setinputs(ifexp, new_value, 3);
                else
                    error('mbc:cgifexpr:InvalidPropertyValue', ' Inputs must be xregpointers.');
                end
                
            case 'out2'
                %Check to see that the new name is a xregpointer.
                if isa(new_value , 'xregpointer') && ~isempty(new_value)
                    ifexp = setinputs(ifexp, new_value, 4);
                else
                    error('mbc:cgifexpr:InvalidPropertyValue', ' Inputs must be xregpointers.');
                end
                
            otherwise
               error('mbc:cgifexpr:InvalidPropertyName', 'Unknown property name.');
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = ifexp;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , ifexp);
    end
    
end



function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.left = 'If left < ';
out.right = '         right THEN';
out.out1 = '                     out1 ELSE';
out.out2 = '                               out2 ';
