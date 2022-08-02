function [result, errstr] = ishdlable(Hb)
%ISHDLABLE True if HDL can be generated for the filter object.
%   ISHDLABLE(Hd) determines if HDL code generation is supported for the
%   filter object Hd and returns true or false.
%
%   The determination is based on the filter structure and the 
%   arithmetic property of the filter.
%
%   The optional second return value is a string that specifies why HDL
%   could not be generated for the filter object Hd.
%
%   See also DFILT, GENERATEHDL.

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/01/25 23:05:50 $ 

% M-file help for ishdlable method.

% [EOF]

