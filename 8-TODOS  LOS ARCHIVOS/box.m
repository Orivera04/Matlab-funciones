% BOX.M  Puts a box around the current plot.
% 
% A. Knight, Aug. 1993

boxed = get(gca,'Box');

if boxed(1:2)=='on'
  set(gca,'Box','off')
else
  set(gca,'Box','on');
end

