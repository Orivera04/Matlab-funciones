% method of class @parameter
%
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function [selectedunit,fullunitname]=getcurrentunit(param,text,panel)
% returns the unit that this value is currently set to


cont=param.entries;
nrent=length(cont);

if nargin<3 % search in all subsections
    panel='all';
end

nr=getentrynumberbytext(param,text,panel);
if nr>0
    type=cont{nr}.type;
    if ~strcmp(type,'float') && ~strcmp(type,'slider')
        selectedunit='only floats have units...';
        fullunitname='';
        return
    end
    
    handleb=gethandle(param,text,panel,1);
    if ~isequal(handleb,0) && ishandle(handleb) % yes, there is a screen representation
        unitty=cont{nr}.unittype;
        if isa(unitty,'unit_none')
            selectedunit='';
            fullunitname='';
        else
            handleb2=gethandle(param,text,panel,2);
            unitnr=get(handleb2,'value');
            possibleunitstr=getunitstrings(unitty);
            selectedunit=possibleunitstr{unitnr};
            possible_units_full=getunitfullstrings(unitty);
            fullunitname=possible_units_full{unitnr};
        end
        return
    else % no representation on screen
        selectedunit=cont{nr}.orgunit;
        return
    end
else
    error('error, the entry does not exist');
    %     val=0;  % we must return a logical value otherwise it can generate difficult errors
end