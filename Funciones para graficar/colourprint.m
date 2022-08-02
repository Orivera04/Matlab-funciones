function colourprint
%COLOURPRINT.M	Send the graph currently on the screen to a file.
%               Works on colour printer (tek87) and A4 sized transparencies
%

col = get(gcf,'color')
Border = axes(...
    'pos',[0 0 1 1],...
    'xtick',[],...
    'ytick',[],...
    'box','on',...
    'xcolor',col,...
    'ycolor',col);


if get(gcf,'color')==[1 1 1]
  bordercolour = [1 1 0.99];
  set(Border,'xcolor',bordercolour,...
      'ycolor',bordercolour)
end

orientation = 'l';
if orientation == 'l'|orientation == 'L'
  orient landscape
else
  orient portrait
end

set(gcf,'PaperType','a4letter')

width=23.9;
height=20;
set(gcf,'PaperUnits','centimeters',...
    'PaperPosition',[3.0 0.45 width height])


set(gcf,'InvertHardCopy','off')

%device = input('Device (eg. psc,psc2,eps): ','s');
device = 'psc';
if device == 'eps'
  ans_eps = input('Include preview image? [y/n; default = y] : ','s');
  if isempty(ans_eps);ans_eps='y';end
  if ans_eps=='y'|ans_eps=='Y'
    device = [device ' -epsi'];
  end
end

PrintFileName = input('FileName (excluding extension): ','s');
PrintFileName = [PrintFileName '.' device];
printstring = ['print -d' device ' ' PrintFileName];
eval(printstring)
disp(['File name is: ' PrintFileName])
disp('...Done.')

delete(Border)

