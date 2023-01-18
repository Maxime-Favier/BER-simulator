function [decoded] = decoder3(y, N)
%DECODER2 Decode the data encoded with the E3 convolutional encoder
%   decode the vector encoded with G = 1+D^3+D^4, 1+D+D^3+D^4
% @author: Maxime Favier

y0 = y(1:2:end);
y1 = y(2:2:end);

dist = zeros(16,N+1); % cumulative metrics
transit = zeros(32,N); % branch metrics
% initialisation
dist(1,1) = 0; % we start from state 00
dist((2:16),1) = Inf;

for i=1:N
    % compute branch metrics
    transit(1,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2);  % from 0000 to 0000
    transit(2,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2);  % from 0000 to 1000
    transit(3,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2);  % from 0001 to 0000
    transit(4,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2);  % from 0001 to 1000
    transit(5,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2);  % from 0010 to 0001
    transit(6,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2);  % from 0010 to 1001
    transit(7,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2);  % from 0011 to 0001
    transit(8,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2);  % from 0011 to 1001
    transit(9,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2);  % from 0100 to 0010
    transit(10,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2); % from 0100 to 1010
    transit(11,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2); % from 0101 to 0010
    transit(12,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2); % from 0101 to 1010
    transit(13,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2); % from 0110 to 0011
    transit(14,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2); % from 0110 to 1011
    transit(15,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2); % from 0111 to 0011
    transit(16,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2); % from 0111 to 1011
    transit(17,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1000 to 0100
    transit(18,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1000 to 1100
    transit(19,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1001 to 0100
    transit(20,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1001 to 1100
    transit(21,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1010 to 0101
    transit(22,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1010 to 1101
    transit(23,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1011 to 0101
    transit(24,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1011 to 1101
    transit(25,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1100 to 0110
    transit(26,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1100 to 1110
    transit(27,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1101 to 0110
    transit(28,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1101 to 1110
    transit(29,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1110 to 0111
    transit(30,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1110 to 1111
    transit(31,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 1111 to 0111
    transit(32,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 1111 to 1111

    % compute cumulative metrics for each states
    dist(1,i+1) = min(dist(1,i) + transit(1,i), dist(2,i) + transit(3,i));      % 0000
    dist(2,i+1) = min(dist(3,i) + transit(5,i), dist(4,i) + transit(7,i));      % 0001 
    dist(3,i+1) = min(dist(5,i) + transit(9,i), dist(6,i) + transit(11,i));     % 0010
    dist(4,i+1) = min(dist(7,i) + transit(13,i), dist(8,i) + transit(15,i));    % 0011    
    dist(5,i+1) = min(dist(9,i) + transit(17,i), dist(10,i) + transit(19,i));   % 0100     
    dist(6,i+1) = min(dist(11,i) + transit(21,i), dist(12,i) + transit(23,i));  % 0101     
    dist(7,i+1) = min(dist(13,i) + transit(25,i), dist(14,i) + transit(27,i));  % 0110 
    dist(8,i+1) = min(dist(15,i) + transit(29,i), dist(16,i) + transit(31,i));  % 0111     
    dist(9,i+1) = min(dist(1,i) + transit(2,i), dist(2,i) + transit(4,i));      % 1000     
    dist(10,i+1) = min(dist(3,i) + transit(6,i), dist(4,i) + transit(8,i));     % 1001     
    dist(11,i+1) = min(dist(5,i) + transit(10,i), dist(6,i) + transit(12,i));   % 1010     
    dist(12,i+1) = min(dist(7,i) + transit(14,i), dist(8,i) + transit(16,i));   % 1011     
    dist(13,i+1) = min(dist(9,i) + transit(18,i), dist(10,i) + transit(20,i));  % 1100     
    dist(14,i+1) = min(dist(11,i) + transit(22,i), dist(12,i) + transit(24,i)); % 1101     
    dist(15,i+1) = min(dist(13,i) + transit(26,i), dist(14,i) + transit(28,i)); % 1110     
    dist(16,i+1) = min(dist(15,i) + transit(30,i), dist(16,i) + transit(32,i)); % 1111     

end

[~,state] = min(dist(:,N+1)); % get state with the minimum weight at the last sample

decoded = NaN(1, N); % decoded bits
% decoding from the last bit to the first
for j=N:-1:1
     % state 1 ==> 0000
     if(state == 1)
        if(dist(1,j)+transit(1, j) <= dist(2, j) + transit(3, j))
            % from 0000 to 0000
            state = 1; 
            decoded(j) = 0;
        else
            % from 0001 to 0000
            state = 2;
            decoded(j) = 0;
        end
    % state 2 ==> 0001
    elseif(state==2)
        if(dist(3, j) + transit(5, j) <= dist(4, j) + transit(7, j))
            % from 0010 to 0001
            state = 3;
            decoded(j) = 0;
        else
            % from 0011 to 0001
            state = 4;
            decoded(j) = 0;
        end
    % state 3 ==> 0010
    elseif(state==3)
        if(dist(5,j) + transit(9,j) <= dist(6,j) + transit(11,j))
            % from 0100 to 0010
            state = 5;
            decoded(j) = 0;
        else
            % from 0101 to 0010
            state = 6;
            decoded(j) = 0;
        end
    % state 4 ==> 0011
    elseif(state==4)
        if(dist(7,j) + transit(13,j) <= dist(8,j) + transit(15,j))
            % from 0110 to 0011
            state = 7;
            decoded(j) = 0;
        else
            % from 0111 to 0011
            state = 8;
            decoded(j) = 0;
        end
    % state 5 ==> 0100
    elseif(state==5)
        if(dist(9,j) + transit(17,j) <= dist(10,j) + transit(19,j))
            % from 1000 to 0100
            state = 9;
            decoded(j) = 0;
        else
            % from 1001 to 0100
            state = 10;
            decoded(j) = 0;
        end
    % state 6 ==> 0101
    elseif(state==6)
        if(dist(11,j) + transit(21,j) <= dist(12,j) + transit(23,j))
            % from 1010 to 0101
            state = 11;
            decoded(j) = 0;
        else
            % from 1011 to 0101
            state = 12;
            decoded(j) = 0;
        end        
    % state 7 ==> 0110
    elseif(state==7)
        if(dist(13,j) + transit(25,j) <= dist(14,j) + transit(27,j))
            % from 1100 to 0110
            state = 13;
            decoded(j) = 0;
        else
            % from 1101 to 0110
            state = 14;
            decoded(j) = 0;
        end        
    % state 8 ==> 0111
    elseif(state==8)
        if(dist(15,j) + transit(29,j) <= dist(16,j) + transit(31,j))
            % from 1110 to 0111
            state = 15;
            decoded(j) = 0;
        else
            % from 1111 to 0111
            state = 16;
            decoded(j) = 0;
        end         
    % state 9 ==> 1000
    elseif(state==9)
        %dist(1,i) + transit(2,i)
        %dist(2,i) + transit(4,i)
        if(dist(1,j) + transit(2,j) <= dist(2,j) + transit(4,j))
            % from 0000 to 1000
            state = 1;
            decoded(j) = 1;
        else
            % from 0001 to 1000
            state = 2;
            decoded(j) = 1;
        end         
    % state 10 ==> 1001
    elseif(state==10)
        if(dist(3,j) + transit(6,j) <= dist(4,j) + transit(8,j))
            % from 0010 to 1001
            state = 3;
            decoded(j) = 1;
        else
            % from 0011 to 1001
            state = 4;
            decoded(j) = 1;
        end
    % state 11 ==> 1010
    elseif(state==11)
        if(dist(5,j) + transit(10,j) <= dist(6,j) + transit(12,j))
            % from 0100 to 1010
            state = 5;
            decoded(j) = 1;
        else
            % from 0101 to 1010
            state = 6;
            decoded(j) = 1;
        end
    % state 12 ==> 1011
    elseif(state==12)
        if(dist(7,j) + transit(14,j) <= dist(8,j) + transit(16,j))
            % from 0110 to 1011
            state = 7;
            decoded(j) = 1;
        else
            % from 0111 to 1011
            state = 8;
            decoded(j) = 1;
        end
    % state 13 ==> 1100
    elseif(state==13)
        if(dist(9,j) + transit(18,j) <= dist(10,j) + transit(20,j))
            % from 1000 to 1100
            state = 9;
            decoded(j) = 1;
        else
            % from 1001 to 1100
            state = 10;
            decoded(j) = 1;
        end
    % state 14 ==> 1101
    elseif(state==14)
        if(dist(11,j) + transit(22,j) <= dist(12,j) + transit(24,j))
            % from 1010 to 1101
            state = 11;
            decoded(j) = 1;
        else
            % from 1011 to 1101
            state = 12;
            decoded(j) = 1;
        end
    % state 15 ==> 1110
    elseif(state==15)
        if(dist(13,j) + transit(26,j) <= dist(14,j) + transit(28,j))
            % from 1100 to 1110
            state = 13;
            decoded(j) = 1;
        else
            % from 1101 to 1110
            state = 14;
            decoded(j) = 1;
        end
    % state 16 ==> 1111
    elseif(state==16)
        if(dist(15,j) + transit(30,j) <= dist(16,j) + transit(32,j))
            % from 1110 to 1111
            state = 15;
            decoded(j) = 1;
        else
            % from 1111 to 1111
            state = 16;
            decoded(j) = 1;
        end
    end
end
end

