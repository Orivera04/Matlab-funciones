function [result, errstr] = ishdlable(filterobj)
%ISHDLABLE True if HDL can be generated for the filter object.
%   ISHDLABLE(Hq) determines if HDL code generation is supported for the
%   quantized filter object Hq and returns 1 if true and 0 if false.
%
%   The determination is based solely on the FILTERSTRUCTURE property of
%   the quantized filter.
%
%   The optional second return value is a string that specifies why HDL
%   could not be generated for the filter object Hq.
%
%   See also QFILT/GENERATEHDL.

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/01/25 22:44:52 $ 

fir_filter_structures = {'fir', 'firt', 'antisymmetricfir', 'symmetricfir'};
iir_filter_structures = {'df1', 'df1t', 'df2', 'df2t'};

filterstruct = filterstructure(filterobj);

if any(strcmpi(filterstruct, fir_filter_structures))
    result = logical(1);
    errstr = '';
elseif issos(filterobj)
    result = logical(any(strcmpi(filterstruct, iir_filter_structures)));
    if result
      errstr = '';
    else
      errstr = sprintf('HDL generation for the filter structure %s is not supported.',...
                       filterstruct);
    end

else
    result = logical(0);
    errstr = ['HDL generation is only supported for ',...
              sprintf('''%s'' ', fir_filter_structures{:}),...
              'and ',...
              sprintf('''%s'' ', iir_filter_structures{:}),...
              'SOS filter structures.'];
end

% [EOF]

