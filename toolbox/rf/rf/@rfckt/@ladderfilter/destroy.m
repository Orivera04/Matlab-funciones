function h = destroy(h,destroyData)
%DESTROY Destroy this object

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/03/30 13:10:54 $

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