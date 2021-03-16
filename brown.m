function [x, y]=brown(N, tStep, D, k)
% [x, y]=brown(N, tStep, D, k)
%
% Simulates the Brownian motion of a particle with restoring force exerted on it.
% Andor Budai (2019); Eötvös University, Institute of Physics, 1117 Budapest, Hungary; email: arandras@caesar.elte.hu
%
% Input:
% N - the number of the time steps
% tStep [s] - the size of the steps
% D [deg^2/s^4] - the diffusion coefficient of the motion
% k [1/s^2] - the restoring force coefficient
%
% Output:
% x [deg] - the vector containing the x coordinate of each step
% y [deg] - the vector containing the y coordinate of each step
%

% Pseudocode:
% 1. Preallocating vectors
% 2. Generating the random force for every time step
% 3. Solving the differential equation for every time step

% 1. Preallocating the vectors
x=zeros(1,N);
y=zeros(1,N);

vx=zeros(1,N);
vy=zeros(1,N);

% 2. Calculating the force
ax=sqrt(D)*randn(1,N);
ay=sqrt(D)*randn(1,N);

% 3. Solving the differential equation
for(i=2:N)
    vx(i)=vx(i-1)+ax(i-1)*tStep;
    vy(i)=vy(i-1)+ay(i-1)*tStep;
    
    x(i)=x(i-1)+vx(i-1)*tStep;
    y(i)=y(i-1)+vy(i-1)*tStep;
    
    ax(i)=ax(i)-k*x(i);
    ay(i)=ay(i)-k*y(i);
end

end % end of function

% Andor Budai (2019) - arandras@caesar.elte.hu