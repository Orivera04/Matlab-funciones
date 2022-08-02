function [om,OK]= widthstep(m)
%XREGRBF/WIDTHSTEP an algorithm to to fit widths and do stepwise
%
% [om,OK]= widthstep(m);
% returns an optimisation manager for i_trialwidths, 


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:48:32 $


% @xregrbf\widthstep

 
[omWidth,OK] = trialwidths(m); 

om= contextimplementation(xregoptmgr,m,@i_widthstep,[],'RBF Fit',@widthstep);

om = AddOption(om,'WidthAlgorithm',omWidth,'xregoptmgr', 'Width selection algorithm',2);

[omStep,ok] = minpress(m); 
AllOpts= {@minpress,@forwardselect,@backwardselect,@prune,@lsqom};
omStep = setAltMgrs(omStep,AllOpts);
om = AddOption(om,'StepAlgorithm',omStep,'xregoptmgr', 'Stepwise',2);




function [m,cost,OK,varargout] = i_widthstep(m,om,x0,x,y,varargin)

omWidth= get(om,'WidthAlgorithm');
%match center selection to the new lambda and width
[m,junk,OK]=run(omWidth,m,[],x,y);

omStep= get(om,'StepAlgorithm');
[m,junk,OK]=run(omStep,m,[],x,y);
cost= 0;
