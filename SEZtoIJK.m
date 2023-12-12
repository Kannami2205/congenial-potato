function IJK = SEZtoIJK()

% Constants
a_e = 6378.137e3; % Equatorial radius of the Earth 
e = 0.08182; % Eccentricity of the Earth

% User input for SEZ coordinates
latitude = input('Enter latitude (degrees): ');
altitude = input('Enter altitude (meters): ');
LST = input('Enter local sidereal time (degrees): ');

% Convert input to radians
latitude = deg2rad(latitude);
LST = deg2rad(LST);

%Calculate x and z 
x= ((a_e/ sqrt(1- e^2*sin(latitude)^2))+altitude)* cos(latitude)* cos(LST);
y= ((a_e/ sqrt(1- e^2*sin(latitude)^2))+altitude)* cos(latitude)* sin(LST); % same as x 
z= ((a_e* (1- e^2)/ sqrt(1-e^2 * sin(latitude)^2))+ altitude) *sin(latitude);

% m2km
x_1= x/1000;
y_1= y/1000;
z_1= z/1000;

% Display the result
disp(['I:', num2str(x_1),'km']);
disp(['J:', num2str(y_1),'km']);
disp(['K:', num2str(z_1),'km']);

% User input for range, azimuth, and elevation
rho = input('Enter the range (\rho) in meters: ');
Az = input('Enter the azimuth (Az) in degrees: ');
El = input('Enter the elevation (El) in degrees: ');

% Convert angles to radians
EI = deg2rad(El);
Az = deg2rad(Az);

% Calculate components of the position vector in SEZ coordinates
rho_s = -rho * cos(EI) * cos(Az);
rho_E = rho * cos(EI) * sin(Az);
rho_Z = rho * sin(EI);

% Display SEZ components
disp('Position Vector in SEZ Coordinates:');
disp(['South Component (S): ', num2str(rho_s), ' meters']);
disp(['East Component (E): ', num2str(rho_E), ' meters']);
disp(['Zenith Component (Z): ', num2str(rho_Z), ' meters']);

% Transformation matrix from SEZ to IJK coordinates
R_SEZ_to_IJK = [ sin(latitude)*cos(LST),-sin(LST), cos(latitude)*cos(LST);
                 sin(latitude)*sin(LST),cos(LST), cos(latitude)*sin(LST);
                 -cos(latitude),            0,       sin(latitude)];

% Convert SEZ position vector to IJK coordinates
rho_IJK = R_SEZ_to_IJK * [rho_s; rho_E; rho_Z];

% Display the result in IJK coordinates
disp('Position Vector in Rho_IJK Coordinates:');
disp(['I Component: ', num2str(rho_IJK(1)), ' meters']);
disp(['J Component: ', num2str(rho_IJK(2)), ' meters']);
disp(['K Component: ', num2str(rho_IJK(3)), ' meters']);

% Convert rhoijk to Rjik 
R_ijk = rho_IJK + [x; y; z];

% Display the result in IJK coordinates
disp('Position Vector in R_IJK Coordinates:');
disp(['I Component: ', num2str(R_ijk(1)), ' meters']);
disp(['J Component: ', num2str(R_ijk(2)), ' meters']);
disp(['K Component: ', num2str(R_ijk(3)), ' meters']);
end


