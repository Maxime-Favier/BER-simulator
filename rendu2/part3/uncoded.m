function [bits_est] = uncoded(y,const_mode)
% @author : Xiaoning Lee
BPSK = [1 -1]; %[-1 1]
QPSK = [1+1i    1-1i    -1+1i    -1-1i]./sqrt(2);
AMPM= [1-1i  -3+3i  1+3i  -3-1i  3-3i  -1+1i  3+1i  -1-3i]./sqrt(10);


switch const_mode
    case 1
        y_repmat = repmat(y,2,1);
        const_repmat = repmat(transpose(BPSK),1,length(y));
        x_abs_repmat = abs(y_repmat - const_repmat);
        [~,symbol_index_est] = min(x_abs_repmat);
        bits_est = de2bi((symbol_index_est-1)','left-msb');
        bits_est = reshape(bits_est',1,length(y));
    case 2
        y_repmat = repmat(y,4,1);
        const_repmat = repmat(transpose(QPSK),1,length(y));
        x_abs_repmat = abs(y_repmat - const_repmat);
        [~,symbol_index_est] = min(x_abs_repmat);
        bits_est = de2bi((symbol_index_est-1)','left-msb');
        bits_est = reshape(bits_est',1,2*length(y));
    case 3
        y_repmat = repmat(y,8,1);
        const_repmat = repmat(transpose(AMPM),1,length(y));
        x_abs_repmat = abs(y_repmat - const_repmat);
        [~,symbol_index_est] = min(x_abs_repmat);
        bits_est = de2bi((symbol_index_est-1)','left-msb');
        bits_est = reshape(bits_est',1,3*length(y));
        bits_est = bits_est(1:end-2); 
end
end