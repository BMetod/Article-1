function A = simMove(sz, N, pl)
% A = simMove(sz, N, pl)
%
% Simulates GRB light curves with random parameters using the moving jet model.
% Returns a matrix containing the opening angle, the viewing angle and the variability measure 
% of every simulations. Optionally creates plots depicting the variability as the function of the angle values.
% Andor Budai (2019); Eötvös University, Institute of Physics, 1117 Budapest, Hungary; email: arandras@caesar.elte.hu
%
% Input:
% sz - type of the luminosity density distribution:
%		1 - Uniform with a log-normal opening angle distribution
%		2 - Gaussian
%		3 - Power-law
% N - number of the repeats
% pl - if pl is 0, no plot is created
%
% Output:
% A(N, 1) [deg] - jet half opening angle
% A(N, 2) [deg] - viewing angle (if the profile Uniform, returns the difference
%           between the viewing and the half opening angle).
% A(N, 3) [1/s] - variability


% Pseudocode:
% 1. Preallocating the variables.
% 2. Calculating the redshifts.
% 3. Calculating the durations.
% 4. Calculating the ratio of the lengths of the Tukey window's taper section
%    and the restoring force coefficients for each GRB
% 5. Checking the profile type:
% Uniform:
%   5a. Calculating the thetas.
%   5b. Recalculating if theta > 30.
%   5c. Calculating the viewing angles.
%   5d. Writing the angle values into A.
% Gaussian:
%   5a. Calculating the thetas.
%   5b. Calculating the viewing angles.
%   5c. Writing the angle values into A.
% Power-law:
%   5a. Calculating the thetas.
%   5b. Calculating the viewing angles.
%   5c. Writing the angle values into A.
% 6. Writing the variabilities into A.
% 7. Plotting


% Called programs:
% *randZ
% *lightCurveMove



% 1. Preallocating the variables
tStep=0.01; %[s] the size of the time steps
I0=1; %[W] maximum of the Tukey window
D=100; %[deg^2/s^4] diffusion coefficient of the Brownian motion
A=zeros(N,3); % The matrix containing the results


% 2. Calculating the redshifts for each GRB
Z = randZ(N); % Calculating the redshifts for the sample


% 3. Calculating the durations
T=lognrnd(1.487, 0.326, 1, N); %[s] the duration of the GRBs (T has a log-normal distribution 
                               % see: Tarnopolski2016.) 
                               
                               
% 4. Calculating the ratio of the lengths of the Tukey window's taper section
%    and the restoring force coefficients for each GRB                               
w=0.3+0.17*rand(1, N); % the ratio of the length of the Tukey window's taper section 
k=0.1+25*rand(1, N); %[1/s^2] restoring force coefficient

% 5. Checking the profile type:
if(sz == 1) % Uniform profile
    
    % 5a. Calculating the thetas.
    theta = lognrnd(1.742, 0.916, 1, N); %[deg] jet half opening angle with log-normal distribution
                                         % (see: Ghirlanda2013)
                                       
    % 5b. Recalculating if theta > 30.                                 
    while(max(theta) > 30)
        th2 = lognrnd(1.742, 0.916, 1, sum(theta > 30));
        theta(theta > 30) = th2(:);
    end
    
    % 5c. Calcualting the viewing angles.
    thv = rad2deg(acos(1 - rand(1, N).*(1 - cos(deg2rad(theta))))); %[deg] the viewing angle
        % the density function of thv, if thv < theta, is sin(thv)/(1 - cos(theta))
        
    % 5d. Writing the angle values into A.
    A(:, 1) = theta;
    A(:, 2) = theta - thv;
    
elseif(sz == 2) % Gaussian profile 
    
    % 5a. Calculating the thetas.
    theta = 3 + 2*rand(1, N); %[deg] theta  is the sigma of the Gaussian curve 
                              % (see: Salafia2015)
                              
    % 5b. Calcualting the viewing angles.                          
    thv = rad2deg(acos(1-rand(1, N).*(1 - cos(deg2rad(30))))); %[deg] the density function of thv is sin(thv)
    
    % 5c. Writing the angle values into A.
    A(:, 1) = theta;
    A(:, 2) = thv; % for the Gaussian profile this is the important value
    
elseif(sz == 3) % Power-law profile
    
    % 5a. Calculating the thetas.
    theta = 0.5 + 0.3*rand(1, N); %[deg] theta is the radius of the central small area
    
    % 5b. Calculating the viewing angles.                          
    thv = rad2deg(acos(1-rand(1, N).*(1 - cos(deg2rad(30))))); %[deg] the density function of thv is sin(thv)
    
    % 5c. Writing the angle values into A.
    A(:, 1) = theta;
    A(:, 2) = thv; % for the Power-law profile this is the important value
end


% 6. Writing the variabilities into A.
for(i = 1:N)
    A(i,3)=lightCurveMove(sz,T(i),tStep,w(i),I0,theta(i),D, k(i),thv(i),Z(i), 0);
end


% 7. Plotting
if(pl ~= 0)
    plot(A(:,1),A(:,3),'r+');
    xlabel('\vartheta(deg)') % the opening angle of the uniform profile, the
                             % size of the inner part of the power-law profile,
                             % the stand. dev. of the gaussian profile
    ylabel('Variability')
 
    figure
    plot(A(:,2),A(:,3),'m+');
	xlabel('\vartheta_{obs}(deg)') % theta-thv for the uniform profile, otherwise thv
    ylabel('Variability')
end


end % end of function

% Andor Budai (2019) - arandras@caesar.elte.hu
