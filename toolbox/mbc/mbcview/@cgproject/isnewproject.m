function out=isnewproject(P)
%ISNEWPROJECT  Attempts to determine whether the Project is new
%
%  OUT=ISNEWPROJECT(P)
%
%  NOTE:  This function CANNOT absolutely determine whether the project
%  is unchanged from a completely new one.  This function should not be used
%  as part of critical code that could lead to data loss!
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:28:17 $

out = 0;

[pth,fnm] = fileparts(P.filename);

if strcmp(fnm,'Untitled') | strcmp(fnm,'\Untitled') | isempty(fnm)
   refs= preorder(P,'getptrs');
   if ~isempty(refs)
      if iscell(refs)
         refs=[refs{:}];
      end
      refs = unique(refs);
      refs= refs(refs~=0);
      if length(refs)==2
         % remove the known project and DD
         refs(refs==address(P))=[];
         refs(refs==getdd(P))=[];
         if length(refs)==0
            out=1;
         end
      end
   end
end
