#!/usr/bin/env ruby

# International Standard Atmosphere (ISA) (ISO 2533:1975)
# ICAO Standard Atmosphere (ICAO Doc 7488/3, 1994)

# 2.1 Primary constants and characteristics
# Table 1 - Main constants and characteristics adopted for
#           the calculation of the ISO Standard Atmosphere
CONST = {
  g_n: 9.80665, # m.s-2
  N_A: 602.257e24, # Avogadro constant, kmol-1
  p_n: 101325, # In Pascal
  rho_n: 1.225, # rho_n standard air density
  T_n: 288.15, # T_n standard thermodynamic air temperature at mean sea level
  R_star: 8.31432, # universal gas constant

  radius: 6356766, # radius of the Earth (m)
  k: 1.4 # adiabatic index, dimensionless
}

# 2.2 The equation of the static atmosphere and the perfect gas law
# Formula (2)
# M: air molar mass at sea level, kg.kmol-1
# Value given in 2.1 as M: 28.964720
CONST[:M] = (CONST[:rho_n] * CONST[:R_star] * CONST[:T_n]) / CONST[:p_n]

# Formula (3)
# R: specific gas constant, J.K-1.kg-1.
# Value given in 2.1 as R: 287.05287
CONST[:R] = CONST[:R_star] / CONST[:M]


# 2.3 Geopotential and geometric altitides; acceleration of free fall

# 2.3 Formula (8)
# H to h
# h(m)
def geometric_altitude_from_geopotential(geopotential_alt)
  CONST[:radius] * geopotential_alt / (CONST[:radius] - geopotential_alt)
end

# 2.3 Formula (9)
# h to H
# H(m)
def geopotential_altitude_from_geometric(geometric_alt)
  CONST[:radius] * geometric_alt / (CONST[:radius] + geometric_alt)
end

# 2.3 Formula (7)
# g(h)
def gravity_at_geometric(geometric_alt)
  temp = CONST[:radius] / (CONST[:radius] + geometric_alt)
  CONST[:g_n] * temp * temp
end

def gravity_at_geopotential(geopotential_alt)
  geometric_h = geometric_altitude_from_geopotential(geopotential_alt)
  gravity_at_geometric(geometric_h)
end

# 2.4 Atmospheric composition and air molar mass

# 2.5 Physical characteristics of the atmosphere at mean sea level

# 2.6 Temperature and vertical temperature gradient

# Formula (11)
# T
def temperature_at_layer_from_H(geopotential_alt)
  lower_layer_index = locate_lower_layer(geopotential_alt)
  lower_layer = TEMPERATURE_LAYERS[lower_layer_index]
  beta = lower_layer[:B]
  capital_t_b = lower_layer[:T]
  capital_h_b = lower_layer[:H]

  capital_t_b + (beta * (geopotential_alt - capital_h_b))
end

def temperature_at_layer_celcius(geopotential_alt)
  kelvin_to_celsius(temperature_at_layer_from_H(geopotential_alt))
end

def locate_lower_layer(geopotential_alt)
  # Return first layer if lower than lowest
  return 0 if geopotential_alt < TEMPERATURE_LAYERS[0][:H]

  # Return second last layer if beyond last layer
  i = TEMPERATURE_LAYERS.length - 1
  return i - 1 if geopotential_alt >= TEMPERATURE_LAYERS[i][:H]

  # find last layer with H larger than our H
  TEMPERATURE_LAYERS.each_with_index do |layer, i|
    return i if layer[:H] > geopotential_alt
  end

  nil
end

# Table 4 - Temperature and vertical temperature gradients
#
TEMPERATURE_LAYERS = [
  # H is Geopotential altitude (base altitude) above mean sea level, m
  # T is Temperature, K
  # B is Temperature gradient, "beta", K m^-1

  # This line is from ICAO 7488/3
  # [H: -5000, T: 320.65, B: -0.0065 ],

  # This line is from ISO 2533:1975
  {H: -2000, T: 301.15, B: -0.0065 },
  {H: 0,     T: 288.15, B: -0.0065 },
  {H: 11000, T: 216.65, B: 0       },
  {H: 20000, T: 216.65, B: 0.001   },
  {H: 32000, T: 228.65, B: 0.0028  },
  {H: 47000, T: 270.65, B: 0       },
  {H: 51000, T: 270.65, B: -0.0028 },
  {H: 71000, T: 214.65, B: -0.002  },
  {H: 80000, T: 196.65},
]


# 2.7 Pressure

# Base pressure values given defined `TEMPERATURE_LAYERS` and constants
def pressure_layers
  # assuming TEMPERATURE_LAYERS index 1 base altitude is zero (mean sea level)
  p = []

  TEMPERATURE_LAYERS.each_with_index do |x, i|
    last_i = (i == 0) ? 0 : i - 1
    last_layer = TEMPERATURE_LAYERS[last_i]
    beta = last_layer[:B]

    if last_layer[:H] <= 0
      pb = CONST[:p_n]
      capital_h_b = 0
      capital_t_b = CONST[:T_n]
    else
      pb = p[last_i]
      capital_h_b = last_layer[:H]
      capital_t_b = last_layer[:T]
    end

    current_layer = TEMPERATURE_LAYERS[i]
    geopotential_alt = current_layer[:H]
    temp = current_layer[:T]

    p[i] = if beta != 0
      # Formula (12)
      pb * (1 + ((beta / capital_t_b) * (geopotential_alt - capital_h_b)) ** (-CONST[:g_n] / (beta * CONST[:R])))
    else
      # Formula (13)
      pb * Math.exp(-(CONST[:g_n] / (CONST[:R] * temp)) * (geopotential_alt - capital_h_b))
    end
  end

  p
end

puts "PRE-CALCULATED PRESSURE LAYERS:"
PRESSURE_LAYERS = pressure_layers
pp PRESSURE_LAYERS

def pa_to_mmhg(pascal)
  pascal * 0.00750062
end

def pa_to_mbar(pascal)
  pascal * 0.01
end

# Pressure for a given geopotential altitude `H` (m) above mean sea level
def pressure_from_H(geopotential_alt)
  i = locate_lower_layer(geopotential_alt)
  lower_temperature_layer = TEMPERATURE_LAYERS[i]
  beta = lower_temperature_layer[:B]
  capital_h_b = lower_temperature_layer[:H]
  capital_t_b = lower_temperature_layer[:T]
  temp = temperature_at_layer_from_H(geopotential_alt)
  pb = PRESSURE_LAYERS[i]

  if beta != 0
    # Formula (12)
    pb * (1 + ((beta / capital_t_b) * (geopotential_alt - capital_h_b)) ** (-CONST[:g_n] / (beta * CONST[:R])))
  else
    # Formula (13)
    pb * Math.exp(-(CONST[:g_n] / (CONST[:R] * temp)) * (geopotential_alt - capital_h_b))
  end
end

def pressure_from_H_mbar(geopotential_alt)
  pa_to_mbar(pressure_from_H(geopotential_alt))
end

def pressure_from_H_mmhg(geopotential_alt)
  pa_to_mmhg(pressure_from_H(geopotential_alt))
end

def p_p_n_from_H(geopotential_alt)
  pressure_from_H(geopotential_alt) / CONST[:p_n]
end

# 2.8 Density and specific weight

# Calculate density for a given geopotential altitude `H` (m) above mean sea level
# Formula (14)
# rho
def density_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  p = pressure_from_H(geopotential_alt)

  p / (CONST[:R] * temp)
end

def rho_rho_n_from_H(geopotential_alt)
  density_from_H(geopotential_alt) / CONST[:rho_n]
end

def root_rho_rho_n_from_H(geopotential_alt)
  Math.sqrt(rho_rho_n_from_H(geopotential_alt))
end


# Specific weight
# Formula (15)
# gamma
def specific_weight_from_H(geopotential_alt)
  density_from_H(geopotential_alt) * gravity_at_geopotential(geopotential_alt)
end

# 2.9 Pressure scale height
# Formula (16)
# H_p
def pressure_scale_height_from_temp(temp)
  (CONST[:R] * temp) / CONST[:g_n]
end

def pressure_scale_height_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  pressure_scale_height_from_temp(temp)
end

# 2.10 Air number density
# Formula (17)
# n
def air_number_density_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  p = pressure_from_H(geopotential_alt)

  CONST[:N_A] * p / (CONST[:R_star] * temp)
end

# 2.11 Mean air-particle speed
# Formula (18)
# v_bar
# CORRECT
def mean_air_particle_speed_from_temp(temp)
  1.595769 * Math.sqrt(CONST[:R] * temp)
end

def mean_air_particle_speed_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  mean_air_particle_speed_from_temp(temp)
end

# 2.12 Mean free path of air particles
# Formula (19)
# l
def mean_free_path_of_air_particles_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  0.944407e-18 * air_number_density_from_H(geopotential_alt) * Math.sqrt(CONST[:R] * temp)
end

# 2.13 Air-particle collision frequency
# Formula (20)
# omega
def air_particle_collision_frequency_from_temp(n, temp)
  0.99407e-18 * n * Math.sqrt(CONST[:R] * temp)
end

def air_particle_collision_frequency_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  n = air_number_density_from_H(geopotential_alt)
  air_particle_collision_frequency_from_temp(n, temp)
end

# 2.14 Speed of sound
# Formula (21)
# a (ms-1)
# CORRECT
def speed_of_sound_from_temp(temp)
  # `kappa` (ratio of c_p / c_v) = 1.4 (see 2.14)
  kappa = 1.4
  Math.sqrt(kappa * CONST[:R] * temp)
end

def speed_of_sound_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  speed_of_sound_from_temp(temp)
end


# 2.15 Dynamic viscosity
# Formula (22)
# mu (Pa s)
def dynamic_viscosity(temp)
  # Sutherland's empirical constants in the equation for dynamic viscosity
  capital_b_s = 1.458e-6
  capital_s = 110.4

  (capital_b_s * (temp ** 1.5)) / (temp + capital_s)
end

def dynamic_viscosity_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  dynamic_viscosity(temp)
end

# 2.16 Kinematic viscosity
# Formula (23)
# v
# CORRECT
def kinematic_viscosity(temp)
  dynamic_viscosity(temp) / CONST[:rho_n]
end

def kinematic_viscosity_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  kinematic_viscosity(temp)
end

# 2.17 Thermal conductivity
# Formula (24)
# lambda
def thermal_conductivity_from_temp(temp)
  (2.648151e-3 * (temp ** (1.5))) / (temp + (245.4 * (10 ** (12.0/temp))))
end

def thermal_conductivity_from_H(geopotential_alt)
  temp = temperature_at_layer_from_H(geopotential_alt)
  thermal_conductivity_from_temp(temp)
end

def kelvin_to_celsius(kelvin)
  kelvin - 273.15
end



### Additional

require 'yaml'
TEST_VALUES = YAML.load(IO.read('tests.yml'))

MAPPING_VAR_TO_METHOD_NAME = {
  H: nil,
  h: "geometric_altitude_from_geopotential",
  TK: "temperature_at_layer_from_H",
  TC: "temperature_at_layer_celcius",
  p_mbar: "pressure_from_H_mbar",
  p_mmhg: "pressure_from_H_mmhg",
  rho: "density_from_H",
  g: "gravity_at_geopotential",
  p_p_n: "p_p_n_from_H",
  rho_rho_n: "rho_rho_n_from_H",
  root_rho_rho_n: "root_rho_rho_n_from_H",
  a: "speed_of_sound_from_H",
  mu: "dynamic_viscosity_from_H",
  v: "kinematic_viscosity_from_H",
  lambda: "thermal_conductivity_from_H",
  H_p: "pressure_scale_height_from_H",
  gamma: "specific_weight_from_H",
  n: "air_number_density_from_H",
  v_bar: "mean_air_particle_speed_from_H",
  omega: "air_particle_collision_frequency_from_H",
  l: "mean_free_path_of_air_particles_from_H"
}

TEST_VALUES.each_with_index do |hash, index|

  puts
  puts "TEST CASE #{index+1}: (calculated vs target)"
  geopotential_h = hash["H"]
  puts "  H\t=\t#{geopotential_h}\t\t(#{hash["H"]})"

  MAPPING_VAR_TO_METHOD_NAME.each_pair do |var, method_name|
    next if method_name.nil?

    res = send(method_name, geopotential_h)
    puts "  #{var}\t=\t#{res}\t\t(#{hash[var.to_s]})"
  end
end
