function val = getset(object,getprop,setprop,setval);
%function val = getset(object,getprop,setprop,setval);
%Set a property, get another property, and then
%restore the original value to the first property.
oldval = get(object,setprop);
set(object,setprop,setval);
val = get(object,getprop);
set(object,setprop,oldval);
