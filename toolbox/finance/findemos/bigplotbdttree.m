function bigplotbdttree()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 0000/00/00 00:00:00


%Unpack the zero curve from the global variable
global GDISCTREE;

DiscTree = GDISCTREE;

%If the zero curve is not empty, plot it in the axes of the current figure
%window
if (~(DiscTree.ErrorFlag))
     
     BDTTreeAxesHandle = findobj('Tag', 'AxesViewBDTTree');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
     
     axes(BDTTreeAxesHandle);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     
    
     RateTree = bdttrans(DiscTree);
     
     plotbintree(RateTree, DiscTree.Dates);
     
     dtaxis;
     
     plotscale(0.10);
     
     set(gca, 'Tag', 'AxesViewBDTTree');
     
     xlabel('Tree Date');
     ylabel('Short Rate');
     
end


