%% BIOWEBSERVICEDEMO: Example of using a SOAP based web service
% This demonstration illustrates how to use a Simple Object Access Protocol
% (SOAP) based web service from within MATLAB. In the example you will
% connect to the OpenBQS Bibliographic Query Service server at the European
% Bioinformatics Institute (http://industry.ebi.ac.uk/openBQS) and use it
% to retrieve information from MEDLINE. 
%
% For more information on the use of web services see the "Using Web
% Services in MATLAB" section of the MATLAB External Interface manual. 
%
%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.1.4.3 $  $Date: 2004/04/14 23:57:03 $ 

if playbiodemo, return; end % Open in the editor or run step-by-step

%% Setting up a web service
% In MATLAB, you use the createClassFromWSDL function to call Web service
% methods. The function creates a MATLAB class based on the Web Services
% Description Language (WSDL) definition for the web service. To use the
% function you provide a URL for the WSDL definition of the service.

% OpenBQS WSDL definition URL
wsdlURL = 'http://industry.ebi.ac.uk/openBQS/copies/BQSWebService.wsdl';

%%
% Create the classes. This will create a directory called @bqswebservice in
% the current directory.
className = createClassFromWSDL(wsdlURL)

%% 
% The @bqswebservice directory contains automatically generated files that
% implement the openBQS web service methods.
dir @bqswebservice

%% 
% In addition to looking at the contents of the methods directory, you can
% also use the *methods* command to see what methods are available. You
% will notice that there are more methods available than files in the
% @bqswebservice directory. These are inherited methods that are available
% for all objects in MATLAB.

methods(bqswebservice)

%% Using the web service
% In order to use the web service, you must first create an instance of the
% bqswebservice.

bqsws = bqswebservice;

%%
% You can confirm that this is an instance of the bqswebservice using the
% *class* command.
class(bqsws)

%%
% The *getbibrefcount* method returns the total number of references in the
% repository.

getbibrefcount(bqsws)

%%
% The *getallvocabularynames* methods returns the names of all available
% controlled vocabularies.

getallvocabularynames(bqsws)

%%
% You can access citation information for a specific MEDLINE entry using
% the *getbyid* method. This returns the information as Base64 encrypted
% XML.

infoBase64 = getbyid(bqsws,10194334,'xml');

%%
% You can decode the Base64 encryption using this Java method.

info = char(org.apache.xerces.impl.dv.util.Base64.decode(infoBase64));

Title = char(regexp(info,'(?<=<ArticleTitle>)[^<]+','match'))
Authors = char(regexp(info,'(?<=<LastName>)[^<]+','match'))

%% Writing an XML file
% You can save the XML text to a file using the *fprintf* function.

filename = 'webservicedata.xml';
fid = fopen(filename,'w');
fprintf(fid,'%c',info);
fclose(fid);

%% Viewing an XML file
% You can view the contents of the file using a web browser.

web(filename,'-browser')

%% Using a stylesheet and XSLT to transform the XML document
% The XML file is in a very generic format that is very convenient for
% storing and transferring data but is not particularly easy to read.
% An XSLT stylesheet describes transformations that can be used to convert
% the data in an XML file into a different type of document. There is a
% sample stylesheet for Medline data called medline.xsl in the biodemos
% directory. The *xslt* function using this to convert the XML file into a
% much more easily readable document. For more details on XSL see
% http://www.w3.org/Style/XSL

xslt(filename,'medline.xsl','-web');

%% Converting an XML file to a structure
% The function *xml2struct* converts an XML file into a MATLAB structure.
% The structure contains four fields, Name, Attributes, Data and Children.
% If a field has children then the Children field will be a structure with
% the same fields containing the nested information. This nesting can be
% many layers deep.

S = xml2struct(filename)
firstLevel = S.Children(4)
secondLevel = S.Children(4).Children(2)
thirdLevel = S.Children(4).Children(2).Children

