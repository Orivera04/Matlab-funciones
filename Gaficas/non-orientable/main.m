function main
% MAIN  Menu to select a non-orientable surfaces to be drawn.

while 1==1

	choice = menu('Select a surface','Moebius strip', ...
							'Moebius strip from ellipse', ...
							'Klein bottle #1 (MATLAB demo file)', ...
							'Klein bottle #2 (MATLAB demo file)', ... 
							'Boy''s surface', ...
							'Cruller (MATLAB demo file)', 'Quit');

	switch choice
	 case 1
		xpgallry('moebius');
	 case 2
		xpgallry('moebius2');
	 case 3
		% this is a MATLAB demo
		feval('xpklein');
	 case 4
		% this is a MATLAB demo
		xpgallry('klein1');
	 case 5
  	xpgallry('boy');
	 case 6
		% this is a MATLAB demo
		xpgallry('cruller');
	 case 7
		break;
	end
end
