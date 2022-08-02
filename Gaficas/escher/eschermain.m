function eschermain
% MAIN  Menu to select some tilings to be drawn.
% These are all tilings that I used in my seminar text.

while 1==1

	choice = menu('Parkettauswahl:','Dreiecke', ...
							'Ein Parkett, aber kein Escher-Parkett #1', ...
							'Ein Parkett, aber kein Escher-Parkett #2', ...
							'Escher-Parkett vollstaendig', ... 
							'Escher-Parkett mit Konstruktion', ...
							'farbloses Parkett', ... 
                            'Zufallsfaerbung', ... 
                            'Farbparkett #1', ... 
                            'Farbparkett #2', ... 
                            'Farbparkett #3', 'Ende');

	switch choice
	 case 1
		xpgallry('dreiecke');
	 case 2
		xpgallry('nonescher1');
	 case 3
		xpgallry('nonescher2');
	 case 4
		xpgallry('eschernetz');
	 case 5
  	    % simply look and enjoy
        feval('escher');
	 case 6
		xpgallry('farblos');
	 case 7
        xpgallry('zufall'); 
     case 8
        xpgallry('farbe1');
     case 9
        xpgallry('farbe2');
     case 10
        xpgallry('farbe3');
     case 11
		break;
	end
end