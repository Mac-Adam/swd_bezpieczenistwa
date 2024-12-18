function P = OWD_z_filtrem(X)
    % X - rows: kryteria, Col: punkty

    x = X'; %kopiowanie

    % n = size(X,2);
    P = zeros(size(x));
    ileP = 0;


    while 1 <= size(x,2)
        n = size(x,2); % zapis do porownania
        Y = x(:,1);
       
        %for j = i+1:size(x,2)
        j = 2;
        while j <= size(x,2)
            %xj = x(:,j); %DEBUG ONLY
            %if Y≤X(j) usuń X(j) z przeglądanej listy;
            if all(Y <= x(:,j))
                [x,done] = delete_col(x,x(:,j));
                %[P,done] = delete_col(P,x(:,j));
                %ileP = ileP - done;
                j = j-done;
            elseif all(x(:,j) <= Y)
                %{usuń Y z przeglądanej listy X; Y:=X(j); fl=1}
                [x,done] = delete_col(x,Y);
                j = j-done;
                if j <= size(x,2)
                    Y = x(:,j);
                end
 
            end
            j = j+1;
        end

        P(:,ileP+1) = Y(:,1);
        ileP = ileP+1;
        %usuń z X wszystkie elementy X(k) takie, że Y≤X(k); //filtracja
        %usuń Y z przeglądanej listy X;
        k = 1;
        while k <= size(x,2)
            if all(Y <= x(:,k))
                [x,done] = delete_col(x,x(:,k));
                k = k-done;
            end
            k = k+1;
        end
        %if X={X(p)} dodaj X(p) do listy punktów //gdy w X został
        %niezdominowanych P; break; end if //tylko jeden element
        if size(x,2) == 1
            P(:,ileP+1) = x(:,1);
            ileP = ileP +1;
            break
        end
    end

    P = P(:,1:ileP);
    P = P';
end

function [newX,done] = delete_col(X,toDel)
    done = 0; %0 jesli nie usunie, 1 jesli usunie
    for i = 1:size(X,2)
        if all(X(:,i) == toDel(:,1))
            newX = [X(:,1:i-1), X(:,i+1:end)];
            done = 1;
            return
        end
    end
    newX = X;
end