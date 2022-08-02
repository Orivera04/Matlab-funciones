function mmkeep(varargin)
%MMKEEP Clear Variables or Functions Except for Those Listed. (MM)
% MMKEEP VAR1 VAR2 ... clears all variables except those specified.
% MMKEEP VARIABLES VAR1 VAR2 ... does the same as the above.
% MMKEEP GLOBAL VAR1 VAR2 ... clears global variable values except those listed.
% MMKEEP FUNCTIONS FUN1 FUN2 ... clears functions except those listed.
%
% The wildcard character * can be used to keep items that match a pattern.

% See also CLEAR, WHO, INMEM

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/19/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<1
   error('One or More Input Arguments Required.')
end
switch lower(varargin{1})
case 'global'
   varargin(1)=[];
   names=evalin('base','who(''global'')');
case 'functions'
   varargin(1)=[];
   names=inmem;
case 'variables'
   varargin(1)=[];
   names=evalin('base','who');
otherwise
   names=evalin('base','who');
end
if length(names)==0
   disp('There are No Items to Clear from the Workspace.')
   return
end
keep=logical(zeros(1,length(names)));
names=char(names);       % convert to string array for faster searching
for i=1:length(varargin) % look for keepers in list of names
   var=varargin{i};
   if var(end)=='*'
      idx=strmatch(var(1:end-1),names);
   else
      idx=strmatch(var,names,'exact');
   end
   if ~isempty(idx)
      keep(idx)=1; % mark keepers
   end
end
if sum(keep)==0
   disp('Input Arguments Do Not Exist in Workspace. No Items Cleared.')
   return
end
names(keep,:)=[]; % remove keepers from list
names=[repmat(' ',size(names,1),1) names]; % add initial spaces
names=cellstr(names); % convert to cells for list processing
%str=['clear' names{:}] % view eval string
if length(names)>0
   evalin('base',['clear' names{:}])
end
