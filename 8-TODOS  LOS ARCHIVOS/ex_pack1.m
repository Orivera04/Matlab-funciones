b = questdlg('Voulez-vous d�truire le syst�me ?', 'Armaggedon','Oui','Non','Non');
switch b
 case 'Oui',
  disp('Ah ! Ah ! rat�');
 case 'Non',
  quit cancel;
end