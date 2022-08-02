function [out] = cgslblock(filename, mode)
%@CGSLBLOCK\CGSLBLOCK Constructor for calibration Generation Simulink block parsing manager
%
%  OUT = CGSLBLOCK(FILENAME)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:15:40 $ 
persistent B

% reset mode
if (nargin==1 & strcmp(filename, 'reset')) | (nargin==2 & strcmp(mode, 'reset'));
    disp('Resetting')
    B=[];
    numins = nargin - 1;
else
    numins = nargin;
end

if isempty(B)
    B = struct('libname',[],...
        'blockname',[],...
        'blocktype',[],...
        'masktype',[],...
        'tagtype',[],...
        'expr',[],...
        'parsefunc',[]);
    
    if numins == 0
        filename = which('cgslblocklist.txt','-all');
    end
    if ~iscell(filename)
        filename = {filename};
    end
    count = 1;
    for i=1:length(filename)  
        [libname,blockname,blocktype,masktype,tagtype,expr,parsefunc] = textread(filename{i},'%s%s%s%s%s%s%s','commentstyle','matlab','emptyvalue',NaN,'whitespace', '', 'delimiter','|');
        for j = 1:length(libname)
            if ~isempty(which([parsefunc{j},'.m'])) 
                funcHandle = str2func(parsefunc{j});
                [B(count).libname,B(count).blockname,B(count).blocktype,B(count).masktype,B(count).tagtype,B(count).expr,B(count).parsefunc] = deal(libname{j},blockname{j},blocktype{j},masktype{j},tagtype{j},expr{j},funcHandle);
                count = count + 1;
            else
                warning('Can''t find parse function "%s" for block "%s"', parsefunc{j}, blockname{j})
            end
        end
    end
    B = class(B,'cgslblock');  
end
out = B;