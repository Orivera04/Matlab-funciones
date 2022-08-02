function ss=mmstructfun(fun,s,varargin)
%MMSTRUCTFUN Functions on Contents of Structure Fields. (MM)
% MMSTRUCTFUN(FUN,S) applies the function FUN to the contents of
% all fields of the scalar structure S returning the results in a
% structure having the same field names as S.
%
% MMSTRUCTFUN(FUN,S,FIELD1,FIELD2) applies the function FUN to the
% the contents of the fields of the SCALAR structure S starting with
% FIELD1 and ending with the field FIELD2 including all fields between
% them as given by the list returned by FIELDNAMES(S).
%
% MMSTRUCTFUN(FUN,S,FIELDS) applies the function FUN to the content of
% all fields of the scalar structure S listed in the cell array FIELDS.
%
% If FUN is a numeric scalar, simple multiplication is performed.
%
% If FUN is an inline function, M-file function, or function handle
% each output field is generated by calling FEVAL, e.g., FEVAL(FUN,S.FIELDi).
%
% See also MMNUMFUN, MMCELLFUN.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/25/99, 1/26/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isstruct(s)
   error('Second Argument Must be a Structure.')
end
if length(s)>1
   error('Structure S Must be a Scalar (i.e. 1-by-1).')
end
if nargin==2
   fn=fieldnames(s);
elseif nargin==3
   fn=varargin{1};
   if ischar(fn)
      fn={fn};
   elseif ~iscell(fn)
      error('A Cell Array of String Field Names are Expected.')
   end
elseif nargin==4
   if ~isfield(s,varargin{1})
      error('FIELD1 is not a Field of the Structure S.')
   elseif ~isfield(s,varargin{2})
      error('FIELD2 is not a Field of the Structure S.')
   end
   fn=fieldnames(s);
   idx=[strmatch(varargin{1},fn);strmatch(varargin{2},fn)];
   fn=fn(min(idx):max(idx));
end
if length(fn)==0
   warning('NO Valid Fieldnames are Provided.')
   ss=[];
   return
end
if isnumeric(fun) % simple multiplication
   ss=struct(fn{1},fun*getfield(s,fn{1}));
   for i=2:length(fn)
      ss=setfield(ss,fn{i},fun*getfield(s,fn{i}));
   end
elseif ischar(fun)|isa(fun,'inline')|isa(fun,'function_handle')
   ss=struct(fn{1},feval(fun,getfield(s,fn{1})));
   for i=2:length(fn)
      ss=setfield(ss,fn{i},feval(fun,getfield(s,fn{i})));
   end
else
   error('Unknown FUN argument.')
end