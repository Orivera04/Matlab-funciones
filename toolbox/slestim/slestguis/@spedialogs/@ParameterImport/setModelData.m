function setModelData(this)
% SETMODELDATA Update the model data from the view settings

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:04 $

% Get the Java handles
Handles = this.Handles;

% Get selected rows
selection = Handles.ImportTable.getSelectedRows + 1;

util  = slcontrol.Utilities;
model = this.Node.getRoot.Model;

TunableVars = this.TunableVars;
TunableVarNames = {TunableVars.Name};
Parameters = this.Node.Parameters;

% Get selected parameters
TunedVars = getTunedVarNames(util, this.Node.Parameters);
TunableDoubles = TunableVars( strcmp( {TunableVars.Type}, 'double' ) );
NewPars = setdiff( {TunableDoubles.Name}, TunedVars );

if all( selection > 0)
  NewPars = NewPars(selection);
  
  % Evaluate new parameters
  pv = evalParameters( util, model, NewPars );
  [junk,idxLoc] = ismember(NewPars, TunableVarNames);
  
  % Add parameters
  for ct = 1:length(NewPars)
    name   = pv(ct).Name;
    value  = pv(ct).Value;
    
    hPar = ParameterEstimator.Parameter(name, value);
    hPar.ReferencedBy = TunableVars(idxLoc(ct)).ReferencedBy;
    
    Parameters = [ Parameters; speforms.ParameterForm(hPar) ];
  end
end

% Expression
Expr = strtrim( char(this.Handles.ImportField.getText) );
if ~isempty(Expr)
  ExpVar = strtok( Expr, '.({' );
  idxTP  = find( strcmp(ExpVar, TunableVarNames) );
  
  if isempty(idxTP)
    errordlg( sprintf( 'Undefined variable %s.', strtok(Expr,'.{(') ), ...
              'Add Parameter Error', 'modal' )
    return
  end
  
  % Try evaluating
  try
    pv = evalParameters( util, model, {Expr} );
  catch
    errordlg(sprintf( 'Expression "%s" could not be evaluated.', Expr), ...
              'Add Parameter Error', 'modal' )
    return
  end
  
  % Check value is double
  if ~isa(pv.Value, 'double')
    errordlg(sprintf('Expression "%s" must evaluate to a double array.', Expr), ...
             'Add Parameter Error', 'modal')
    return
  end

  % Check for valid assignable expression by reassigning the value
  try
    assignParameters( util, model, pv)
  catch
    errordlg( sprintf( 'Expression "%s" is not tunable.', Expr ), ...
              'Add Parameter Error', 'modal' )
    return
  end
  
  % Add parameter
  if ~any( strcmp( Expr, get(Parameters, {'Name'}) ) )
    hPar = ParameterEstimator.Parameter(pv.Name, pv.Value);
    hPar.ReferencedBy = TunableVars(idxTP).ReferencedBy;
    Parameters = [ Parameters; speforms.ParameterForm(hPar) ];
  end
end

% Sort by parameter name
[dummy, idxs]  = sort( get(Parameters, {'Name'}) );
this.Node.Parameters = Parameters( idxs );
