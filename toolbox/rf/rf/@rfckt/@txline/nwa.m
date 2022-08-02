function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2004/04/20 23:19:43 $

error(nargchk(2,2,nargin));
% if freq is empty, return empty output
% if isempty(freq)
%     type = '';
%     netparameters = [];
%     z0 = 50;
%     return
% end

% The following is done in analyze of rfckt
% [row, col] = size(squeeze(freq));
% % Check if Freq is a vector
% if (~(row == 1) && ~(col == 1)) || ~isnumeric(freq) || ~isreal(freq) ||...
%         any(freq <= 0) || any(isinf(freq)) || any(isnan(freq))
%     error('Freq must be a vector whose elements are finite, real and positive.')
% end
% freq = freq(:);

% Allocate memory for netparameters
nport = get(h, 'nPort');
netparameters  = zeros(nport,nport,length(freq));

switch upper(h.get('StubMode'))
    % transmission line is not a stub
    case 'NONE'
        % when Termination is not empty or 'None'
        if ~(isempty(h.Termination) || strcmpi(h.Termination, 'None'))
            id = ['rf:rfckt:txline:nwa:TerminationIgnored'];
            warning(id, ['Termination ''', h.Termination, ...
                ''' is ignored in calculation ',...
                'when StubMode is set to None.'])
        end
        e_negkl = calckl(h, freq);
        e_kl = 1./e_negkl;
        z0 = get(h, 'Z0');
        % Check z0
        if length(z0) == 1
            z0 = z0*ones(size(freq));
        elseif length(z0) ~= length(freq);
            id = sprintf('rf:%s:nwa:Z0Freq',strrep(class(h),'.',':'));
            error(id, 'Length of Z0 must equal length of freq or 1.');
        end
        % type = 'S_PARAMETERS';
        % netparameters(1,1,:)= 0;
        % netparameters(1,2,:)= e_negkl;
        % netparameters(2,1,:)= e_negkl;
        % netparameters(2,2,:)= 0;
        type = 'ABCD_PARAMETERS';
        netparameters(1,1,:) = (e_kl + e_negkl)./2;
        netparameters(1,2,:) = (e_kl - e_negkl).*z0./2;
        netparameters(2,1,:) = (e_kl - e_negkl)./z0./2;
        netparameters(2,2,:) = (e_kl + e_negkl)./2;
        % transmission line is a series stub
    case 'SERIES'
        Z_in = calczin(h, freq);
        type = 'ABCD_PARAMETERS';
        netparameters(1,1,:) = 1;
        netparameters(1,2,:) = Z_in;
        netparameters(2,1,:) = 0;
        netparameters(2,2,:) = 1;
        % transmission line is a shunt stub
    case 'SHUNT'
        Z_in = calczin(h, freq);
        type = 'ABCD_PARAMETERS';
        netparameters(1,1,:) = 1;
        netparameters(1,2,:) = 0;
        netparameters(2,1,:) = 1./Z_in;
        netparameters(2,2,:) = 1;
end

% Simply return z0
z0 = get(h, 'Z0');
