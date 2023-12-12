% Given parameters
frequency = 1.2e9; % Frequency in Hz (1.2 GHz)
xmit_antenna_efficiency = 0.5; % Transmit antenna efficiency
xmit_antenna_diameter = 0.5; % Transmit antenna diameter in meters
receive_antenna_efficiency = 0.6; % Receive antenna efficiency
receive_antenna_diameter = 3; % Receive antenna diameter in meters
propagation_path_length = 35786e3; % Approximate altitude of GEO satellite in meters
data_rate = 20e6; % Data rate in bits per second (20 Mbps)
system_noise_temperature = 135; % System noise temperature in Kelvin
margin_dB = 3; % Margin in dB
pointing_error_percentage = 3; % Pointing error between transmit and receive antennas

% Constants
c = 3e8; % Speed of light in meters/second
k_Boltzmann = 1.38e-23; % Boltzmann's constant in J/K

% Calculate the gains for transmit and receive antennas in dB
xmit_antenna_gain_dB = 20*log10(pi) + 20*log10(xmit_antenna_diameter) - 20*log10(c) + 20*log10(frequency) + 10*log10(xmit_antenna_efficiency);
receive_antenna_gain_dB = 20*log10(pi) + 20*log10(receive_antenna_diameter) - 20*log10(c) + 20*log10(frequency) + 10*log10(receive_antenna_efficiency);

% Calculate the free space path loss Ls_dB
Ls_dB = 20*log10(frequency) + 20*log10(4*pi*propagation_path_length/c);

% Assuming the pointing error results in additional loss
pointing_loss_dB =-12 * (pointing_error_percentage / 100)^2;

% Calculate received power Pr at the GS receiver in dBW
Pr_dBw = xmit_antenna_gain_dB + receive_antenna_gain_dB - Ls_dB + pointing_loss_dB;

% Convert received power from dBW to watts
Pr_W = 10^(Pr_dBw/10);

% Display the result
fprintf('The transmit antenna gain Gt_dB in dB is %.6f dB\n', xmit_antenna_gain_dB);
fprintf('The free space path loss Ls_dB in dB is %.6f dB\n', Ls_dB);
fprintf('The receive antenna gain Gr_dB in dB is %.6f dB\n', receive_antenna_gain_dB);
fprintf('The received power at the GS receiver Pr is: %.6f dBW\n', Pr_dBw);
fprintf('The received power at the GS receiver Pr is: %.6e W\n', Pr_W);