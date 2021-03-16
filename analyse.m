function analyse(szTh, min, max, S, name)
% analyse(szTh, min, max, S, name)
%
% Calculating the correlation coefficient of GRB light curve samples created by the simMove.m function, with sample sizes between
% min and max. Name is the path to the data files, with names ending in
% numbers. Every size is repeated S times. The results are saved in a data
% file.
% Andor Budai (2019); Eötvös University, Institute of Physics, 1117 Budapest, Hungary; email: arandras@caesar.elte.hu
%
%
% Input:
% szTh - the type of the jet model:
%           'j' - Uniform with measured half opening angles
%           'd' - Uniform with measured angle difference
%           'g' - Gaussian
%           'p' - Power-law
% min - the minimal sample size
% max - the maximal sample size
% S - the repetition of every sample size
% name - the path to the data files
%
% Output:
% A file containing the correlation coefficient and the p values for every
% sample, the median and the error limits of these values.

% Pseudocode:
% 1. Loading and pre-allocating the variables.
% 2. For loop on every sample size.
% 3. Inner for loop on every sample with the given size.
% 4. Checking the remaining size of the loaded datafile. If it is not large
%    enough, then loading an other datafile.
% 5. Calculating r and p.
% 6. Calculating the medians and the upper and lower limits.
% 7. Calculating where the correlation reaches the 3 and 5 sigma sign.
%    level.
% 8. Saving.


% 1. Loading and pre-allocating the variables.
index = 1; % the number of the loaded files
Ao = load([name, num2str(index)]);
Ao = Ao.A; % the data matrix
L = size(Ao, 1); % size of every matrix
% choosing the angle value column from the matrix
c = 1*(szTh == 'j') + 2*(szTh == 'd' | szTh == 'g' | szTh == 'p');
R = zeros(S, max - min+1); % correlation coefficient matrix
P = zeros(S, max - min+1); % p-value matrix
No = 1; % the size of the used part of the data matrix 


% 2. For loop on every sample size.
for(i = min:max)
    
% 3. Inner for cicle on every sample with the given size.    
    for(j = 1:S)
        
% 4. Checking the remaining size of the loaded datafile. If it is not large
%    enough, then loading an other datafile.        
        if(No-1 + i > L)
            
% 5. Calculating r and p.
            index = index + 1;
            An = load([name, num2str(index)]); % the new matrix
            Ao = [Ao(No:end, :); An.A(1:i - (L - No+1), :)];
            [r, p] = corrcoef(Ao(1:end, c), Ao(1:end, 3));
            R(j, i-min+1) = r(1, 2);
            P(j, i-min+1) = p(1, 2);

            No = i - (L - No);
            Ao = An.A;
        else
            
% 5. Calculating r and p.
            Nn = No+i;
            
            [r, p] = corrcoef(Ao(No:Nn-1, c), Ao(No:Nn-1, 3));
            R(j, i-min+1) = r(1, 2);
            P(j, i-min+1) = p(1, 2);
           
            
            No = Nn;
        end
        
    end
    
    
end


% 6. Calculating the medians and the upper and lower limits.
Rq=[quantile(R, 0.8414); median(R); quantile(R, 0.1587)];
Pq=[quantile(P, 0.8414); median(P); quantile(P, 0.1587)];


% 7. Calculating where the correlation reaches the 3 and 5 sigma sign. level.
i = max;
while Pq(2, i-min+1) <= 0.0027 % 3 sigma
    i = i-1;
end
sigm3 = i;

i = max;
while Pq(2, i-min+1) <= 6.0000e-07 % 5 sigma
    i = i-1;
end
sigm5 = i;


% 8. Saving.
samples = min:max; % samplesizes
% Comment
readMe = 'Data produced by analyse.m. R: corrcoeff values, Rq:[upper limit, median, lower limit], P: p-value, Pq:[ul; m; l l], sigma3: the sample size where the correlation confidence is 3sigma, samples: sample sizes';
save([szTh,'_data'], 'R', 'Rq', 'P', 'Pq', 'sigm3', 'sigm5', 'samples', 'readMe')

end % end of function

% Andor Budai (2019) - arandras@caesar.elte.hu
