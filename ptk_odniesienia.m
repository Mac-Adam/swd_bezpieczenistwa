function [non_dominated, ranking] = ptk_odniesienia(A1,A2,punkty,min_max)

non_dominated = min_max.*klp_full(min_max.*punkty);

punkty_n = size(non_dominated,1);
ranking = zeros([punkty_n,1]);
for i  = 1:punkty_n
    rank = 0;
    objSum = 0;
    for ia1 = 1:size(A1,1)
        for ia2 = 1:size(A2,1)
            inside = 1;
            for n  = 1: size(A1,2)
                if max([A1(ia1,n),A2(ia2,n)]) < non_dominated(i,n)
                    inside = 0;
                    break
                end
                if min([A1(ia1,n),A2(ia2,n)]) > non_dominated(i,n)
                    inside = 0;
                    break
                end
            end
            if(inside)
                obj = abs(prod(A1(ia1,:) - A2(ia2,:)));
                aspiracji = norm(non_dominated(i,:) - A1(ia1,:));
                status_quo = norm(non_dominated(i,:) - A2(ia2,:));
                rank = rank + obj*status_quo/(status_quo+aspiracji);
                objSum  = objSum + obj;
            end

        end
    end

    ranking(i) = rank/objSum    ;
end
end