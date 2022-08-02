function varargout=set(A,varargin);
% SWEEPSET/SET overloaded set for sweepset
%   set(A,Properties,Values);
%
% Supported Properties
%   Variable Properties
%      'ID','FORMAT','NAME','DESCRIPTION',
%      'UNITS','TYPE','STATUS','NOTES','MIN','MAX'
% Sweepset Header Properties
%      'NUMBER','DATE','COMMENT'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:11:30 $




if builtin('isempty',A);
   error('Empty Object');
end


if nargin/2 == fix(nargin/2)
   % Variable Index as Second input parameter
   % call set recurively
   subs = varargin{1};
   S = substruct('()', {':',subs});
   B = subsref(A,S);
   set(B,varargin{2:end})
   switch class(subs)
   case {'cell','char'}
      ind=find(A,S.subs{2});
   case 'double'
      ind=S.subs{2};
   end
   % Check for duplicate names
   if any(ismember({B.var.name},{A.var.name}))
	   error('Attempt to set duplicate names in a sweepset')
   end
   A.var(ind)= B.var;   
else
   Valid_VarDescript   = {'ID','FORMAT','NAME','DESCRIPTION','UNITS','TYPE','STATUS','NOTES','MIN','MAX'};
   vfields= fieldnames(A.var);
   Valid_MapDescript   = {'NUMBER','DATE','COMMENT','FILENAME'};
   mfields= {'number','datetime','comment','filename'};
   
   for i=1:2:length(varargin)
      Property= varargin{i};
      if isa(Property,'char')
         Property={Property};
      end
      Value= varargin{i+1};
      if ~isa(Value,'cell')
         Value={Value};
      end
      for k=1:length(Property)
         mind= strmatch(upper(Property(k)),Valid_MapDescript);
         vind= strmatch(upper(Property(k)),Valid_VarDescript);
         if all(size(mind))==1
            fstr= ['A.',mfields{mind},'= Value{1};'];
            eval(fstr)
         elseif all(size(vind))==1
            if size(Value,1)==size(A,2) & size(Value,2)==size(Property,2)
               ValueStr= 'Value{:,k}';
            elseif all(size(Value,1)==1) & size(Value,2)==size(Property,2)
               ValueStr= 'Value{1,k}';
            elseif all(size(Value)==1)
               ValueStr= 'Value{k}';
            else
               error('Invalid Size for Value')
            end
            fstr= ['[A.var.',vfields{vind},']= deal(',ValueStr,');'];			
			eval(fstr)
				
			% Make sure any duplicate names are correctly dealt with
			if strcmp(vfields{vind},'name')
                A = makeValidNames(A);
            end

			if strcmp(vfields{vind},'units')
				% convert units into junits 
				for kk=1:length(A.var)
					if isstr(A.var(kk).units)
						A.var(kk).units= junit(A.var(kk).units);
					else
						A.var(kk).units= junit;
					end
				end
			end
			
         else
            error('Invalid Property')
         end
      end
   end
end

if nargout>0 | isempty(inputname(1))
   varargout{1}= A;
else
   assignin('caller',inputname(1),A);
end