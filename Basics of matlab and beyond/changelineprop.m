function changelineprop(h,PropertyName,PropertyValue)

%function changelineprop(h,PropertyName,PropertyValue)

%Changes objects to the given property.

for jj = h'
   set(jj, PropertyName,PropertyValue)
end
