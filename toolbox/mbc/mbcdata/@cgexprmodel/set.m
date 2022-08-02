function varargout = set(varargin)
%cgExprModel/SET method.
%
%Sets the properties of the eq model expression objects.
%
%Usage: set(obj , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:46 $

if nargin == 1
	% This object has the same setable properties as it's parent
	varargout{1} = set(modexpr);   
else
	mod_object = varargin{1};
	if nargin < 3
		error('ModExpr::set: Insufficient arguments.');
	end
	
	for i = 2:2:nargin
		property = varargin{i};
		new_value = varargin{i+1};
		
		if ~isa(property , 'char')
			error('EqExpr\set: Non character array property name.');
		end
		
		switch lower(property)
		case 'valptrs'
			newPtrs = new_value;
			if isa(newPtrs,'xregpointer')
				% if we change the ptrlist at all we need to do a  search and replace on the 
				% ptrs in modptr
				if length(get(mod_object,'valptrs')) == length(new_value)
					mod_object = mapptr(mod_object,get(mod_object,'valptrs'),new_value);
				end
			end
		otherwise
			try
				M = mod_object.xregexportmodel;
				M = set(M,property,new_value);
				mod_object.xregexportmodel = M;
			catch
				error(['cgExprModel\set: No such property as ',property]);
			end
		end
	end
	%If we are out here, then we should be able to set the property of the object.
	if nargout > 0
		varargout{1} = mod_object;
	elseif ~isempty(inputname(1))
		assignin('caller' , inputname(1) , mod_object);
	end
	
end

