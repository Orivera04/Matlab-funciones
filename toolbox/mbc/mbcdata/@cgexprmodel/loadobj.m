function E = loadobj(Eold)
% cgExprModel \ loadobj
% required to do the right thing with the pointers this object contains

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/04/04 03:25:51 $
if isa(Eold,'struct')
   E = cgexprmodel;
   
   % transfer unchanged properties
   E.valPtrs = Eold.valPtrs;
   if isa(Eold.xregexportmodel , 'xregexportmodel')
      E.xregexportmodel = Eold.xregexportmodel;
   end
   
   if ~isfield(Eold,'version')
      % pre version 2 object
      if ~isfield(Eold,'store')
         % This is the original structure.  The allPtrs field may contain either
         % a pointer vector (older versions) or an old exprlist (newer versions)
         % plus the store of a pointer heap
         if iscell(Eold.allPtrs) & length(Eold.allPtrs) == 2
            % This corresponds to a saved heap of the local pointers.  Temporarily
            % move them into store to avoid mapptr - they will be moved back later
            E.store = [{Eold.modObj}, {Eold.allPtrs{1}(:)'},  Eold.allPtrs(2)];
            E.allPtrs = [];
            E.modObj=[];
         else
            % This reference operation will convert any exprlist into a plain
            % xregpointer, and it also works on xregpointers
            E.allPtrs = Eold.allPtrs(:)';
         end
      else
         % second iteration of object structure: store field added.  Again the allPtrs 
         % field may contain pointers (newer versions) or an exprlist (older versions)
         if isempty(Eold.store)
            % newer version - does not use store, pointers need to be mapped properly
            E.allPtrs=Eold.allPtrs;
            E.modObj=Eold.modObj;
         elseif ~isempty(Eold.allPtrs)
            E.store={Eold.modObj, Eold.allPtrs(:)',Eold.store};
            E.modObj=[];
            E.allPtrs = [];
         else
            % No pointers saved - make sure there is no legacy heap structure remaining
            E.modObj=Eold.modObj;
            E.store=[];
         end
      end
   else
      E.allPtrs=Eold.allPtrs;
      E.modObj=Eold.modObj;
   end
else
   E = Eold;
end