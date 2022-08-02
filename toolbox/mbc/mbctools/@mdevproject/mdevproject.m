function P= mdevproject(fname,inf,dlist);
%MDEVPROJECT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:03:42 $



if nargin==0
   % call from Matlab during loading
   loadstr=1;
	fname= 'Untitled';
	inf=[];
	dlist=[];
   P = i_defaultstruct(fname,inf,dlist);
	mdev= modeldev;
elseif nargin==1 & isstruct(fname)
   % call from loadobj
   loadstr=1;
   mdev = fname.modeldev;
   P = rmfield(fname,'modeldev');
else
	loadstr=0;
   P = i_defaultstruct(fname,inf,dlist);
   [PATH,NAME,EXT] = fileparts(fname);
   mdev= modeldev(NAME,{xregcubic,[],[],'project'});
end

P.ProjectVersion = 5;
P= class(P,'mdevproject',mdev);

if ~loadstr
   user = getusername(initfromprefs(mbcuser));
	P.History= struct('User', initfromapp(mbcuser), 'Action', ['Created by ' user], 'Date', now);
	ptr=pointer(P);
	P= info(ptr);
end



function P = i_defaultstruct(fname,inf,dlist)
P= struct('loader', mbcloadstart, ...
    'Version',mbcver,...
    'Filename',fname,...
    'Information',inf,...
    'History',[],...
    'Modified',0,...
    'Datalist',dlist,...
    'heap',[],...
    'ProjectVersion',[], ...
    'SavedMBCVersion', '', ...
    'SavedAddonVersions', {cell(0,2)});