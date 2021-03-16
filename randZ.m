function Z = randZ(N)
% Z = randZ(N) 
%
%
% Calculates the redshifts of a uniformly distributed sample based on the comoving distance. 
% The distance of the elements is the comoving distance. The max. dist. is 
% 9.2 Gpc. It calculates Z from the table zLinCom. Z max is 8.2.
% Andor Budai (2019); Eötvös University, Institute of Physics, 1117 Budapest, Hungary; email: arandras@caesar.elte.hu
%   
% Input:
% N - size of the sample
%
% Output:
% Z - redshifts


% Pseudocode
% 1. Load the zLinCom file
%        (zLinCom contains 10 000 comoving distance bins between 0 and 9.2
%        Gpc.)
% 2. Calculating N bin number as if the GRBs were uniformly distributed in the 
%    Universe      
% 3. Assign to every GRB the corresponding redshift value

% Called programs:
%   zLinCom.mat data file


% 1. Load the zLinCom file
load zLinCom


% 2. Calculating N bin number as if the GRBs were uniformly distributed in the 
%    Universe
Imax = length(dLin);
i = round(Imax*nthroot(rand(1,N), 3)); % The probability function: P(i)= (i^3/Imax^3).                                        


% 3. Assign to every GRB the corresponding redshift value
Z = zLinCom(i); % i is the index vector.



% VERIFYING PLOTS --------------------------------------------------------- 
% (Uncomment if want to check the results)
%--------------------------------------------------------------------------
%
% %Plotting the distribution of the comoving distance 
% d = dLin(i);
% dmax = max(dLin);
% h = hist(d, 100);
% h = h/(sum(h)*dmax/100);
% x = linspace(0, dmax, 100);
% p = 3*x.^2/(dmax^3);
% bar(x,h)
% hold on
% pl = plot(x, p, 'r');
% hold off
% xlabel('d [Mpc]')
% ylabel('relative frequency')
% legend(pl, 'Theor. dist. funct.');
% figure
% 
% %Plotting the distribution of the redshift
% zmax = max(zLinCom);
% h = hist(Z,100);
% h = h/(sum(h)*zmax/100);
% x = linspace(0, zmax, 100);
% bar(x, h)
% xlabel('z')
% ylabel('relative frequency')
%
%
%--------------------------------------------------------------------------
end %end of function

% Andor Budai (2019) - arandras@caesar.elte.hu