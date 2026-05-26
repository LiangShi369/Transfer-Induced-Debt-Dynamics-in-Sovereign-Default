function [Ft1,Ft2,lambda,Ft_un,N] = exostates_shocked(f,shock,rhof,sdf,nos,nrep,tburn1,tburn2)

%% define parameters and vectors
N = tburn1 + nos; 
N1 = tburn2 + N;  % the length of produced series

Ft1 = zeros(N,nrep);
Ft2 = zeros(N,nrep);
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


%% shocked pathes
[~,ife] = sort(abs(f - shock)); % find the nearest state of g grid to shock
f1 = f(ife(1)); % 1st nearest value
f2 = f(ife(2)); % 2nd nearest value
lambda = (shock-f2)/(f1-f2); % g1 path takes lamb weight, g2 path takes (1-lamb) weight

for rep = 1:nrep

  ft1 = zeros(N1,1); 
  ft2 = zeros(N1,1); 
 
  for i = 2:N1
      if i == N1-nos+1
          ft1(i,1) = rhof*ft1(i-1,1) + f_shocks_m(i,rep) + f1;
          ft2(i,1) = rhof*ft2(i-1,1) + f_shocks_m(i,rep) + f2;
      else
          ft1(i,1) = rhof*ft1(i-1,1) + f_shocks_m(i,rep);
          ft2(i,1) = rhof*ft2(i-1,1) + f_shocks_m(i,rep);
      end
  end
  Ft1(:,rep) = ft1(tburn2+1:end,1);
  Ft2(:,rep) = ft2(tburn2+1:end,1);
end


end

