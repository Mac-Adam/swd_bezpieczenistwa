function [new_low,new_upp] = Lamana_szkieletowa(low,upp)
    %odczyt punktow w tej kolejnosci:
        %low,new_low(1 do end),new_upp(end do 1), upp

    %N - ile kryteriow
    %upp - punkt gorny
    %low - punkt dolny
    
    N = length(low);
    
    d = zeros(N,1);
    for i = 1:N
        d(i) = (upp(i) - low(i))/2;
    end
    %a)
    d = sort(d);
    
    %b)
    new_upp = zeros(N-1,N);
    new_low = zeros(N-1,N);
    for j = 1:N-1
        for i = 1:N
            if(j == 1)
                new_upp(j,i) = upp(i) - d(j);
                new_low(j,i) = low(i) + d(j);
                continue
            end
            if(j-1 < i)
                new_upp(j,i) = new_upp(j-1,i) - d(j);
                new_low(j,i) = new_low(j-1,i) + d(j);
                continue
            end
            if(i <= j-1)
                new_upp(j,i) = new_upp(j-1,i);
                new_low(j,i) = new_low(j-1,i);
                continue
            end
        end
        %obliczanie nowego d
        for i = 1:N
            d(i) = (new_upp(j,i) - new_low(j,i))/2;
        end
        d = sort(d);
    end
    
    %%% do testow
    % dwa kryteria
%     figure
%     plot_data = [low; new_low; new_upp; upp];
%     plot(plot_data(:,1),plot_data(:,2))

    % trzy kryteria
%      figure
%      plot_data = [low; new_low; flip(new_upp); upp];
%      subplot(311)
%      plot(plot_data(:,1),plot_data(:,2))
%      subplot(312)
%      plot(plot_data(:,1),plot_data(:,3))
%      subplot(313)
%      plot(plot_data(:,2),plot_data(:,3))


end