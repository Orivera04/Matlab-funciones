function varargout=varinfo(A,fmt);
% SWEEPSET/VARINFO variable info of sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:46 $



if nargin==1
   fmt=' %3u %-4s %-9s %-39s %-14s %-48s\n';  % FT File Format
   fmt=['ID          : %d\nFormat      : %s\nName        : %s\nDescription : ',...
      '%s\nUnits       : %s\nNotes       : %s'];
end

info=cell(size(A,2),1);
for i=1:size(A,2)
   info{i}=sprintf(fmt  ...
      , A.var(i).id, A.var(i).format, A.var(i).name, A.var(i).descript ...
      , char(A.var(i).units), A.var(i).notes);
end
if nargout>0
   varargout{1}=info;
else
   info=  char(info);
   disp(info);
end

