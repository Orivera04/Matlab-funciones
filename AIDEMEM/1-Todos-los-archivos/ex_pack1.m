b = questdlg('Voulez-vous détruire le système ?', 'Armaggedon','Oui','Non','Non');
switch b
 case 'Oui',
  disp('Ah ! Ah ! raté');
 case 'Non',
  quit cancel;
end