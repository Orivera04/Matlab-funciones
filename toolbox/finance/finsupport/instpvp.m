function [ValueList, FoundFlags, TagList, DataList] = instpvp(TagStyle,ParamList,varargin)
%INSTPVP Parameter-value parsing.
%
%   [ValueList, FoundFlags] = instpvp('None',ParamList,...
%        'PARAM1', VALUE1, 'PARAM2', VALUE2, ...)
%   
%   [ValueList, FoundFlags, TagList] = instpvp('Single',ParamList,...
%        'PARAM1', VALUE1, 'PARAM2', VALUE2, ...
%        'TAG1', 'TAG2', 'TAGNTAGS', ... )
%
%   [ValueList, FoundFlags, TagList, DataList] = instpvp('Pair',ParamList,...
%        'PARAM1', VALUE1, 'PARAM2', VALUE2, ...
%        'TAG1', DATA1, 'TAG2', DATA2, 'TAG3', DATA3, ... )
%
%   [...] = instpvp(TagStyle, ParamList, ArgList{:})
%
%
%   Inputs:
%     TagStyle : String of 'None', 'Single', or 'Pair'.  TagStyle
%     determines treatment of arguments which are not matched as
%     Parameter-Value pairs by parameters in ParamList.  
%     1) 'None' - Unmatched arguments generate an error
%     2) 'Single' - Unmatched arguments are listed in TagList
%     3) 'Pair' - Unmatched arguments are treated as Tag-Data pairs, with
%        the parameter tags returned in TagList and the value data
%        returned in DataList.
%     ParamList : NUMPARAM x 1 cell array of string parameter names
%     ArgList: Cell array of arguments for comma-separated list.  All
%
%   Outputs:
%     ValueList : NUMPARAM x 1 cell array of values found for each
%     parameter listed in ParamList.  If the corresponding Parameter was
%     not found in the argument list, the cell is empty.
%
%     FoundFlags : NUMPARAM x 1 logical flags indicating which Parameters
%     in ParamList were found in the argument list.
%
%     TagList : NTAGS x 1 cell array of unmatched arguments.  If TagStyle
%     is 'None', unmatched parameters are an error.
%
%     DataList : NTAGS x 1 cell array of data values for unmatched
%     Tag-Data pairs in the arguments.  If TagStyle is 'Single', all
%     unmatched arguments are listed in TagList, and DataList is empty.
%
%   Note: 
%     Parameters and Tags in Parameter-Value or Tag-Data pairs must be strings.
%

%   Author(s): J. Akao 21-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:40:35 $


%-------------------------------------------------------------------
%-------------------------------------------------------------------
ParamList = cellstr(finargchar(ParamList));
NumParams = length(ParamList);
NumArgs = length(varargin);

% Declare default outputs
ValueList = cell(NumParams,1);
FoundFlags = false(NumParams,1);
TagList = {};
DataList = {};

if NumArgs==0
  return
end
%-------------------------------------------------------------------
%-------------------------------------------------------------------
% Find single-row strings in the argument list
PTagCandMask = ( cellfun('isclass', varargin, 'char') & ...
                 (cellfun('size', varargin, 1)==1)    );
IArgPTag = find(PTagCandMask);

% Locate strings which are reserved parameter names
[Params, IParam, IArgP] = intersect(ParamList, varargin(IArgPTag));
IArgP = IArgPTag(IArgP);

% Get the locations in the argument list of corresponding values
IArgV = IArgP+1;

% Check for existence of value arguments
if any(IArgV > NumArgs)
  IA = max(IArgP);
  error(sprintf('parameter, %s, must have a value\n', varargin{IA}))
end
if ~isempty(intersect(IArgV,IArgP))
  IA = intersect(IArgV,IArgP)-1;
  error(sprintf('parameter, %s, must have a value\n', varargin{IA}))
end

% Copy the arguments to the output
ValueList(IParam) = varargin(IArgV);
FoundFlags(IParam) = 1;

% Check for unused arguments
UnMatchMask = true(NumArgs,1);
UnMatchMask(IArgP) = 0;
UnMatchMask(IArgV) = 0;

if any(UnMatchMask)
  switch TagStyle
   case 'None'
    error('Arguments must be in parameter value pairs')
    
   case 'Single'
    % everyone unmatched goes right to tags
    TagList = varargin(UnMatchMask);
    
   case 'Pair'
    IArgUnM = find(UnMatchMask);

    % check for proper formatting of Tag-Data pairs
    % compute tag and data locations 
    if (rem(length(IArgUnM),2) ~= 0)
      error('Arguments must be in parameter value pairs')
    else
      NumTags = length(IArgUnM)/2;
      IArgT = IArgUnM(1:2:end);
      IArgD = IArgUnM(2:2:end);
      
      if any(IArgD ~= IArgT+1)
        error('Arguments must be in parameter value pairs')
      end
      if any( ~PTagCandMask(IArgT) )
        error('Parameters must be strings')
      end
    end

    % create tags and values
    TagList = varargin(IArgT);
    DataList = varargin(IArgD);

   otherwise
    error(sprintf('unknown TagStyle %s', TagStyle));
  end
end


% varargin is a row, so I need to transpose these
TagList = TagList';
DataList = DataList';
    
