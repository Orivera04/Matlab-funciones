function result = checkfrequency(h, freq)
%CHECKFREQUENCY Check the frequency.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/03/05 18:19:29 $

% Set the default                                                          
result = [];                                                               
% Get the input FREQ                                                       
f = squeeze(freq);                                                         
freqpoint = size(f);                                                       
d1 = freqpoint(1);                                                         
d2 = freqpoint(2);                                                         
% Check the frequency                                                      
if((d1==1 || d2==1) && ~isempty(f) && isreal(f) && all(f >= 0) && ...
        isnumeric(f) && ~any(isinf(f)))                           
    if(d1 == 1)                                                           
        result = f';                                                      
    elseif (d2 == 1)                                                      
        result = f;                                                       
    end                                                                   
    result = sort(result);                                                
end    

if isempty(result)
    id = sprintf('rf:%s:checkfrequency:FrequencyNotRignt', strrep(class(h),'.',':'));
    error(id, 'Wrong input: frequency must be a positive vector.');
end
