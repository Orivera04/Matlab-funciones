function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  contable1 object are :
%
%     breakx:  breakpoint vector
%     table:  table values vector
%     factors:  [N,M]  factors to use for breakpoints(N) and table(M)
%     le:    0/1  use "<=" if 1, ">=" if 0
%     model:  a model to use as a basis for default settings
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:59:17 $

msg={};
for n=1:2:length(varargin)
   val=varargin{n+1};
   switch lower(varargin{n})
   case 'breakx'
      if any(diff(val)<0)
         msg(end+1)={'Breakpoints must be increasing'};
      else
         c.breakcols=val(:)';
         L=length(c.breakcols);
         if L>length(c.table)
            c.table=[c.table ones(1,L-length(c.table))];
         elseif L<length(c.table)
            c.table=c.table(1:L);
         end
      end
   case 'table'
      c.table=val(:)';
      L=length(c.table);
      if L>length(c.breakcols)
         c.breakcols=[c.breakcols repmat(c.breakcols(end),1,L-length(c.breakcols))];
      elseif L<length(c.breakcols)
         c.breakcols=c.breakcols(1:L);
      end
   case 'factors'
      if length(val(:))==2 & all(val<=c.size) & all(val)
         c.factors=val(:)';
      else
         msg(end+1)={'Factor index is too high'};
      end
   case 'le'
      c.le=val;
   case 'model'
      lims=gettarget(val);
      if nfactors(val)>=2
         c.breakcols= linspace(lims(c.factors(1),1),lims(c.factors(1),2),length(c.breakcols));
         if c.le
            c.table= repmat(lims(c.factors(2),2),1,length(c.table));
         else
            c.table= repmat(lims(c.factors(2),1),1,length(c.table));
         end
      end
   end
end