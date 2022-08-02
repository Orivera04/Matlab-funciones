function val = get(dd,prop_name)
% GET Get asset properties from the specified object
% and return the value

if nargin==1    %Return structure of entire object
    val =struct(dd);
else
    try
        val = getfield(struct(dd),prop_name);
    catch
        error([prop_name,' Is not a valid drag and drop property'])
    end
end