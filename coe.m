clc;
clear;
format long g;
% Prompt user for position vector in km
r_i= input('Enter the x-component of the position vector in km [r_i] = ');
r_j= input('Enter the y-component of the position vector in km [r_j] = ');
r_k= input('Enter the z-component of the position vector in km [r_k] = ');

% Prompt user for velocity vector in km/sec
v_i= input('Enter the x-component of the velocity vector in km/sec [v_i] = ');
v_j= input('Enter the y-component of the velocity vector in km/sec [v_j] = ');
v_k= input('Enter the z-component of the velocity vector in km/sec [v_k] = ');

% Combine the user inputs into vectors
r= [r_i; r_j; r_k];
v= [v_i; v_j; v_k];
d2r= pi/180;
r2d= 180/pi;
km2m= 1e3;
m2km= 1/1e3;

% Convert to meters
r1= r*km2m;
v1= v*km2m;

GM= 398600e9;
ae= 6378e3;

% Vector operations
r2= r1;
v2= v1;
rr= norm(r2);
vv= norm(v2);

% Angular momentum
h= cross(r2,v2);
h1= norm(h);

% Semi-major axis
a1= (2.0/rr - vv^2/GM)^(-1);
a= a1*m2km;

% Eccentricity
eCosE= 1.0 - rr/a1;
eSinE= dot(r2, v2) / sqrt(GM * a1);
e2= eCosE^2 + eSinE^2;
e= sqrt(e2);

% Inclination
i= atan2(sqrt(h(1)^2 + h(2)^2), h(3)) * r2d;

% Argument of Latitude
u= atan2(r2(3)*h1, -r2(1)*h(2) + r2(2)*h(1));

% Right Ascension of Ascending Node 
raan= atan2(h(1), h(2));
raan= mod(raan, 2.0*pi)*r2d; % large omega

% Argument of Perigee and Mean Anomaly
E= atan2(eSinE, eCosE);
M= mod(E-eSinE,2.0*pi)*r2d;
nu= atan2(sqrt(1.0-e2)*eSinE,eCosE-e2);
nu_1= mod(nu,2*pi) * r2d;
omega = mod(u-nu,2.0*pi)*r2d;

% quadrant checks
if nu_1<0
    nu_1= nu+360; 
end
if omega<0
   omega= omega+360; 
end
if raan< 0
   raan= raan+360; 
end

% Display calculated COE 
disp(['Semi-major Axis (a): ', num2str(a), ' km']);
disp(['Eccentricity (e): ', num2str(e)]);
disp(['Inclination (i): ', num2str(i), ' degrees']);
disp(['Right Ascension of Ascending Node (RAAN): ', num2str(raan), ' degrees']);
disp(['Argument of Perigee (omega): ', num2str(omega), ' degrees']);
disp(['True Anomaly (nu): ', num2str(nu_1), ' degrees']);