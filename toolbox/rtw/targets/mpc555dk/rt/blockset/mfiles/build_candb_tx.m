function build_candb_tx(block,message,signals)
%BUILD_CANDB_TX
%
% Parameters
%
%   block   - the subsystem in which to build the packing system
%   message - { MSGNAME ID DLC }
%   signals - { SIGNAME  STARTBIT SIZE MIN MAX OFFSET FACTOR ; 
%               SIGNAME  STARTBIT ...                 FACTOR ;
%               SIGNAME  ...             
%               ...
%              }

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/19 01:29:35 $


%----------------------------------
% Load Systems Required By This
% Function
%----------------------------------
load_system('simulink3');
load_system('mpc555generic');

%----------------------------------
% Declare some blocks that we will
% use.
%----------------------------------
inportSrc =    'built-in/Inport';
outportSrc =   'built-in/Outport';
bitpackSrc =   'mpc555generic/Serial Communications/bit-packing';
canbuildSrc =  'mpc555generic/Serial Communications/CAN blocks/Can Frame Builder';
satSrc =       'simulink3/Nonlinear/Saturation';
gainSrc =      'simulink3/Math/Gain';
muxSrc =       'simulink3/Signals & Systems/Mux';
demuxSrc =     'simulink3/Signals & Systems/Demux';
dataTypeConvSrc = 'simulink3/Signals & Systems/Data Type Conversion';
sumSrc=        'simulink3/Math/Sum';
constSrc=      'simulink3/Sources/Constant';
subSysSrc=     'simulink3/Subsystems/Subsystem';
sigPackerSrc=  'mpc555generic/Serial Communications/Signal Packer';
canFrameBuilderSrc= 'mpc555generic/Serial Communications/CAN blocks/Can Frame Builder';

%-----------------------------------------
% Define some constants that will be 
% usefull
%-----------------------------------------
nSignals = size(signals,1);
midScreen = 40 * size(signals,1)/2 + 20;


%-----------------------------------------
% Start Building The Subsystem
%-----------------------------------------

% Ensure that we have a block path name not
% just a numeric handle.
parent = get_param(block,'parent');
block = [parent '/' get_param(block,'name') ];
oldPosition = get_param(block,'position');
blockHandle = get_param(block,'Handle');


set_param(block,'LinkStatus','inactive');

% Delete everything in the system except the ports
simUtil_deleteAllButPorts(block);

% Refresh the input ports
names = {signals{:,1}};
simUtil_addInputPorts(block,names,[40 20]);

% Add the mux input
muxDest = simUtil_addBlock(block,muxSrc,'muxin',{'Inputs',i_int2str(nSignals)},{},{},[200 midScreen]);

% Connect the input ports to the mux
simUtil_addLines(block,names,ones(1,nSignals),repmat({'muxin'},1,nSignals),1:nSignals);

% Insert Saturation Block
lower = [ '[' i_int2str([ signals{:,4}]) ']' ];
upper = [ '[' i_int2str([ signals{:,5}]) ']' ];
props = { 'LowerLimit' lower 'UpperLimit' upper };
satDest = simUtil_addBlock(block,satSrc,'saturation',props,{'muxin' 1 1},{},{muxDest [50 0]});

% Insert Sum Block
sumDest = simUtil_addBlock(block,sumSrc,'sum',{},{'saturation' 1 1},{},{ satDest [75 0] });

% Insert Offset Constant
value = [ '[' i_int2str([ signals{:,6} ]) ']' ];
props = { 'Value' value }; 
simUtil_addBlock(block,constSrc,'offset',props,{},{'sum' 2 1},{ sumDest [-50 50]});

% Insert Gain Block
value = [ '[' i_int2str([ signals{:,7} ]) ']' ];
props = {'Gain' value };
gainDest = simUtil_addBlock(block,gainSrc,'gain',props,{'sum' 1 1 },{},{ sumDest [50 0 ] });

% Insert the Demux Block
props = { 'Outputs' i_int2str(nSignals) };
demuxDest = simUtil_addBlock(block,demuxSrc,'demux',props,{'gain' 1 1 },{},{ gainDest [100 0 ]});


% Build the Bit patterns parameter 
bitpattern = '';
for i=1:nSignals
    baseBit = i_int2str(signals{i,2});
    endBit = i_int2str(signals{i,2} + signals{i,3} - 1) ;
    element = [ ' [' baseBit ':' endBit '] ' ]; 
    bitpattern = [ bitpattern element ];
end
bitpattern = [ '{' bitpattern '}' ];

props = { 'len' i_int2str(message{3}) 'bitpattern' bitpattern };

bitpackDest = simUtil_addBlock(block,bitpackSrc,'pack',props,{},{},{ demuxDest [ 250 0] } );

% Insert the Data Type Conversion blocks
nSignalsDiv2 = nSignals / 2 + 0.5;
for i=1:nSignals
    istr = i_int2str(i);
    
    % They should all have been offset
    % and scaled now so packing them
    % into a uint32 should be correct
    props = {   'DataType','uint32', ... 
                'SaturateOnIntegerOverflow','off' } ;

    name = [ 'conv_' signals{i,1} ];
    simUtil_addBlock(block,dataTypeConvSrc,name,props,{'demux' i 1},{'pack' i 1}, ...
            {demuxDest [100 60 * (i-nSignalsDiv2) ]});
end

% Add the Can Frame Builder Block
props = { 'message_type' 'Standard Frame' 'id' i_int2str(message{2})};
cfbDest = simUtil_addBlock(block,canFrameBuilderSrc,'canBuilder',props,{'pack' 1 1},{},{bitpackDest [200 0]});




% Add in the single output port
simUtil_addOutputPorts(block,{ message{1} }, { cfbDest [200 0] } )

% Connect the output port to its input
simUtil_addLines(block,{'canBuilder'},1,{message{1}},1);

% Set the name of the block 
% and make sure that it's position hasn't 'walked'
set_param(block,'name',message{1});
set_param(blockHandle,'position',oldPosition);


function str = i_int2str(num)
str = sprintf('%d',num);

