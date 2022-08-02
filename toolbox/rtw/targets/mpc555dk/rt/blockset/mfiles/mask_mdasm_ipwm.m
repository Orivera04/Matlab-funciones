function varargout = mask_mdasm_ipwm(action,block,varargin)
%MASK_MDASM_IPWM
%   Mask parameter processing and code generation
%   function for the waveform measurement
%   block in the MIOS1 library.
%
% Parameters
%    
%    action    -  'init'|'code'
%    block     -  the block to process 
%    

%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.8.4.3 $
%   $Date: 2004/04/19 01:29:41 $

switch lower(action)
case 'init'
    
case 'update_range'
    % update measurement range - need to 
    % call 'code' case to get new values of pmin / pmax, derived
    % from the appropriate clock
    % set range to null in case call to 'code' fails . ie. if config block
    % is missing
    set_param(gcb, 'range', '[]');
    [ notUsedb, pmax, pmin] = mask_mdasm_ipwm('code', gcb);  
    set_param(gcb, 'range', ['[ ', num2str(pmin), ' , ', num2str(pmax), ' ]']);
    
case 'getdispstr'
    % seperate case for deriving the dispstr
    % this allows a display string even if the 
    % 'code' case does not complete
    operation = get_param(gcb,'operation');
    switch operation
    case 'Pulse width'
        dispstr = [ ...
                'Pulse Width\n(MDASM)'];
    case 'Pulse period'
        dispstr = [ ...
                'Pulse Period\n(MDASM)'];
    end
    varargout{1} = dispstr;
    
case 'code'
 
    operation = get_param(gcb,'operation');
    module = get_param(gcb,'module');
    bsl = get_param(gcb,'bsl');
    edpol = get_param(gcb,'edpol');
    fren = get_param(gcb,'fren');
    
    
      
    bdt = get_param(bdroot(block), 'BlockDiagramType');
    switch bdt
    case 'library'
     clock = 1e6; % Dummy value for display purposes
     mlr   = 0  ; % Dummy value for Modulus Latch Register

    case 'model'
       target = RTWConfigurationCB('get_target',block);
       mios1 = target.findConfigForClass('MPC555dkConfig.MIOS1');

        if ~isempty(mios1)
            if strcmp(bsl,'Counter Bus 6 (CB6)')
	      clock = mios1.Modulus_Counter_6.Clock_Frequency;
              mlr = mios1.Modulus_Counter_6.Modulus_Latch_Register;
            elseif strcmp(bsl,'Counter Bus 22 (CB22)')
	      clock = mios1.Modulus_Counter_22.Clock_Frequency;
              mlr = mios1.Modulus_Counter_22.Modulus_Latch_Register;
            else
	      error('Invalid option for bus select parameter')
	    end
        else
             clock = 1e6;
        end
    end
        
        
    if clock == -1 
      error(['Could not evaluate clock frequency: check that MIOS1 - ' bsl ' on the configuration block is enabled']);
    end
    if mlr ~= 0
        error(['The modulus latch register in MIOS1 - ' bsl ' must be 0 for this block to be used. ' ...
        'Please check the configuration block in your model.']);
    end
    scale = 1/clock;
    
    pmin = 1 / clock;
    pmax = 2^16 / clock;
             
    varargout = { scale, pmax, pmin };
   
otherwise
    error([action ' is not supported.']);
end
