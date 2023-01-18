function [decoded] = decoder1(y, N)
%DECODER1 Viterbi hard decoder for E1
%   Decoder for 1+D^2 1+D+D^2
% @author Maxime Favier

% bit separation
y0 = y(1:2:end);
y1 = y(2:2:end);

dist = zeros(4,N+1); % cumulative metrics
transit = zeros(8,N); % branch metrics
% initialisation
dist(1,1) = 0; % we start from state 00
dist(2,1) = Inf;
dist(3,1) = Inf;
dist(4,1) = Inf;

for i=1:N
    % compute branch metrics
    transit(1,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2); % transition from 00 to 00
    transit(2,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2); % from 00 to 10
    transit(3,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 10 to 01
    transit(4,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 10 to 11
    transit(5,i) = sqrt((1 - y0(i))^2 + (1 - y1(i))^2); % from 01 to 00
    transit(6,i) = sqrt((0 - y0(i))^2 + (0 - y1(i))^2); % from 01 to 10
    transit(7,i) = sqrt((1 - y0(i))^2 + (0 - y1(i))^2); % from 11 to 01
    transit(8,i) = sqrt((0 - y0(i))^2 + (1 - y1(i))^2); % from 11 to 11

    % compute cumulative metrics for each states
    dist(1,i+1) = min(dist(1,i) + transit(1,i), dist(3,i) + transit(5,i)); % 00
    dist(2,i+1) = min(dist(1,i) + transit(2,i), dist(3,i) + transit(6,i)); % 10 
    dist(3,i+1) = min(dist(2,i) + transit(3,i), dist(4,i) + transit(7,i)); % 01
    dist(4,i+1) = min(dist(2,i) + transit(4,i), dist(4,i) + transit(8,i)); % 11     
end

[~,state] = min(dist(:,N+1)); % get state of the minimum weight at the last sample

decoded = NaN(1, N); % decoded bits
% decoding from the last bit to the first
for j=N:-1:1
     % state 1 ==> 00
     if(state == 1)
        if(dist(1,j)+transit(1, j) <= dist(3, j) + transit(5, j))
            % from 00 to 00
            state = 1; 
            decoded(j) = 0;
        else
            % from 01 to 00
            state = 3;
            decoded(j) = 0;
        end
    % state 2 ==> 10
    elseif(state==2)
        if(dist(1, j) + transit(2, j) <= dist(3, j) + transit(6, j))
            % from 00 to 10
            state = 1;
            decoded(j) = 1;
        else
            % from 01 to 10
            state = 3;
            decoded(j) = 1;
        end
    % state 3 ==> 01
    elseif(state==3)
        if(dist(2, j) + transit(3, j) <= dist(4, j) + transit(7, j))
            % from 10 to 01
            state = 2;
            decoded(j) = 0;
        else
            % from 11 to 01
            state = 4;
            decoded(j) = 0;
        end
    % state 4 ==> 11
    elseif(state==4)
        if(dist(2, j) + transit(4, j) <= dist(4, j) + transit(8, j))
            % from 10 to 11
            state = 2;
            decoded(j) = 1;
        else
            % from 11 to 11
            state = 4;
            decoded(j) = 1;
        end
    end
end

%BitErrs = sum(a ~= decoded)

end

