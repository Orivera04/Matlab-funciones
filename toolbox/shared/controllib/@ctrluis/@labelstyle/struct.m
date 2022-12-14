function s = struct(h)
%STRUCT  Converts to structure

%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:18:16 $
s = struct(...
   'Color',h.Color,...
   'FontAngle',h.FontAngle,...
   'FontSize',h.FontSize,...
   'FontWeight',h.FontWeight,...
   'Interpreter',h.Interpreter);