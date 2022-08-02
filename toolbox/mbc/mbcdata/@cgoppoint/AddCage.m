function [op,fact_i,ptr,e] = AddCage(op,varargin)
% op = AddCage(op,index) creates a new value, assigned to factor(index).
%     The current pointer is overwritten.
%     A suitable name is generated, based on the original column name.
% op = AddCage(op,index,name) assigns the factor as above, using the
%     given name rather than a generated name.
% op = AddCage(op,ptr) adds a new factor to the dataset, assigned to ptr.
%      (call to addfactor)
% op = AddCage(op,name) creates a new value and assigns this to a new
%      factor.
%
% [op,index,ptr] = AddCage(...) returns the assigned factor index 
%      and the assigned value pointer.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:00 $

name = ''; fact_i = []; addptr = []; ename = [];

if ~isa(op,'cgoppoint')
    error('cgoppoint::addcage: cgoppoint object expected.');
elseif nargin<2
    error('cgoppoint::addcage: insufficient arguments.');
end
argsused = 2;
switch class(varargin{1})
case 'double'
    fact_i = varargin{1};
    if ~ismember(fact_i,1:length(op.ptrlist))
        error('cgoppoint::addcage: bad index into factors.');
    elseif length(fact_i)~=1
        error('cgoppoint::addcage: single index required.');
        %elseif isvalid(op.ptrlist(fact_i))
        %error('cgoppoint::addcage: factor already assigned.');
    end
    if nargin>2 & ischar(varargin{2})
        % given name
        name = varargin{2};
        argsused = 3;
    elseif isempty(op.orig_name{fact_i})
        % Check for orig_name empty - error.
        error('cgoppoint:addcage: cannot generate name for this factor.');
    else
        % don't check name - rely on orig_names being unique
        % generate suitable name
        name = op.orig_name{fact_i};
    end
case 'xregpointer'
    addptr = varargin{1};
    if length(addptr)~=1
        error('cgoppoint::addcage: single xregpointer required.');
    end
case 'char'
    name = varargin{1};
otherwise
    error('cgoppoint::addcage: check usage.');
end

if ~isempty(name)
    % dummy range for value
    %  length>1, so that it is a required dataset input
    %  (so if two datasets are in session, relevant input in each dataset
    %   must be assigned to this value for error to be calculated)
    name = uniquename(op,name,fact_i);
    newptr = cgvalue(name,[0 1]);
end

if ~isempty(fact_i) & ~isempty(newptr)
    % assign new value to factor
    % Flag as unique to dataset
    op = set(op,fact_i,'ptr',newptr,'created_flag',1);
    if ~op.factor_type(fact_i) %'ignore'
        op = set(op,fact_i,'factor_type',1);
    end
    ptr = newptr;
elseif ~isempty(addptr)
    % add factor to dataset
    op = addfactor(op,addptr,'grid_flag',1);
    ptr = addptr;
    fact_i = length(op.ptrlist); %return new factor index
elseif ~isempty(newptr)
    % add new ptr as new factor to dataset
    op = addfactor(op,newptr,'grid_flag',1,'created_flag',1,...
        'orig_name',{name});
    ptr = newptr;
    fact_i = length(op.ptrlist);%return new factor index
else
    error('something gone wrong');
end
