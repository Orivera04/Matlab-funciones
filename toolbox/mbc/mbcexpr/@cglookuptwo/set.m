function varargout = set(varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:27:37 $

% Set method for cglookuptwo Objects
% 
%   set(T) displays possible properties to set.
%
%  T = set(T,'values',M); will set the values array to the matrix M.
% If the locks field is empty, them M can be any size, if the locks field is
% not empty then the size of M must be the same size as the existing field.
% 
% T = set(T,'values',{M,Information})
% sets the values field as above, and passes the argument 'Information'
% into the memory field
% 
% T = set(T,'element',[i,j,x]) sets the (i,j) entry in the values matrix to x 
% provided that this is valid and theat element is not locked.
% 
% T = set(T,'element',{[i,j,x],Information}) as above, and fills up memory field.
%
% T = set(T,'clips',[l,u]) sets the clips vector to be [l,u].
%
% T = set(T,'locks',L) sets the locks field to the matrix L. L should consist 
% of only 0's and 1's and must be the same size as the values field.
%
% T = set(T,'locks',[]) sets the locks field to the empty matrix thus allowing
% for resizing of the values field
% 
% T = set(T,'matrix',V) sets the values field to the matrix V. Ignores any locks, 
% thus the table can be resized.


if nargin == 1
   
   varargout{1} = i_ShowFields;
   
else
   
   LT = varargin{1};
   if nargin < 3
      error('cglookuptwo::set: Insufficient arguments.');
   end
   for i = 2:2:nargin
      property = varargin{i};
      new_value = varargin{i+1};
      if ~isa(property , 'char')
         error('cglookuptwo::set: Non character array property name.');
      end
      
      switch lower(property)
      case 'values'
         
         LT = i_setvalues(LT,new_value);
         
      case 'element'
         
         LT = i_element(LT,new_value);
         
      case 'clips'
         % Changes the clipping values. Requires a 1 by 2 vector. If there is
         % upper or lower clip use Inf or -Inf accordingly.
         
         if any(size(new_value)~=[1 2])
            error('Clips requires a 1 by 2 vector');
         else
            LT.Clips = new_value;
         end
         
      case {'locks','vlocks'}
         LT = i_locks(LT,new_value);
      case 'weights'
         if length(new_value) == length(LT.SFlist)
            LT.Weights = new_value;
         else
            error('cglookuptwo:: Set: Weight vector is wrong length');
         end
      case 'matrix'
         if ~isnumeric(new_value);
            M = new_value{1};
            info = new_value{2};
         else
            M = new_value;
            info = 'No information';
         end
         LT = set(LT,'locks',[]);
         LT = setVunofficial(LT,[]);
         LT = set(LT,'values',{M,info});
         if ~isempty(M)
            LT = set(LT,'locks',zeros(size(M)));
            LT = clearExtrapolationMask(LT);        
         end
      case 'description'
         LT.Description = new_value;
      case 'input'
         LT.Input = new_value;
      case 'precision'
         LT.Precision = new_value;
      case 'range'
         LT.Range = new_value;
         if ~isempty(new_value)
            LT.Clips = new_value;
         end
      case 'memory'
          LT.Memory = new_value;
      otherwise
          warning('mbc:InvalidArgument',['Attempting to set ''' property ...
                  ''' in cglookuptwo. Not a valid property.']);
      end
  end
  if nargout > 0
      varargout{1} = LT;
  elseif ~isempty(inputname(1))
      assignin('caller' , inputname(1) , LT);
   end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ShowFields                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_ShowFields

out.Values = 'm by n Array';
out.element = 'number';
out.Clips = '1 by 2 double';
out.locks = 'm by n array OR empty';




%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_setvalues              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LT = i_setvalues(LT,newvalue)

if ~isnumeric(newvalue)
   M = newvalue{1};
   info = newvalue{2};
else
   M = newvalue;
   info = 'no information';
end

if isempty(M)
    LT.VLocks = [];
    LT.Values = [];
    LT = clearExtrapolationMask(LT);
else
    values = LT.Values;
    vlocks = LT.VLocks;
    if isempty(values)
        values = zeros(size(M));
    end
    if ~isempty(vlocks);
        if ~isequal(size(vlocks),size(M))
            error('cglookuptwo:: Set: New values array is wrong size');
        end
        vlocks = logical(vlocks);
        M(vlocks) = values(vlocks);
    end
    prec = get(LT,'precision');
    LT.Values = resolve(prec,M);
end

n = length(LT.Memory);
LT.Memory{n+1}.Information = info;
LT.Memory{n+1}.Values = LT.Values;
LT.Memory{n+1}.Date = datestr(now,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_element                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_element(LT,newvalue)

if ~isnumeric(newvalue);
   i = newvalue{1}(1);
   j = newvalue{1}(2);
   x = newvalue{1}(3);
   info = newvalue{2};
else
   i = newvalue(1);
   j = newvalue(2);
   x = newvalue(3);
   info = 'no information';
end

val = get(LT,'values');
val(i,j) = x;

out = set(LT,'values',{val,info});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_locks                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LT = i_locks(LT,L)

M = get(LT,'values');
if isempty(L)
   LT.VLocks = [];
elseif ~isequal(size(M),size(L))
   error('new locks matrix is wrong size');
elseif ~isequal(L, L.^2)
   error('Locks can only be 0 or 1');
else 
   LT.VLocks = L;
end
