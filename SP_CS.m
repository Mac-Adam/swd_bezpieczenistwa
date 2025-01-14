function [non_dominated, ranking] = SP_CS(A1,A2,punkty,min_max)

non_dominated = min_max.*klp_full(min_max.*punkty);

punkty_n = size(non_dominated,1);
ranking = zeros([punkty_n,1]);

ile_pkt_lamanych = 2.*(size(punkty,2)-1);
Fragmenty_Woronoja = zeros(size(A1,1),size(A2,1),ile_pkt_lamanych);
Dlug_Lam = zeros(size(A1,1),size(A2,1)); % potrzebne w normalizacji do 0-1

% tworzenie lamanych szkieletowych dla każdej pary A1 A2 oraz zapis
% dlugosci
for ia1 = 1:size(A1,1)
    for ia2 = 1:size(A2,1)
        [low_fra,upp_fra] = Lamana_szkieletowa(A1(ia1,:),A2(ia2,:));
        Fragmenty_Woronoja(ia1,ia2,:) = [low_fra;flip(upp_fra)]; 
        Dlug_Lam(ia1,ia2) = dlugosc_lamanej([A1(ia1,:) ; low_fra ; flip(upp_fra) ; A2(ia2,:)]);
    end
end

for i  = 1:punkty_n
    spr_pkt = punkty(i,:); %obecnie oceniany punkt
    rank = 0;
    for ia1 = 1:size(A1,1)
        for ia2 = 1:size(A2,1)

            %parametryzacja Lamanej Woronoja - 
            krzyw = [A1(ia1,:); Fragmenty_Woronoja(ia1,ia2,:); A2(ia2,:)];
            
            % odleglosc punktu od lamanej
            % 1. odleglosc od punktow lamanej, gdyby punkt byl nad zgieciem
            metryka = @metr_Czebyszewa;
            min_odl = metryka(spr_pkt,A1(ia1,:));
            min_pkt = A1(ia1,:);
            for ii = 1:ile_pkt_lamanych
                if(min_odl > metryka(spr_pkt,krzyw(ii)))
                    min_odl = metryka(spr_pkt,krzyw(ii));
                    min_pkt = krzyw(ii);
                end
            end
            % 2. odleglosc od odcinkow
            [new_pkt,new_odl] = odl_od_odcinka(metryka,spr_pkt,A1(ai1,:),krzyw(1,:));
            if new_odl < min_odl
                min_pkt = new_pkt;
                min_odl = new_odl;
            end
            [new_pkt,new_odl] = odl_od_odcinka(metryka,spr_pkt,krzyw(end,:),A2(ai2,:));
            if new_odl < min_odl
                min_pkt = new_pkt;
                min_odl = new_odl;
            end
            for ii = (ile_pkt_lamanych-1)
                [new_pkt,new_odl] = odl_od_odcinka(metryka,spr_pkt,krzyw(ii,:),krzyw(ii+1,:));
                if new_odl < min_odl
                    min_odl = new_odl;
                    min_pkt = new_pkt;
                end
            end

            % liczenie dlugosci lamanej do najblizszego punktu do pkt_spr
            % znajdz po ktorym punkcie lamanej jest najblizszy punkt do
            % niej i dodaj odleglosc
            c_cur = 0;   %skoring dla tej krzywej lamanej
            for ii = 1:(ile_pkt_lamanych)
                if all(min_pkt < krzyw(ii,:))
                    if ii == 1
                        c_cur = metryka(A1(ia1,:),min_pkt);
                        break
                    else
                        c_cur = metryka(A1(ia1,:),krzyw(1,:));
                        c_cur = c_cur + metryka(krzyw(ii-1,:),pkt_spr);
                    end
                end
                if ii > 1   
                    c_cur = c_cur + metryka(krzyw(ii,:),krzyw(ii-1,:));
                end
            end

            % normalizacja i aktualizacja scoringu punktu
            c_cur = c_cur/Dlug_Lam(ia1,ia2); %normalizacja 0-1
            rank = min(rank,c_cur);

        end
    end
    ranking(i) = rank;
end
end

function [pkt,odl] = odl_od_odcinka(metryka,pkt,pkt_pros1,pkt_pros2)
    a = pkt_pros2-pkt_pros1; %wsp kierunkowy
    A = [1;-1];
    b = [1;0];
    % x wynosi od 0 do 1
    [x,odl] = fmincon(@(x)metryka(pkt,pkt_pros1+a*x),pkt_pros1,A,b);
    pkt = pkt_pros1+a*x;
end

function dl = metr_Czebyszewa(pkt1,pkt2)
    dl = 0;
    for i = 1:length(pk1)
        dl = max(dl,abs(pkt1-pkt2));
    end
end

function dl = dlugosc_lamanej(metryka,punkty)
    dl = 0;
    for i = 1:(size(punkty,1)-1)
        dl = dl + metryka(punkty(i,:),punkty(i+1,:));
    end
end