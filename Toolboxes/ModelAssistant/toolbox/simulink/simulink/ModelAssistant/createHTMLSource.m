function htmlSource = createHTMLSource(PageStyle)
% this function will create HTML source

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:13 $


            CaseSensitive = HTMLattic('AtticData', 'CaseSensitive');
            Grammar = HTMLattic('AtticData', 'Grammar');
            ShowDialogParam = HTMLattic('AtticData', 'ShowDialogParam');
            SearchAnnotation = HTMLattic('AtticData', 'SearchAnnotation');
            SearchSignal = HTMLattic('AtticData', 'SearchSignal');
            SearchBlock = HTMLattic('AtticData', 'SearchBlock');
            %SearchPort = HTMLattic('AtticData', 'SearchPort');
            SearchInport = HTMLattic('AtticData', 'SearchInport');
            SearchOutport = HTMLattic('AtticData', 'SearchOutport');
            % Stateflow objects
            SearchData = HTMLattic('AtticData', 'SearchData');
            ShowFullName = HTMLattic('AtticData', 'ShowFullName');
            model = HTMLattic('AtticData', 'model');
            
HTMLTab = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';            

scope = '';
scope = [scope '  <p>'];
scope = [scope '     Simulink objects:'];
scope = [scope '  </P>'];
if isempty(SearchBlock) || (SearchBlock==1)
    scope = [scope '   <input type="checkbox" name="SearchBlock" checked>  Block'];
else
    scope = [scope '   <input type="checkbox" name="SearchBlock">  Block'];    
end
if isempty(SearchSignal) || (SearchSignal==0)
    scope = [scope '   <input type="checkbox" name="SearchSignal" > Signal '];
else
    scope = [scope '   <input type="checkbox" name="SearchSignal" checked> Signal '];
end
if isempty(SearchAnnotation) || (SearchAnnotation==0)
    scope = [scope '   <input type="checkbox" name="SearchAnnotation" >  Annotation    '];
else
    scope = [scope '   <input type="checkbox" name="SearchAnnotation" checked>  Annotation    '];
end
if isempty(SearchInport) || (SearchInport==0)
    scope = [scope '   <input type="checkbox" name="SearchInport" >  Input port    '];
else
    scope = [scope '   <input type="checkbox" name="SearchInport" checked>  Input port    '];
end
if isempty(SearchOutport) || (SearchOutport==0)
    scope = [scope '   <input type="checkbox" name="SearchOutport" >  Output port    '];
else
    scope = [scope '   <input type="checkbox" name="SearchOutport" checked>  Output port    '];
end

stateflowscope = '';
stateflowscope = [stateflowscope '  <p>'];
stateflowscope = [stateflowscope '     Stateflow objects:'];
stateflowscope = [stateflowscope '  </P>'];
if isempty(SearchData) || (SearchData==1)
    stateflowscope = [stateflowscope '   <input type="checkbox" name="SearchData" checked>  Data'];
else
    stateflowscope = [stateflowscope '   <input type="checkbox" name="SearchData">  Data'];    
end

ActionScope = '';
FOUND_OBJECTS = HTMLattic('AtticData', 'FOUND_OBJECTS');
if isempty(FOUND_OBJECTS)  % auto switch to "withinmodel" if found result is empty
    ActionScope = [ActionScope '   &nbsp;&nbsp;&nbsp;<input type="radio" name="ActionScope" value="withinResult"> Within Search Results'];
    ActionScope = [ActionScope '   &nbsp;<input type="radio" name="ActionScope" value="withinModel" checked> Within System   '];
else
    ActionScope = [ActionScope '   &nbsp;&nbsp;&nbsp;<input type="radio" name="ActionScope" value="withinResult" checked> Within Search Results'];
    ActionScope = [ActionScope '   &nbsp;<input type="radio" name="ActionScope" value="withinModel"> Within System   '];
end
ActionScope = [ActionScope '  </P>'];

CommonOptions = '';
CommonOptions = [CommonOptions '<p> Search criteria:'];
CommonOptions = [CommonOptions '<p> Predefined options'];
CommonOptions = [CommonOptions '<table border="0" width="60%">'];
CommonOptions = [CommonOptions '  <tr>'];
CommonOptions = [CommonOptions '    <td><input type="checkbox" name="paramChecked_1"></td>'];
CommonOptions = [CommonOptions '    <td><select size="1" name="Property_1" onFocus="paramChecked_1.checked=true">'];
%CommonOptions = [CommonOptions '     <option>  </option>'];
CommonOptions = [CommonOptions '     <option selected>BlockType</option>'];
CommonOptions = [CommonOptions '     <option>Name</option>'];
CommonOptions = [CommonOptions '     <option>BlockDescription</option>'];
CommonOptions = [CommonOptions '     <option>OutDataType</option>'];
CommonOptions = [CommonOptions '   </select></td>'];
CommonOptions = [CommonOptions '    <td><select name="IsorNot_1">'];
CommonOptions = [CommonOptions '     <option>is</option>'];
CommonOptions = [CommonOptions '     <option>isnot</option>'];
CommonOptions = [CommonOptions '   </select></td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Value_1" onFocus="paramChecked_1.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td>AND</td>'];
CommonOptions = [CommonOptions '  </tr>'];
CommonOptions = [CommonOptions '  <tr>'];
CommonOptions = [CommonOptions '    <td><input type="checkbox" name="paramChecked_2"></td>'];
CommonOptions = [CommonOptions '    <td><select size="1" name="Property_2" onFocus="paramChecked_2.checked=true">'];
%CommonOptions = [CommonOptions '     <option>  </option>'];
CommonOptions = [CommonOptions '     <option>BlockType</option>'];
CommonOptions = [CommonOptions '     <option selected>Name</option>'];
CommonOptions = [CommonOptions '     <option>BlockDescription</option>'];
CommonOptions = [CommonOptions '     <option>OutDataType</option>'];
CommonOptions = [CommonOptions '   </select></td>'];
CommonOptions = [CommonOptions '    <td><select name="IsorNot_2">'];
CommonOptions = [CommonOptions '     <option>is</option>'];
CommonOptions = [CommonOptions '     <option>isnot</option>'];
CommonOptions = [CommonOptions '   </select> </td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Value_2" onFocus="paramChecked_2.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td>AND</td>'];
CommonOptions = [CommonOptions '  </tr>'];
CommonOptions = [CommonOptions '  <tr>'];
CommonOptions = [CommonOptions '    <td><input type="checkbox" name="paramChecked_3"></td>'];
CommonOptions = [CommonOptions '    <td><select size="1" name="Property_3" onFocus="paramChecked_3.checked=true">'];
%CommonOptions = [CommonOptions '     <option>  </option>'];
CommonOptions = [CommonOptions '     <option>BlockType</option>'];
CommonOptions = [CommonOptions '     <option>Name</option>'];
CommonOptions = [CommonOptions '     <option selected>BlockDescription</option>'];
CommonOptions = [CommonOptions '     <option>OutDataType</option>'];
CommonOptions = [CommonOptions '   </select></td>'];
CommonOptions = [CommonOptions '    <td><select name="IsorNot_3">'];
CommonOptions = [CommonOptions '     <option>is</option>'];
CommonOptions = [CommonOptions '     <option>isnot</option>'];
CommonOptions = [CommonOptions '   </select></td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Value_3" onFocus="paramChecked_3.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td>AND</td>'];
CommonOptions = [CommonOptions '  </tr>'];
CommonOptions = [CommonOptions '  </table>'];
CommonOptions = [CommonOptions '  <tr> Other parameters (specify)</tr>'];
CommonOptions = [CommonOptions '  <table border="0" width="60%">'];
CommonOptions = [CommonOptions '  <tr>'];
CommonOptions = [CommonOptions '    <td><input type="checkbox" name="paramChecked_4"></td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Property_4" size="14" value="" onFocus="paramChecked_4.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td><select name="IsorNot_4">'];
CommonOptions = [CommonOptions '     <option>is</option>'];
CommonOptions = [CommonOptions '     <option>isnot</option>'];
CommonOptions = [CommonOptions '    </select></td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Value_4" size="20" onFocus="paramChecked_4.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td>AND</td>'];
CommonOptions = [CommonOptions '  </tr>'];
CommonOptions = [CommonOptions '    <tr>'];
CommonOptions = [CommonOptions '    <td><input type="checkbox" name="paramChecked_5"></td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Property_5" size="14" value="" onFocus="paramChecked_5.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td><select name="IsorNot_5">'];
CommonOptions = [CommonOptions '     <option>is</option>'];
CommonOptions = [CommonOptions '     <option>isnot</option>'];
CommonOptions = [CommonOptions '   </select></td>'];
CommonOptions = [CommonOptions '    <td><input type="text" name="Value_5" size="20" onFocus="paramChecked_5.checked=true"></td>'];
CommonOptions = [CommonOptions '    <td>AND</td>'];
CommonOptions = [CommonOptions '  </tr>'];
CommonOptions = [CommonOptions '  <tr>'];
CommonOptions = [CommonOptions '    <td></td>'];
CommonOptions = [CommonOptions '    <td></td>'];
CommonOptions = [CommonOptions '    <td></td>'];
CommonOptions = [CommonOptions '    <td></td>'];
CommonOptions = [CommonOptions '    <td></td>'];
CommonOptions = [CommonOptions '  </tr>'];
CommonOptions = [CommonOptions '</table>  '];

sfCommonOptions = '';
sfCommonOptions = [sfCommonOptions '<p> Search criteria:'];
sfCommonOptions = [sfCommonOptions '<p> Predefined options'];
sfCommonOptions = [sfCommonOptions '<table border="0" width="60%">'];
sfCommonOptions = [sfCommonOptions '  <tr>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="checkbox" name="paramChecked_1"></td>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="text" name="Property_1" value="DataType" disabled></td>'];
sfCommonOptions = [sfCommonOptions '    <td><select name="IsorNot_1">'];
sfCommonOptions = [sfCommonOptions '     <option>is</option>'];
sfCommonOptions = [sfCommonOptions '     <option>isnot</option>'];
sfCommonOptions = [sfCommonOptions '   </select></td>'];
sfCommonOptions = [sfCommonOptions '    <td><select size="1" name="Value_1" onFocus="paramChecked_1.checked=true">'];
sfCommonOptions = [sfCommonOptions '     <option>fixpt</option>'];
sfCommonOptions = [sfCommonOptions '     <option>double</option>'];
sfCommonOptions = [sfCommonOptions '     <option>single</option>'];
sfCommonOptions = [sfCommonOptions '     <option>int32</option>'];
sfCommonOptions = [sfCommonOptions '     <option>int16</option>'];
sfCommonOptions = [sfCommonOptions '     <option>int8</option>'];
sfCommonOptions = [sfCommonOptions '     <option>uint32</option>'];
sfCommonOptions = [sfCommonOptions '     <option>uint16</option>'];
sfCommonOptions = [sfCommonOptions '     <option>uint8</option>'];
sfCommonOptions = [sfCommonOptions '     <option>boolean</option>'];
sfCommonOptions = [sfCommonOptions '     <option>ml</option>'];
sfCommonOptions = [sfCommonOptions '   </select></td>'];
sfCommonOptions = [sfCommonOptions '    <td>AND</td>'];
sfCommonOptions = [sfCommonOptions '  </tr>'];
sfCommonOptions = [sfCommonOptions '  </table>'];
sfCommonOptions = [sfCommonOptions '  <tr> Other parameters (specify)</tr>'];
sfCommonOptions = [sfCommonOptions '  <table border="0" width="60%">'];
sfCommonOptions = [sfCommonOptions '  <tr>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="checkbox" name="paramChecked_4"></td>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="text" name="Property_4" size="14" value="Name" onFocus="paramChecked_4.checked=true"></td>'];
sfCommonOptions = [sfCommonOptions '    <td><select name="IsorNot_4">'];
sfCommonOptions = [sfCommonOptions '     <option>is</option>'];
sfCommonOptions = [sfCommonOptions '     <option>isnot</option>'];
sfCommonOptions = [sfCommonOptions '    </select></td>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="text" name="Value_4" size="20" onFocus="paramChecked_4.checked=true"></td>'];
sfCommonOptions = [sfCommonOptions '    <td>AND</td>'];
sfCommonOptions = [sfCommonOptions '  </tr>'];
sfCommonOptions = [sfCommonOptions '    <tr>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="checkbox" name="paramChecked_5"></td>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="text" name="Property_5" size="14" value="" onFocus="paramChecked_5.checked=true"></td>'];
sfCommonOptions = [sfCommonOptions '    <td><select name="IsorNot_5">'];
sfCommonOptions = [sfCommonOptions '     <option>is</option>'];
sfCommonOptions = [sfCommonOptions '     <option>isnot</option>'];
sfCommonOptions = [sfCommonOptions '   </select></td>'];
sfCommonOptions = [sfCommonOptions '    <td><input type="text" name="Value_5" size="20" onFocus="paramChecked_5.checked=true"></td>'];
sfCommonOptions = [sfCommonOptions '    <td>AND</td>'];
sfCommonOptions = [sfCommonOptions '  </tr>'];
sfCommonOptions = [sfCommonOptions '  <tr>'];
sfCommonOptions = [sfCommonOptions '    <td></td>'];
sfCommonOptions = [sfCommonOptions '    <td></td>'];
sfCommonOptions = [sfCommonOptions '    <td></td>'];
sfCommonOptions = [sfCommonOptions '    <td></td>'];
sfCommonOptions = [sfCommonOptions '    <td></td>'];
sfCommonOptions = [sfCommonOptions '  </tr>'];
sfCommonOptions = [sfCommonOptions '</table>  '];

findParameter = '';
%findParameter = [findParameter 'If you don''t know the parameter name, <a href="parameter_search.html">click here</a> for more general search options.'];
%findParameter = [findParameter 'If you don''t know parameter name, you can use <a href="parameter_search.html">Find Parameters </a> feature. Additionally, you can turn on '];
%findParameter = [findParameter '"View All Dialog Parameters" check box to see all available choices.'];

Options = '';
Options = [Options '  <p>'];
Options = [Options '   <select name="Grammar">'];
if isempty(Grammar) || strcmpi(Grammar, 'ContainsWord')
    Options = [Options '     <option selected>Contains word</option>'];
    Options = [Options '     <option>Match whole word</option>'];
    Options = [Options '     <option>Regular expression</option>'];
elseif strcmpi(Grammar, 'MatchWholeWord')
    Options = [Options '     <option>Contains word</option>'];
    Options = [Options '     <option selected>Match whole word</option>'];
    Options = [Options '     <option>Regular expression</option>'];
else 
    Options = [Options '     <option>Contains word</option>'];
    Options = [Options '     <option>Match whole word</option>'];
    Options = [Options '     <option selected>Regular expression</option>'];
end
Options = [Options '     </select>'];
if isempty(CaseSensitive) || (CaseSensitive==0)
    Options = [Options '   <input type="checkbox" name="MatchCase">     Match case for value &nbsp;&nbsp;&nbsp;      '];
else
    Options = [Options '   <input type="checkbox" name="MatchCase" checked>     Match case for value &nbsp;&nbsp;&nbsp;      '];
end
if isempty(ShowDialogParam) || (ShowDialogParam==0)
% temporally remove this option    
%    Options = [Options '   <input type="checkbox" name="ShowDialogParam">     View all dialog parameters '];
else
%    Options = [Options '   <input type="checkbox" name="ShowDialogParam" checked>     View all dialog parameters '];
end
if isempty(ShowFullName) || (ShowFullName==1)
    Options = [Options '   <input type="checkbox" name="ShowFullName" checked>     Show full path name'];
else
    Options = [Options '   <input type="checkbox" name="ShowFullName">     Show full name'];
end
Options = [Options '  </P>'];
Options = [Options '<p>'];
Options = [Options '<p>'];


formHead = '<form method="POST" action="matlab: htmlgateway " name=f>';
formTail = '</form>';
StartPageHeader = '';
StartPageHeader = [StartPageHeader '<head>'];
StartPageHeader = [StartPageHeader '<title> Model Assistant </title>'];
StartPageHeader = [StartPageHeader '</head>'];
%StartPageHeader = [StartPageHeader '<body onLoad=sf()>'];
StartPageHeader = [StartPageHeader '<body>'];
StartPageTitle = '<p align="left"><b>Simulink object search: </b>specify a general Simulink object search and modify action. This search mechanism is useful when you know the specific names of underlying attributes. </b></p>';
sfPageTitle = '<p align="left"><b>Stateflow object search: </b>specify a Stateflow object search. </p>';
javascript = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'translate.js']);
searchButton = '<p align="center"><input type="submit" value="Search" name="submitButton" onClick="htmlEncode(this.form)"></p>';
stateflowsearchButton = '<p align="center"><input type="submit" value="Search" name="sfSearchButton" onClick="htmlEncode(this.form)"></p>';

paramSearchPageHeader = '';
paramSearchPageHeader = [paramSearchPageHeader '<head>'];
paramSearchPageHeader = [paramSearchPageHeader '<title> Model Search and Configure Tool </title>'];
paramSearchPageHeader = [paramSearchPageHeader '</head>'];
%paramSearchPageHeader = [paramSearchPageHeader '<body onLoad=sf()>'];
paramSearchPageHeader = [paramSearchPageHeader '<body>'];
paramSearchPageTitle1 = '<p align="left"><b>Parameter name search using prompt string: </b>search for Simulink parameter attributes by matching text contained within the dialog prompt string of a Simulink block parameter.  This search mechanism is useful when you know the parameter by its dialog prompt, but you don''t know the name of the underlying attribute.</b></p>';
paramSearchPageTitle2 = '<p align="left"><b>Parameter name search using property/value: </b>perform a "fuzzy" search on specified Simulink objects based on a property and/or value pair.  This search mechanism is very useful for isolating the name of an underlying attribute in the absence of any other knowledge.</b></p>';
paramSearchOptions1 = '';
paramSearchOptions1 =[paramSearchOptions1 '<P>Dialog parameter string <input type="text" name="DialogPrompt" size="20"> (e.g., sample time, case is always ignored.)'];
%paramSearchOptions1 =[paramSearchOptions1 '<hr>  '];
paramSearchOptions2 = '';
paramSearchOptions2 =[paramSearchOptions2 '    <p><input type="hidden" name="fuzzySearch" value="off">&nbsp;Specify a partial property/value pair'];  
paramSearchOptions2 =[paramSearchOptions2 '    <p>Attribute <input type="text" name="fuzzyParameter" size="10" value="" onFocus="fuzzySearch.value=''on''"> (e.g., datatype)'];
paramSearchOptions2 =[paramSearchOptions2 HTMLTab];
paramSearchOptions2 =[paramSearchOptions2 '    Value <input type="text" name="fuzzyValue" size="10" onFocus="fuzzySearch.value=''on''">'];
paramSearchOptions2 =[paramSearchOptions2 ' (e.g., sfix, case is always ignored.)'];
paramSearchOptions2 =[paramSearchOptions2 '      </P>'];
%paramSearchOptions2 =[paramSearchOptions2 '<hr>  '];
paramScope = strrep(scope, 'Simulink objects:', '<b>Optionally</b>, narrow down the search scope by limiting to the following objects: ');
paramsearchButton = '<p align="center"><input type="submit" value="Search" name="paramSearchButton" onClick="htmlEncode(this.form)"></p>';

StartNewSearch = '';
StartNewSearch = [StartNewSearch '  <table width="100%" border="0" cellspacing="0" cellpadding="0">'];
StartNewSearch = [StartNewSearch '    <tr> '];
StartNewSearch = [StartNewSearch '      <td width="15" height="50" nowrap> '];
StartNewSearch = [StartNewSearch '        <div align="center"><font size="4" color="#FFFFFF"></font></div>'];
StartNewSearch = [StartNewSearch '      </td>'];
StartNewSearch = [StartNewSearch '      <td width="160" bgcolor="#EEEEEE" height="50" nowrap> '];
StartNewSearch = [StartNewSearch '        <div align="center"><a href="matlab: Jump2Page model_advisor "><font size="4"><b>General Code <br> Generation Goals</b></font></a></div>'];
StartNewSearch = [StartNewSearch '      </td>'];
StartNewSearch = [StartNewSearch '      <td width="15"><img src="pixelclear.gif" width="1" height="1"></td>'];
StartNewSearch = [StartNewSearch '      <td width="160" bgcolor="#EEEEEE" height="50" nowrap> '];
StartNewSearch = [StartNewSearch '        <div align="center"><a href="matlab: Jump2Page model_detail "><font size="4"><b>Detailed Code<br> Generation Goals</b></font></a></div>'];
StartNewSearch = [StartNewSearch '      </td>'];
StartNewSearch = [StartNewSearch '      <td width="15">&nbsp;</td>'];
StartNewSearch = [StartNewSearch '      <td width="160" bgcolor="#EEEEEE" height="50" nowrap> '];
StartNewSearch = [StartNewSearch '        <div align="center"><a href="matlab: Jump2Page model_diagnose "><font size="4"><b>Model Advisor</b></font></a></div>'];
StartNewSearch = [StartNewSearch '      </td>'];
StartNewSearch = [StartNewSearch '      <td width="15">&nbsp;</td>'];
StartNewSearch = [StartNewSearch '      <td width="160" bgcolor="#000099" height="50" nowrap> '];
StartNewSearch = [StartNewSearch '        <div align="center"><font size="4" color="#FFFFFF"><b>Search and Modify</b></font></div>'];
StartNewSearch = [StartNewSearch '      </td>'];
StartNewSearch = [StartNewSearch '      <td width="15">&nbsp;</td>'];
StartNewSearch = [StartNewSearch '      <td>&nbsp;</td>'];
StartNewSearch = [StartNewSearch '    </tr>'];
StartNewSearch = [StartNewSearch '  </table>'];
StartNewSearch = [StartNewSearch '  <table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td height="5" bgcolor="#000099"><img src="pixelclear.gif" width="1" height="1"></td></tr></table>'];
StartNewSearch = [StartNewSearch HTMLattic('AtticData', 'StartInSystemTemplate')];
StartNewSearch = [StartNewSearch '<hr>'];
StartNewSearch = [StartNewSearch '<p><b>Search and modify objects in the current system.  In each case, the search is performed on all blocks contained within ', ...
        'the hierarchy of the active system (not looking under masks.)  Attributes are always case insensitive.  Values follow the "Match case for value" setting ', ...
        'unless otherwise specified.</p>'];
StartNewSearch = [StartNewSearch '<b><br><a href="frequent_task.html"> Frequent tasks</a> ' HTMLTab HTMLTab HTMLTab HTMLTab HTMLTab HTMLTab '<a href="javascript:history.go(-1)"> Back </a> &nbsp;&nbsp; <a href="javascript:history.go(1)"> Forward </a> </p>'];
%StartNewSearch = [StartNewSearch '<br><a href="matlab: SearchConfigWizard"> Simulink object search </a></p>']; 
StartNewSearch = [StartNewSearch '<br><a href="Start.html"> Simulink object search </a></p>']; 
StartNewSearch = [StartNewSearch '<br><a href="Stateflow.html"> Stateflow object search</a> </p>'];
StartNewSearch = [StartNewSearch '<br><a href="SimulinkTextSearch.html"> Search and replace Simulink text</a> </p>'];
StartNewSearch = [StartNewSearch '<br>Parameter name search </p>'];
StartNewSearch = [StartNewSearch '<br>' HTMLTab '<a href="parameter_search1.html"> Using prompt string </a></p>'];
StartNewSearch = [StartNewSearch '<br>' HTMLTab '<a href="parameter_search2.html"> Using property/value </a></p>'];
StartNewSearch = [StartNewSearch '</b><hr>'];
%StartNewSearch = [StartNewSearch '<p align="left"><a
%href="javascript:history.go(-1)"> Back </a> &nbsp;&nbsp; <a href="javascript:history.go(1)"> Forward </a>'];

framePage = '';
framePage = [framePage '<HTML>'];
framePage = [framePage '<HEAD>'];
framePage = [framePage '<TITLE>Model Search and Modify Tool</TITLE>'];
framePage = [framePage '</HEAD>'];
framePage = [framePage '<FRAMESET Cols="25%,75%" CELLSPACING=0>'];
framePage = [framePage '<FRAME scrolling="auto" SRC="menu.html" NAME="rtwreport_contents_frame">'];
framePage = [framePage '<FRAME scrolling="auto" SRC="Start.html"  NAME="rtwreport_document_frame">'];
framePage = [framePage '</FRAMESET>'];
framePage = [framePage '<FRAMESET Cols="100%,*">'];
framePage = [framePage '<FRAME scrolling="auto" SRC="Start.html"  NAME="rtwreport_document_frame">'];
framePage = [framePage '<FRAME>'];
framePage = [framePage '</FRAMESET>'];
framePage = [framePage '</HTML>'];

menuPage = '';
menuPage = [menuPage '<p align="right"><a href="matlab: SearchConfigWizard" TARGET="rtwreport_document_frame"> New Object Search </a></p>'];
menuPage = [menuPage '<p align="right"><a href="parameter_search.html" TARGET="rtwreport_document_frame"> New Parameter Name Search </a></p>'];
menuPage = [menuPage '<p align="right"><a href="frequent_task.html" TARGET="rtwreport_document_frame"> Frequent tasks</a></p>'];

TextSearchPageTitle = '<p align="left"><b>Search and replace Simulink text: </b>perform textural search and replace actions on specified Simulink objects.  The search and replace semantics are the same as for Stateflow search and replace.</p>';
TextSearchcope = '';
TextSearchcope = [TextSearchcope '  <p>'];
TextSearchcope = [TextSearchcope '     Search within:'];
TextSearchcope = [TextSearchcope '  </P>'];
TextSearchcope = [TextSearchcope '   <input type="checkbox" name="SearchParamValue" checked>  Block dialog parameter'];
TextSearchcope = [TextSearchcope '   <input type="checkbox" name="SearchSignalName">  Signal name'];

TextSearchCommonOptions = '<p>';
TextSearchCommonOptions = [TextSearchCommonOptions 'Search for: <input type="text" size=20 name="fuzzyValue" > ' HTMLTab ];
if isempty(CaseSensitive) || (CaseSensitive==0)
    TextSearchCommonOptions = [TextSearchCommonOptions '   <input type="checkbox" name="MatchCase">     Match case&nbsp;&nbsp;&nbsp;      '];
else
    TextSearchCommonOptions = [TextSearchCommonOptions '   <input type="checkbox" name="MatchCase" checked>     Match case&nbsp;&nbsp;&nbsp;      '];
end
TextSearchCommonOptions = [TextSearchCommonOptions '<p>Replace with: <input type="text" size=20 name="fuzzyReplaceValue" >' HTMLTab];
TextSearchCommonOptions = [TextSearchCommonOptions '<input type="checkbox" name="PreserveCase">     Preserve case'];
TextSearchCommonOptions = [TextSearchCommonOptions '   <p><select name="Grammar">'];
if isempty(Grammar) || strcmpi(Grammar, 'ContainsWord')
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option selected>Contains word</option>'];
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option>Match whole word</option>'];
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option>Regular expression</option>'];
elseif strcmpi(Grammar, 'MatchWholeWord')
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option>Contains word</option>'];
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option selected>Match whole word</option>'];
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option>Regular expression</option>'];
else 
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option>Contains word</option>'];
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option>Match whole word</option>'];
    TextSearchCommonOptions = [TextSearchCommonOptions '     <option selected>Regular expression</option>'];
end
TextSearchCommonOptions = [TextSearchCommonOptions '     </select>'];
if isempty(ShowFullName) || (ShowFullName==1)
    TextSearchCommonOptions = [TextSearchCommonOptions '   <input type="checkbox" name="ShowFullName" checked>     Show full path name'];
else
    TextSearchCommonOptions = [TextSearchCommonOptions '   <input type="checkbox" name="ShowFullName">     Show full name'];
end

TextSearchButton = '<p align="center"><input type="submit" value="Search" name="textSearchButton" onClick="htmlEncode(this.form)"></p>';

switch PageStyle
    case 'normal'
        htmlSource = [scope ActionScope CommonOptions findParameter Options];
    case 'StartNewSearch'
        htmlSource = StartNewSearch;
    case 'startPage'
        htmlSource = ['<html>' StartPageHeader javascript formHead StartNewSearch StartPageTitle scope CommonOptions findParameter Options searchButton formTail '</html>'];
    case 'stateflowPage'
        htmlSource = ['<html>' StartPageHeader javascript formHead StartNewSearch sfPageTitle stateflowscope sfCommonOptions Options stateflowsearchButton formTail '</html>'];        
    case 'SimulinkTextSearch'
        htmlSource = ['<html>' StartPageHeader javascript formHead StartNewSearch TextSearchPageTitle TextSearchcope TextSearchCommonOptions TextSearchButton formTail '</html>'];
    case 'paramSearchPage1'
        htmlSource = ['<html>' paramSearchPageHeader javascript formHead StartNewSearch paramSearchPageTitle1 paramSearchOptions1 paramScope CommonOptions Options paramsearchButton formTail '</html>'];
    case 'paramSearchPage2'
        htmlSource = ['<html>' paramSearchPageHeader javascript formHead StartNewSearch paramSearchPageTitle2 paramSearchOptions2 paramScope CommonOptions Options paramsearchButton formTail '</html>'];
    case 'framePage'
        htmlSource = framePage;
    case 'menuPage'
        htmlSource = menuPage;
    otherwise
        htmlSource = [scope ActionScope CommonOptions findParameter Options];
end