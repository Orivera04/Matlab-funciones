findandreplacevalues=inputdlg(...
{'Enter find parameters.  Read ''Find Help'' for explanation','To set search size enter one of above matrices. Not a scalar if mixed.'},...
        'Structure Search',1,{'findarea==[ ]','[ ]'});
if isempty(findandreplacevalues)==0; % means you entered something in the boxes
findexpression=findandreplacevalues{1};
findingmatrix=eval(findandreplacevalues{2});

analysis_area; changerfailed=0;
if exist('analysisarea');

save_undo;
% Keep in order
foundvaluelocations=0; foundvaluelocations2=0;
finding=multi_dimension_transpose(analysisarea);
findingmatrix2=multi_dimension_transpose(findingmatrix);
findingtemp=finding;
[findingrows, findingcolumns, findingplanes]=size(analysisarea);
findingplanessize=findingrows*findingcolumns;
[finding2rows, finding2columns, finding2planes]=size(finding);
[findingmatrixrows, findingmatrixcols, findingmatrixplanes]=size(findingmatrix2);

    
% This computes the find.  There was a one-line find for values.
% This complicated version does matricies or values.
% Rows & columns are reversed since the matrix was transposed!
% Its fixed again during selection at bottom.
% The transpose is because foundvaluelocations goes by element number,
% left to right.  And I want the search to go top to bottom. So we
% transpose everything.

for findcheckingplanes=1:finding2planes-(findingmatrixplanes-1);
    for findcheckingcol=1:finding2columns-(findingmatrixcols-1);
        for findcheckingrows=1:finding2rows-(findingmatrixrows-1);
            findarea=multi_dimension_transpose(finding(findcheckingrows:findcheckingrows+findingmatrixrows-1, findcheckingcol:findcheckingcol+findingmatrixcols-1,findcheckingplanes:findcheckingplanes+findingmatrixplanes-1));
            for findcheckingplanes2=1:finding2planes-(findingmatrixplanes-1);
                for findcheckingcol2=1:finding2columns-(findingmatrixcols-1);
                    for findcheckingrows2=1:finding2rows-(findingmatrixrows-1);
                        findarea2=multi_dimension_transpose(finding(findcheckingrows2:findcheckingrows2+findingmatrixrows-1, findcheckingcol2:findcheckingcol2+findingmatrixcols-1,findcheckingplanes2:findcheckingplanes2+findingmatrixplanes-1));
                        if eval(findexpression) & coordinate2element_num(finding,findcheckingrows,findcheckingcol,findcheckingplanes)<coordinate2element_num(finding,findcheckingrows2,findcheckingcol2,findcheckingplanes2);
                            % section checking against
                            foundvalues=multi_dimension_transpose(finding(findcheckingrows:findcheckingrows+findingmatrixrows-1, findcheckingcol:findcheckingcol+findingmatrixcols-1,findcheckingplanes:findcheckingplanes+findingmatrixplanes-1));
                            evaluate_changer;
                            if exist('changer');
                                findingtemp(findcheckingrows:findcheckingrows+findingmatrixrows-1, findcheckingcol:findcheckingcol+findingmatrixcols-1,findcheckingplanes:findcheckingplanes+findingmatrixplanes-1)=multi_dimension_transpose(changer);
                            else; changerfailed=1;
                            end;
                            % found match
                            foundvalues=multi_dimension_transpose(finding(findcheckingrows2:findcheckingrows2+findingmatrixrows-1, findcheckingcol2:findcheckingcol2+findingmatrixcols-1,findcheckingplanes2:findcheckingplanes2+findingmatrixplanes-1));
                            evaluate_changer;
                            if exist('changer');
                                findingtemp(findcheckingrows2:findcheckingrows2+findingmatrixrows-1, findcheckingcol2:findcheckingcol2+findingmatrixcols-1,findcheckingplanes2:findcheckingplanes2+findingmatrixplanes-1)=multi_dimension_transpose(changer);
                            else; changerfailed=1;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
finding=findingtemp; finding=multi_dimension_transpose(finding);


if strcmp(analysisarealabel,'matrix'); a=finding;
elseif strcmp(analysisarealabel,'selection'); 
    a(selectedoriginrow2:selectedendrow2,selectedorigincol2:selectedendcol2,selectedoriginiteration2:selectedenditeration2)=finding;
elseif strcmp(analysisarealabel,'graphed');
    if dimension==2;
        a(firstrow:firstrow+rowsshown-1,firstcolumn:firstcolumn+columnsshown-1,(currentiteration+1))=finding;
    elseif dimension==1;
        if agraphingrows<=rows;
            a(1:currentiteration+1,firstcolumn:firstcolumn+columnsshown-1)=finding;
        else;
            a(currentiteration-rows+2:currentiteration+1,firstcolumn:firstcolumn+columnsshown-1)=finding;
        end;
    end;
end;
opening_iteration; CA_Display;

else;
    errordlg('Analysis area is Selection, but nothing selected','Error');
end;

if changerfailed==1;
    errordlg('Enter ''replace with'' value or matrix in Input Box','Error');
end;

end;
