!include Parameters.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_oval_coil_solid_target.e
  second_order = true
[]

[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = ${room_temperature}
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
[]

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names =  'thermal_conductivity    specific_heat      density'
    prop_values = '${copper_tconductivity} ${copper_capacity} ${copper_density}'
    block = 'coil target'
  []
  [vacuum]
    type = GenericConstantMaterial
    prop_names =  'thermal_conductivity    specific_heat      density'
    prop_values = '${vacuum_tconductivity} ${vacuum_capacity} ${vacuum_density}'
    block = vacuum_region
  []
[]

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
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = -pc_type
  petsc_options_value = hypre
  start_time = 0.0
  end_time = ${end_t}
  dt = ${delta_t}

  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  l_tol = 1e-6
[]

[Postprocessors]
  [max-T]
    type = NodalExtremeValue
    variable = T
  []
  [max-flux]
    type = NodalExtremeValue
    variable = aux_flux_boundary
  []
[]

[Outputs]
  exodus = true
  csv = true
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
    variable = temp_received
    to_boundaries = "inner_pipe"
    num_nearest_points = 1
  []
  [heatflux_from_parent_to_child]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = flow_channel
    # distance_weighted_average = true
    source_variable = aux_flux_boundary # *from variable*
    from_boundaries = "inner_pipe"
    variable = q_wall # *to variable*
    num_nearest_points = 1
  []
[]
