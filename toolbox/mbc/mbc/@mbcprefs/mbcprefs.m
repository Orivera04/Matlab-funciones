function p=AppPrefs(varargin)
% APPPREFS  Constructor for an AppPrefs object
%
%   P=APPPREFS creates a preferences object which gives access
%   to an interface for accessing and creating application 
%   preferences.
%   P=APPPREFS(PREFSET) creates an object and attaches to the 
%   given preferences set
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:06 $

% Created 16/6/2000


p.version=1;
p=class(p,'mbcprefs');

pr_datastore('switchtolocal',0);
if nargin  
   i=strmatch('UseClassPrefs',varargin);
   if ~isempty(i)
      pr_datastore('switchtolocal',1);
      varargin(i)=[];
   end
end

% check the persistent storage is initialised
if length(varargin)
   ok=pr_datastore('init',varargin{1});
else
   ok=pr_datastore('init');
end

if ~ok
   warning('Failed to initialise preferences!')
end

return