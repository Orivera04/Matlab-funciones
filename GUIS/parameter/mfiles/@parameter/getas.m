% method of class @parameter
%
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function val=getas(param,text,selectedunit,panel)
% returns the current value of the parameter if its an float or an int

cont=param.entries;
nrent=length(cont);

if nargin<4 % search in all subsections
    panel='all';
end

nr=getentrynumberbytext(param,text,panel);

if nr>0
    type=cont{nr}.type;

    if nargin==2
        selectedunit=cont{nr}.orgunit;
    end

    handleb=gethandle(param,text,panel,1);
    if  ~isequal(handleb,0) && ishandle(handleb) % yes, there is a screen representation
        strvalue=get(handleb,'string');            % value is a string, lets see what we make of it
        if ~strcmp(strvalue,'auto')
            orgvalue=str2num(strvalue); % its a float, it must have a value
            
            unitty=cont{nr}.unittype;
            if isa(unitty,'unit_none')
                rawvalue=orgvalue;
                selectedunit='';
            else
                cunit=getcurrentunit(param,text);
                rawvalue=fromunits(unitty,orgvalue,cunit); % translate to rawdata
                testvalue=tounits(unitty,rawvalue,cont{nr}.orgunit); %the unit in which the min and max values are defined
                val=fromunits(unitty,orgvalue,selectedunit); % translate to asked unit
            end
            val=tounits(unitty,rawvalue,selectedunit);
            return
        else
            val='auto';
            return
        end
    else % no representation on screen
        unittype=param.entries{nr}.unittype;
        rawval=cont{nr}.rawvalue;
        stringval=cont{nr}.stringvalue;
        if isequal(rawval,'auto')
            val=rawval;
            return
        end
        if isa(unittype,'unit_none')
            val=str2num(stringval);
        else
            val=tounits(unittype,rawval,selectedunit);
        end
    end
else
    error('getas:: error, the entry does not exist');
end