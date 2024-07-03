vacuum_permeability  = ${fparse 4e-7*pi}                      # H/m
vacuum_reluctivity   = ${fparse 1/vacuum_permeability}        # 1/(H/m)
vacuum_econductivity = 100                                    # S/m
vacuum_tconductivity = 0                                      # W/(m*K)
vacuum_density       = 0                                      # kg/m^3
vacuum_capacity      = 0                                      # J/(kg*K)

copper_permeability  = ${fparse 0.999994*vacuum_permeability} # H/m
copper_reluctivity   = ${fparse 1/copper_permeability}        # 1/(H/m)
copper_econductivity = 5.96e7                                 # S/m
copper_tconductivity = 398                                    # W/(m*K)
copper_density       = 8.96e3                                 # kg/m^3
copper_capacity      = 385                                    # J/(kg*K)

room_temperature     = 293.15                                 # K

innerpipe_len        = 0.15                                   # m
innerpipe_diameter   = 10e-3                                  # m
innerpipe_area       = ${fparse pi*(innerpipe_diameter/2)^2 } # m^2
inlet_temp           = 323.15                                 # K
vol_flowrate_Lmin    = 40                                     # L/min
vol_flowrate         = ${fparse vol_flowrate_Lmin*1.66667e-5} # m^3/s
outlet_pressure      = 2e5                                    # Pa

voltage_amplitude    = 1e-5                                   # V
voltage_frequency    = ${fparse 2*pi/.5}                      # rad/s

end_t                = 100                                     # s
delta_t              = 0.05                                    # s
