vacuum_permeability  = ${fparse 4e-7*pi}                      # H/m
vacuum_reluctivity   = ${fparse 1/vacuum_permeability}        # (H/m)^-1
vacuum_econductivity = 1                                      # S/m
vacuum_tconductivity = 0                                      # W/(m*K)
vacuum_density       = 0                                      # kg/m^3
vacuum_capacity      = 0                                      # J/(kg*K)

copper_permeability  = ${fparse 0.999994*vacuum_permeability} # H/m
copper_reluctivity   = ${fparse 1/copper_permeability}        # (H/m)^-1
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

voltage_amplitude    = 1                                      # V
voltage_frequency    = 1e5                                    # Hz
voltage_wfrequency   = ${fparse 2*pi*voltage_frequency}       # rad/s
voltage_period       = ${fparse 1/voltage_frequency}          # s

end_t                = ${fparse voltage_period}               # s
delta_t              = ${fparse voltage_period/10}            # s
dt_fluid             = ${fparse voltage_period/10}
