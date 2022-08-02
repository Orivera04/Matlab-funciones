function varargout = aeroblkconversion(action)
%  AEROBLKGRAVITY - Aerospace Blockset unit conversion 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.2.2.5 $ $Date: 2003/07/11 15:50:08 $

if nargin == 0, 
    action = 'init'; 
end

blk = gcbh;

switch action
 case 'icon'
  [ports slope bias] = get_labels(blk);
  varargout = {ports,slope,bias};

 case 'init'
  mtype = get_param(gcb,'Masktype');
  
  % load unit conversion data structure
  ConvertStruct = aeroblkconvertdata(mtype);
  
  % Find correct unit type
  %  Create strings for MKS popup menus
  ConvertStruct.popup = [ConvertStruct.tdata(1).unit '|'];
  for j = 2:(length(ConvertStruct.tdata)-1)
    ConvertStruct.popup = [ConvertStruct.popup ConvertStruct.tdata(j).unit '|'];
  end
  ConvertStruct.popup = [ConvertStruct.popup ConvertStruct.tdata(end).unit];
  ConvertStruct.popup = [ 'popup(' ConvertStruct.popup '),popup(' ConvertStruct.popup ')'];
  
  set_param(gcb,'MaskStyleString',ConvertStruct.popup);
otherwise
   error('aeroblks:aeroblkconversion:invalidiconaction','Icon action not defined');
end

return

% ----------------------------------------------------------
function [ports,slope,bias] = get_labels(blk)

ports = struct('type',{'',''},'port',{1},'txt',{''});  
  
mtype = get_param(gcb,'Masktype');
imode = get_param(blk,'IU');
omode = get_param(blk,'OU');

% load unit conversion data structure
ConvertStruct = aeroblkconvertdata(mtype);

% Define ports:
ports(1).type='input';
ports(1).port=1;
ports(1).txt ='';

ports(2).type='output';
ports(2).port=1;
ports(2).txt ='';

if ~strcmp(mtype,'Temperature Conversion')
    for j=1:length(ConvertStruct.tdata)
        if strcmp(imode,ConvertStruct.tdata(j).unit)
            ports(1).txt = ConvertStruct.tdata(j).unit;
            if strcmp(ConvertStruct.tdata(j).unit,'naut mi')
                ports(1).txt = 'n.mi';
            end
            slope_in = ConvertStruct.tdata(j).slope;
        end    
    end
    for j=1:length(ConvertStruct.tdata)
        if strcmp(omode,ConvertStruct.tdata(j).unit)
            ports(2).txt = ConvertStruct.tdata(j).unit;
            if strcmp(ConvertStruct.tdata(j).unit,'naut mi')
                ports(2).txt = 'n.mi';
            end
            slope_out = ConvertStruct.tdata(j).slope;
        end    
    end
    slope = slope_in/slope_out;
    bias = [];
else
    for j=1:length(ConvertStruct.tdata)
        if strcmp(imode,ConvertStruct.tdata(j).unit)
            ports(1).txt = ConvertStruct.tdata(j).unit;
            slope_in = ConvertStruct.tdata(j).slope;
            bias_in = ConvertStruct.tdata(j).bias;
        end    
    end
    for j=1:length(ConvertStruct.tdata)
        if strcmp(omode,ConvertStruct.tdata(j).unit)
            ports(2).txt = ConvertStruct.tdata(j).unit;
            slope_out = ConvertStruct.tdata(j).slope;
            bias_out = ConvertStruct.tdata(j).bias;
        end    
    end
    slope = slope_in/slope_out;
    bias = ( bias_in - bias_out )/slope_out;
end

return





