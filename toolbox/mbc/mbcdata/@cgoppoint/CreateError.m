function [op,e_ptr,e] = CreateError(op,addvec,left,right,varargin)
% op = CreateError(op,addvec,left,right)
%   addvec: vector length 3, containing 1s where left, right, error 
%   should be added to dataset.
%   left, right may be: factor index (new value created)
%                       ptr
% Checks for error already existing; if not, generates name and
%  creates error.
%
% op = CreateError(op,addvec,left,right,name) uses given name
% op = CreateError(op,addvec,left,right,e_ptr,[name]) updates given equation, 
%       updating name if applicable.
% [op,ptr] = CreateError(...) returns the pointer to the error equation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:51:10 $

if nargin<4
    error('cgoppoint::createerror: insufficient arguments.');
elseif ~isa(op,'cgoppoint')
    error('cgoppoint::createerror: cgoppoint required.');
elseif ~isnumeric(addvec) | length(addvec)~=3
    error('cgoppoint::createerror: addvec must be vector, length 3.');
end


name_i = 0; done_e = 0; e_ptr = xregpointer; errname = '';
argsused = 4;
while nargin>argsused
    this = varargin{argsused-3};
    switch class(this)
    case 'xregpointer'
        e_ptr = this;
    case 'char'
        errname = this;
        name_i = -1;
    otherwise
        error('cgoppoint::createerror: check usage.');
    end
    argsused = argsused + 1;
end

if isnumeric(right)
    [op,fact1,ptr1] = AddCage(op,right);
elseif isa(right,'xregpointer')
    ptr1 = right;
    name_i = 1;
    if addvec(2) & isempty(find(right==op.ptrlist))
        op = addfactor(op,right);
    end
else
    error('cgoppoint::createerror: index or xregpointer required.');
end
if isnumeric(left)
    [op,fact2,ptr2] = AddCage(op,left);
elseif isa(left,'xregpointer')
    ptr2 = left;
    name_i = 2;
    if addvec(1) & isempty(find(left==op.ptrlist))
        op = addfactor(op,left);
    end
else
    error('cgoppoint::createerror: index or xregpointer required.');
end

if isempty(errname)
switch name_i
case {0,1}
    errname = ['Error_' ptr1.getname];
case 2
    errname = ['Error_' ptr2.getname];
end
end
    
if ~isempty(errname)
    % filter out invalid characters -
    %  do some checks against other names later.
    e = setname(cgexpr,errname);
    errname = getname(e);
end
created_flag = 0;
if ~isvalid(e_ptr)
    if ~addvec(3)
        error('cgoppoint::CreateError: error must be added to cgoppoint');
        return
    end
    % create new equation
    % First check whether this one already exists
    [exists,e_ptr,dir] = i_SubExprExists(op.ptrlist,ptr2,ptr1,'reverse');
    if ~exists
        % create new one - ensure unique name within dataset
        errname = i_uniquename(op.ptrlist,errname);
        e_ptr = xregpointer(cgsubexpr(errname,ptr2,ptr1));
    end
    created_flag = 1;
else
    % updating old equation
    [exists,e_ptr2,dir] = i_SubExprExists(op.ptrlist,ptr2,ptr1,'reverse');
    if exists & ~(e_ptr==e_ptr2)
        if dir==1
            warning(['CreateError: Equation ' ptr2.getname ' - ' ptr1.getname ...
                    ' already exists as ' e_ptr2.getname '.']);
        elseif dir==-1
            warning(['CreateError: The reverse equation ' ptr1.getname ' - ' ptr2.getname ...
                    ' already exists as ' e_ptr2.getname '.']);
        end
    end
    % name changed? Ensure it is unique
    if ~strcmp(errname,e_ptr.getname)
        errname = uniquename(op,errname);
    end
    e_ptr.info = set(e_ptr.info,...
        'left',ptr2, 'right', ptr1);
    e_ptr.info = e_ptr.setname(errname);
end

if addvec(3) & isempty(find(e_ptr==op.ptrlist))
    op = addfactor(op,e_ptr,'created_flag',created_flag,...
        'orig_name',{errname});
    op = eval_fill(op);
end

%-------------------------------------------------    
function [exists,e_ptr,dir] = i_SubExprExists(e,ptr2,ptr1,opt);
%-------------------------------------------------    

e_ptr = xregpointer; dir = 0; exists = 0;
ErrPtrs = [];
for i = 1:length(e)
    if isvalid(e(i))
        [iserr,l,r] = i_isErrorExpr(e(i).info);
        if iserr
            ErrPtrs = [ErrPtrs ; i double(l) double(r)];
        end
    end
end

if ~isempty(ErrPtrs)
    compare = double([ptr2 ptr1]);
    % find matching error
    cmat = repmat(compare,size(ErrPtrs,1),1);
    f = find(~any((ErrPtrs(:,2:3) - cmat)'));
    if ~isempty(f)
        ind = ErrPtrs(f(1),1);
        dir = 1;
        e_ptr = e(ind);
        exists = 1;
    elseif strcmp(lower(opt),'reverse')
        % check reverse order too
        f = find(~any((ErrPtrs(:,[3 2]) - cmat)'));
        if ~isempty(f)
            ind = ErrPtrs(f(1),1);
            dir = -1;
            e_ptr = e(ind);
            exists = 1;
        end
    end
end

%-------------------------------------------------    
function name=i_uniquename(l,name)
%-------------------------------------------------    

%exprList/uniqueName
%newName=uniquename(l,name);
% Given an inputname, this function suggests a unique name or returns the input
% name if it was unique in the list.
for i=1:length(l)
    if isvalid(l(i))
   currentName=l(i).getname;
   if strcmp(name,currentName)
      for j = 0:length(name)-1
         if isempty(str2num((name(end-j))))
            break;
         end
      end
      if j == 0
         num = 1;
      else
         num = str2num(name(end-j+1:end)) + 1;
      end
      name = [name(1:end-j) num2str(num)];
   end
end
end


%------------------------------------------------------------------
function [iserr,l,r] = i_isErrorExpr(obj)
%------------------------------------------------------------------
iserr = 0; l = []; r = [];
if isa(obj,'cgsubexpr')
    l = get(obj,'left');
    r = get(obj,'right');
    if length(l)==1 & isvalid(l) & length(r)==1 & isvalid(r)
        iserr = 1;
    end
end
    
