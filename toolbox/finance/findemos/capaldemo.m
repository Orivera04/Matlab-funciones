function capaldemo(command)
% CAPALDEMO Capital Allocation demo.
% This is a demo for the function PORTALLOC.M

% Author(s): M. Reyes-Kattar, 03/05/98
%   Copyright 1995-2003 The MathWorks, Inc.
% $Revision: 1.6.2.2 $   $Date: 2004/04/06 01:07:04 $

persistent A PRisk PRoR PWts rb rf myHandles hOverall hRisky
persistent hcal1_minus hcal2_minus hcal1_plus hcal2_plus


if(nargin < 1)
   command = 'start';
end


if(strcmpi(command, 'start'))

	load capaldemo

	% Create the user interface
	hui = capalui;

	% Collect all interesting handles in the UI's userdata
	myHandles = setuihandles(hui);

	% Connect sliders to edit controls
	seteditsliders(hui);

	% Assign the input data to the corresponding ui controls
	set(myHandles.hRfEdit, 'string', num2str(rf));
	set(myHandles.hRfSlider, 'value', rf);

	set(myHandles.hRbEdit, 'string', num2str(rb));
	set(myHandles.hRbSlider, 'value', rb);

	set(myHandles.hAEdit, 'string', num2str(A));
	set(myHandles.hASlider, 'value', A);

	[OptRiskyRisk, OptRiskyRoR, RiskyWts, PRiskPortfolio, OptOverallRisk, OptOverallRoR] = ...
   	portalloc(PRisk, PRoR, PWts, rf, rb, A);

	% Set the UIControls to the values returned by portalloc
	set(myHandles.hRiskOverallText, 'string', num2str(OptOverallRisk));
	set(myHandles.hRiskRiskyText, 'string', num2str(OptRiskyRisk));
	set(myHandles.hRoROverallText, 'string', num2str(OptOverallRoR));
	set(myHandles.hRoRRiskyText, 'string', num2str(OptRiskyRoR));


	% Graph
	hEff = plot(PRisk, PRoR);
	hold on

	hOverall = plot(OptOverallRisk, OptOverallRoR,'k+') ;
	hRisky = plot(OptRiskyRisk, OptRiskyRoR,'k*') ;

	if(PRiskPortfolio < 1)
		hcal1_minus = plot([0, OptRiskyRisk], [rf, OptRiskyRoR], 'm');
	else 
   	if(PRiskPortfolio > 1)
   		hcal2_minus = plot([0, OptRiskyRisk], [rb, OptRiskyRoR], '--m');
      	hcal2_plus  = plot([OptRiskyRisk, OptOverallRisk], [OptRiskyRoR, OptOverallRoR], 'm');
   	end         
	end    

	xl = get(gca, 'xlim');
	xl = [0 xl(2)];
	set(gca, 'xlim', xl);

	legend([hOverall hRisky], 'Optimal Overall Portfolio', 'Optimal Risky Portfolio', 4);
                  
	title('Optimal Capital Allocation', 'Color', 'k');
	xlabel('Risk (Standard Deviation)');
	ylabel('Expected  Return');
	grid on;

elseif strcmpi(command, 'update')
   
%   set(myHandles.hRfEdit, 'string', num2str(rf));
% 	set(myHandles.hRfSlider, 'value', rf);
% 
% 	set(myHandles.hRbEdit, 'string', num2str(rb));
% 	set(myHandles.hRbSlider, 'value', rb);
% 
% 	set(myHandles.hAEdit, 'string', num2str(A));
% 	set(myHandles.hASlider, 'value', A);
    
   % Get new input data from the edit controls
	rf = str2double(get(myHandles.hRfEdit, 'string'));
    if(rf < 0)
        % Set to minimum value
        minVal = get(myHandles.hRfSlider, 'Min');
        set(myHandles.hRfSlider, 'Value', minVal);
        set(myHandles.hRfEdit, 'string', num2str(minVal));
        msgbox('Rate cannot be negative', 'Capaldemo Error', 'error');
        return  
    end

	rb = str2double(get(myHandles.hRbEdit, 'string'));
    if(rb < 0)
        % Set to minimum value
        minVal = get(myHandles.hRbSlider, 'Min');
        set(myHandles.hRbSlider, 'Value', minVal);
        set(myHandles.hRbEdit, 'string', num2str(minVal));
        msgbox('Rate cannot be negative', 'Capaldemo Error', 'error');
        return  
    end
    
	A  = str2double(get(myHandles.hAEdit, 'string'));
    if(A < 0)
        % Set to minimum value
        minVal = get(myHandles.hASlider, 'Min');
        set(myHandles.hASlider, 'Value', minVal);
        set(myHandles.hAEdit, 'string', num2str(minVal));
        msgbox('Risk Aversion factor cannot be negative', 'Capaldemo Error', 'error');
        return  
    end

	%Call the function portalloc with the new input arguments
    try
	    [OptRiskyRisk, OptRiskyRoR, RiskyWts, PRiskPortfolio, OptOverallRisk, OptOverallRoR] = ...
   	    portalloc(PRisk, PRoR, PWts, rf, rb, A);
    catch
        msgbox(lasterr, 'Capaldemo Error', 'error');
        return
    end
    

	% Set the text UIControls to the values returned by portalloc
	set(myHandles.hRiskOverallText, 'string', num2str(OptOverallRisk));
	set(myHandles.hRiskRiskyText, 'string', num2str(OptRiskyRisk));
	set(myHandles.hRoROverallText, 'string', num2str(OptOverallRoR));
	set(myHandles.hRoRRiskyText, 'string', num2str(OptRiskyRoR));

	set(hOverall, 'xdata', OptOverallRisk);
	set(hOverall, 'ydata', OptOverallRoR) ;

	set(hRisky, 'xdata', OptRiskyRisk);
	set(hRisky, 'ydata', OptRiskyRoR);


	if(PRiskPortfolio < 1 )
   	if(~isempty(hcal1_minus))
   		set(hcal1_minus, 'xdata', [0, OptRiskyRisk]);
      	set(hcal1_minus, 'ydata', [rf, OptRiskyRoR]);
   	else
      	hcal1_minus = plot([0, OptRiskyRisk], [rf, OptRiskyRoR], 'm');
   	end
   
   	if(~isempty(hcal2_plus))
      	delete(hcal2_plus);
      	hcal2_plus = [];
   	end
   
   	if(~isempty(hcal2_minus))
      	delete(hcal2_minus);
      	hcal2_minus = [];
   	end

	else 
   	if(PRiskPortfolio > 1 )
      	if(~isempty(hcal2_minus))
      		set(hcal2_minus, 'xdata', [0, OptRiskyRisk]);
      		set(hcal2_minus, 'ydata', [rb, OptRiskyRoR]);
      
      		set(hcal2_plus, 'xdata', [OptRiskyRisk, OptOverallRisk]);
         	set(hcal2_plus, 'ydata', [OptRiskyRoR, OptOverallRoR]);
      	else
         	hcal2_minus = plot([0, OptRiskyRisk], [rb, OptRiskyRoR], '--m');
         	hcal2_plus  = plot([OptRiskyRisk, OptOverallRisk], [OptRiskyRoR, OptOverallRoR], 'm');
      	end
      
      	if(~isempty(hcal1_plus))
      		delete(hcal1_plus);
      		hcal1_plus = [];
   		end
   
   		if(~isempty(hcal1_minus))
      		delete(hcal1_minus);
      		hcal1_minus = [];
   		end

   	end         
	end


	if(PRiskPortfolio == 1)
   	if(~isempty(hcal1_minus))
      	delete(hcal1_minus);
      	hcal1_minus = [];
		end
   	if(~isempty(hcal1_plus))
      	delete(hcal1_plus);
      	hcal1_plus = [];
   	end
   
   	if(~isempty(hcal2_minus))
      	delete(hcal2_minus);
      	hcal2_minus = [];
   	end
   
   	if(~isempty(hcal2_plus))
      	delete(hcal2_plus);
      	hcal2_plus = [];
		end
	end
end








