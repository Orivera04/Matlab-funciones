function varargout = set(varargin)
%FUNCMOD/SET set method.
%
%  Sets the properties of the Function Model object.
%
%  Usage: set(F , 'property_name' , property_value, ...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:49:56 $

if nargin == 1
   
   varargout{1} = i_ShowFields;
   
else
   
   F = varargin{1};
   
   if nargin < 3
      error('FuncMod\set: Insufficient arguments.');
   end
   
   for i = 2:2:nargin
      
      property = varargin{i};
      new_value = varargin{i+1};
      if ~isa(property , 'char')
         error('FuncMod\set: Non character array property name.');
      end
      switch lower(property)
	  case 'arguments'
		  F = setsymbols(F,new_value);
      otherwise
         try
            F.xregexportmodel=set(F.xregexportmodel,property,new_value);
         catch
            error(['FuncMod\set: Unknown property name: ''' property '''.']);     
         end
      end
   end
   %If we are out here, then we should be able to set the property of the object.
   if nargout > 0
      varargout{1} = F;
   elseif ~isempty(inputname(1))
      assignin('caller' , inputname(1) , F);
   end
end

function out = i_ShowFields

%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.Function = 'Function string';
out.Arguments= 'Array of strings';