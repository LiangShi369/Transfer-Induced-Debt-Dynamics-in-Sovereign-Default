function [Ft,Ft_un,N] = exostates_unshocked(rhof,sdf,nos,nrep,tburn1,tburn2)

%% define parameters and vectors
N = tburn1 + nos; 
N1 = tburn2 + N;  % the length of produced series

Ft_un = zeros(N,nrep); 
f_shocks_m = normrnd(0,sdf,[N1,nrep]); % random shocks

%% comparative unshocked pathes
for rep = 1:nrep
    ft_un = zeros(N1,1);  
    for i = 2:N1
      ft_un(i,1) = rhof*ft_un(i-1,1) + f_shocks_m(i,rep);
    end
    Ft_un(:,rep) = ft_un(tburn2+1:end,1);
end

Ft = Ft_un;

end

