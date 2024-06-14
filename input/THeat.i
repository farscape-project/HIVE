!include Constants.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_meshed_oval_coil_and_solid_target.e
  second_order = true
[]

[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = ${room_temperature}
  []
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[AuxVariables]
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
  [temp_received]
    # order = CONSTANT
    order = FIRST
    family = LAGRANGE
    initial_condition = ${room_temperature}
  []
  [aux_flux]
    order = CONSTANT
    family = MONOMIAL
  []
  [aux_flux_boundary]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxKernels]
 [aux_flux_kernel_proj]
    type = ProjectionAux
    variable = aux_flux_boundary
    v = aux_flux
  []
  [aux_flux_kernel]
    type = DiffusionFluxAux
    diffusion_variable = T
    component = normal
    diffusivity = thermal_conductivity
    variable = aux_flux
    boundary = "inner_pipe"
  []
[]

[Kernels]
  [HeatConduction]
    type = HeatConduction
    variable = T
  []
  [TimeDerivative]
    type = HeatConductionTimeDerivative
    variable = T
  []
  [HeatSource]
    type = CoupledForce
    variable = T
    v = P
  []
  [TensorMechanics] 
     displacements = 'disp_x disp_y disp_z'
    #  generate_output = 'vonmises_stress'
     eigenstrain_names = 'eigenstrain'
     use_automatic_differentiation = false
     block = 'target'
  []
[]

[Materials]
  [copper-density]
    type = PiecewiseLinearInterpolationMaterial
    x = '293.15 323.15 373.15 423.15 473.15 523.15 573.15 623.15 673.15 723.15 773.15 823.15 873.15 923.15 973.15 1023.15 1073.15 1123.15 1173.15'
    y = '8940.0 8926.0 8903.0 8879.0 8854.0 8829.0 8802.0 8774.0 8744.0 8713.0 8681.0 8647.0 8612.0 8575.0 8536.0 8495.0 8453.0 8409.0 8363.0'
    property = 'density'
    variable = T
    block = 'coil target'
  []
  [copper-youngs_modulus]
    # Data from prebuilt material library
    # for material
    type = PiecewiseLinearInterpolationMaterial
    x = '293.15 323.15 373.15 423.15 473.15 523.15 573.15 623.15 673.15'
    y = '117.0 116.0 114.0 112.0 110.0 108.0 105.0 102.0 98.0'
    variable = T
    property = 'copper-youngs_modulus'
    scale_factor = 1e9    
    block = 'coil target'
  []
  [copper-heat]
    type = HeatConductionMaterial
    block = 'coil target'
    temp = T
    specific_heat_temperature_function = 'copper_sh'
    thermal_conductivity_temperature_function = 'copper_tc'
  []
  [copper-elasticity]
    type = ComputeVariableIsotropicElasticityTensor
    args = T
    youngs_modulus = copper-youngs_modulus
    poissons_ratio = 0.33
    block = 'target coil'
  []
  [copper-thermal_strain]
    type = ComputeMeanThermalExpansionFunctionEigenstrain
    thermal_expansion_function = 'copper-thermal_expansion'
    thermal_expansion_function_reference_temperature = 293.15
    stress_free_temperature = 293.15
    temperature = T
    eigenstrain_name = eigenstrain
    block = 'target'
  []
  [copper-strain] #We use small deformation mechanics
    type = ComputeSmallStrain
    displacements = 'disp_x disp_y disp_z'
    eigenstrain_names = 'eigenstrain'
    block = 'target'
  []
  [copper-stress] #We use linear elasticity
    type = ComputeLinearElasticStress
    block = 'target'
  []
  [vacuum-heat]
    type = HeatConductionMaterial
    block = vacuum_region
    temp = T
    specific_heat = '${vacuum_capacity}'
    thermal_conductivity = '${vacuum_tconductivity}'
  []
  [vacuum-density]
    type = ConstantMaterial
    property_name = density
    value = ${vacuum_density}
    block = vacuum_region
  []
[] # Materials

[BCs]
  [plane]
    type = DirichletBC
    variable = T
    # boundary = 'coil_in coil_out terminal_face'
    boundary = 'coil_in coil_out'
    value = ${room_temperature}
  []
  [temp_inner_pipe_from_multiapp]
    type = FunctorDirichletBC
    variable = T
    boundary = 'inner_pipe'
    functor = temp_received
  []
  [zero-displacment-x]
    type = DirichletBC
    variable = disp_x
    boundary = 'part_boundary pipe_side_out'
    value = 0.0
  []
  [zero-displacment-y]
    type = DirichletBC
    variable = disp_y
    boundary = 'part_boundary pipe_side_out'
    value = 0.0
  []
  [zero-displacment-z]
    type = DirichletBC
    variable = disp_z
    boundary = 'part_boundary pipe_side_out'
    value = 0.0
  []

[] # BCs

[Functions]
  [copper-thermal_expansion]
    # Data from prebuilt material library
    # for material
    type = PiecewiseLinear
    x = '293.15 323.15 373.15 423.15 473.15 523.15 573.15 623.15 673.15 723.15 773.15 823.15 873.15 923.15 973.15 1023.15 1073.15 1123.15 1173.15'
    y = '16.7 17.0 17.2 17.5 17.7 17.8 18.0 18.1 18.2 18.4 18.5 18.65 18.8 18.97 19.14 19.34 19.55 19.78 20.05'
    scale_factor = '1e-6'
  []
  [copper_tc]
    # Data from prebuilt material library
    # for material copper
    type = PiecewiseLinear
    x = '293.15 323.15 373.15 423.15 473.15 523.15 573.15 623.15 673.15 723.15 773.15 823.15 873.15 923.15 973.15 1023.15 1073.15 1123.15 1173.15 1223.15 1273.15'
    y = '401.0 398.0 395.0 391.0 388.0 384.0 381.0 378.0 374.0 371.0 367.0 364.0 360.0 357.0 354.0 350.0 347.0 344.0 340.0 337.0 334.0'
  []
  [copper_sh]
    # Data from prebuilt material library
    # for material copper
    type = PiecewiseLinear
    x = '293.15 323.15 373.15 423.15 473.15 523.15 573.15 623.15 673.15 723.15 773.15 823.15 873.15 923.15 973.15 1023.15 1073.15 1123.15 1173.15 1223.15 1273.15'
    y = '388.0 390.0 394.0 398.0 401.0 406.0 410.0 415.0 419.0 424.0 430.0 435.0 441.0 447.0 453.0 459.0 466.0 472.0 479.0 487.0 494.0'
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = hypre
  start_time = 0.0
  end_time = ${end_t}
  dt = ${delta_t}
[]

[Postprocessors]
  [max-T]
    type = NodalExtremeValue
    variable = T
  []
[]

[Outputs]
  exodus = true
  interval = 200
[]

[MultiApps]
  [AForm]
    type = TransientMultiApp
    input_files = AForm.i
    execute_on = timestep_begin
  []
  [flow_channel]
    type = TransientMultiApp
    input_files = coolant.i
    execute_on = 'timestep_end'
    sub_cycling = true
    max_procs_per_app = 1 #8
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer
    from_multi_app = AForm
    source_variable = P
    variable = P
  []

  # coolant transfers
  [T_from_child]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = flow_channel
    # distance_weighted_average = true
    source_variable = 'T'
    variable = "T" 
    to_boundaries = "inner_pipe"
    num_nearest_points = 3
  []
  [heatflux_from_parent_to_child]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = flow_channel
    # distance_weighted_average = true
    source_variable = aux_flux_boundary # *from variable*
    from_boundaries = "inner_pipe"
    variable = q_wall # *to variable*
    num_nearest_points = 10
  []
[]
