function revisionHistory
% revisionHistory  Listing of changes to the NMM Toolbox
%
% Version 1.05 released 22-Oct-2007
% Changes:
%
%   o  Archimedes -- increased upper range of n
%   o  loadColData -- change error messages when data cannot be reshaped to rectangle
%   o  brackPlot -- added code to print function name when fun is a function handle
%
% Version 1.04 released 02-Feb-2003
% Changes:
%
%   o  compSplinePlot -- fixed legend so that curves are correctly labelled
%   o  install.m, nmmPathDef.m -- updated installation instructions
%   o  myArrow, myArrow3 -- updated documentation, cleaned up code
%   o  newtonSys -- included maxit in Synopsis and in Input variables
%
%
% Version 1.03 released 20-Aug-2001
% Changes:
%
%   o  fidiff.m -- provide default value for x; superficial changes
%   o  makeHTMLindex.m -- minor tweaks
%   o  traffic.dat -- included traffic.dat in data directory
%   o  velocity.dat -- included velocity.dat in data directory
%   o  xyline.dat -- included xyline.dat in data directory
%   o  yesNoAnswer -- added to utils directory
%
% Version 1.02 released 04-Nov-2000
% Changes:
%
%   o  demoNewtonSys.m -- updated to be consistent with listing in textbook
%   o  demoSSub.m -- updated to be consistent with listing in textbook
%   o  GEPivShow -- updated to be consistent with listing in textbook
%   o  install.m -- minor corrections
%   o  JFresevoir -- added this file, was missing in earlier release
%   o  lineTest.m -- updated with current syntax for linefit
%   o  makeHTMLindex.m -- m-files and data files with short names are now included
%   o  mycon.m -- fixed spelling of "Avogadro"
%   o  nmmCheck.m -- contents.m files are not counted
%   o  NMMfiles.html -- generated with latest version of makeHTMLindex.m
%   o  pathdef.m -- added instructions for use by system administrator
%   o  plotData.m -- replaced call to obselete loadFile function
%   o  splint, splineFE, splintFull -- Changed "beta" to "bbeta" to avoid
%              name clash with built-in beta function
%
%   o  removed some extraneous m-files 
%
% Version 1.01 released 17-Oct-2000
% Changes made to following m-files:
% 
%   halfDiff  -- Reduced digits displayed for delta
%   brackPlot -- Changed ylabel string so that brackPlot now works with
%                in-line function objects
%
% Version 1.0 released 21-Aug-2000

fprintf('\n\tEnter:\n\n\t\t>> help revisionHistory\n');
fprintf('\n\tat the command prompt to display the revision history\n');