function out = aminoacidinfo(varargin)
%AMINOACIDINFO various data about amino acids
%
%       Name 
%       MolecularFormula
%       MolecularWeight 
%       AminoAcidComposition: McCaldon P., Argos P.  Proteins: Structure, Function and Genetics 4:99-122(1988). 
%       Bulkiness: Zimmerman J.M., Eliezer N., Simha R.  Journal of Theoretical Biology 21:170-201(1968). 
%       Polarity: Grantham R.  Science 185:862-864(1974). 
%       RecognitionFactor: Fraga S.  Can. J. Chem. 60:2606-2610(1982). 
%       Hydrophobicity: Eisenberg D., Schwarz E., Komarony M., Wall R.  Journal of Molecular Biology 179:125-142(1984). 
%       HydropathicityKD: Author(s): Kyte J., Doolittle R.F.   Reference: J. Mol. Biol. 157:105-132(1982). 
%       Refractivity: Jones. D.D.   J. Theor. Biol. 50:167-184(1975). 
%       NumberOfCodons
%       PercentBuriedResidues: Janin J.   Nature 277:491-492(1979). 
%       PercentAccesibleResidues: Janin J.   Nature 277:491-492(1979). 
%       AverageAreaBuried: Rose G.D., Geselowitz A.R., Lesser G.J., Lee
%            R.H., Zehfus M.H.   Science 229:834-838(1985). 
%       AverageFlexibility: Bhaskaran R., Ponnuswamy P.K.  Int. J. Pept. Protein. Res. 32:242-255(1988). 


%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.3.4.3 $  $Date: 2004/01/24 09:20:12 $

str = varargin{1};

error(nargchk(1,3,nargin)) %#ok

ltrident = '';
abbrvident = '';

if ~ischar(str) && ~iscellstr(str),
    error('First input must be a string or cell array of strings.') %#ok
end

if nargin > 1,
    prop = varargin{2};
    if ~ischar(prop)
        error('Second input must be a string.') %#ok
    elseif nargin > 2 
        if ~ischar(varargin{3})
            error('Third input must be a string.') %#ok
        end 
    else
        %check to make sure it matches one of the property values.
    end
else
    prop = 'all';
end

% this section is used to populate the listbox in the PROTEINPLOT gui
% only the properties listed here will be available for graphing
if strcmp(str,'plotfields')
    out = {'MolecularWeight';...
            'AminoAcidComposition';...
            'Bulkiness';...
            'Polarity';...
            'RecognitionFactor';...
            'Hydrophobicity';...
            'HydropathicityKD';...
            'Refractivity';...
            'NumberOfCodons';...
            'PercentBuriedResidues';...
            'PercentAccessibleResidues';...
            'AverageAreaBuried';...
            'AverageFlexibility'};
    return
end

if ~iscellstr(str), %pass in multiple proteins, call recursively
    if ischar(str) && length(str) > 1,
        for i = 1:numel(str)
            out(i) = aminoacidinfo(str(i),prop);
        end
    else
        out = struct('Name','',...
            'MolecularFormula','',...
            'MolecularWeight','',...
            'AminoAcidComposition','',...
            'Bulkiness','',...
            'Polarity','',...
            'RecognitionFactor','',...
            'Hydrophobicity','',...
            'HydropathicityKD','',...
            'Refractivity','',...
            'NumberOfCodons','',...
            'PercentBuriedResidues','',...
            'PercentAccessibleResidues','',...
            'AverageAreaBuried','',...
            'AverageFlexibility','',...
            'HalfLife',struct('Mammalian','',...
                               'Yeast','',...
                               'EColi',''));
        switch numel(str)
            case 1
                ltrident = lower(str);        
            case 3
                abbrvident = lower(str);
            otherwise
                error('String must have one or three characters.') %#ok
        end
        if ~isempty(ltrident)
            switch ltrident
                case 'a'
                    abbrvident = 'ala';
                case 'c'
                    abbrvident = 'cys';
                case 'd'
                    abbrvident = 'asp';
                case 'e'
                    abbrvident = 'glu';
                case 'f'
                    abbrvident = 'phe';
                case 'g'
                    abbrvident = 'gly';
                case 'h'
                    abbrvident = 'his';
                case 'i'
                    abbrvident = 'ile';
                case 'k'
                    abbrvident = 'lys';
                case 'l' 
                    abbrvident = 'leu';
                case 'm'
                    abbrvident = 'met';
                case 'n'
                    abbrvident = 'asn';
                case 'p'
                    abbrvident = 'pro';
                case 'q'
                    abbrvident = 'gln';
                case 'r'
                    abbrvident = 'arg';
                case 's'
                    abbrvident = 'ser';
                case 't'
                    abbrvident = 'thr';
                case 'v'
                    abbrvident = 'val';
                case 'w'
                    abbrvident = 'trp';
                case 'y'
                    abbrvident = 'tyr';
                otherwise
                    error('Invalid letter code.') %#ok
            end
        end
        
        switch abbrvident
            case 'ala' 
                out.Name = 'Alanine';
                out.MolecularFormula  = 'C3H7NO2'; 
                out.MolecularWeight = 89.09;
                out.AminoAcidComposition = 8.300;
                out.Bulkiness = 11.500;
                out.Polarity = 8.100;
                out.RecognitionFactor = 78.000;
                out.Hydrophobicity = 0.620;
                out.HydropathicityKD = 1.800;
                out.Refractivity = 4.340;
                out.NumberOfCodons = 4.000;
                out.PercentBuriedResidues = 11.200;
                out.PercentAccessibleResidues = 6.600;
                out.AverageAreaBuried = 86.600;
                out.AverageFlexibility = 0.360;
                out.HalfLife.Mammalian = '4.4 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hours';
            case 'arg'
                out.Name = 'Arginine';
                out.MolecularFormula  = 'C6H14N4O2';
                out.MolecularWeight = 174.20;
                out.AminoAcidComposition = 5.700;        
                out.Bulkiness = 14.280;
                out.Polarity = 10.500;
                out.RecognitionFactor = 95.000;
                out.Hydrophobicity = -2.530;
                out.HydropathicityKD = -4.500;
                out.Refractivity = 26.660;
                out.NumberOfCodons = 6.000;
                out.PercentBuriedResidues = 0.500;
                out.PercentAccessibleResidues = 4.500;
                out.AverageAreaBuried = 162.200;
                out.AverageFlexibility = 0.530;
                out.HalfLife.Mammalian = '1 hour';
                out.HalfLife.Yeast = '2 min';
                out.HalfLife.EColi = '2 min';
            case 'asn'
                out.Name = 'Asparagine';
                out.MolecularFormula  = 'C4H8N2O3';
                out.MolecularWeight = 132.12;
                out.AminoAcidComposition = 4.400;
                out.Bulkiness = 12.820;
                out.Polarity = 11.600;
                out.RecognitionFactor = 94.000;
                out.Hydrophobicity = -0.780;
                out.HydropathicityKD = -3.500;
                out.Refractivity = 12.000;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 2.900;
                out.PercentAccessibleResidues = 6.700;
                out.AverageAreaBuried = 103.300;
                out.AverageFlexibility = 0.460;
                out.HalfLife.Mammalian = '1.4 hours';
                out.HalfLife.Yeast = '3 min';
                out.HalfLife.EColi = '>10 hour';
            case 'asp'
                out.Name = 'AsparticAcid';
                out.MolecularFormula  = 'C4H7NO4';
                out.MolecularWeight = 133.10;
                out.AminoAcidComposition = 5.300;
                out.Bulkiness = 11.680;
                out.Polarity = 13.000;
                out.RecognitionFactor = 81.000;
                out.Hydrophobicity = -0.900;
                out.HydropathicityKD = -3.500;
                out.Refractivity = 13.280;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 2.900;
                out.PercentAccessibleResidues = 7.700;
                out.AverageAreaBuried = 97.800;
                out.AverageFlexibility = 0.510;
                out.HalfLife.Mammalian = '1.1 hours' ;
                out.HalfLife.Yeast = '3 min';
                out.HalfLife.EColi = '>10 hour';
            case 'cys'
                out.Name = 'Cysteine';
                out.MolecularFormula  = 'C3H7NO2S';
                out.MolecularWeight = 121.15;
                out.AminoAcidComposition = 1.700;
                out.Bulkiness = 13.460;
                out.Polarity = 15.500;
                out.RecognitionFactor = 89.000;
                out.Hydrophobicity = 0.290;
                out.HydropathicityKD = 2.500;
                out.Refractivity = 35.770;
                out.NumberOfCodons = 1.000;
                out.PercentBuriedResidues = 4.100;
                out.PercentAccessibleResidues = 0.900;
                out.AverageAreaBuried = 132.300;
                out.AverageFlexibility = 0.350;
                out.HalfLife.Mammalian = '1.2 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hour';
            case 'gln'
                out.Name = 'Glutamine';
                out.MolecularFormula  = 'C5H10N2O3';
                out.MolecularWeight = 146.15;
                out.AminoAcidComposition = 4.000;
                out.Bulkiness = 14.450;
                out.Polarity = 10.500;
                out.RecognitionFactor = 87.000;
                out.Hydrophobicity = -0.850;
                out.HydropathicityKD = -3.500;
                out.Refractivity = 17.260;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 1.600;
                out.PercentAccessibleResidues = 5.200;
                out.AverageAreaBuried = 119.200;
                out.AverageFlexibility = 0.490;
                out.HalfLife.Mammalian = '0.8 hours';
                out.HalfLife.Yeast = '10 min';
                out.HalfLife.EColi = '>10 hour';
            case 'glu'
                out.Name = 'GlutamicAcid';
                out.MolecularFormula  = 'C5H9NO4';
                out.MolecularWeight = 147.13;
                out.AminoAcidComposition = 6.200;
                out.Bulkiness = 13.570;
                out.Polarity = 12.300;
                out.RecognitionFactor = 78.000;
                out.Hydrophobicity = -0.740;
                out.HydropathicityKD = -3.500;
                out.Refractivity = 17.560;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 1.800;
                out.PercentAccessibleResidues = 5.700;
                out.AverageAreaBuried = 113.900;
                out.AverageFlexibility = 0.500;
                out.HalfLife.Mammalian = '1 hour';
                out.HalfLife.Yeast = '30 min';
                out.HalfLife.EColi = '>10 hour';
            case 'gly'
                out.Name = 'Glycine';
                out.MolecularFormula  = 'C2H5NO2';
                out.MolecularWeight = 75.07;
                out.AminoAcidComposition = 7.200;
                out.Bulkiness = 3.400;
                out.Polarity = 9.000;
                out.RecognitionFactor = 84.000;
                out.Hydrophobicity = 0.480;
                out.HydropathicityKD = -0.400;
                out.Refractivity = 0.000;
                out.NumberOfCodons = 4.000;
                out.PercentBuriedResidues = 11.800;
                out.PercentAccessibleResidues = 6.700;
                out.AverageAreaBuried = 62.900;
                out.AverageFlexibility = 0.540;
                out.HalfLife.Mammalian = '30 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hour';
            case 'his'    
                out.Name = 'Histidine';
                out.MolecularFormula  = 'C6H9N3O2';
                out.MolecularWeight = 155.16;
                out.AminoAcidComposition = 2.200;
                out.Bulkiness = 13.690;
                out.Polarity = 10.400;
                out.RecognitionFactor = 84.000;
                out.Hydrophobicity = -0.400;
                out.HydropathicityKD = -3.200;
                out.Refractivity = 21.810;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 2.000;
                out.PercentAccessibleResidues = 2.500;
                out.AverageAreaBuried = 155.800;
                out.AverageFlexibility = 0.320;
                out.HalfLife.Mammalian = '3.5 hours';
                out.HalfLife.Yeast = '10 min';
                out.HalfLife.EColi = '>10 hour';
            case 'ile'
                out.Name = 'Isoleucine';
                out.MolecularFormula  = 'C6H13NO2';
                out.MolecularWeight = 131.17;
                out.AminoAcidComposition = 5.200;
                out.Bulkiness = 21.400;
                out.Polarity = 5.200;
                out.RecognitionFactor = 88.000;
                out.Hydrophobicity = 1.380;
                out.HydropathicityKD = 4.500;
                out.Refractivity = 18.780;
                out.NumberOfCodons = 3.000;
                out.PercentBuriedResidues = 8.600;
                out.PercentAccessibleResidues = 2.800;
                out.AverageAreaBuried = 158.000;
                out.AverageFlexibility = 0.460;
                out.HalfLife.Mammalian = '20 hours';
                out.HalfLife.Yeast = '30 min';
                out.HalfLife.EColi = '>10 hour';
            case 'leu'
                out.Name = 'Leucine';
                out.MolecularFormula  = 'C6H13NO2';
                out.MolecularWeight = 131.17;
                out.AminoAcidComposition = 9.000;
                out.Bulkiness = 21.400;
                out.Polarity = 4.900;
                out.RecognitionFactor = 85.000;
                out.Hydrophobicity = 1.060;
                out.HydropathicityKD = 3.800;
                out.Refractivity = 19.060;
                out.NumberOfCodons = 6.000;
                out.PercentBuriedResidues = 11.700;
                out.PercentAccessibleResidues = 4.800;
                out.AverageAreaBuried = 164.100;
                out.AverageFlexibility = 0.370;
                out.HalfLife.Mammalian = '5.5 hours';
                out.HalfLife.Yeast = '3 min';
                out.HalfLife.EColi = '2 min';
            case 'lys'
                out.Name = 'Lysine';
                out.MolecularFormula  = 'C6H14N2O2';
                out.MolecularWeight = 146.19;
                out.AminoAcidComposition = 5.700;
                out.Bulkiness = 15.710;
                out.Polarity = 11.300;
                out.RecognitionFactor = 87.000;
                out.Hydrophobicity = -1.500;
                out.HydropathicityKD = -3.900;
                out.Refractivity = 21.290;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 0.500;
                out.PercentAccessibleResidues = 10.300;
                out.AverageAreaBuried = 115.500;
                out.AverageFlexibility = 0.470;
                out.HalfLife.Mammalian = '1.3 hours';
                out.HalfLife.Yeast = '3 min';
                out.HalfLife.EColi = '2 min';
            case 'met'
                out.Name = 'Methionine';
                out.MolecularFormula  = 'C5H11NO2S';
                out.MolecularWeight = 149.21;
                out.AminoAcidComposition = 2.400;
                out.Bulkiness = 16.250;
                out.Polarity = 5.700;
                out.RecognitionFactor = 80.000;
                out.Hydrophobicity = 0.640;
                out.HydropathicityKD = 1.900;
                out.Refractivity = 21.640;
                out.NumberOfCodons = 1.000;
                out.PercentBuriedResidues = 1.900;
                out.PercentAccessibleResidues = 1.000;
                out.AverageAreaBuried = 172.900;
                out.AverageFlexibility = 0.300;
                out.HalfLife.Mammalian = '30 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hour';
            case 'phe'
                out.Name = 'Phenylalanine';
                out.MolecularFormula  = 'C9H11NO2';
                out.MolecularWeight = 165.19;
                out.AminoAcidComposition = 3.900;
                out.Bulkiness = 19.800;
                out.Polarity = 5.200;
                out.RecognitionFactor = 81.000;
                out.Hydrophobicity = 1.190;
                out.HydropathicityKD = 2.800;
                out.Refractivity = 29.400;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 5.100;
                out.PercentAccessibleResidues = 2.400;
                out.AverageAreaBuried = 194.100;
                out.AverageFlexibility = 0.310;
                out.HalfLife.Mammalian = '1.1 hours';
                out.HalfLife.Yeast = '3 min';
                out.HalfLife.EColi = '2 min';
            case 'pro'
                out.Name = 'Proline';
                out.MolecularFormula  = 'C5H9NO2';
                out.MolecularWeight = 115.13;
                out.AminoAcidComposition = 5.100;
                out.Bulkiness = 17.430;
                out.Polarity = 8.000;
                out.RecognitionFactor = 91.000;
                out.Hydrophobicity = 0.120;
                out.HydropathicityKD = -1.600;
                out.Refractivity = 10.930;
                out.NumberOfCodons = 4.000;
                out.PercentBuriedResidues = 2.700;
                out.PercentAccessibleResidues = 4.800;
                out.AverageAreaBuried = 92.900;
                out.AverageFlexibility = 0.510;
                out.HalfLife.Mammalian = '>20 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '?';
            case 'ser'
                out.Name = 'Serine';
                out.MolecularFormula  = 'C3H7NO3';
                out.MolecularWeight = 105.09;
                out.AminoAcidComposition = 6.900;
                out.Bulkiness = 9.470;
                out.Polarity = 9.200;
                out.RecognitionFactor = 107.000;
                out.Hydrophobicity = -0.180;
                out.HydropathicityKD = -0.800;
                out.Refractivity = 6.350;
                out.NumberOfCodons = 6.000;
                out.PercentBuriedResidues = 8.000;
                out.PercentAccessibleResidues = 9.400;
                out.AverageAreaBuried = 85.600;
                out.AverageFlexibility = 0.510;
                out.HalfLife.Mammalian = '1.9 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hour';
            case 'thr'
                out.Name = 'Threonine';
                out.MolecularFormula  = 'C4H9NO3';
                out.MolecularWeight = 119.12;
                out.AminoAcidComposition = 5.800;
                out.Bulkiness = 15.770;
                out.Polarity = 8.600;
                out.RecognitionFactor = 93.000;
                out.Hydrophobicity = -0.050;
                out.HydropathicityKD = -0.700;
                out.Refractivity = 11.010;
                out.NumberOfCodons = 4.000;
                out.PercentBuriedResidues = 4.900;
                out.PercentAccessibleResidues = 7.000;
                out.AverageAreaBuried = 106.500;
                out.AverageFlexibility = 0.440;
                out.HalfLife.Mammalian = '7.2 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hour';
            case 'trp'
                out.Name = 'Tryptophan';
                out.MolecularFormula  = 'C11H12N2O2';
                out.MolecularWeight = 204.23;
                out.AminoAcidComposition = 1.300;
                out.Bulkiness = 21.670;
                out.Polarity = 5.400;
                out.RecognitionFactor = 104.000;
                out.Hydrophobicity = 0.810;
                out.HydropathicityKD = -0.900;
                out.Refractivity = 42.530;
                out.NumberOfCodons = 1.000;
                out.PercentBuriedResidues = 2.200;
                out.PercentAccessibleResidues = 1.400;
                out.AverageAreaBuried = 224.600;
                out.AverageFlexibility = 0.310;
                out.HalfLife.Mammalian = '2.8 hours';
                out.HalfLife.Yeast = '3 min';
                out.HalfLife.EColi = '2 min';
            case 'tyr'
                out.Name = 'Tyrosine';
                out.MolecularFormula  = 'C9H11NO3 ';
                out.MolecularWeight = 181.19;
                out.AminoAcidComposition = 3.200;
                out.Bulkiness = 18.030;
                out.Polarity = 6.200;
                out.RecognitionFactor = 84.000;
                out.Hydrophobicity = 0.260;
                out.HydropathicityKD = -1.300;
                out.Refractivity = 31.530;
                out.NumberOfCodons = 2.000;
                out.PercentBuriedResidues = 2.600;
                out.PercentAccessibleResidues = 5.100;
                out.AverageAreaBuried = 177.700;
                out.AverageFlexibility = 0.420;
                out.HalfLife.Mammalian = '2.8 hours';
                out.HalfLife.Yeast = '10 min';
                out.HalfLife.EColi = '2 min';
            case 'val'
                out.Name = 'Valine';
                out.MolecularFormula  = 'C5H11NO2';
                out.MolecularWeight = 117.15;
                out.AminoAcidComposition = 6.600;
                out.Bulkiness = 21.570;
                out.Polarity = 5.900;
                out.RecognitionFactor = 89.000;
                out.Hydrophobicity = 1.080;
                out.HydropathicityKD = 4.200;
                out.Refractivity = 13.920;
                out.NumberOfCodons = 4.000;
                out.PercentBuriedResidues = 12.900;
                out.PercentAccessibleResidues = 4.500;
                out.AverageAreaBuried = 141.000;
                out.AverageFlexibility = 0.390;
                out.HalfLife.Mammalian = '100 hours';
                out.HalfLife.Yeast = '>20 hours';
                out.HalfLife.EColi = '>10 hour';
            otherwise
                error(['Invalid abbreviation: ' abbrvident])
        end
        if ~strcmp(prop,'all')
            out = out.(varargin{2:end});
        end
         
    end
else
    for i = 1:numel(str)
        out{i} = aminoacidinfo(str{i});
    end
end

