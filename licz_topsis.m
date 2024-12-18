
function[ranking]=licz_topsis(daneA, min_max, wektorWag)    

[liczbaAlternatyw,iloscKryteriow] = size(daneA);

 % proces skalowania 
 macierz_skalowana = zeros(liczbaAlternatyw,iloscKryteriow); 
 for i =1:liczbaAlternatyw     
     for j =1:iloscKryteriow         
         macierz_skalowana(i,j) = (daneA(i,j) * wektorWag(j))/ norm(double(daneA(:,j)));
     end
 end
 % wyznaczenie wektora idealnego oraz antyidealnego
 % Funkcja przyjmuje tylko niezdominowane, więc tak naoprawdę używany jest
 % punkt nadir
 % jeści dla dangeo kryterium wartość min_max jest równa 1 kryterium jest
 % maksymalzowane, jak -1 minimalizowane
 wektorIdealny = min_max.*max(min_max.*macierz_skalowana);
 wektorAntyIdealny = min_max.*min(min_max.*macierz_skalowana);

 odleglosci = zeros(liczbaAlternatyw,2); 
 for i =1:liczbaAlternatyw     
     odleglosci(i,1) = norm(macierz_skalowana(i,:)-wektorIdealny);     
     odleglosci(i,2) = norm(macierz_skalowana(i,:)-wektorAntyIdealny);  
 end
 % uszeregowanie obiektow 
 ranking = zeros(liczbaAlternatyw,2); 
 for i =1:liczbaAlternatyw     
     ranking(i,1) = i;         
     ranking(i,2) = odleglosci(i,2)/(odleglosci(i,1)+odleglosci(i,2)); 
 end
 