function [Wc]= eval(c,varargin)
%EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:14 $

Wc=1;
if ~isempty(c.wfunc)
   % simple weighting function
   w= feval(c.wfunc,c,varargin{:});
   nc= length(w);
   if nc<100
      Wc= diag(w);
   else
      % use sparse matrices if > 100x100
      Wc= spdiags(w,0,nc,nc);
   end
end

if ~isempty(c.cfunc)
   % correlation function
   C= feval(c.cfunc,c,varargin{:});
   w2= sqrt(diag(Wc));
   if issparse(Wc) & length(Wc)>1
      w2= spdiags(w2,0,nc,nc);
   else
      w2= diag(w2);
   end
   Wc= w2*C*w2;
end  
