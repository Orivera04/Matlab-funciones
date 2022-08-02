function obj = cgoptimtablefiller(varargin)
%CGOPTIMTABLEFILLER Constructor for cgoptimtablefiller
%
%  CGOPTIMTABLEFILLER is an object that fills a set of tables from the
%  results of an optimization. 
% 
%  OBJ = CGOPTIMTABLEFILLER creates an empty CGOPTIMTABLEFILLER object. 
%  OBJ = CGOPTIMTABLEFILLER(PTABS) creates a CGOPTIMTABLEFILLER object that
%  will be able to fill the tables in the (1-by-NTABS) pointer array,
%  PTABS. 
%  OBJ = CGOPTIMTABLEFILLER(PTABS, PFILL, SOLTYPE, SOLINDEX) creates a
%  CGOPTIMTABLEFILLER object that will be able to fill PTABS with the
%  optimization output data corresponding to output factors in the
%  (1-by-NTABS) pointer array PFILL. The data to fill each table is a
%  vector, V, from the optimization output data cube, D. Specifically,  
%  SOLTYPE{i} = 'solution'       : V = D(:, IND,SOLINDEX) 
%  SOLTYPE{i} = 'pareto'         : V = D(SOLINDEX, IND, :)
%  SOLTYPE{i} = 'weightedpareto' : V = weighted_pareto(:, IND)
% 
%  where IND is the index of PFILL(i) in the pointer list of the
%  optimization output columns.
%
%  See also CGOPTIM/GETSOLUTION 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:06 $

s = i_createstruct;

if ~isempty(varargin)
    in = varargin;
    [ok, msg] = i_CheckInputs(in);
    if ok
        s.tables = varargin{1};
        if nargin > 1
            s.fillfactors = varargin{2};
            s.solutiontype = varargin{3};
            s.solutionindex = varargin{4};
        end
    else
        error(['CGOPTIMTABLEFILLER : ',msg]);
    end
end

obj = class(s, 'cgoptimtablefiller');

%--------------------------------------------------------------------------
function s=i_createstruct
%--------------------------------------------------------------------------
% Create the default structure 
s = struct(...
    'tables', [],... % 1-by-NTAB pointer array of tables to be filled
    'fillfactors', [], ... % 1-by-NTAB pointer array of outputs to fill tables in same order as tables
    'solutiontype', [], ... % 1-by-NTAB cell array of strings specifying the type of solution to be used to fill each table. Each element must be 'solution', 'pareto' or 'weightedpareto'
    'solutionindex', [], ... % 1-by-NTAB cell array of indices into data for each table. See comment below.
    'version', 1);

%--------------------------------------------------------------------------
function [ok, msg] = i_CheckInputs(in)
%--------------------------------------------------------------------------

ok = false;
msg = '';
tables = in{1};
[notneeded, msg] = pCheckTables(tables);
if length(in) == 4
    fillfactors = in{2};
    solutiontype = in{3};
    solutionindex = in{4};
    [notneeded, msg] = pCheckTableLinks(fillfactors, solutiontype, solutionindex);
elseif length(in) > 1
    msg = 'CGOPTIMTABLEFILLER accepts 0, 1 or 4 input arguments';
else
    % single input case - already checked
end

if isempty(msg)
    ok = true;
end
    





