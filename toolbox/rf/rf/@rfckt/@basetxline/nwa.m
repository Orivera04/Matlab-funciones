function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/20 23:19:33 $

error(nargchk(2,2,nargin));

% Allocate memory for netparameters
nport = get(h, 'nPort');
netparameters  = zeros(nport,nport,length(freq));

switch upper(h.get('StubMode'))
    % transmission line is not a stub
    case 'NONE'
        % when Termination is not empty or 'None'
        if ~(isempty(h.Termination) || strcmpi(h.Termination, 'None'))
            id = ['rf:rfckt:basetxline:nwa:TerminationIgnored'];
            warning(id, ['Termination ''', h.Termination, ...
                ''' is ignored in calculation ',...
                'when StubMode is set to None.'])
        end
        e_negkl = calckl(h, freq);
        e_kl = 1./e_negkl;
        z0 = get(h, 'Z0');
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