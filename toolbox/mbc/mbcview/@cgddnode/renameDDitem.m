function [ok, syms] = renameDDitem(ddnode, pCurr, newstr)
%RENAMEDDITEM Rename callback for Variable Dictionary
%
%  OK = RENAMEDDITEM(DD, PITEM, NEWSTR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:23:46 $

p = project(ddnode);
syms = null( xregpointer, 0 );
if isvarname(newstr)
   ok=isuniquename(p,newstr);
   if ok
      str=getname(pCurr.info);
      pCurr.info= setname(pCurr.info, newstr);
      
      % Check for occurrence of renamed item in symvals
      % and update the equation string if necessary
      syms = insymval(ddnode, pCurr);
      for n = 1:length(syms)
          syms(n).info = syms(n).updatenames;
      end
   end  
else
    ok=0;
end