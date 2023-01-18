function [C] = encoder4(bits) %Works for Eps 1,2,3
% @author : Xiaoning Lee
     C = zeros(3,length(bits)/2); 
     C(2,:) = bits(1:2:end);
     C(3,:) = bits(2:2:end);
     M = zeros(1,3);
        for i = 1:length(bits)/2
        C(1,i) = M(1,3);
        temp1  = M(1,1);
        temp2  = M(1,2);
        M(1,1) = M(1,3);
        M(1,2) = bitxor(temp1,C(3,i));
        M(1,3) = bitxor(temp2,C(2,i));
        end
      C = reshape(C,1,[]);
end

