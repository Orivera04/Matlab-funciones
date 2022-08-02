function [pIest charge] = isoelectric(seq_aa, varargin)
%ISOELECTRIC estimates the isoelectric point (pI) for a polypeptide.
%
%   ISOELECTIC(SEQ_AA) provides an estimate of the isoelectric point (the
%   pH at which the protein has a net charge of zero) for an amino acid
%   sequence SEQ_AA, as well as an estimated charge at the typical
%   intracellular pH 7.2. SEQ_AA should be a string of one-letter amino
%   acid symbols or a structure with sequence data. The estimate will be
%   skewed by the underlying assumptions that all amino acids are fully
%   exposed to the solvent, that neighboring peptides have no influence on
%   the pK of any given amino acid, and that the constitutive amino acids -
%   as well as the N- and C-termini - are unmodified. Cystine (two cysteine
%   residues participating in a disulfide bridge) will also affect the true
%   pI and are not considered here. By default, ISOELECTRIC uses the EMBOSS
%   amino acid pK table. Other values can be substituted as desired. If
%   ambiguous or unknown symbols are found in the sequence, they are
%   ignored.
%
%   ISOELECTRIC(..., 'PKVALS', VALUES) uses an alternative pK table stored
%   in a text file VALUES (see the 'Emboss.pK' file for an example).
%
%   ISOELECTRIC(..., 'CHARGE', pH) returns the predicted charge of the
%   sequence for an alternative pH.
%
%   ISOELECTRIC(..., 'CHART', TRUE) returns a chart plotting the charge of
%   the protein with respect to the pH of the solvent.
%
%   Examples:
%
%       % Get a sequence from PDB and estimate the isoelectric point.
%       pdbSeq = getpdb('1CIV', 'SequenceOnly', true)
%       isoelectric(pdbSeq)
%
%       % Plot the charge against the pH for a short polypeptide sequence.
%       isoelectric('PQGGGGWGQPHGGGWGQPHGGGGWGQGGSHSQG', 'CHART', true)
%
%       % Get the Rh blood group D antigen from NCBI and calculate its
%       % charge at pH 7.38 (typical blood pH).
%       gpSeq = getgenpept('AAB39602')
%       [pI charge] = isoelectric(gpSeq, 'Charge', 7.38)
%
%   See also AACOUNT, MOLWEIGHT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:18:48 $

chart = false;
test_pH = 7.2;

% Setup the default pK table (EMBOSS)
pKset = struct('N_term',8.6,'K',10.8,'R',12.5,'H',6.5,'D',3.9,'E',4.1,...
    'C',8.5,'Y',10.1,'C_term',3.6);

if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.', mfilename);
    end
    okargs = {'pkvals','charge','chart'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);%#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.', pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.', pname);
        else
            switch(k)
                case 1  % pkvals
                    if exist(pval, 'file')
                        [pKnames, pKvalues] = textread(pval, '%s %f');
                        pKset = cell2struct(num2cell(pKvalues), pKnames);
                    else
                        if ischar(pval)
                            warning('Bioinfo:UnknownFile',...
                            'Unknown pK file: %s. Defaulting to Emboss values.', pval)
                        else
                            warning('Bioinfo:UnknownFile',...
                            'Invalid file name: %f. Defaulting to Emboss values.', pval)
                        end
                    end
                case 2  % charge
                    test_pH = pval;
                case 3  % chart
                    if pval == true
                        chart = true;
                    else
                        if pval ~= false
                            warning('Bioinfo:InvalidChartType',...
                            'Invalid Chart argument.')
                        end
                    end
            end
        end
    end
end

pepcounts = aacount(seq_aa);
    
% calulate the estimated pI
pIest = 7;
pH_diff = 3.5;
pp_charge = calc_charge(pepcounts, pIest, pKset);
while abs(pp_charge) >= 10^-4
    pIest = pIest + (sign(pp_charge) * pH_diff);
    pH_diff = pH_diff/2;
    pp_charge = calc_charge(pepcounts, pIest, pKset);
end

% determine the charge for the specified pH
charge = calc_charge(pepcounts, test_pH, pKset);

if chart % print the chart
    x = 0: 0.1: 14;
    y = zeros(size(x,2));
    for i = 1: size(x,2)
        y(i) = calc_charge(pepcounts, x(i), pKset);
    end
    figure;
    plot(x,y);
    line(xlim,[0 0],'Color','k');
    y_limits = ylim;
    line([pIest pIest],y_limits,'LineStyle',':','Color','r');
    set(gca,'XTick',0:1:14)
    set(gca,'XTickLabel',{'0','1','2','3','4','5','6','7','8','9',...
        '10','11','12','13','14'})
    ylabel('Net Charge')
    xlabel('pH')
    text(pIest + .5, y_limits(2)/6,['pI = ' num2str(pIest)])
end

% calculates the charge for a polypeptide at a specified pH.
function net_charge = calc_charge(pepcounts, pH, pKset)
net_charge = p_chrg(pKset.N_term, pH)...
    + pepcounts.K * p_chrg(pKset.K, pH)...
    + pepcounts.R * p_chrg(pKset.R, pH)...
    + pepcounts.H * p_chrg(pKset.H, pH)...
    - pepcounts.D * p_chrg(pH, pKset.D)...
    - pepcounts.E * p_chrg(pH, pKset.E)...
    - pepcounts.C * p_chrg(pH, pKset.C)...
    - pepcounts.Y * p_chrg(pH, pKset.Y)...
    - p_chrg(pH, pKset.C_term);

% calculates the partial charge for a specific amino acid
function partial = p_chrg(pA, pB)
cr = 10^(pA - pB);
partial = cr/(cr + 1);
