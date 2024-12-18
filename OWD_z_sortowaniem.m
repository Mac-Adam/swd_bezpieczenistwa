function [P] = OWD_z_sortowaniem(X,k)
x = sortrows(X,k,'descend');
P = OWD_z_filtrem(x);
end