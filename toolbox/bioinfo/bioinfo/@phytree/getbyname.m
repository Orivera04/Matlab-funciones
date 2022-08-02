function sel = getbyname(tr,query)
%GETBYNAME Selects branches and leaves by name.
%
%   S = GETBYNAME(T,EXPRESSION) returns a logical vector S of size 
%   [NUMNODES x 1] indicating the node names of the phylogenetic tree T
%   that match the regular espression EXPRESSION regardless of case. 
%
%   Symbols than can be used in a matching regular expression are explained
%   in help REGEXP.
%
%   When EXPRESSION is a cell array of strings, GETBYNAME returns a matrix
%   where every column corresponds to every query in EXPRESSION.
%
%   Example:
%
%     % Load a phylogenetic tree created from a protein family:
%      tr = phytreeread('pf00002.tree');
%       
%      % Select all the 'mouse' and 'human' proteins:
%      sel = getbyname(tr,{'mouse','human'});
%      view(tr,any(sel,2));
%       
%   See also PHYTREE, PHYTREE/PRUNE, PHYTREE/SELECT, PHYTREE/GET.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Author: batserve $ $Date: 2004/03/09 16:15:19 $

tr=struct(tr);
numLabels = numel(tr.names);
if iscell(query)
    sel = false(numLabels,numel(query));
    for ind = 1:numel(query)
        try
            regexpiOutput = regexpi(tr(:).names,query{ind});
        catch
            error('Bioinfo:IncorrectRegularExpression',...
              ['The query expression produced the following error in ' ...
              'REGEXPI: \n%s'],lasterr);
        end
        sel(:,ind) = ~cellfun('isempty',regexpiOutput);
    end
else % must be a single string of chars
    try
        regexpiOutput = regexpi(tr(:).names,query);
    catch
        error('Bioinfo:IncorrectRegularExpression',...
              ['The query expression produced the following error in ' ...
              'REGEXPI: \n%s'],lasterr);
    end
    sel = ~cellfun('isempty',regexpiOutput);

end
