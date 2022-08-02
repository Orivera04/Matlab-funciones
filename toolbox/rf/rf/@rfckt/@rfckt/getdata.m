function data = getdata(h)
%GETDATA Get the data.
%   DATA = GETDATA(H) gets the RFDATA property of the RFCKT object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:37:32 $

% Get the result
data =  get(h, 'RFdata');
if(isempty(data))
    cktname = get(h, 'Name');
    id = sprintf('rf:%s:getdata:NoData', strrep(class(h),'.',':'));
    error(id, sprintf('%s has no data; analyze first.', cktname));
end
