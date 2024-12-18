function [A1,A2,res] = rozdziel_punkty(Dane,min_max)
A1 = min_max.*klp_full(min_max.*Dane);
A2 = (-min_max).*klp_full((-min_max).*Dane);
A1_sorted = sortrows(A1);
A2_sorted = sortrows(A2);
i = 1;
maxi = size(A1,1);
j = 1;
maxj = size(A2,1);
k = 1;
Dane = sortrows(Dane);
res = zeros(size(Dane) - [maxi+maxj,0]);
n = 1;
disp(size(Dane,1))
while k < size(Dane,1)
    if (i <= maxi )&& all(Dane(k,:) == A1_sorted(i,:))
        i = i+1;
        k = k +1;
        continue;
    end
    if (j <= maxj )&& all( Dane(k,:) == A2_sorted(j,:))
        j = j+1;
        k = k+1;
        continue;
    end
    res(n,:) = Dane(k,:);
    k = k+1;
    n = n+1;
end

end