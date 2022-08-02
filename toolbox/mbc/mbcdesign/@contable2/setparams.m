function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  contable1 object are :
%
%     breakx:  breakpoint vector
%     breaky:  breakpoint vector
%     table:  table values matrix
%     factors:  [I,J,K]  factors to use for breakx (I), breaky (J) and table (K)
%     le:    0/1  use "<=" if 1, ">=" if 0
%     model:  a model to use as a basis for default settings
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:59:25 $

msg={};
for n=1:2:length(varargin)
   val=varargin{n+1};
   switch lower(varargin{n})
   case 'breakx'
      if any(diff(val)<=0)
         msg(end+1)={'X breakpoints must be increasing'};
      else
         c.breakcols=val(:)';
         L=length(c.breakcols);
         if L>size(c.table,2)
            c.table(:,end+1:L)=1;
         elseif L<length(c.table)
            c.table=c.table(:,1:L);
         end
      end
   case 'breaky'
      if any(diff(val)<=0)
         msg(end+1)={'Y breakpoints must be increasing'};
      else
         c.breakrows=val(:)';
         L=length(c.breakrows);
         if L>size(c.table,1)
            c.table(end+1:L,:)=1;
         elseif L<length(c.table)
            c.table=c.table(1:L,:);
         end
      end
   case 'table'
      c.table=val;
      L=size(c.table,1);
      if L>length(c.breakrows)
         c.breakrows=[c.breakrows repmat(c.breakrows(end),1,L-length(c.breakrows))];
      elseif L<length(c.breakrows)
         c.breakrows=c.breakrows(1:L);
      end
      L=size(c.table,2);
      if L>length(c.breakcols)
         c.breakcols=[c.breakcols repmat(c.breakcols(end),1,L-length(c.breakcols))];
      elseif L<length(c.breakcols)
         c.breakcols=c.breakcols(1:L);
      end
   case 'factors'
      if length(val(:))==3 & all(val<=c.size) & all(val)
         c.factors=val(:)';
      else
         msg(end+1)={'Factor index is too high'};
      end
   case 'le'
      c.le=val;
   case 'model'
      lims=gettarget(val);
      if nfactors(val)>=3
         c.breakcols= linspace(lims(c.factors(1),1),lims(c.factors(1),2),length(c.breakcols));
         c.breakrows= linspace(lims(c.factors(2),1),lims(c.factors(2),2),length(c.breakrows));
         if c.le
            c.table= repmat(lims(c.factors(3),2),size(c.table));
         else
            c.table= repmat(lims(c.factors(3),1),size(c.table));
         end
      end
   end
end