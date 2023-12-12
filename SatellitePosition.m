% Given parameters
a = 32016.565; % semi-major axis in km
e = 0.65877; % eccentricity
i = 46.865; % inclination in degrees
nu_initial = 350.7056; % initial true anomaly in degrees
time_future = 6; % TOF in hours

% Constants
mu = 3.986e5; % Earth's gravitational parameter in km^3/s^2
deg2rad = pi/180; % conversion factor from degrees to radians

% 1. Calculate mean motion n
n = sqrt(mu/a^3);

% 2. Find initial eccentric anomaly E_initial
nu_initial_rad = deg2rad * nu_initial; % Convert to radians
cos_E_initial = (e + cos(nu_initial_rad)) / (1 + e*cos(nu_initial_rad));
E_initial = acos(cos_E_initial);

% Adjust angles for half-plane consistency
if nu_initial_rad > pi
    E_initial = 2*pi - E_initial;
end

% 3. Calculate initial mean anomaly M_initial
M_initial = E_initial - e*sin(E_initial);

% Adjust M_initial for half-plane consistency
%if E_initial > pi
%    M_initial = 2*pi - M_initial;
%end

% 4. Determine future mean anomaly M_future
t_initial = 0; % assuming t_initial is 0 hours
t_future = time_future * 3600; % convert future time to seconds
M_future = M_initial + n * (t_future - t_initial);

% Ensure M_future is within 0 to 2pi range
M_future = mod(M_future, 2*pi);

% 5. Solve for E_future using Kepler's equation iteratively
E_future = M_future; % Initial guess for E_future
for iteration = 1:1000
    E_future_new = M_future + e*sin(E_future);
    if abs(E_future_new - E_future) < 1e-10 % convergence criterion
        break;
    end
    E_future = E_future_new;
end

% 6. Calculate future true anomaly nu_future
cos_v_future = (cos(E_future) - e) / (1 - e*cos(E_future));
v_future = acos(cos_v_future);

% Adjust v_future for half-plane consistency
if E_future > pi
    v_future = 2*pi - v_future;
end

v_future_deg = rad2deg(v_future); % Convert to degrees
% Display the result
fprintf('mean motion n %.6f \n', n);
fprintf('The E_initial is %.6f rads\n', E_initial);
fprintf('The M_initial is %.6f rads\n', M_initial);
fprintf('The E_futureis %.6f rads\n', E_future);
fprintf('The true anomaly six hours from now is %.2f degrees\n', v_future_deg);
