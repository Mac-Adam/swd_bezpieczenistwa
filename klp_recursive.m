function [out] = klp_recursive(in)
if size(in,1) == 1
    out = in;
    return
end

mid = floor(size(in,1)/2);
left = in(1:mid,:);
right = in((mid+1:end),:);

R = klp_recursive(left);
S = klp_recursive(right);

out = klp_combine(R,S);
end