function C = itemlist2cell(ItemList);

% function C = itemlist2cell(ItemList);
% 
% Returns a cell array from an item list supplied in any of the formats
% that can be used for the String property of ListBox- and PopupMenu-
% style uicontrols:  a cell array of strings, a padded string matrix,
% or a string vector separated by vertical slash (`|') characters.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

C = {};
if ~isempty(ItemList)
   if iscell(ItemList)
      C = ItemList;                    % cell array of strings
   elseif ndims(ItemList) == 2 & size(ItemList, 1) > 1
      C = deblank(cellstr(ItemList));  % padded string matrix
   else
      while ~isempty(ItemList)         % slash-separated string
         [Token, ItemList] = strtok(ItemList, '|');
         C = [C {Token}];
      end
   end
end
