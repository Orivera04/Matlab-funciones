function SetLabelFontSize(FontSize, MarkerSize, bReportFontSize)

%  function SetLabelFontSize(FontSize, MarkerSize, bReportFontSize)
%
%  Operates on the current figure, and sets all labels to FontSize.
%
%  Inputs:
%	FontSize:	(Optional) The default fontsize is 14
%	MarkerSize:	(Optional) The default MarkerSize is the FontSize
%
%	bReportFontSize:    (Optional)  Boolean, Causes SetLabels to report 
%			the fontsize of each string item is finds
%
%  Options:	A FontSize of -1 causes the child structure of the 
%		current figure to be printed
%
%  Example:
%   tt = 0:0.2:10;
%   plot(tt, sin(tt), 'b+-')
%   xlabel('Time [sec]'); ylabel('Amplitude');
%   SetLabels(16, 12)  %% Sets the FontSize of all text items 
%		       %%  of the current figure to 16 points, 
%		       %%  and the MarkerSize of all markers in 
%		       %%  the current figure to 14 points. 
%
%
%  Modification History
%	16 Jun 03 BSRA	Picked up text in subplots 
%	01 Mar 04 BSRA	Added test for 'Type' because step creates subplots
%			which don't have 'FontSize'
%	13 DEC 05 BSRA  Added bReportFontSize to report the items and f sizes
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Copyright 2000 - 2005,  Brian S R Armstrong.  
%
%  Rights to copy, transmit and modify this file are granted, so long 
%  as this notice is preserved. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if nargin < 1, FontSize = 14; end
  if nargin < 2, MarkerSize = FontSize; end
  if nargin < 3, bReportFontSize = 0; end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Display children
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if FontSize == -1, 
   Items = gcf;
   kItem = 0;
   NItems = length(Items);

   while(NItems > 0)
    kItem=kItem+1;
    gcItem = Items(1);
    gcParent = get(gcItem, 'Parent'); ParentType = get(gcParent, 'Type');
    Type = get(gcItem, 'Type'); 
    sprintf('kItem: %4d; ID: %8.4f; Type: %s; Parent Type: %s', ...
		kItem, gcItem, Type, ParentType),,
    get(gcItem),,

    IChildren = get(gcItem, 'Children');
    Items = [Items(2:NItems); IChildren];

	%% If these items are present, add them to the list
    if isprop(gcItem, 'Title'),  Items = [Items; get(gcItem, 'Title')];  end 
    if isprop(gcItem, 'XLabel'), Items = [Items; get(gcItem, 'XLabel')]; end 
    if isprop(gcItem, 'YLabel'), Items = [Items; get(gcItem, 'YLabel')]; end 
    if isprop(gcItem, 'ZLabel'), Items = [Items; get(gcItem, 'ZLabel')]; end 

    NItems = length(Items);
   end	%% while 

   return
  end   %%  if FontSize == -1, 

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Run Across All Children
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  Items = gcf;
  kItem = 0;
  NItems = length(Items);

  while(NItems > 0)
    gcItem = Items(1);
    kItem=kItem+1;
%    Type = get(gcItem, 'Type');
%    get(gcItem); 

    IChildren = get(gcItem, 'Children');
    Items = [Items(2:NItems); IChildren];

	%% Set the font size 
    if bReportFontSize, 
     if isprop(gcItem, 'FontSize'), GSize = get(gcItem, 'FontSize'),
       if isprop(gcItem, 'String'), String = get(gcItem, 'String'), end 
       if isprop(gcItem, 'Tag'),    Tag    = get(gcItem, 'Tag'), end 
     end 
     if isprop(gcItem, 'MarkerSize'),   Marker = get(gcItem, 'Marker'),
         MSize = get(gcItem, 'MarkerSize'), end

    else 
     if isprop(gcItem, 'FontSize'),   set(gcItem, 'FontSize', FontSize); end 
     if isprop(gcItem, 'MarkerSize'), set(gcItem, 'MarkerSize', MarkerSize);end
    end 
	%% If these items are present, add them to the list
    if isprop(gcItem, 'Title'),  Items = [Items; get(gcItem, 'Title')];  end 
    if isprop(gcItem, 'XLabel'), Items = [Items; get(gcItem, 'XLabel')]; end 
    if isprop(gcItem, 'YLabel'), Items = [Items; get(gcItem, 'YLabel')]; end 
    if isprop(gcItem, 'ZLabel'), Items = [Items; get(gcItem, 'ZLabel')]; end 

    NItems = length(Items);

   end	%% while 

return	%% SetLabels


