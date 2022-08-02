%References for the PROTEINPLOT properties.
%
%   'Amino Acid Composition (%)' calculates the overall amino acid
%   composition percentages.
%   Author(s) :  McCaldon P., Argos P.
%   Reference :  Proteins: Structure, Function and Genetics 4:99-122(1988).
% 
%   '% accessible residues' calculates the molar fraction (%) of 3220
%   accessible residues. 
%   Author(s) :  Janin J.
%   Reference :  Nature 277:491-492(1979).
% 
%   'Alpha helix (Chou & Fasman)'(AA) calculates the conformational
%   parameter for alpha helix (computed from 29 proteins). 
%   Author(s) :  Chou P.Y., Fasman G.D.
%   Reference :  Adv. Enzym. 47:45-148(1978).
% 
%   'Alpha helix (Levitt)' calculates the normalized frequency for alpha
%   helix.
%   Author(s) :  Levitt M.
%   Reference :  Biochemistry 17:4277-4285(1978).
% 
%   'Alpha helix (Deleage & Roux)' calculates the conformational parameter
%   for alpha helix. 
%   Author(s) :  Deleage G., Roux B.
%   Reference :  Protein Engineering 1:289-294(1987).
% 
%   'Antiparallel beta strand'(AA) returns a vector of values of the
%   conformational preference for antiparallel beta strands for the amino
%   acids in sequence AA.  
%   Author(s) :  Lifson S., Sander C.
%   Reference :  Nature 282:109-111(1979).
% 
%   'Average area buried' calculates average area buried on transfer from
%   standard state to folded protein.  
%   Author(s) :  Rose G.D., Geselowitz A.R., Lesser G.J., Lee R.H., Zehfus M.H.
%   Reference :  Science 229:834-838(1985).
% 
%   'Average flexibility' calculates the average flexibility index.
%   Author(s) :  Bhaskaran R., Ponnuswamy P.K.
%   Reference :  Int. J. Pept. Protein. Res. 32:242-255(1988).
% 
%   'Beta-sheet (Chou & Fasman)' calculates the conformational parameter for
%   beta-sheet (computed from 29 proteins).
%   Author(s) :  Chou P.Y., Fasman G.D.
%   Reference :  Adv. Enzym. 47:45-148(1978).
% 
%   'Beta-sheet (Levitt)' calculates the normalized frequency for
%   beta-sheet.
%   Author(s) :  Levitt M.
%   Reference :  Biochemistry 17:4277-4285(1978).
% 
%   'Beta-sheet (Roux)' calculates the conformational parameter for
%   beta-sheet.
%   Author(s) :  Deleage G., Roux B.
%   Reference :  Protein Engineering 1:289-294(1987).
% 
%   'Beta-turn (Chou & Fasman)'(AA) calculates the conformational parameter
%   for beta-turn. 
%   Author(s) :  Chou P.Y., Fasman G.D.
%   Reference :  Adv. Enzym. 47:45-148(1978).
% 
%   'Beta-turn (Levitt)' calculates normalized frequency for beta-turn.
%   Author(s) :  Levitt M.
%   Reference :  Biochemistry 17:4277-4285(1978).
% 
%   'Beta-turn (Roux)' calculates the conformational parameter for
%   beta-turn. 
%   Author(s) :  Deleage G., Roux B.
%   Reference :  Protein Engineering 1:289-294(1987).
% 
%   'Bulkiness' calculates bulkiness.
%   Author(s) :  Zimmerman J.M., Eliezer N., Simha R.
%   Reference :  J. Theor. Biol. 21:170-201(1968).
% 
%   '% buried residues' calculates molar fraction (%) of 2001 buried
%   residues. 
%   Author(s) :  Janin J.
%   Reference :  Nature 277:491-492(1979).
% 
%   'Coil (Deleage & Roux)' calculates the conformational parameter for coil.
%   Author(s) :  Deleage G., Roux B.
%   Reference :  Protein Engineering 1:289-294(1987).
% 
%   'Hydrophobicity (Rao & Argos)' calculates membrane buried helix parameter.
%   Author(s) :  Rao M.J.K., Argos P.
%   Reference :  Biochim. Biophys. Acta 869:197-214(1986).
% 
%   'Hydrophobicity (Black & Mould)' calculates hydrophobicity of
%   physiological L-alpha amino acids 
%   Author(s) :  Black S.D., Mould D.R.
%   Reference :  Anal. Biochem. 193:72-82(1991).
%   http://psyche.uthct.edu/shaun/SBlack/aagrease.html
% 
%   'Hydrophobicity (Bull & Breese)' calculates hydrophobicity (free energy
%   of transfer to surface in kcal/mole).  
%   Author(s) :  Bull H.B., Breese K.
%   Reference :  Arch. Biochem. Biophys. 161:665-670(1974).
% 
%   'Hydrophobicity (Chothia)' calculates proportion of residues 95% buried
%   (in 12 proteins). 
%   Author(s) :  Chothia C.
%   Reference :  J. Mol. Biol. 105:1-14(1976).
% 
%   'Hydrophobicity (Kyte & Doolittle)' calculates hydropathicity.
%   Author(s) :  Kyte J., Doolittle R.F.
%   Reference :  J. Mol. Biol. 157:105-132(1982).
% 
%   'Hydrophobicity (Eisenberg et al.) ' calculates normalized consensus
%   hydrophobicity scale. 
%   Author(s) :  Eisenberg D., Schwarz E., Komarony M., Wall R.
%   Reference :  J. Mol. Biol. 179:125-142(1984).
% 
%   'Hydrophobicity (Fauchere & Pliska)' calculates hydrophobicity scale
%   (pi-r). 
%   Author(s) :  Fauchere J.-L., Pliska V.E.
%   Reference :  Eur. J. Med. Chem. 18:369-375(1983).
% 
%   'Hydrophobicity (Guy)' calculates hydrophobicity scale based on free
%   energy of transfer (kcal/mole).
%   Author(s) :  Guy H.R.
%   Reference :  Biophys J. 47:61-70(1985).
% 
%   'Hydrophobicity (Janin)' calculates free energy of transfer from inside
%   to outside of a globular protein.
%   Author(s) :  Janin J.
%   Reference :  Nature 277:491-492(1979).
% 
%   'Hydrophobicity (Abraham & Leo)' calculates hydrophobicity (delta G1/2
%   cal)
%   Author(s) :  Abraham D.J., Leo A.J. 
%   Reference :  Proteins: Structure, Function and Genetics 2:130-152(1987).
% 
%   'Hydrophobicity (Manavalan et al.)' calculates average surrounding
%   hydrophobicity.
%   Author(s) :  Manavalan P., Ponnuswamy P.K.
%   Reference :  Nature 275:673-674(1978).
% 
%   'Hydrophobicity (Miyazawa et al.)' calculates hydrophobicity scale
%   (contact energy derived from 3D data).
%   Author(s) :  Miyazawa S., Jernigen R.L.
%   Reference :  Macromolecules 18:534-552(1985).
% 
%   'Hydrophobicity (Aboderin)' calculates mobilities of amino acids on
%   chromatography paper (RF).
%   Author(s) :  Aboderin A.A.
%   Reference :  Int. J. Biochem. 2:537-544(1971).
% 
%   'Hydrophobicity HPLC (Parker et al.)' calculates hydrophilicity scale
%   derived from HPLC peptide retention times.
%   Author(s) :  Parker J.M.R., Guo D., Hodges R.S.
%   Reference :  Biochemistry 25:5425-5431(1986).
% 
%   'Hphob. HPLC pH3.4' calculates hydrophobicity indices at ph 3.4
%   determined by HPLC.
%   Author(s) :  Cowan R., Whittaker R.G.
%   Reference :  Peptide Research 3:75-80(1990).
% 
%   'Hphob. HPLC pH7.5' calculates hydrophobicity indices at ph 7.5
%   determined by HPLC.
%   Author(s) :  Cowan R., Whittaker R.G.
%   Reference :  Peptide Research 3:75-80(1990).
% 
%   'Hydrophobicity (Rose & al)'(AA) calculates the mean fractional area
%   loss (f) [average area buried/standard state area].  
%   Author(s) :  Rose G.D., Geselowitz A.R., Lesser G.J., Lee R.H., Zehfus M.H.
%   Reference :  Science 229:834-838(1985).
% 
%   'Hydrophobicity (Roseman)' calculates hydrophobicity scale (pi-r).
%   Author(s) :  Roseman M.A.
%   Reference :  J. Mol. Biol. 200:513-522(1988).
% 
%   'Hydrophobicity (Sweet et al.)' calculates optimized matching hydrophobicity (OMH).
%   Author(s) :  Sweet R.M., Eisenberg D.
%   Reference :  J. Mol. Biol. 171:479-488(1983).
% 
%   'Hydrophobicity (Welling et al.)' calculates the antigenicity value X 10.
%   Author(s) :  Welling G.W., Weijer W.J., Van der Zee R., Welling-Wester S.
%   Reference :  FEBS Lett. 188:215-218(1985).
% 
%   'Hydrophobicity HPLC (Wilson et al.)' calculates the hydrophobic
%   constants derived from HPLC peptide retention times. 
%   Author(s) :  Wilson K.J., Honegger A., Stotzel R.P., Hughes G.J.
%   Reference :  Biochem. J. 199:31-41(1981).
% 
%   'Hydrophobicity (Wolfenden et al.)' calculates the hydration potential
%   (kcal/mole) at 25C.
%   Author(s) :  Wolfenden R.V., Andersson L., Cullis P.M., Southgate C.C.F.
%   Reference :  Biochemistry 20:849-855(1981).
% 
%   'Hydrophobicity (Hopp & Woods) ' calculates the hydrophilicity (Hopp &
%   Woods).
%   Author(s) :  Hopp T.P., Woods K.R.
%   Reference :  Proc. Natl. Acad. Sci. U.S.A. 78:3824-3828(1981).
% 
%   'HPLC retention, pH 2.1 (Meek)' calculates the retention coefficient in
%   HPLC, pH 2.1.
%   Author(s) :  Meek J.L.
%   Reference :  Proc. Natl. Acad. Sci. USA 77:1632-1636(1980).
% 
%   'HPLC retention, pH 7.4 (Meek)' calculates the retention coefficient in
%   HPLC, pH 7.4. 
%   Author(s) :  Meek J.L.
%   Reference :  Proc. Natl. Acad. Sci. USA 77:1632-1636(1980).
% 
%   'HFBA retention' calculates the retention coefficient in HFBA.
%   Author(s) :  Browne C.A., Bennett H.P.J., Solomon S.
%   Reference :  Anal. Biochem. 124:201-208(1982).
% 
%   'TFA retention' calculates the retention coefficient in TFA.
%   Author(s) :  Browne C.A., Bennett H.P.J., Solomon S.
%   Reference :  Anal. Biochem. 124:201-208(1982).
% 
%   'Parallel beta strand' calculates conformational preference for parallel
%   beta strand.
%   Author(s) :  Lifson S., Sander C.
%   Reference :  Nature 282:109-111(1979).
% 
%   'Polarity (Grantham)' calculates polarity (Grantham).
%   Author(s) :  Grantham R.
%   Reference :  Science 185:862-864(1974).
% 
%   'Polarity (Zimmerman)' -  Polarity.
%   Author(s) :  Zimmerman J.M., Eliezer N., Simha R.
%   Reference :  J. Theor. Biol. 21:170-201(1968).
% 
%   'Ratio hetero end/side' calculates atomic weight ratio of hetero
%   elements in end group to C in side chain.
%   Author(s) :  Grantham R.
%   Reference :  Science 185:862-864(1974).
% 
%   'Recognition factors' calculates recognition factors.
%   Author(s) :  Fraga S.
%   Reference :  Can. J. Chem. 60:2606-2610(1982).
% 
%   'Refractivity' calculates refractivity.
%   Author(s) :  Jones. D.D.
%   Reference :  J. Theor. Biol. 50:167-184(1975).
% 
%   'Relative mutability' calculates relative mutability of amino acids
%   (Ala=100).
%   Author(s) :  Dayhoff M.O., Schwartz R.M., Orcutt B.C.
%   Reference :  In "Atlas of Protein Sequence and Structure", Vol.5, Suppl.3 (1978).
% 
%   'Total beta strand'(AA) calculates conformational preference for total
%   beta strand (antiparallel+parallel). 
%   Author(s) :  Lifson S., Sander C.
%   Reference :  Nature 282:109-111(1979).

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/01/24 09:20:22 $

helpwin('private\proteinplotreferences');

% % this was generated using:
% list = dir('aa*.m');
% fid = fopen('proteinplotreferences.m','w')
% for count = 1:numel(list)
%     prop = strrep(feval(strtok(list(count).name,'.')),'AAProp_ ','');
%     if isempty(prop)
%         list(count).name
%     end
%     out = help(list(count).name);
%     
%     text = strrep(out,upper(strtok(list(count).name,'.')),['''' prop '''']);
%     
%     fprintf(fid,'%s\n',text);
% end
% fclose(fid) 