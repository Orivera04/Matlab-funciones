function varargout =  sfun_bitop_msk(action, varargin)
%SFUN_BITOP_MSK

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $

   logicOpStrings = ...
      { 'AND' 'OR' 'NAND' 'NOR' 'XOR' 'NOT' 'SHIFT_LEFT' ...
              'SHIFT_RIGHT' 'BIT_SET' 'BIT_CLEAR'  ...
              '~A & B' 'A & ~B' '~A | B' 'A | ~B' };

   %enum logicOpStrings {
      DO_AND = 1;
      DO_OR  = 2;
      DO_NAND = 3;
      DO_NOR = 4;
      DO_XOR = 5;
      DO_NOT = 6;
      DO_SHIFT_LEFT = 7;
      DO_SHIFT_RIGHT = 8;
      DO_BIT_SET = 9;
      DO_BIT_CLEAR = 10;
      DO_NOTA_AND_B = 11;
      DO_A_AND_NOTB = 12;
      DO_NOTA_OR_B = 13;
      DO_A_OR_NOTB = 14;
   %}

   switch action
   case 'init'
      % UseBitMask,NumInputPorts,BitMask,logicop
      UseBitMask = varargin{1};
      NumInputPorts = varargin{2};
      BitMask = varargin{3};
      LogicOp = varargin{4};
      ZeroTest = varargin{5};

      if UseBitMask
        [m,n] = size(BitMask);
        if ischar(BitMask)
          len = m;
          n = 1;
        else
          len = m * n;
        end
        internalBitMask = zeros(len,1);
        if isnumeric(BitMask)
          for i=1:len,
            internalBitMask(i) = BitMask(i);
          end
        elseif ischar(BitMask)
          for i=1:m,
            internalBitMask(i) = hex2dec(BitMask(i,:));
          end
        elseif iscell(BitMask)
          for i=1:len,
            if isnumeric( BitMask{i} )
              internalBitMask(i) = BitMask{i};
            elseif ischar( BitMask{i} )
              internalBitMask(i) = hex2dec(BitMask{i});
            else
              errordlg(['Data type is not supported at cell item ', num2str(i) ]);
            end
          end
        end
        BitMask = fix(internalBitMask);
        if len == 1
            if strcmp(get_param(gcbh,'maskInBinary'),'on')
               str = [ '0b',dec2bin(BitMask(1))];
            else  
               str=['0x',dec2hex(BitMask(1))];
            end
        else
           str='Masks';
        end

      else
        BitMask = 0;
        str='';
      end


      switch ZeroTest
      case 1
         %% Do nothing
         logicOpStr = logicOpStrings{LogicOp}; 
      case 2
         %% Test for zero
          logicOpStr = [ '(' logicOpStrings{LogicOp} ') == 0']; 
      case 3
         %% Test for not zero
         logicOpStr = [ '(' logicOpStrings{LogicOp} ') ~= 0']; 
      otherwise
         error('ZeroTest parameter is out of range.');
      end

      
      if ~isempty(str) &  ~strcmp(get_param(gcbh,'logicop'),'NOT')
           str = [ logicOpStr '\n' str ];
       else
          str = [ logicOpStr ];
      end

      varargout = { uint32(BitMask), str };

   case 'callback'
      %--------------------------------------
      % Dynamically alter the visibilites
      % of all components
      % -------------------------------------
      wsa = get_param(gcbh,'MaskWSVariables');
      logicop = get_param(gcbh,'logicop');
      blk = gcbh;
      if strcmp(logicop,'NOT')
         paramDisable(blk,'NumInputPorts','1');
         paramDisable(blk,'UseBitMask','on');
         paramSetInvisible(blk,'BitMask');
         paramSetInvisible(blk,'maskInBinary');
     else      
         paramEnable(blk,'UseBitMask');
         if strcmp(get_param(blk,'UseBitMask'),'on')
            paramDisable(blk,'NumInputPorts');
            paramSetVisible(blk,'BitMask');
            paramSetVisible(blk,'maskInBinary');
        else
            paramEnable(blk,'NumInputPorts');
            paramSetInvisible(blk,'BitMask');
            paramSetInvisible(blk,'maskInBinary');
        end
      end
         
            
   otherwise
      error('Bad Action');
   end


%------------------------------------------------------------
%  Disable a parameters and optionally set its value
%------------------------------------------------------------

%   $Revision: 1.9.4.1 $  $Date: 2004/04/19 01:30:03 $
function paramDisable(block,pName,pValue)
   enables = get_param(gcbh,'MaskEnables');
   names = get_param(gcbh,'MaskNames');
   i=find(strcmp(names,pName));
   enables{i} = 'off';
   set_param(gcbh,'MaskEnables',enables);
   if nargin == 3
      set_param(gcbh,pName,pValue);
   end

%------------------------------------------------------------
%  Enable a parameter and optionally set its value
%------------------------------------------------------------
function paramEnable(block,pName,pValue)
   enables = get_param(gcbh,'MaskEnables');
   names = get_param(gcbh,'MaskNames');
   i=find(strcmp(names,pName));
   enables{i} = 'on';
   set_param(gcbh,'MaskEnables',enables);
   if nargin == 3
      set_param(gcbh,pName,pValue);
   end

%------------------------------------------------------------
% Make a parameter invisible and optionally set its value
%------------------------------------------------------------
function paramSetInvisible(block,pName,pValue)
   enables = get_param(gcbh,'MaskVisibilities');
   names = get_param(gcbh,'MaskNames');
   i=find(strcmp(names,pName));
   enables{i} = 'off';
   set_param(gcbh,'MaskVisibilities',enables);
   if nargin == 3
      set_param(gcbh,pName,pValue);
   end

%------------------------------------------------------------
% Make a parameter visible and optionally set its value
%------------------------------------------------------------
function paramSetVisible(block,pName,pValue)
   enables = get_param(gcbh,'MaskVisibilities');
   names = get_param(gcbh,'MaskNames');
   i=find(strcmp(names,pName));
   enables{i} = 'on';
   set_param(gcbh,'MaskVisibilities',enables);
   if nargin == 3
      set_param(gcbh,pName,pValue);
   end
