function varargout = rfblksmathamp1(block, action)
%RFBLKSMATHAMP1 Mask function for the math aplifier block

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:40:23 $

% Set index to mask parameters
setblockfieldindexes(block);
allparams = get_param(block,'MaskWsVariables');

%**************************************************************************
% Action switch -- Determines which of the callback functions is called
%**************************************************************************
switch(action)
case 'rfInit'
    % Get the block parameters
    model_select = get_param(block,'model_select');
    method_select = get_param(block,'method_select');
    linGaindB = allparams(idxLinGaindB).Value;
    iip3 = allparams(idxIip3).Value;
    GindB = allparams(idxGindB).Value;
    GoutdB = allparams(idxGoutdB).Value;
    c1 = 1;
    switch model_select
    case 'Linear'
        method = 0;
        c1 = 10^(linGaindB/20);
        inputGain = 1;
        outputGain = 1;
    case 'Cubic polynomial'
        method = 1;
        c1 = 10^(linGaindB/20);
        inputGain = sqrt(3/(10^((iip3-30)/10)));
        outputGain = c1/inputGain;
    case 'Hyperbolic tangent'
        method = 2;
        c1 = 10^(linGaindB/20);
        inputGain = sqrt(3/(10^((iip3-30)/10)));
        outputGain = c1/inputGain;
    case 'Saleh model',
        method = 3;
        inputGain = 10^(GindB/20);
        outputGain = 10^(GoutdB/20);
    case 'Ghorbani model',
        method = 4;
        inputGain = 10^(GindB/20);
        outputGain = 10^(GoutdB/20);
    case 'Rapp model',
        method = 5;
        c1 = 10^(linGaindB/20);
        inputGain = c1;
        outputGain = 1;
    end

    k=1.380650e-23; % Boltzmann's constant, J/K

    switch method_select
    case 'Noise temperature',
        ntemp = allparams(idxNtemp).Value;
        T = ntemp;
    case 'Noise figure',
        nfigure = allparams(idxNfigure).Value;
        nfactor = 10.^(0.1*nfigure);
        T = 290*(nfactor-1);
    case 'Noise factor',
        nfactor = allparams(idxNfactor).Value;
        T = 290*(nfactor-1);
    end

    kT=k*T;

    varargout{1} = c1;  
    varargout{2} = method;  
    varargout{3} = inputGain;  
    varargout{4} = outputGain;  
    varargout{5} = kT;  

case 'rfModel'
    % Get the model type
    model_select = get_param(block,'model_select');
    Vis   = get_param(block, 'MaskVisibilities');

    % Set visibilities
    switch model_select
    case 'Linear',
        idxOn = [idxLinGaindB];
        idxOff = [idxGindB idxIip3 idxAm2pm idxAmam idxAmpm idxX idxY idxP idxGoutdB idxVsat];

    case 'Cubic polynomial',
        idxOn = [idxLinGaindB idxIip3 idxAm2pm];
        idxOff = [idxGindB idxAmam idxAmpm idxX idxY idxP idxGoutdB idxVsat];

    case 'Hyperbolic tangent',
        idxOn = [idxLinGaindB idxIip3 idxAm2pm];
        idxOff = [idxGindB idxAmam idxAmpm idxX idxY idxP idxGoutdB idxVsat];

    case 'Saleh model',
        idxOn = [idxGindB idxAmam idxAmpm idxGoutdB];
        idxOff = [idxLinGaindB  idxIip3 idxAm2pm idxX idxY idxP idxVsat];

    case 'Ghorbani model',
        idxOn = [idxGindB idxX idxY idxGoutdB];
        idxOff = [idxLinGaindB  idxIip3 idxAm2pm idxAmam idxAmpm idxP idxVsat];

    case 'Rapp model',
        idxOn = [idxLinGaindB idxP idxVsat];
        idxOff = [idxGindB idxIip3 idxAm2pm idxAmam idxAmpm idxX idxY idxGoutdB];

    end

    [Vis{idxOn}] = deal('on');
    [Vis{idxOff}] = deal('off');
    set_param(block,'maskvisibilities', Vis);

case 'rfMethod'
    % Get the noise type
    method_select = get_param(block,'method_select');
    Vis   = get_param(block, 'MaskVisibilities');

    % Set visibilities
    switch method_select
    case 'Noise temperature',
        idxOn = [idxNtemp];
        idxOff = [idxNfigure idxNfactor];
    case 'Noise figure',
        idxOn = [idxNfigure];
        idxOff = [idxNtemp idxNfactor];
    case 'Noise factor',
        idxOn = [idxNfactor];
        idxOff = [idxNtemp idxNfigure];
    end
    [Vis{idxOn}] = deal('on');
    [Vis{idxOff}] = deal('off');
    set_param(block,'maskvisibilities', Vis);
                        
end
