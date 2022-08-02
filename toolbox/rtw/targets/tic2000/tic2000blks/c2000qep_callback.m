function c2000qep_callback(action)
% C2000QEP_CALLBACK Mask Helper Function for the c2000 qep blocks.
%
% $RCSfile: c2000qep_callback.m,v $
% $Revision: 1.1.6.1 $
% $Date: 2004/04/01 16:13:36 $
% Copyright 2004 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end
blk = gcbh;
%
visibility = {'off'; 'on'};
%
positiverotation = 3;
initialcount = positiverotation + 1;
encoderresolution = initialcount + 1;
%
countingmode = strcmp(get_param(blk,'countingmode'),'RPM'); 
visibilityidx = countingmode + 1;

switch action
case 'dynamic'
    mask_visibilities = get_param(blk,'MaskVisibilities');
    mask_visibilities{positiverotation} = visibility {visibilityidx};
    mask_visibilities{encoderresolution} = visibility {visibilityidx};    
    set_param(blk,'MaskVisibilities', mask_visibilities);
end

return

% [EOF] c2000qep_callback.m
