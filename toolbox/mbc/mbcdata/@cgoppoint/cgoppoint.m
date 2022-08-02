function P = cgOpPoint(varargin)
% cgOpPoint constructor
% Stores a set of operating point data which has
% one column for each factor.
% Each factor has an associated CAGE xregpointer and unit type
%
% P = cgOpPoint creates an empty operating point set
%
% P = cgOpPoint(ptrlist) creates an empty set with factors for each expr on the ptrlist
% P = cgOpPoint(ptrlist,{range}) creates an empty set, but sets the factor ranges
% P = cgOpPoint(ptrlist,[data]) fills the set with the given data
%
% P = cgOpPoint(namelist,...) creates a set with named factors not corresponding to cage expressions.
%   namelist may be a single string or a cell array of names
%
% P = cgOpPoint(... , property, value,...) also sets the property/value pairs
% P = cgOpPoint([],property,value,...) creates a blank oppoint with set property/value pairs
%
% See also: addfactor, addrow, addset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:34 $


P = struct('data',[],...
    'name','',...
    'ptrlist',[],...
    'units',[],...
    'orig_name',[],...
    'factor_type',[],...
    'linkptrlist',[],...
    'overwrite',[],...
    'group',[],...
    'grid_flag',[],...
    'range',[],...
    'constant',[],...
    'tolerance',[],...
    'rules',cgrules,...
    'outliers',[],...
    'created_flag',[],...
    'nogroups', [], ...
    'blocklen', []);

% If a field is added, the following methods should be updated:
%  addfactor, removefactor, horzcat, loadobj, set, get

% What do these fields do?
%  Most contain a vector, one item for each factor.
% Some of the obscurer ones:
%  factor_type: 0 - ignore, 1 - input, 2 - output
%      During evaluation, inputs and outputs behave identically.
%      Ignored columns play no role in evaluation (but may be viewed).
%  linkptrlist: if a valid pointer, use this expression instead of the given factor ptr.
%         Care must be taken to avoid algebraic loops.
%         isValidLink may be used to check for allowable links.
%  overwrite: if this factor is evaluated, where does the result come from?
%            0 - evaluate factor as normal, 1 - take column of data as expression output.
%         Provisos: Ignored factors must have overwrite = 0
%                   Factors which are values must = 1
%                   Unassigned factors must = 1
%
%  group: 0 for no group, otherwise group number of factor.
%        Allows output of evaluation to set the input 
%        ( eg L = A / S, allows setting of A using L)
%        isInGroup may be used to check for possible groups.
%
%  grid_flag (formerly do_range): during a grid-build, determines role of each input:
%      0 - use constant, 1 - use range, 7 - block, 8 - dependant (in group)
%     dependants are re-evaluated to match the gridded input.
%  
%  created_flag = 1 if this factor's ptr does not exist
%     outside the dataset (ie need to free if column deleted)
%                = -1 if factor created from cage.
%
%  rules:  set of filtering rules to select certain points.

P = class(P,'cgoppoint');

if nargin>0
    P = addfactor(P,varargin{:});
end

