function [Bits] = EN4(SymbolsC)
% author : Xiaoning Lee
N = length(SymbolsC);
ac_metric = zeros(8,N); 
s_paths = zeros(8,N); % saves the previous state of the least weight state
Bits = zeros(1,2*N);  % saves a one or a zero

Next_State = zeros(8,4);

for i = 1:8
   state = dec2bin(i-1,3)-'0';
   for j = 1:4
       next_state = state;
       u = dec2bin(j-1,2)-'0';
       next_state(1,1) = state(1,3);
       next_state(1,2) = bitxor(state(1,1),u(1,2));
       next_state(1,3) = bitxor(state(1,2),u(1,1));
       Next_State(i,j) = bi2de(next_state,'left-msb')+1;
   end
end

prev_state = zeros(8,4);

for i = 1:8
   for j = 1:4
      ind = Next_State(i,j);
      prev_state(ind,round(i/2)) = i;
   end
end

    next_code =[0 0 0; 0 1 0; 0 0 1; 0 1 1; 0 1 0; 0 0 0; 0 1 1; 0 0 1; 0 0 1; 0 1 1; 0 0 0; 0 1 0; 0 1 1; 0 0 1; 0 1 0; 0 0 0; 1 0 0; 1 1 0;1 0 1; 1 1 1; 1 1 0; 1 0 0; 1 1 1; 1 0 1; 1 0 1; 1 1 1; 1 0 0; 1 1 0; 1 1 1; 1 0 1; 1 1 0; 1 0 0];

    % Initialize first step
    symb_seq = SymbolsC(1:1);
    ac_metric(:,2) = 1000;
    s_paths(:,2) = 0;
    
    a1 = symb_seq - mapper_4(next_code(1,:)); 
    a2 = symb_seq - mapper_4(next_code(5,:)); %Fifth element represents the code from state 1 --> 2
    a3 = symb_seq - mapper_4(next_code(9,:)); 
    a4 = symb_seq - mapper_4(next_code(13,:)); 
    
    ac_metric(1,2) = sum(real(a1).^2 + imag(a1).^2); %extract the symbol from const that corresponds to next code
    ac_metric(2,2) = sum(real(a2).^2 + imag(a2).^2); %Sum is needed to work for BPSK.
    ac_metric(3,2) = sum(real(a3).^2 + imag(a3).^2); 
    ac_metric(4,2) = sum(real(a4).^2 + imag(a4).^2);
    s_paths(1,2) = 1;
    s_paths(2,2) = 1;  
    s_paths(3,2) = 1;
    s_paths(4,2) = 1; 
    
    %next_code =[0 0 0 0 1 0 0 0 1 0 1 1 0 1 0 0 0 0 0 1 1 0 0 1 0 0 1 0 1 1 0 0 0 0 1 0 0 1 1 0 0 1 0 1 0 0 0 0 1 0 0 1 1 0 1 0 1 1 1 1 1 1 0 1 0 0 1 1 1 1 0 1 1 0 1 1 1 1 1 0 0 1 1 0 1 1 1 1 0 1 1 1 0 1 0 0];
    next_code = reshape(transpose(next_code),1,[]);
for i = 2:N % n = number of symbols to decode
          symb_seq = SymbolsC(i:i);  %For QPSK
          next_symbols = transpose(mapper_4(next_code)); %Row table with next symbols 
      
          b_metric = symb_seq - next_symbols; 
          b_metric = sum(real(b_metric).^2 + imag(b_metric).^2,2);
         for j=1:8 %Go through all states 
             [MIN,INDEX] = min(ac_metric(prev_state(j,:)',i) + b_metric(4*j-3:4*j,1)); %INDEX is 1 or 2 for the min prev_state
             s_paths(j,i+1) = prev_state(j,INDEX);
             ac_metric(j,i+1) = MIN;
         end
end

[~, Ind] = min(ac_metric(:,end));
%Ind = s_paths(Ind,end);
next_code =[0 0 0; 0 1 0; 0 0 1; 0 1 1; 0 1 0; 0 0 0; 0 1 1; 0 0 1; 0 0 1; 0 1 1; 0 0 0; 0 1 0; 0 1 1; 0 0 1; 0 1 0; 0 0 0; 1 0 0; 1 1 0;1 0 1; 1 1 1; 1 1 0; 1 0 0; 1 1 1; 1 0 1; 1 0 1; 1 1 1; 1 0 0; 1 1 0; 1 1 1; 1 0 1; 1 1 0; 1 0 0];

for k=1:N
    prev_Ind = s_paths(Ind,end-k+1); %Previous state, Ind is the same as a state.
    %code_index = [Ind round(prev_Ind/2)]; Figure out the code
    code_index = (Ind-1)*4 + round(prev_Ind/2);
    bits = next_code(code_index,:);
    Bits(end-2*k+1:end-2*k+2) = bits(2:3);
    Ind = prev_Ind;
end

end