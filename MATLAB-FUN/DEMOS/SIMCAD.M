function simcad(fileName)
%SIMCAD	The SIMULINK system caddy.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

eval(fileName);

str= ...                                                             
    ['                                                            '  
     ' With any SIMULINK system, you can start the simulation     '  
     ' by selecting "Start" from the "Simulation" menu. Once you  '  
     ' have started, you can always terminate a simulation by     '  
     ' selecting "Stop" from the same menu (the commands          '  
     ' "Start" and "Stop" appear alternately in the same place on '  
     ' the menu). Some simulations may reach their pre-set stop   '  
     ' time and terminate automatically. You can set the          '  
     ' simulation stop time, step size, and other simulation      '  
     ' parameters by editing the "Parameters" dialog box under    '  
     ' the "Simulation" menu.                                     '  
     '                                                            '  
     ' You can select and move any block on a SIMULINK block      '  
     ' diagram by clicking once and dragging. You can generally   '  
     ' open a SIMULINK block by double-clicking on it. For        '  
     ' example, demo systems will often have a box marked with    '  
     ' a question mark (?). By double-clicking on this block,  you'  
     ' can reveal an explanatory note contained inside it.        '  
     '                                                            '  
     ' When you have finished with a SIMULINK system, you         '  
     ' can close it by selecting "Close" from the "File" menu.    '];

helpStrings=get_param([fileName '/More Info'],'blocks');

if ~isempty(helpStrings),
    % Now get the text from the "More Info" block and format it properly
    for count=1:size(helpStrings,1),
    	pos=get_param([fileName '/More Info/' helpStrings(count,:)],'position');
    	yPos(count)=pos(4);
    end;
    [yPosSorted,newOrder]=sort(yPos);
    helpStrings=helpStrings(newOrder,:);
    newHelpStr=[];
    for count=1:size(helpStrings,1),
        helpStrTemp=helpStrings(count,:);
    	% Replace newlines (ASCII 10) with newline and a space
	helpStrTemp=strrep(helpStrTemp,10,[13 10 32]);      
    	newHelpStr=str2mat(newHelpStr,helpStrTemp,' ');
    end;
    newHelpStr=str2mat(newHelpStr,['File name: ' fileName '.m']);
    newHelpStr=[32*ones(size(newHelpStr,1),1) newHelpStr];
    xppage(['SIMULINK Info for the system ' fileName],str,newHelpStr);
else
    xppage(['SIMULINK Info for the system ' fileName],str);
end;



