function option = choosecolor
option = 0;
if(strcmp(computer,'MAC2') | strcmp(computer,'PCWIN'))
	option = uisetcolor('Set Pen Color');
else
	option = inputdlg('Color Spec?  (Must be 1x3 vector)','MatDraw',1,{'[0.0 0.0 0.0]'});
	if(isempty(option))
		option = 0;
	else
		option = str2num(option{1});
		if(~all(size(option)==[1 3]))
			errordlg('Color spec must be of the form [R G B]!');
			option = choosecolor;
		end
	end
end
