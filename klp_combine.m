function [out] = klp_combine(R,S)
R = sortrows(R,1,'descend');
%R = [R;-inf(1,size(R,2))];
S = sortrows(S,1,'ascend');

out = R;
for i = 1:size(S,1)
    flag = 0;
    for k = 1:size(R,1)
        if all(S(i,:) <= R(k,:))
            flag = 1;
            break
        end
    end
    if  flag == 0
        out = [out;S(i,:)];
    end
end
end