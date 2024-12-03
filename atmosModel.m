function [density, temperature, pressure] = atmosModel(altitude)
    % atmosModel calculates density, temperature, and pressure
    % for a given altitude based on the International Standard Atmosphere (ISA).
    %
    % INPUT:
    %   altitude - Altitude in meters above sea level
    %
    % OUTPUT:
    %   density - Air density in kg/m^3
    %   temperature - Air temperature in Kelvin
    %   pressure - Air pressure in Pascals

    % Constants
    T0 = 288.15; % Sea level standard temperature (K)
    P0 = 101325; % Sea level standard pressure (Pa)
    rho0 = 1.225; % Sea level standard density (kg/m^3)
    g = 9.80665; % Gravitational acceleration (m/s^2)
    R = 287.05; % Specific gas constant for air (J/(kg*K))
    L = 0.0065; % Temperature lapse rate (K/m)
    h_tropopause = 11000; % Troposphere height (m)

    if altitude <= h_tropopause
        % Troposphere
        temperature = T0 - L * altitude;
        pressure = P0 * (temperature / T0)^(g / (R * L));
    else
        % Above the troposphere (isothermal layer)
        temperature = T0 - L * h_tropopause;
        pressure = P0 * (temperature / T0)^(g / (R * L)) * ...
                   exp(-g * (altitude - h_tropopause) / (R * temperature));
    end

    % Density calculation using the ideal gas law
    density = pressure / (R * temperature);
end