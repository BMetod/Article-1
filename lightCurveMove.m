 function v = lightCurveMove(Lum, T, tStep, w, I0, R, D, k, thv, Z, pl)
% v = lightCurveMove(Lum, T, tStep, w, I0, R, D, b, k, thv, Z, pl)
%
% Generates a light curve based on the simulated random motion of a point
% through a radially symmetric luminosity density (LD) distribution. The LD distribution can 
% either be Uniform, Gaussian or follow an inverse power law. The motion of
% the point is Brownian with a restoring force. The intrinsic light profile has a Tukey window shape. 
% The simulation returns the variability of the curve calculated by the peak counting method.
% Andor Budai (2019); Eötvös University, Institute of Physics, 1117 Budapest, Hungary; email: arandras@caesar.elte.hu
%
% Input:
% Lum - the model of the LD distribution:
%		1 - Uniform
%		2 - Gaussian
%		3 - Power law
% T [s] - the duration of the simulation
% tStep [s] - the size of the time steps
% w - the ratio of the length of taper section of the Tukey window
% I0 [W] - the maximum of the Tukey window
% R [deg] - the radius of the profile in angles
% D [deg^2/s^4] - the diffusion coefficient of the Brownian motion.
% k [1/s^2] - the restoring force coefficient
% thv [deg] - the initial viewing angle
% Z - the red shift of the GRB
% pl - if pl is 0, no plot is created
%
% Output:
% v [1/s] - the variability measure value


% Pseudocode: 
% 1. Calculating the length of the vectors
% 2. Simulating the movement
% 3. Placing the path of the observer in the coordinate system of the jet
% 4. Calculating the time dependence of the intrinsic luminosity density
% 5. Calculating the distance from the jet axis
% 6. Simulating the light curve
% 7. Calculating the variability of the light curve
% 8. Creating the plots

% Called functions:
% *brown
% *varMeasure



% 1. The number of the steps
N = round(T/tStep);
t = 0:tStep:tStep*(N - 1);

% 2. Simulating the motion of the point
[x, y] = brown(N, tStep, D, k); % Simulating the motion in the comoving frame
                                   % [x, y] = deg. 

% 3. Simulating the motion seen by the observer
y = thv-y; % Placing the course into the jet system

% 4. Simulating the time dependence of the luminosity density
I=I0*tukeywin(N,w)';

% 5. Distance from the jet axis
r=sqrt(x.^2+y.^2); % Calculating the distance from the axis of the jet. [r] = deg.


% 6. Creating the light curve
 if(Lum == 1)
     L = I.*(r <= R); % Uniform profile
 elseif(Lum==2)
     L = I.*exp(-0.5*(r/R).^2); % Gaussian profile
 elseif(Lum==3)
     L = (I.*(r/R).^-2).*(r > R) + I.*(r <= R); % Power-law profile
 end

% 7. Calculating the variability of the curve
v = varMeasure(L, tStep)/(Z + 1);

% 8. Plotting
if(pl ~= 0)
	 clf;
     % Movement in the jet frame
	 subplot(1,2,1); 
	 hold on;
	 fill(R*cos(0:.01:2*pi),R*sin(0:.01:2*pi),'y');
	 plot(x,y);
	 title('Position');
	 xlabel('x [deg]');
	 ylabel('y [deg]');
	 axis equal;
	 
     % Light curve in the co-moving frame
	 subplot(1,2,2); 
	 plot(t, L/max(L));
	 title('Light curve (com. frame)');
	 xlabel('time');
	 ylabel('light intensity [I/I_{max}]');
end
 
end % end of function

% Andor Budai (2019) - arandras@caesar.elte.hu