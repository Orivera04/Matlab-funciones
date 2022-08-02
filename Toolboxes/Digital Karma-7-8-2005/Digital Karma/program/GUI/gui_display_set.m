% Keeps values inside matrix size. Must be before slider settings & in this order
columnsinputscript; rowsinputscript;
if (dimension==2) & (firstrow+rowsshown-1>totalrows); firstrow=totalrows-rowsshown+1; end;
if (dimension==2) & (firstrow<1); firstrow=1; end;
if firstcolumn+columnsshown-1>columns; firstcolumn=columns-columnsshown+1; end;
if firstcolumn<1; firstcolumn=1; end;
if currentiteration>completediterations; currentiteration=completediterations; end;
if currentiteration<0; currentiteration=0; end;
% Sliders
if completediterations>1; set(findobj('Tag','sliderbar'),'Max',completediterations,'Min',0,'value',currentiteration,'sliderstep',[1/(completediterations-0), 10/(completediterations-0)]);
else; set(findobj('Tag','sliderbar'),'Max',1,'Min',0,'value',currentiteration,'sliderstep',[.1,1]); end;
set(findobj('Tag','sliderbarcols'),'Max',columns-columnsshown+1.0001,'Min',1,'value',firstcolumn,'sliderstep',[1/(columns-columnsshown+1.0001), 5/(columns-columnsshown+1.0001)]);
if dimension==2; set(findobj('Tag','sliderbarrows'),'Max',totalrows-rowsshown+1.0001,'Min',1,'value',firstrow,'sliderstep',[1/(totalrows-rowsshown+1.0001), 5/(totalrows-rowsshown+1.0001)]);
else; set(findobj('Tag','sliderbarrows'),'Max',1.0001,'Min',1,'value',1,'sliderstep',[1/1.0001, 1000/1.0001]); end;
% Display Boxes
if dimension==2; set(findobj('Tag','rowsinputbox'), 'string', num2str(rowsshown)); 
elseif dimension==1; set(findobj('Tag','rowsinputbox'), 'string', num2str(rows)); end;
set(findobj('Tag','columnsinputbox'), 'string', num2str(columnsshown));
%Autoscale
if autoscaleon==1;
    rangescale=(high-low)+1;
    set(findobj('Tag','rangescaleinput'), 'string', num2str(rangescale));
    colorsetmine;
end;
%Displaybox
if currentlyfindandselecting==1;
    searchingdisplay={['Searching'];['[',num2str(findcheckingcol),', ',num2str(findcheckingrows),', ',num2str(findcheckingplanes),']']};
    set(findobj('Tag','displaybox'), 'string', searchingdisplay);
    currentlyfindandselecting=0;
else;
    if dimension==2;
        if casizelimit==1 & stopiteration==0; display2value=[[c,iterationsremaining];[firstrow,totalrows-rowsshown+1];[firstcolumn,columns-columnsshown+1]];
        else; display2value=[[currentiteration,completediterations];[firstrow,totalrows-rowsshown+1];[firstcolumn,columns-columnsshown+1]]; end;
    elseif dimension==1; 
        if casizelimit==1 & stopiteration==0; display2value=[[c,iterationsremaining];[firstcolumn,columns-columnsshown+1]];
        else; display2value=[[currentiteration,completediterations];[firstcolumn,columns-columnsshown+1]]; end;
    end;
    set(findobj('Tag','displaybox'), 'string', num2str(display2value));
end;
