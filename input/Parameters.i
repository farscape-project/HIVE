vacuum_permeability  = ${fparse 4e-7*pi}                      # H/m
vacuum_reluctivity   = ${fparse 1/vacuum_permeability}        # (H/m)^-1
vacuum_econductivity = 1                                      # S/m
vacuum_tconductivity = 0                                      # W/(m*K)
vacuum_density       = 0                                      # kg/m^3
vacuum_capacity      = 0                                      # J/(kg*K)

steel_econductivity = 1e6                                     # S/m
apollo_permeability  = ${fparse vacuum_permeability}          # H/m
apollo_reluctivity   = ${fparse 1/apollo_permeability}        # (H/m)^-1

room_temperature     = 300.0                                  # K

coil_length = 0.4202366016924178                              # m (from paraview)
coil_area = 2.3753e-05                                        # m^2 (from paraview)
coil_resistance = ${fparse 1/steel_econductivity * coil_length / coil_area} # Ohm
coil_current = 1828                                           # A, taken from Apollo input file
voltage_amplitude    = ${fparse coil_current*coil_resistance} # V
voltage_frequency    = 1e5                                    # Hz
voltage_wfrequency   = ${fparse 2*pi*voltage_frequency}       # rad/s
voltage_period       = ${fparse 1/voltage_frequency}          # s

coolant_bulk_temp    = 300.0                                  # K

num_voltage_periods = 4
end_t                = ${fparse voltage_period*num_voltage_periods} # s
delta_t              = ${fparse voltage_period/40}            # s
end_t_temp           = 60                                     # s
delta_t_temp         = 5                                      # s
