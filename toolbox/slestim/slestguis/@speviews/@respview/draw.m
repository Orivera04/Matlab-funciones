function draw(this, Data, NormalRefresh)
% Draws response curves.

%  Author(s): John Glass, Bora Eryilmaz
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:20 $

% Numbers of ports and experiments
[nport,nexp] = size(this.SimPlot);

% Map data to curves
for ct = 1:nport*nexp
   % Adjust the number of curves
   SimPlot = this.SimPlot{ct};
   SimData = Data.SimData(ct);
   YData = SimData.Amplitude;
   if isempty(YData)
      set(double(SimPlot), 'XData', [], 'YData', [])
   else
      % Create additional curves for non-scalar parameters if necessary
      Nc = size(YData,2);
      if Nc>length(SimPlot)
         Styles = {'-','--',':','-.'};
         ax = get(SimPlot(1),'Parent');
         for cte=Nc:-1:2
            SimPlot(cte,1) = copyobj(SimPlot(1),ax);
            set(SimPlot(cte),'LineStyle', Styles{rem(cte-1,4)+1})
         end
         this.SimPlot{ct} = SimPlot;
      end
      % Update line data
      for cte=1:Nc
         set(double(SimPlot(cte)), 'XData', SimData.Time, 'YData', YData(:,cte))
      end
   end
end
