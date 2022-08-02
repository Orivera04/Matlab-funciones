function sys = makeProjectLibrary( featnode )
%MAKEPROJECTLIBRARY Create simulink diagram for strategy editing
%  Output a Simulink block library of tags
%  Representing all the tables as tags

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:03 $

% get interesting things from the featurenode
F = getdata( featnode );
P = project( featnode );
D = getdd( P );

width = 5; % number of blocks wide in the library
horizspacer = 140; vertspacer = 40;
ncount = 0;ccount = 0;l2count = 0;l1count = 0;fcount = 0;vcount = 0;
sys = 'CAGE_Project';
try
    alreadyExist = find_system('type','block_diagram','name',sys);
    for i = 1:length(alreadyExist)
        bdclose(alreadyExist{i});
    end
end
new_system(sys,'Library');
varDictionaryBlock = [sys,'/Variable', char(10),  'Dictionary'];
add_block('built-in/Subsystem',[sys,'/Tables'],'position',[10 10 50 70]);
add_block('built-in/Subsystem',[sys,'/Functions'],'position',[70 10 110 70]);
add_block('built-in/Subsystem',[sys,'/Normalizers'],'position',[130 10 170 70]);
add_block('built-in/Subsystem',[sys,'/Cal. constants'],'position',[200 10 240 70]);
add_block('built-in/Subsystem',[sys,'/Features'],'position',[260 10 300 70]);
add_block('built-in/Subsystem',varDictionaryBlock,'position',[320 10 360 70]);
modelBrowserWidth = 200;
set_param(sys,'modelbrowservisibility','on','modelbrowserwidth',modelBrowserWidth);
% First add data dictionary items
ptrs = D.listptrs;
featModel = F.get('model');
ind = [];
if ~isempty(featModel)
    allInputPtrs = unique(featModel.getptrs);
    for i = 1:length(allInputPtrs)
        if allInputPtrs(i).isddvariable
            ind = [ind find(allInputPtrs(i)==ptrs)];
        end
    end
end
modelVar = ptrs(ind);
% sort the variables alphabetically
modelVarNames = pveceval(modelVar, 'getname');
[sorted, alphasortindex] = sort(upper(modelVarNames));
modelVar = modelVar(alphasortindex);

otherVar = ptrs(setdiff((1:length(ptrs)),ind));
% sort the variables alphabetically
otherVarNames = pveceval(otherVar, 'getname');
[sorted, alphasortindex] = sort(upper(otherVarNames));
otherVar = otherVar(alphasortindex);

i = 0;
if length(modelVar)
    for i = 0:length(modelVar)-1
        left = horizspacer*mod(i,width)+10;
        top = vertspacer*floor(i/width);
        i_AddTag(varDictionaryBlock,modelVar(i+1),left,top,i,'red');
        vcount = vcount + 1;
    end
end

% if we have a large variable dictionary we'll partion it into blocks of
% about 50.
if length(otherVar) > 100
    % we want max maxBlocks vars per subsystem
    maxBlocks = 50;
    keepGoing = true;
    endIndex = maxBlocks;
    n = 1;
    startLetter = 'A';
    startPoint(n) = 1;
    while keepGoing
        endLetter = upper(sorted{endIndex}(1));
        % find the last occurance of the letter
        endPoint(n) = max(strmatch(endLetter, sorted));
        startPoint(n+1) = endPoint(n)+1;
        label{n} = sprintf('%s/%s-%s', varDictionaryBlock, startLetter, endLetter);
        
        if (startLetter == endLetter)
            label{n} = sprintf('%s/%s', varDictionaryBlock, startLetter);
        end
            
        startLetter = char(endLetter+1);
        endIndex = endPoint(n) + maxBlocks;
        if endIndex>length(sorted)
            endIndex = length(sorted);
        end
        if endPoint(n) == length(sorted)
            keepGoing = false;
        end
        n = n + 1;
    end
    % now need to add stuff
    for subI = 0:length(label)-1
        SSleft = 100*mod(subI,width)+10;
        SStop  = 80*floor((subI)/width);
        add_block('built-in/Subsystem', label{subI+1},'position',[SSleft SStop+40 SSleft+60  SStop+100]);
        vcount = vcount + 1;
        thisStart = startPoint(subI+1);
        for subJ = thisStart : endPoint(subI+1)
            left = horizspacer * mod( subJ-thisStart , width ) + 10;
            top  = vertspacer  * floor( ( subJ-thisStart ) / width );
            i_AddTag( label{subI+1},otherVar(subJ), left, top , subJ+1 ,'black' );
        end
    end
else
    for j = 0:length(otherVar)-1
        left = horizspacer*mod(j+i,width)+10;
        top = vertspacer*floor((j+i)/width);
        i_AddTag(varDictionaryBlock,otherVar(j+1),left,top,i+j+1,'black');
        vcount = vcount + 1;
    end
end

% Now classify all nodes in this branch
nodes = preorder(P);
d = [];
for i = 1:length(nodes)
    try
        d = [d getdata(nodes{i})];
        if d(end).isa('cgfeature')
            eq = d(end).get('equation');
            if ~isempty(eq)
                d = [d eq];
                otherPtrs = [eq.getptrs];
                if ~isempty(otherPtrs)
                    d = [d otherPtrs(:)'];
                end
            end
        end
    end
end
d = unique(d);

for i = 1:length(d)
    if ~(d(i) == F) % don't include current cgfeature
        thisObj = d(i).info;
        switch class(thisObj)
        case 'cglookuptwo'
            left = horizspacer*mod(l2count,width)+10;
            top = vertspacer*floor(l2count/width);
            i_AddTag([sys,'/Tables'],d(i),left,top,l2count);
            l2count = l2count+1;
        case {'cgnormfunction','cglookupone'}
            left = horizspacer*mod(l1count,width)+10;
            top = vertspacer*floor(l1count/width);
            i_AddTag([sys,'/Functions'],d(i),left,top,l1count);
            l1count = l1count+1;
        case 'cgnormaliser'
            parent = d(i).get('flist');
            if length(parent) == 1 && parent.isa('cglookupone')
                % Don't add axes of lookupones
            else
                left = horizspacer*mod(ncount,width)+10;
                top = vertspacer*floor(ncount/width);
                i_AddTag([sys,'/Normalizers'],d(i),left,top,ncount);
                ncount = ncount+1;
            end
        case 'cgconstant'
            left = horizspacer*mod(ccount,width)+10;
            top = vertspacer*floor(ccount/width);
            i_AddTag([sys,'/Cal. constants'],d(i),left,top,ccount);
            ccount = ccount+1;
        case 'cgfeature'
            left = horizspacer*mod(fcount,width)+10;
            top = vertspacer*floor(fcount/width);
            i_AddTag([sys,'/Features'],d(i),left,top,fcount);
            fcount = fcount+1;
        end
    end
end
maxBlocks = max([ncount,ccount,l2count,l1count,fcount,vcount]);
height = min(max(maxBlocks*20+40,150),300);

slPos = pcalcSLPosition;
set_param(sys,'location',[slPos(1)+modelBrowserWidth slPos(2)-75-height slPos(3) slPos(2)-75],'blockdescriptionStringDataTip','on');

if maxBlocks > 0
    open_system(sys);
end

%------------------------------------------
function i_AddTag(sys,ptr,left,top,i,col)
% I_ADDTAG

if nargin == 5
    col = 'black';
end
blockname = ['tag',num2str(i)];
objname = ptr.getname;

add_block('built-in/From',[sys,'/',blockname],...
    'GotoTag',objname,...
    'Description',objname,...
    'ShowName','off',...
    'orientation','left',...
    'userdata',ptr,...
    'position',[left,top,left+120,top+15],...
    'foregroundcolor',col);
