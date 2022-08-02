SIVector=[0 0 0 0 0 0 0 1 1 1 1 1 1 1];
NamesVector=char('aluminum','cast iron','bronze','structural steel','stainless steel','tool steel','titanium','aluminum','cast iron','bronze','structural steel','stainless steel','tool steel','titanium');
ConstantsVector=char('E','G','yield tension','yield compression','yield shear','ultimate tension','ultimate compression','ultimate shear','Poissons','thermal expansion');
UnitsVectorSI=char('GPa','GPa','MPa','MPa','MPa','MPa','MPa','MPa','Unitless','1 / Degree C');
UnitsVectorUS=char('10e3 ksi','10e3 ksi','ksi','ksi','ksi','ksi','ksi','ksi','Unitless','1 / Degree F');

ValuesMatrix(1,:)= [10.6 3.9 60  60  25  68   68   42  0.35 12.8e-6];
ValuesMatrix(2,:)= [10.0 3.9 nan nan nan 26   97   nan 0.28 6.70e-6];
ValuesMatrix(3,:)= [15   5.6 50  50  nan 95   95   nan 0.34 9.6e-6 ];
ValuesMatrix(4,:)= [29   11  36  36  nan 58   58   nan 0.32 6.60e-6];
ValuesMatrix(5,:)= [28   11  30  30  nan 75   75   nan 0.27 9.6e-6 ];
ValuesMatrix(6,:)= [29   11  102 102 nan 116  116  nan 0.32 6.5e-6 ];
ValuesMatrix(7,:)= [17.4 6.4 134 134 nan 145  145  nan 0.36 5.2e-6 ];
ValuesMatrix(8,:)= [73.1 27  414 414 172 469  469  290 0.35 23e-6  ];
ValuesMatrix(9,:)= [67.0 27  nan nan nan 179  669  nan 0.28 12e-6  ];
ValuesMatrix(10,:)=[103  38  345 345 nan 655  655  nan 0.34 17e-6  ];
ValuesMatrix(11,:)=[200  75  250 250 nan 400  400  nan 0.32 12e-6  ];
ValuesMatrix(12,:)=[193  75  207 207 nan 517  517  nan 0.27 17e-6  ];
ValuesMatrix(13,:)=[200  75  703 703 nan 800  800  nan 0.32 12e-6  ];
ValuesMatrix(14,:)=[120  44  924 924 nan 1000 1000 nan 0.36 9.4e-6 ];

% Used to define the material properties look-up table.  If you found this
% undocumented file, then you are smart enough to figure out how to use it.
% Save as matprop,mat in the toolbox directory with matprop.
%
% Details are to be found in Mastering Mechanics I, Douglas W. Hull,
% Prentice Hall, 1998
%
% Douglas W. Hull, 1998
% Copyright (c) 1998-99 by Prentice Hall
% Version 1.00
