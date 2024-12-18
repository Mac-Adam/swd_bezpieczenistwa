function [out] = klp_full(in)
sorted = sortrows(in,1,"descend");
out = klp_recursive(sorted);
 
end