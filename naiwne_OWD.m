function P = naiwne_OWD(X)
    % X - rows: kryteria, Col: punkty

    x = X; %kopiowanie

    % n = size(X,2);
    P = zeros(size(x));
    ileP = 0;

    i = 1;
    while i <= size(x,2)
        n = size(x,2); % zapis do porownania
        Y = x(:,i);
        fl = 0;
       
        %for j = i+1:size(x,2)
        j = i+1;
        while j <= size(x,2)
            xj = x(:,j); %DEBUG ONLY
            %if Y≤X(j) usuń X(j) z przeglądanej listy;
            if all(Y <= x(:,j))
                [x,done] = delete_col(x,x(:,j));
                %[P,done] = delete_col(P,x(:,j));
                %ileP = ileP - done;
                j = j-done;
            elseif all(x(:,j) <= Y)
                %{usuń Y z przeglądanej listy X; Y:=X(j); fl=1}
                [x,done] = delete_col(x,Y);
                if j <= size(x,2)
                    Y = x(:,j);
                end
                fl = 1;
                j = j-done;
            end
            j = j+1;
        end

        P(:,ileP+1) = Y(:,1);
        ileP = ileP+1;
        if fl == 0
            % usun Y z x
            [x,~] = delete_col(x,Y);
        end

        if n ~= size(x,2)
            i = i;
        else
            i = i+1;
        end
    end

    P = P(:,1:ileP);
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