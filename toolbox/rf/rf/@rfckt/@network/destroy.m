function h = destroy(h,destroyData)
%DESTROY Destroy this object

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:17 $

% Delete objects associated with this object
ckts = get(h, 'Ckts');
nckts = length(ckts);

for i=1:nckts
    ckt = ckts{i};
    if isa(ckt,'rfckt.rfckt'); delete(ckt); end;
end

if isa(h.RFdata,'rfdata.data')
    delete(h.RFdata);
end