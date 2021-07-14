function  MA = calcma( S , Param )
%% calculate multiple moving averages for time series

% S: time series
% Param: parameter vector for calculating moving averages
% MA (N by T matrix): moving averages for S



%%
T = numel(S); % length of time series
N = numel(Param); % parameter dimension ->决定了多少条均线


%% compute MA
MA = nan(N,T);
for i = 1 : N
    for j = Param(i) : T 
        MA(i, j)  =  mean(  S( j-Param(i)+1 : j )  );
    end
end
