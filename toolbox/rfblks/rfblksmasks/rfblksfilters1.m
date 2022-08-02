function varargout = rfblksfilters1(block, action)
%RFBLKSFILTERS1 Mask function for the RF mathematical filter blocks

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/12 23:40:22 $

%**************************************************************************
% Action switch -- Determines which of the callback functions is called
%**************************************************************************
if nargin==1,
    action = 'dynamic';   % mask callback
end

switch action
case 'rfInit'
    % Create User Data
    Udata = get_param(block, 'UserData');
    if isempty(Udata)
        Udata.Version = 1.0;
        Udata.Model = rfmodel.filter;
    end
    % Get the model and datainfo
    model = Udata.Model;
    % Analyze filter 
    analyze(model, block);
    % Update the model
    Udata.Model = model;
    varargout{1} = model;
        
case 'dynamic'
    % Execute dynamic dialogs
    Prompts  = get_param(block, 'MaskPrompts');
    Vis      = get_param(block, 'MaskVisibilities');
    filttype = get_param(block, 'filttype');
    method   = get_param(block, 'method');   

    switch filttype
    case 'Lowpass'
        if (strcmp(method, 'Chebyshev II'))
            Prompts{4} = 'Stopband edge frequency (Hz):';
        else
            Prompts{4} = 'Passband edge frequency (Hz):';
        end
        Vis(5) = {'off'};
        Prompts{5} = '(unused)';
        % Only enable upper-band edge dialog for bandpass or bandstop
    case 'Highpass'
        if (strcmp(method, 'Chebyshev II'))
            Prompts{4} = 'Stopband edge frequency (Hz):';
        else
            Prompts{4} = 'Passband edge frequency (Hz):';
        end
        Vis(5) = {'off'};
        Prompts{5} = '(unused)';
        % Only enable upper-band edge dialog for bandpass or bandstop
    case 'Bandpass'
        Vis(5) = {'on'};
        if (strcmp(method, 'Chebyshev II'))
            Prompts{4} = 'Lower stopband edge frequency (Hz):';
            Prompts{5} = 'Upper stopband edge frequency (Hz):';
        else
            Prompts{4} = 'Lower passband edge frequency (Hz):';
            Prompts{5} = 'Upper passband edge frequency (Hz):';
        end
    case 'Bandstop'
        Vis(5) = {'on'};
        if (strcmp(method, 'Chebyshev II'))
            Prompts{4} = 'Lower stopband edge frequency (Hz):';
            Prompts{5} = 'Upper stopband edge frequency (Hz):';
        else
            Prompts{4} = 'Lower passband edge frequency (Hz):';
            Prompts{5} = 'Upper passband edge frequency (Hz):';
        end
    otherwise
        error('Unknown filter type');
    end

    % Enable the appropriate passband and stopband ripple dialogs
    switch method
    case {'Butterworth','Bessel'}
        Vis{6} = 'off';
        Vis{7} = 'off';
    case 'Chebyshev I',
        Vis{6} = 'on';
        Vis{7} = 'off';
    case 'Chebyshev II',
        Vis{6} = 'off';
        Vis{7} = 'on';
    case 'Elliptic',
        Vis{6} = 'on';
        Vis{7} = 'on';
    otherwise
        error('Unknown filter design type specified.');
    end

    set_param(block,'maskvisibilities',Vis,'maskprompts',Prompts);

otherwise
        
end

