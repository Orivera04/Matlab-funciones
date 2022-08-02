function result = ga(h)
%GA Calculate the available power gain.
%   RESULT = PA(H) calculates the available power gain of the data object. 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:14 $

% Set the default 
result = 1;
smatrix = get(h, 'S_Parameters');
if ~isempty(smatrix)
    gammas = (h.Zs - h.Z0) ./ (h.Zs + h.Z0);
    % Analysis and Design, p187
    gammaout = smatrix(2,2,:) + smatrix(1,2,:) .* smatrix(2,1,:) .* gammas ./ ...
        (1 - smatrix(1,1,:) .* gammas);
    % Analysis and Design, p187
    temp = (abs(1 - smatrix(1,1,:) .* gammas) .^ 2) .* (1 - (abs(gammaout) .^ 2));
    index = find(temp == 0);
    if ~isempty(index)
        temp(index) = eps;
    end

    result = (1 - abs(gammas) .^ 2) .* (abs(smatrix(2,1,:)) .^ 2) ./ temp;
    result = result(:);
    % Analysis and Design, (3.2.4) p213
end
