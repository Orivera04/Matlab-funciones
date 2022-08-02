function notes = fixpt_advisor(curModel,action);

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:18 $
  
notes = {};
  
if nargin < 2
  action = 'all';
end

curRoot = bdroot(curModel);

try
  eval([curRoot,'([],[],[],''compile'');'])

  new_notes = lookup_spacing(curModel);
  
  notes = { notes{:}, new_notes{:} };
  
  new_notes = check_gain_blocks(curModel);  
  
  notes = { notes{:}, new_notes{:} };
    
  new_notes = check_product_blocks(curModel);  
  
  notes = { notes{:}, new_notes{:} };
    
  new_notes = check_dot_product_blocks(curModel);  
  
  notes = { notes{:}, new_notes{:} };
    
  % can't do fir blocks because, runtime params not registered in 
  % normal mode, need to change for R14.
  
  new_notes = check_sum_blocks(curModel);  
  
  notes = { notes{:}, new_notes{:} };
    
  new_notes = check_relop_blocks(curModel);  
  
  notes = { notes{:}, new_notes{:} };
    
  new_notes = check_minmax_blocks(curModel);  
  
  notes = { notes{:}, new_notes{:} };
    
catch
end

eval([curRoot,'([],[],[],''term'');'])


function notes = lookup_spacing(curModel);
  
  notes = {};
  
  CR = sprintf('\n');
          
  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','graphical','BlockType','Lookup');
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};
    
    pdt = get_param(curBlk,'CompiledPortDataTypes');

    fxpProp = getFxpPropFromName(pdt.Inport{1});
    
    xdata = evalin('base',get_param(curBlk,'InputValues'));
      
    % Getting runtime parameter on lookup causes segv
    %
    %      rtp = get_param(curBlk,'Runtimeparameters')
    
    new_notes = evenSpacing(curBlk,fxpProp,xdata);
    
    notes = { notes{:}, new_notes{:} };
  
  end

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','graphical','BlockType','Lookup2D');
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};
    
    pdt = get_param(curBlk,'CompiledPortDataTypes');

        
    fxpProp = getFxpPropFromName(pdt.Inport{1});
    
    xdata = evalin('base',get_param(curBlk,'RowIndex'));
      
    % Getting runtime parameter on lookup causes segv
    %
    %      rtp = get_param(curBlk,'Runtimeparameters')
    
    new_notes = evenSpacing(curBlk,fxpProp,xdata);
    
    notes = { notes{:}, new_notes{:} };
  
  
    fxpProp = getFxpPropFromName(pdt.Inport{2});
    
    xdata = evalin('base',get_param(curBlk,'ColumnIndex'));
      
    % Getting runtime parameter on lookup causes segv
    %
    %      rtp = get_param(curBlk,'Runtimeparameters')
    
    new_notes = evenSpacing(curBlk,fxpProp,xdata);
    
    notes = { notes{:}, new_notes{:} };
  
end


function notes = evenSpacing(curBlk,fxpProp,xdata)
%   
% want to add checks based on tunability but
% runtimeparameter access currently segv's for 
% lookups because they don't always register
% all their runtime parametes.
  
  notes = {};
  
  CR = sprintf('\n');

  if strcmp(fxpProp.class,'FixedPoint')
 
    xdata_quantized = num2fixpt( xdata, fxpProp.dt, fxpProp.scale, 'Nearest', 'on' );
  
    diff_xdata_quantized = diff(xdata_quantized/fxpProp.scale(1));
    
    diffdelta_quantized = max(diff_xdata_quantized) - min(diff_xdata_quantized);
    
    if diffdelta_quantized > 0
      
      notes{end+1}.path = curBlk;
      
      if diffdelta_quantized > 2
        
        notes{end}.issue = ['The lookup table input data is not evenly spaced. An evenly spaced', CR, ...
                            'table might be more efficient. See fixpt_look1_func_approx.'];
        
      else
        notes{end}.issue = ['The lookup table input data is NOT evenly spaced when quantized,', CR,...
                            'but it is very close to being evenly spaced. It is strongly recommend', CR, ...
                            'that you consider adjusting the table to be evenly spaced. It is possible', CR, ...
                            'that the ideal data is evenly spaced such as 0:0.005:1, but is not', CR, ...
                            'evenly spaced after quantization. If you use quantized values when you enter the', CR, ...
                            'data, these issues can be solved. For example, instead of', CR, ...
                            'entering 0:0.005:1, enter 0:num2fixpt(0.005,sfix(16),2^-12,''Nearest'',''on''):1'];
      end
      
    else 
      
      [fff,eee] = log2(diff_xdata_quantized(1));
      
      if fff ~= 0.5
        
        notes{end+1}.path = curBlk;
        
        notes{end}.issue = ['The lookup table input data is evenly spaced, but the spacing is not a power-of-two.', CR, ...
                            'A simplified implementation can result if you can reimplement the table', CR, ...
                            'with even power-of-2 spacing. See fixpt_look1_func_approx.'];
        
      end
    end
  end
    
function notes = check_relop_blocks(curModel);
  
  notes = {};
  
  CR = sprintf('\n');

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','BlockType','RelationalOperator');
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};
    
    pdt = get_param(curBlk,'CompiledPortDataTypes');

    fxpPropU1 = getFxpPropFromName(pdt.Inport{1});
    
    fxpPropU2 = getFxpPropFromName(pdt.Inport{2});
    
    new_notes = relopCheck(curBlk,fxpPropU1,fxpPropU2);
      
    notes = { notes{:}, new_notes{:} };
  
  end


    
function notes = check_minmax_blocks(curModel);
  
  notes = {};
  
  CR = sprintf('\n');

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','BlockType','MinMax');

  % In R13+, the minmax is still not unified
  foundBlksOld = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','MaskType','Fixed-Point MinMax');

  foundBlks = { foundBlks{:}, foundBlksOld{:}}.';
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};
    
    pdt = get_param(curBlk,'CompiledPortDataTypes');

    fxpPropY = getFxpPropFromName(pdt.Outport{1});
        
    for iOps = 1:length(pdt.Inport)
      
      fxpPropU = getFxpPropFromName(pdt.Inport{iOps});
      
      new_notes = minmaxCheck(curBlk,fxpPropU,fxpPropY);
      
      notes = { notes{:}, new_notes{:} };
    end
    
  end


    
function notes = check_sum_blocks(curModel);
  
  notes = {};

  CR = sprintf('\n');

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','BlockType','Sum');
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};

    pdt = get_param(curBlk,'CompiledPortDataTypes');

    satMode = get_param(curBlk,'SaturateOnIntegerOverflow');
      
    rndMode = get_param(curBlk,'RndMeth');
      
    ops = get_param(curBlk,'Inputs');    
    
    if ~strncmp('+',ops,1) && ~strncmp('-',ops,1)
      ops = repmat('+',1,eval(ops));
    end
    
    nOps = length(ops);
    
    fxpPropY = getFxpPropFromName(pdt.Outport{1});
        
    netBias = 0;
    
    for iOps = 1:nOps
      
      fxpPropU = getFxpPropFromName(pdt.Inport{iOps});
      
      if ops(iOps) == '+'
        netBias = netBias + fxpPropU.bias;
      else
        netBias = netBias - fxpPropU.bias;
      end      
      
      new_notes = sumCheck(curBlk,fxpPropU,fxpPropY,satMode,rndMode);
      
      notes = { notes{:}, new_notes{:} };
    end
  
    if nOps == 1
    
      pdim = get_param(curBlk,'CompiledPortWidths');
    
      netBias = netBias * pdim.Inport(1) 
    end
 
    netBias = netBias - fxpPropY.bias;
    
    if netBias ~= 0
  
          notes{end+1}.path = curBlk;
        
          notes{end}.issue = [ ...
              'For this Sum block, the net sum of the input biases', CR, ...
              'does not equal the bias of the output. The implementation will include one extra', CR, ...
              'addition or subtraction instruction to correctly account for the net', CR, ...
              'bias adjustment. You can change the bias of the output scaling to make', CR, ...
              'the net bias adjustment zero, and eliminate the need for the extra', CR, ...
              'operation.'
                             ];      
    end
  end


function notes = check_dot_product_blocks(curModel);
  
  notes = {};
  
  CR = sprintf('\n');

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','MaskType','Dot Product');

  % In R13+, the dot is still not unified
  foundBlksOld = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','MaskType','Fixed-Point Dot Product');

  foundBlks = { foundBlks{:}, foundBlksOld{:}}.';
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};
    
    pdt = get_param(curBlk,'CompiledPortDataTypes');

    fxpPropU = getFxpPropFromName(pdt.Inport{1});
    
    fxpPropU2 = getFxpPropFromName(pdt.Inport{2});
    
    fxpPropY = getFxpPropFromName(pdt.Outport{1});
    
    satMode = get_param(curBlk,'SaturateOnIntegerOverflow');
    
    rndMode = get_param(curBlk,'RndMeth');
    
    new_notes = mulCheck(curBlk,fxpPropU,fxpPropU2,fxpPropY,satMode,rndMode);
    
    notes = { notes{:}, new_notes{:} };
  
  end


  
function notes = check_gain_blocks(curModel);
  
  notes = {};
  
  CR = sprintf('\n');

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','BlockType','Gain');
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};
    
    pdt = get_param(curBlk,'CompiledPortDataTypes');

    rtp = get_param(curBlk,'Runtimeparameters');
    
    fxpPropU = getFxpPropFromName(pdt.Inport{1});
    
    fxpPropY = getFxpPropFromName(pdt.Outport{1});
    
    fxpPropK = getFxpPropFromName(rtp.Datatype);

    satMode = get_param(curBlk,'SaturateOnIntegerOverflow');
    
    rndMode = get_param(curBlk,'RndMeth');
    
    new_notes = mulCheck(curBlk,fxpPropU,fxpPropK,fxpPropY,satMode,rndMode);
    
    notes = { notes{:}, new_notes{:} };
  
  end



  
  
function notes = check_product_blocks(curModel);
  
  notes = {};
  
  CR = sprintf('\n');

  foundBlks = find_system( curModel, 'FollowLinks','on','LookUnderMasks','all','BlockType','Product');
  
  for iBlk = 1:length(foundBlks)
    
    curBlk = foundBlks{iBlk};

    pdt = get_param(curBlk,'CompiledPortDataTypes');

    satMode = get_param(curBlk,'SaturateOnIntegerOverflow');
      
    rndMode = get_param(curBlk,'RndMeth');
      
    ops = get_param(curBlk,'Inputs');    
    
    if ~strncmp('*',ops,1) && ~strncmp('/',ops,1)
      ops = repmat('*',1,eval(ops));
    end
    
    nOps = length(ops);
    
    if nOps == 1
    
      pdim = get_param(curBlk,'CompiledPortWidths');
    
      if  ops=='/'
        
        if pdim.Inport(1) > 1 
        
          new_notes = manyDivSameBlock(curBlk);
        
          notes = { notes{:}, new_notes{:} };
        end
          
      else
        if pdim.Inport(1) > 2
        
          new_notes = manyMulDivSameBlock(curBlk);
        
          notes = { notes{:}, new_notes{:} };        
        end
      end
 
      fxpPropU = getFxpPropFromName(pdt.Inport{1});
    
      fxpPropY = getFxpPropFromName(pdt.Outport{1});
    
      new_notes = mulCheck(curBlk,fxpPropU,fxpPropU,fxpPropY,satMode,rndMode);
      
      notes = { notes{:}, new_notes{:} };
    
    elseif nOps >= 2
      
      fxpPropY = getFxpPropFromName(pdt.Outport{1});
        
      if ops(1) == '/' && ops(2) == '*'
        
        new_notes = doDivSecond(curBlk);
        
        notes = { notes{:}, new_notes{:} };
      end
 
      if  length(ops) > 2
        
        new_notes = manyMulDivSameBlock(curBlk);
        
        notes = { notes{:}, new_notes{:} };
      end
 
      if  sum(ops=='/') > 1
        
        new_notes = manyDivSameBlock(curBlk);
        
        notes = { notes{:}, new_notes{:} };
      end
 
      for iOps = 2:nOps
    
        fxpPropULeft = getFxpPropFromName(pdt.Inport{iOps-1});
        
        fxpPropURght = getFxpPropFromName(pdt.Inport{iOps});
        
        new_notes = mulCheck(curBlk,fxpPropULeft,fxpPropURght,fxpPropY,satMode,rndMode);
        
        notes = { notes{:}, new_notes{:} };
      
      end
    end
  end

  
  
function notes = mulCheck(curBlk,fxpPropU0,fxpPropU1,fxpPropY,satMode,rndMode);
  
  notes = {};
  
  CR = sprintf('\n');

  curModel = bdroot(curBlk);
  
  wordSizes = getMicroSizes(curModel);
  
  if strcmp(fxpPropU0.class,'FixedPoint') && ...
     strcmp(fxpPropU1.class,'FixedPoint') && ...
     strcmp(fxpPropY.class, 'FixedPoint')
    
    idealNumBits = fxpPropU0.numBits + fxpPropU1.numBits;
    
    if wordSizes.long < idealNumBits
      
      if strcmp(satMode,'on')
        
        notes{end+1}.path = curBlk;
        
        notes{end}.issue = [ ...
            'A very cumbersome multiplication is required by this block.', CR, ...
            sprintf('The first input has   %2d bits.',fxpPropU0.numBits), CR, ...
            sprintf('The second input has  %2d bits.',fxpPropU1.numBits), CR, ...
            sprintf('The ideal product has %2d bits.',idealNumBits), CR, ...
            sprintf('The largest integer size for the target has only %d bits.',wordSizes.long), CR, ...
            'Saturation is ON, so it is necessary to determine all ', sprintf('%d',idealNumBits), CR, ...
            'bits of the ideal product in the C code.', CR, ...
            'The C code required to do this multiplication is large and slow.', CR, ...
            'For this target, restricting multiplications to', CR, ...
            sprintf('%d bits times %d bits is strongly recommended.', wordSizes.long/2, wordSizes.long/2), ...
        ];
      
      else 
    
        msBitOutput = fxpPropY.numBits - 1 + fxpPropY.fixedExp;
        
        msEasyBitIdealProd = wordSizes.long - 1 + fxpPropU0.fixedExp + fxpPropU1.fixedExp;
        
        if msBitOutput > msEasyBitIdealProd
        
          notes{end+1}.path = curBlk;
        
          notes{end}.issue = [ ...
            'A very cumbersome multiplication is required by this block.', CR, ...
            sprintf('The first input has   %2d bits.',fxpPropU0.numBits), CR, ...
            sprintf('The second input has  %2d bits.',fxpPropU1.numBits), CR, ...
            sprintf('The ideal product has %2d bits.',idealNumBits), CR, ...
            sprintf('The largest integer size for the target has only %d bits.',wordSizes.long), CR, ...
            'The relative scaling of the inputs and the output requires that some of the', CR, ...
            sprintf('%d most significant bits of the ideal product be determined in the C code.', idealNumBits - wordSizes.long), CR, ...
            'The C code required to do this multiplication is large and slow.', CR, ...
            'For this target, restricting multiplications to', CR, ...
            sprintf('%d bits times %d bits is strongly recommended.', wordSizes.long/2, wordSizes.long/2), ...
                             ];      
        end
      end

    end
      if fxpPropU0.bias ~= 0.0 || ...
         fxpPropU1.bias ~= 0.0 || ...
         fxpPropY.bias ~= 0.0
    
          notes{end+1}.path = curBlk;
        
          notes{end}.issue = [ ...
              'This block is multiplying signals with nonzero bias.', CR, ...
              'It is recommended that you avoid this when possible.', CR, ...
              'In some cases, code generation is not supported', CR, ...
	      'for multiplication with nonzero bias, and in other cases,', CR, ...
              'extra steps are required to implement the multiplication.', CR, ...
              'To avoid this, insert a Data Type Conversion block before', CR, ...
              'and/or after the block doing the multiplication.  This allows the biases', CR, ...
              'to be removed, and allows you to control data type and', CR, ...
              'scaling for intermediate calculations. In many cases the', CR, ...
              'Data Type Conversion blocks can be moved to the "edges" of a (sub)system.', CR, ...
              'The conversion is only done once, and all blocks in the', CR, ...
              'subsystem can benefit from simpler, bias-free math.'
                             ];      
      end
    
      netSlopeAdj = (fxpPropU0.slopeAdj * fxpPropU1.slopeAdj / fxpPropY.slopeAdj);

      % this is overly conservative, need to investigate
      % quantization details further
      quantNetSlopeAdj = num2fixpt( netSlopeAdj, sfix(33), fixptbestprec( netSlopeAdj ,sfix(33) ) );
      
      if round(log2(quantNetSlopeAdj)) ~= log2(quantNetSlopeAdj)
        
          notes{end+1}.path = curBlk;
        
          notes{end}.issue = [ ...
              'This block is multiplying signals with mismatched fractional slopes.', CR, ...
              sprintf('The first  input has fractional slope %-15g',fxpPropU0.slopeAdj), CR, ...
              sprintf('The second input has fractional slope %-15g',fxpPropU1.slopeAdj), CR, ...
              sprintf('The       output has fractional slope %-15g',fxpPropY.slopeAdj), CR, ...
              sprintf('The net slope adjustment is           %-15g',netSlopeAdj), CR, ...
              'This mismatch causes the overall operation to involve two multiply', CR, ...
              'instructions rather than just one as expected. To remove the mismatch,', CR, ...
              'change the scaling of the output so that its fractional slope is', CR, ...
              'the product of the input fractional slopes.'
                             ];      
      end
  end
        
        
  
function notes = sumCheck(curBlk,fxpPropU,fxpPropY,satMode,rndMode);
  
  notes = {};
  
  CR = sprintf('\n');

  curModel = bdroot(curBlk);
  
  wordSizes = getMicroSizes(curModel);
  
  if strcmp(fxpPropU.class,'FixedPoint') && ...
     strcmp(fxpPropY.class,'FixedPoint')
    
    uMin = num2fixpt(-realmax,fxpPropU.dt,fxpPropU.scale(1),'Nearest','on');
    uMax = num2fixpt( realmax,fxpPropU.dt,fxpPropU.scale(1),'Nearest','on');
    
    yMin = num2fixpt(-realmax,fxpPropY.dt,fxpPropY.scale(1),'Nearest','on');
    yMax = num2fixpt( realmax,fxpPropY.dt,fxpPropY.scale(1),'Nearest','on');
    
    if uMin < yMin || uMax > uMax
      
      notes{end+1}.path = curBlk;
        
      if fxpPropU.bias ~= 0 || fxpPropY.bias ~= 0
        biasNote = [ ...
            'Note that for better accuracy and efficiency,', CR, ... 
            'nonzero bias terms are handled separately and are not included', CR, ...
            'in the conversion from input to output. The ranges given', CR, ...
            'below for the input and output exclude their biases.', CR ...
        ];
      else
        biasNote = '';
      end
      notes{end}.issue = [ ...
            'The Sum block can have a range error prior to the addition', CR, ...
            'or subtraction operation being performed. For simplicity of', CR, ...
            'design, the Sum block always casts each input to the output', CR, ...
            'data type and scaling prior to performing the addition or subtraction.', CR, ...
            sprintf('%s',biasNote), ...
            'One of the inputs has range ', sprintf('%15g to %15g',uMin,uMax), CR, ...
            'but  the   output has range ', sprintf('%15g to %15g',yMin,yMax), CR, ...
            'so a range error can occur when casting the input to the', CR, ...
            'output data type.', CR, ...
            '    You can get any addition or subtraction your application', CR, ...
            'requires by inserting Data Type Conversion blocks before and/or', CR, ...
            'after the Sum block. For example, suppose the inputs are a', CR, ...
            'combination of signed and unsigned 8-bit data types with binary points', CR, ...
            'that differ by at most five places. The output of the Sum', CR, ...
            'block can be set to a signed 16-bit data type with scaling that matches', CR, ...
            'the most precise input. When the inputs are cast to the', CR, ...
            'output data type, there is no loss of range or precision.', CR, ...
            'A Data Type Conversion block placed after the Sum block would allow the', CR, ...
            'final result to be converted to whatever data type is desired.'
          ];
    end
  
      netSlopeAdj = (fxpPropU.slopeAdj / fxpPropY.slopeAdj);

      % this is overly conservative, need to investigate
      % quantization details further
      quantNetSlopeAdj = num2fixpt( netSlopeAdj, sfix(33), fixptbestprec( netSlopeAdj ,sfix(33) ) );
      
      if round(log2(quantNetSlopeAdj)) ~= log2(quantNetSlopeAdj)
        
          notes{end+1}.path = curBlk;
        
          notes{end}.issue = [ ...
              'This Sum block has an input with a fractional slope that does not', CR, ...
              'equal the fractional slope of the output.', CR, ...
              sprintf('The input  has fractional slope %-15g',fxpPropU.slopeAdj), CR, ...
              sprintf('The output has fractional slope %-15g',fxpPropY.slopeAdj), CR, ...
              sprintf('The net slope adjustment is     %-15g',netSlopeAdj), CR, ...
              'This mismatch requires the Sum block to multiply the input by', CR, ...
              'the net slope adjustment each time the input is converted to the output', CR, ...
              'data type and scaling. To remove the mismatch, change the scaling', CR, ...
              'of the output or the input.'
                             ];      
      end
  
  end



function notes = relopCheck(curBlk,fxpPropU1,fxpPropU2);
  
  notes = {};
  
  CR = sprintf('\n');

  curModel = bdroot(curBlk);
  
  wordSizes = getMicroSizes(curModel);

  if ~isequal(fxpPropU1,fxpPropU2)
  
    notes{end+1}.path = curBlk;
        
    notes{end}.issue = [ ...
            'For this Relational Operator block, the data types of the first', CR, ...
            'and second inputs are not the same. A conversion operation is', CR, ...
            'required every time the block is executed. If one of the inputs', CR, ...
            'is invariant (sample time color magenta), then changing the data', CR, ...
            'type and scaling of the invariant input to match the other input', CR, ...
            'is a good opportunity for improving the model''s efficiency.' ...
        ];
  end
  
  if strcmp(fxpPropU1.class,'FixedPoint') && ...
     strcmp(fxpPropU2.class,'FixedPoint')
    
    u1Min = num2fixpt(-realmax,fxpPropU1.dt,fxpPropU1.scale,'Nearest','on');
    u1Max = num2fixpt( realmax,fxpPropU1.dt,fxpPropU1.scale,'Nearest','on');
    
    u2Min = num2fixpt(-realmax,fxpPropU2.dt,fxpPropU2.scale,'Nearest','on');
    u2Max = num2fixpt( realmax,fxpPropU2.dt,fxpPropU2.scale,'Nearest','on');
    
    if u1Max >= u2Max
    
      netSlopeAdj = (fxpPropU2.slopeAdj / fxpPropU1.slopeAdj);

      if u2Min < u1Min || u2Max > u1Max
      
        notes{end+1}.path = curBlk;
        
        notes{end}.issue = [ ...
            'For this Relational Operator block, the first input has the', CR, ...
            'greater positive range. The second input is converted to the', CR, ...
            'data type and scaling of the first input prior to performing', CR, ...
            'the relational operation.', CR, ...
            'The     first  input has range ', sprintf('%15g to %15g',u1Min,u1Max), CR, ...
            'but the second input has range ', sprintf('%15g to %15g',u2Min,u2Max), CR, ...
            'so a range error can occur when casting. ', ...
            'You can insert Data Type Conversion blocks', CR, ...
            'in front of the Relational Operator block to', CR, ...
            'convert both inputs to a common data type that has sufficient', CR, ...
            'range and precision to perfectly represent each input. The relational', CR, ...
            'operation would then be error-free.'
          ];
      end
      
      if fxpPropU2.scale(1) < fxpPropU1.scale(1)
      
        notes{end+1}.path = curBlk;
        
        notes{end}.issue = [ ...
            'For this Relational Operator block, the first input has the', CR, ...
            'greater positive range. The second input is converted to the', CR, ...
            'data type and scaling of the first input prior to performing', CR, ...
            'the relational operation.', CR, ...
            'The first  input has precision ', sprintf('%15g',fxpPropU1.scale(1)), CR, ...
            'The second input has precision ', sprintf('%15g',fxpPropU2.scale(1)), CR, ...
            'so there can be a precision loss each time the conversion is performed.', ...
            'You can insert Data Type Conversion blocks', CR, ...
            'in front of the Relational Operator block to', CR, ...
            'convert both inputs to a common data type that has sufficient', CR, ...
            'range and precision to perfectly represent each input. The relational', CR, ...
            'operation would then be error-free.'
          ];
      end
      
    else
      netSlopeAdj = (fxpPropU1.slopeAdj / fxpPropU2.slopeAdj);

      if u2Min > u1Min || u2Max < u1Max
      
        notes{end+1}.path = curBlk;
        
        notes{end}.issue = [ ...
            'For this Relational Operator block, the second input has the', CR, ...
            'greater positive range. The first input is converted to the', CR, ...
            'data type and scaling of the second input prior to performing', CR, ...
            'the relational operation.', CR, ...
            'The     first  input has range ', sprintf('%15g to %15g',u1Min,u1Max), CR, ...
            'but the second input has range ', sprintf('%15g to %15g',u2Min,u2Max), CR, ...
            'so a range error can occur when casting.', ...
            'You can insert Data Type Conversion blocks', CR, ...
            'in front of the Relational Operator block to', CR, ...
            'convert both inputs to a common data type that has sufficient', CR, ...
            'range and precision to perfectly represent each input. The relational', CR, ...
            'operation would then be error-free.'
          ];
      end
    
      if fxpPropU2.scale(1) > fxpPropU1.scale(1)
      
        notes{end+1}.path = curBlk;
        
        notes{end}.issue = [ ...
            'For this Relational Operator block, the second input has the', CR, ...
            'greater positive range. The first input is converted to the', CR, ...
            'data type and scaling of the second input prior to performing', CR, ...
            'the relational operation.', CR, ...
            'The first  input has precision ', sprintf('%15g',fxpPropU1.scale(1)), CR, ...
            'The second input has precision ', sprintf('%15g',fxpPropU2.scale(1)), CR, ...
            'so there can be a precision loss each time the conversion is performed.', ...
            'You can insert Data Type Conversion blocks', CR, ...
            'in front of the Relational Operator block to', CR, ...
            'convert both inputs to a common data type that has sufficient', CR, ...
            'range and precision to perfectly represent each input. The relational', CR, ...
            'operation would then be error-free.'
          ];
      end
      
    end      
    
    % this is overly conservative, need to investigate
    % quantization details further
    quantNetSlopeAdj = num2fixpt( netSlopeAdj, sfix(33), fixptbestprec( netSlopeAdj ,sfix(33) ) );
    
    if round(log2(quantNetSlopeAdj)) ~= log2(quantNetSlopeAdj)
      
      notes{end+1}.path = curBlk;
      
      notes{end}.issue = [ ...
          'This Relational Operator block has different fractional slopes for it first and second inputs.', CR, ...
          sprintf('The first  input has fractional slope %-15g',fxpPropU1.slopeAdj), CR, ...
          sprintf('The second input has fractional slope %-15g',fxpPropU2.slopeAdj), CR, ...
          sprintf('The net slope adjustment is           %-15g',netSlopeAdj), CR, ...
          'This mismatch causes the Relational Operator block to require a multiply operation each', CR, ...
          'time the input with lesser positive range is converted to the data type and scaling of ', CR, ...
          'the input with greater positive range.', CR, ...
          'To remove the mismatch, change the scaling of either of the inputs.'
                             ];      
    end
  
  end



function notes = minmaxCheck(curBlk,fxpPropU,fxpPropY);
  
  notes = {};
  
  CR = sprintf('\n');

  curModel = bdroot(curBlk);
  
  wordSizes = getMicroSizes(curModel);

  if ~isequal(fxpPropU,fxpPropY)
  
    notes{end+1}.path = curBlk;
        
    notes{end}.issue = [ ...
            'For this MinMax block, the data types of the output', CR, ...
            'and an input are not the same. A conversion operation is', CR, ...
            'required every time the block is executed.  If you change the', CR, ...
            'data types to be the same, your model will be more efficient.' 
        ];
  end
  
  if strcmp(fxpPropU.class,'FixedPoint') && ...
     strcmp(fxpPropY.class,'FixedPoint')
    
    uMin = num2fixpt(-realmax,fxpPropU.dt,fxpPropU.scale,'Nearest','on');
    uMax = num2fixpt( realmax,fxpPropU.dt,fxpPropU.scale,'Nearest','on');
    
    yMin = num2fixpt(-realmax,fxpPropY.dt,fxpPropY.scale,'Nearest','on');
    yMax = num2fixpt( realmax,fxpPropY.dt,fxpPropY.scale,'Nearest','on');
    
    netSlopeAdj = (fxpPropU.slopeAdj / fxpPropY.slopeAdj);

    if uMin < yMin || uMax > yMax
      
      notes{end+1}.path = curBlk;
      
      notes{end}.issue = [ ...
          'For this MinMax block, an input is converted to the', CR, ...
          'data type and scaling of the output prior to performing', CR, ...
          'the relational operation.', CR, ...
          'The     input  has range ', sprintf('%15g to %15g',uMin,uMax), CR, ...
          'but the output has range ', sprintf('%15g to %15g',yMin,yMax), CR, ...
          'so a range error can occur when casting.', ...
          'If you change the output data type so that it has sufficient', CR, ...
          'range and precision to perfectly represent each input, then ', CR
          'the operation will be error-free.'
                         ];
    end
    
    if fxpPropU.scale(1) < fxpPropY.scale(1)
      
      notes{end+1}.path = curBlk;
      
      notes{end}.issue = [ ...
          'For this MinMax block, an input is converted to the', CR, ...
          'data type and scaling of the output prior to performing', CR, ...
          'the relational operation.', CR, ...
          'The input  has precision ', sprintf('%15g',fxpPropU.scale(1)), CR, ...
          'The output has precision ', sprintf('%15g',fxpPropY.scale(1)), CR, ...
          'so there can be a precision loss each time the conversion is performed.', ...
          'If you change the output data type so that it has sufficient', CR, ...
          'range and precision to perfectly represent each input, then ', CR
          'the operation will be error-free.'
                         ];
    end
    
    % this is overly conservative, need to investigate
    % quantization details further
    quantNetSlopeAdj = num2fixpt( netSlopeAdj, sfix(33), fixptbestprec( netSlopeAdj ,sfix(33) ) );
    
    if round(log2(quantNetSlopeAdj)) ~= log2(quantNetSlopeAdj)
      
      notes{end+1}.path = curBlk;
      
      notes{end}.issue = [ ...
          'This MinMax block has an input with a fractional slope that does not', CR, ...
          'equal the fractional slope of the output.', CR, ...
          sprintf('The input  has fractional slope %-15g',fxpPropU.slopeAdj), CR, ...
          sprintf('The output has fractional slope %-15g',fxpPropY.slopeAdj), CR, ...
          sprintf('The net slope adjustment is     %-15g',netSlopeAdj), CR, ...
          'This mismatch causes the MinMax block to require a multiply operation each', CR, ...
          'time the input is converted to the data type and scaling of the output.', CR, ...
          'To remove this mismatch, change the scaling of either of the input or output.'
                             ];      
    end
  
  end



function notes = doDivSecond(curBlk);
  
  notes = {};
  
  CR = sprintf('\n');

  notes{end+1}.path = curBlk;
        
  notes{end}.issue = [ ...
            'This Product block is configured with a divide operation for the first input', CR, ...
            'and a multiply operation for the second input. This configuration results', CR, ...
            'in a reciprocal operation followed by a multiply operation. If you reverse', CR, ...
            'the inputs so that the "multiply" occurs first and the division occurs second,', CR, ...
            'a single division operation can handle both the first and second input.' ...
      ];
      
  
function notes = manyMulDivSameBlock(curBlk);
  
  notes = {};
  
  CR = sprintf('\n');

  notes{end+1}.path = curBlk;
        
  notes{end}.issue = [ ...
            'This Product block is configured to do more than one multiplication or', CR, ...
            'division operation. This is supported, but if the output data type is', CR, ...
            'integer or fixed-point, then better results are likely if this operation', CR, ...
            'is split across several blocks, with each block performing one multiplication or one', CR, ...
            'division. Using several blocks allows you to control the data type', CR, ...
            'and scaling used for intermediate calculations. The choice of data types', CR, ...
            'for intermediate calculations effects precision, range errors, and efficiency.'
      ];
      
function notes = manyDivSameBlock(curBlk);
  
  notes = {};
  
  CR = sprintf('\n');

  notes{end+1}.path = curBlk;
        
  notes{end}.issue = [ ...
            'This Product block is configured to do more than one', CR, ...
            'division operation. A general guideline from the field', CR, ...
            'of numerical analysis is to multiply all the denominator', CR, ...
            'terms together first, and then do only one division. This', CR, ...
            'improves accuracy and often speed in floating-point and', CR, ...
            'especially fixed-point calculations. This can', CR, ...
            'be accomplished in Simulink by cascading Product blocks.' ...
      ];
      
  
function wordSizes = getMicroSizes(curModel)
  
  gotMicroSizes = 0;
  
  try
    
    if strcmp( 'Microprocessor', get_param(curModel,'ProdHWDeviceType') )

      lenStr = get_param(curModel,'ProdHWWordLengths');
      
      [temp,lenStr]   = strtok(lenStr,',');
      wordSizes.char  = eval(temp);

      [temp,lenStr]   = strtok(lenStr,',');
      wordSizes.short = eval(temp);

      [temp,lenStr]   = strtok(lenStr,',');
      wordSizes.int   = eval(temp);

      [temp,lenStr]   = strtok(lenStr,',');
      wordSizes.long  = eval(temp);

    end

    gotMicroSizes = 1;
  catch
  end

  if gotMicroSizes == 0
     wordSizes = [];
     error('Could not determine word sizes of the intended target. Go to the Advanced Tab of the Simulink Simulation Parameters dialog. Make sure device is ''Microprocessor'' and sizes are set correctly');
  end
  
  

function fxpProp = getFxpPropFromName(name)

  fxpProp.class    = '';
  fxpProp.dt       = '';
  fxpProp.scale    = 1;
  
  if strcmp(name,'double')
    
    fxpProp.class = 'FloatingPoint';
    fxpProp.dt    = float('double');
    
  elseif strcmp(name,'single')
    
    fxpProp.class = 'FloatingPoint';
    fxpProp.dt    = float('single');
    
  elseif strcmp(name,'boolean')
    
    fxpProp.class = 'Boolean';
    fxpProp.dt    = uint(8);
    
  else
    
    fxpProp.class = 'FixedPoint';
    
    fxpProp.isSigned = 1;
    fxpProp.slopeAdj = 1;
    fxpProp.fixedExp = 0;
    fxpProp.bias     = 0;
    fxpProp.numBits  = 8;
    
    switch name

     case 'int8'
    
      fxpProp.dt = sfix(8);
      
     case 'uint8'

      fxpProp.isSigned   = 0;

      fxpProp.dt = ufix(8);
      
     case 'int16'
    
      fxpProp.numBits    = 16;
      
      fxpProp.dt = sfix(16);
      
     case 'uint16'

      fxpProp.numBits    = 16;      
      fxpProp.isSigned   = 0;

      fxpProp.dt = ufix(16);
      
     case 'int32'
    
      fxpProp.numBits    = 32;
      
      fxpProp.dt = sfix(32);
      
     case 'uint32'

      fxpProp.numBits    = 32;      
      fxpProp.isSigned   = 0;

      fxpProp.dt = ufix(32);
      
     otherwise
      
      try
        
        stuff = rtwprivate('slbus','ResolveFixPtType',name);
        
        fxpProp.isSigned = stuff.signed;
        fxpProp.slopeAdj = stuff.slope * stuff.fraction;
        fxpProp.fixedExp = stuff.exponent;
        fxpProp.bias     = stuff.bias;
        fxpProp.numBits  = stuff.nBits;
        
        if fxpProp.slopeAdj < 1 || fxpProp.slopeAdj >= 2
          
          [fff,eee]=log2(fxpProp.slopeAdj);
          
          fxpProp.slopeAdj = 2*fff;
          
          fxpProp.fixedExp = fxpProp.fixedExp + eee - 1;
        end
        
      catch
        clear fxpProp
        
        fxpProp.class = 'Unknown';
    
      end
    
    end

    if strcmp(fxpProp.class,'FixedPoint')
      
      if fxpProp.isSigned 

        fxpProp.dt = sfix(fxpProp.numBits);
      else
        fxpProp.dt = ufix(fxpProp.numBits);
      end

      fxpProp.scale = [fxpProp.slopeAdj*2^fxpProp.fixedExp fxpProp.bias];
      
    end
  end
