function [angles, hline] =  ramachandran(pdb_struct)
%RAMACHANDRAN generates a Ramachandran plot for a protein structure.
%
%   RAMACHANDRAN(ID) generates the Ramachandran plot for the protein with
%   PDB ID code ID.
%
%   RAMACHANDRAN(FILENAME) generates the Ramachandran plot for the protein
%   stored in PDB file FILENAME. 
%
%   RAMACHANDRAN(PDB_STRUCT) generates the Ramachandran plot for the
%   protein stored in structure PDB_STRUCT, where PDB_STRUCT is a structure
%   obtained by using PDBREAD or GETPDB.   
%
%   RAMACHANDRAN generates a plot of the torsion angle PHI (torsion angle
%   between the 'C-N-CA-C' atoms) and the torsion angle PSI (torsion angle
%   between the 'N-CA-C-N' atoms) of the protein sequence.
%
%   ANGLES = RAMACHANDRAN(...) returns an array of the torsion angles PHI,
%   PSI, and OMEGA for the residue sequence. 
%
%   [ANGLES, HANDLE] = RAMACHANDRAN(...) returns a handle to the plot.
%
%   Example:
%
%       ramachandran('1E7I')
%   
%   This generates the Ramachandran plot for the human serum albumin
%   complexed with octadecanoic acid. 
%
%   See also GETPDB, PDBDISTPLOT, PDBREAD.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.5.6.4 $   $Date: 2004/01/24 09:20:27 $


% Testing for the validity of the input. If the input is a PDB file, read
% it and store the result into a structure
try
    if (~isstruct(pdb_struct))
        if exist(pdb_struct,'file')
            pdb_struct = pdbread(pdb_struct);
        else
            pdb_struct = getpdb(pdb_struct);
        end
    end
catch
    error('Bioinfo:RamachandranPlotIllegalInput',...
        'The input to this function is neither a structure of data nor a pdb file. Please provide one of the above. ');
end
 
% Obtaining the serial numbers for the Atoms and Heterogen Atoms
a = zeros(1,length(pdb_struct.Atom)+length(pdb_struct.HeterogenAtom));
for i = 1:length(pdb_struct.Atom)
    a(i) = pdb_struct.Atom(i).AtomSerNo;
end

for j = 1:length(pdb_struct.HeterogenAtom)
    a(i+j) = pdb_struct.HeterogenAtom(j).AtomSerNo;
end

pdb_struct.NewAtom = [pdb_struct.Atom pdb_struct.HeterogenAtom];

[sorted_SerNo, sorted_index] = sort(a); %#ok

% Obtaining a new serial so that it has both the Atoms as well as Heterogen
% atoms together
pdb_struct.NewAtom = pdb_struct.NewAtom(sorted_index);

clear sorted_SerNo sorted_index a

%Extracting the atoms which are 'C', 'CA', or 'N', as only these atoms are
%responsible for the torision angles, along with their coordinates
k = 1;
numAtoms = length(pdb_struct.NewAtom);
atom_name = cell(1,numAtoms);
atom_resSeq = zeros(1,numAtoms);
atom_coord = zeros(numAtoms,3);
for i = 1:length(pdb_struct.NewAtom)
    if (isequal(pdb_struct.NewAtom(i).AtomName, 'C') || isequal(pdb_struct.NewAtom(i).AtomName, 'N') || isequal(pdb_struct.NewAtom(i).AtomName, 'CA'))
        atom_coord(k,:) = [pdb_struct.NewAtom(i).X pdb_struct.NewAtom(i).Y pdb_struct.NewAtom(i).Z];
        atom_name{k} = pdb_struct.NewAtom(i).AtomName;
        atom_resSeq(k) = pdb_struct.NewAtom(i).resSeq;
        k = k+1;
    end
end
atom_name(k:end) = [];
atom_resSeq(k:end) = [];
atom_coord(k:end,:) = [];
title_str = pdb_struct.Title;


% Preprocessing the Data- Checking to see if the initial pattern is
% N-CA-C-N. In this case we reject this data point as this would mean that
% both PHI and PSI are not sharing the same CA.

%if ((isequal(atom_name(1), Atom_of_Interest(2))) && (isequal(atom_name(2), Atom_of_Interest(3))))
if ((isequal(atom_name{1}, 'N')) && (isequal(atom_name{2}, 'CA')))
    atom_name(1:end-2) = atom_name(3:end);
    atom_name(end-1:end) = [];
    
    atom_coord(1:end-2, :) = atom_coord(3:end, :);
    atom_coord(end-1:end,:) = [];
    
    atom_resSeq(1:end-2) = atom_resSeq(3:end);
    atom_resSeq(end-1:end) = [];
end

% Preprocessing the Data- Checking to see if the final pattern is
% C-N-CA-C. In this case we reject this data point as this would mean that
% both PHI and PSI are not sharing the same CA.

if ((isequal(atom_name{end-3}, 'C')) && (isequal(atom_name{end-2}, 'N')) && (isequal(atom_name{end-1}, 'CA')) && (isequal(atom_name{end}, 'C')))
    %if ((isequal(atom_name(end-3), Atom_of_Interest(1))) && (isequal(atom_name(end-2), Atom_of_Interest(2))) && (isequal(atom_name(end-1), Atom_of_Interest(3))) && (isequal(atom_name(end), Atom_of_Interest(1))))
    atom_name(end) = [];
    atom_coord(end,:) = [];
    atom_resSeq(end) = [];
end


numResidues = max(atom_resSeq);
phi = nan(numResidues,1);
psi = phi;
omega = phi;
% Calculating the torsion angles

for i = 1:length(atom_coord)-3
    switch(atom_name{i})
        
        case 'C'
            % Checking to see if the pattern satisfies for the phi torsion
            % angle
            if (isequal(atom_name{i+1}, 'N') && (isequal(atom_name{i+2}, 'CA')) && (isequal(atom_name{i+3}, 'C')))
                % Checking to see if the atoms are from adjacent amino acid
                % sequences. If they are not then the torsion angle does not
                % exist and is NaN
                if ((atom_resSeq(i) == atom_resSeq(i+1)-1) && (atom_resSeq(i+1) == atom_resSeq(i+2)) &&(atom_resSeq(i+1)== atom_resSeq(i+3)))
                    [phi(atom_resSeq(i+1))] = calculate_torsion_angle(atom_coord(i:i+3,:));
                end
                
            end
        case  'N'
            % Checking to see if the pattern satisfies for the psi torsion
            % angle
            if (isequal(atom_name{i+1}, 'CA') && (isequal(atom_name{i+2}, 'C')) && (isequal(atom_name{i+3}, 'N')))
                if ((atom_resSeq(i) == atom_resSeq(i+1)) && (atom_resSeq(i) == atom_resSeq(i+2)) && (atom_resSeq(i) == atom_resSeq(i+3)-1))
                    [psi(atom_resSeq(i))] = calculate_torsion_angle(atom_coord(i:i+3,:));
                end
            end
        case 'CA'
            if (nargout > 0)
                % Checking to see if the pattern satisfies for the omega torsion
                % angle. Will calculate the angle only if the user asks for the
                % output
                
                if (isequal(atom_name{i+1}, 'C') && (isequal(atom_name{i+2}, 'N')) && (isequal(atom_name{i+3}, 'CA')))
                    if ((atom_resSeq(i) == atom_resSeq(i+1)) && (atom_resSeq(i) == atom_resSeq(i+2)-1) && (atom_resSeq(i) == atom_resSeq(i+3)-1))
                        [omega(atom_resSeq(i))] = calculate_torsion_angle(atom_coord(i:i+3, :));
                    end
                end
            end
    end
end

% Converting the angles from Radians to Degrees
phi = phi*180/pi;
psi = psi*180/pi;

% Plotting the Figure with necessary settings
hline = plot(phi, psi, 'r.');
axis([-180 180 -180 180])
line([0 -180; 0 180], [-180 0; 180 0], 'Color', 'k')
lim = linspace(-180, 180, 9);
hAxis = get(hline,'parent');
hFig = get(hAxis,'parent');
set(hAxis, 'Xtick', lim, 'YTick', lim);
set(hFig, 'NumberTitle', 'off', 'Name', 'Ramachandran Plot');
xlabel('\bf{\fontsize{10} Phi (Degrees)} ');
ylabel('\bf{\fontsize{10} Psi (Degrees)} ');
% str = strcat('Ramachandran Plot: ', title_str);;
title(['\bf{\fontsize{8}', title_str(1,:), ' }'] );

% Returning the output
if nargout > 0
    angles = [phi, psi, omega];
end

function [torsion_angle] = calculate_torsion_angle(coord)
% Evaluating the torsion angles

p1 = coord(1,:);
p2 = coord(2,:);
p3 = coord(3,:);
p4 = coord(4,:);

a = p2 - p1;
b = p3 - p2;
c = p4 - p3;

a = a/norm(a,2);
b = b/norm(b,2);
c = c/norm(c,2);

b_cross_c = [b(2).*c(3) - b(3).*c(2);
    b(3).*c(1) - b(1).*c(3);
    b(1).*c(2) - b(2).*c(1)];

x = -sum(conj(a).*c) + ((sum(conj(a).*b))*(sum(conj(b).*c)));
y = sum(conj(a).*b_cross_c');
torsion_angle = newangle(x,y);

function ang = newangle(x,y)
% This function calculates the angle represented by (x,y). The angle lies
% between -pi and pi

ang = 0; % This is the default value. In case y == 0 and x ~= 0, ang = 0.
if (x ~= 0) && (y~= 0)
    c = x./sqrt(x.^2 + y.^2);
    ang = sign(y)*acos(c);
elseif (x == 0)
    if (y > 0)
        ang = pi/2;
    elseif (y < 0)
        ang = -pi/2;
    end
end
