function draw(this, Data, NormalRefresh)
% Draws time response curves.

%  Author(s): John Glass, Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:30 $
% Input and output sizes
Np = length(this.Curves);

% Map data to curves
for ct=1:Np
   % Adjust the number of curves
   ParCurves = this.Curves{ct};
   if isempty(Data.Values)
      set(double(ParCurves), 'XData', [], ...
         'YData', [])
   else
      ParData = Data.Values{ct};
      % Create additional curves for non-scalar parameters if necessary
      Ne = size(ParData,2);
      if Ne>length(ParCurves)
         Styles = {'-','--',':','-.'};
         ax = get(ParCurves(1),'Parent');
         for cte=Ne:-1:2
            ParCurves(cte,1) = copyobj(ParCurves(1),ax);
            set(ParCurves(cte),'LineStyle', Styles{rem(cte-1,4)+1})
         end
         this.Curves{ct} = ParCurves;
      end
      % Update line data
      for cte=1:Ne
         set(double(ParCurves(cte)), 'XData', Data.Iterations, ...
            'YData', ParData(:,cte))
      end
   end
end