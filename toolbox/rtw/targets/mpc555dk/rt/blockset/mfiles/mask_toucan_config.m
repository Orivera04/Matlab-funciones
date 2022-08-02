function varargout = mask_toucan_config(action,block,varargin)
%MASK_TOUCAN_CONFIG
% Mask callbacks for the toucan configuration mask

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/19 01:29:52 $

	switch lower(action)
		case 'init'
			simUtil_maskParam('callback',block,'show_mask_config' , ...
				'mask_toucan_config(''show_mask_config'',gcb)');
			simUtil_maskParam('callback',block,'show_tx_config' , ...
				'mask_toucan_config(''show_tx_config'',gcb)');
			simUtil_maskParam('callback',block,'show_bt_config' , ...
				'mask_toucan_config(''show_bit_timing'',gcb)');
			simUtil_maskParam('callback',block,'baud' , ...
				'mask_toucan_config(''baud'',gcb)');
		case 'show_mask_config'
			showhide(@mask_id_config,get_param(block,'show_mask_config'),block)
		case 'show_tx_config'
			showhide(@tx_config,get_param(block,'show_tx_config'),block)
		case 'show_bit_timing'
			showhide(@bit_timing_config,get_param(block,'show_bt_config'),block)
      case 'baud'
         process_baud(block);
      case 'apply'
         varargout = apply(block);
	end

function showhide(fun,state,block)
	switch state
		case 'on'
			feval(fun,'show',block)
		case 'off'
			feval(fun,'hide',block)
	end

function mask_id_config(action,block)
	simUtil_maskParam(action,block,{ 'rxGlobalMask' 'rx14Mask' 'rx15Mask' 'maskType' });

function tx_config(action,block)
	simUtil_maskParam(action,block,{ 'txBuffer' 'txBufferSize' 'irqLevel' });

function bit_timing_config(action,block)
	simUtil_maskParam(action,block,{ 'baud' 'presdiv' 'propseg' 'pseg1' 'pseg2' 'quanta', 'sample_point' 'rjw' });

function process_baud(block)
   selection = get_param(block,'baud');

   simUtil_maskParam('disable',block,{ 'presdiv' 'propseg' 'pseg1' 'pseg2' });
   simUtil_maskParam('enable',block,{ 'quanta','sample_point'});
   switch selection
   case 'Program Registers Manually'
      simUtil_maskParam('enable',block,{'presdiv' 'propseg' 'pseg1' 'pseg2'});
      simUtil_maskParam('disable',block,{ 'quanta','sample_point'});
   case '1 Mb'
   case '500kb'
   case '250kb'
   case '125kb'
   case '100kb'
   otherwise
      error(['''' selection ''' is not a valid option for baud rate']);
   end

function argout  = apply(block)
   
   selection = get_param(block,'baud');

   switch selection
   case 'Program Registers Manually'
      baud = -1;
   case '1 Mb'
      baud = 1e6;
   case '500kb'
      baud = 500e3;
   case '250kb'
      baud = 250e3;
   case '125kb'
      baud = 125e3;
   case '100kb'
      baud = 100e3;
   otherwise
      error(['''' selection ''' is not a valid option for baud rate']);
  end
  
  quanta = simUtil_maskParam('get',block,'quanta');
  sample_point = simUtil_maskParam('get',block,'sample_point');
  
  try
      mpc555obj = mpc555_get_model_config_object(block);
      clock = mpc555obj.ClocksAndPowerControl_OSCCLK;   
      
      
      
      if baud ~= -1
          [propseg,pseg1,pseg2,presdiv,sample_point] = can_bit_timing(clock,baud,quanta,sample_point);
          baud = clock / (presdiv * (propseg+pseg1+pseg2+1)); % Just verify that calculations are correct.
      else
          propseg = simUtil_maskParam('get',block,'propseg');
          pseg1 = simUtil_maskParam('get',block,'pseg1');
          pseg2 = simUtil_maskParam('get',block,'pseg2');
          presdiv = simUtil_maskParam('get',block,'presdiv');
          
          baud = clock / (presdiv * (propseg+pseg1+pseg2+1));
      end
      
      argout = {propseg, pseg1, pseg2, presdiv, sample_point,baud};
  catch
      error('An MPC555 configuration block is required in this model to use a TOUCAN configuration block');
  end

