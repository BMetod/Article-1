function T = t90(L, dt)
% T = t90(L, dt)
%
% Returns the T90 length of a light curve. 
% It calculates the area under the curve by using the trapezoid rule,
% then measures the width of its middle 90 percent.
% Andor Budai (2019); Eötvös University, Institute of Physics, 1117 Budapest, Hungary; email: arandras@caesar.elte.hu
%
% Input:
% L - the ordinate of the light curve at each time step of the simulation
% dt [s] - the length of the time steps
%
% Output:
% T [s] - the T90 width of the light curve

% Pseudocode:
% 1. If length(L) <= 1 --> I = 1
% 2. Calculating the area under L in every bin.
% 3. Creating a vector containing the normalized area function of L.
% 4. Calculating the width of the middle 90 percent.


% 1. If length(L) <= 1 --> I = 1
if(length(L) <= 1)
    T = 0.9*dt;
    return
end

% 2. Calculating the area under L in every bin.
aL = (L(2:end) + L(1:end-1))/2;

% 3. Creating a vector containing the normalized area function of L.
cuma = cumsum(aL);
cuma = cuma/cuma(end);

% 4. Calculating the width of the middle 90%.
T = length(cuma(cuma >= 0.05 & cuma <= 0.95))*dt;

end % end of function

% Andor Budai (2019) - arandras@caesar.elte.hu