!include Parameters.i

[Mesh]
[]

[Variables]
  [A]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[AuxVariables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = ${room_temperature}
  []
  [V]
    family = LAGRANGE
    order = FIRST
  []
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
  [Vt]
    family = LAGRANGE
    order = FIRST
  []
  [E]
    family = NEDELEC_ONE
    order = FIRST
  []
  [B]
    family = NEDELEC_ONE
    order = FIRST
  []
[]

[Kernels]
  [curlcurlA_coil]
    type = CurlCurlField
    variable = A
    coeff = ${copper_reluctivity}
    block = coil
  []
  [curlcurlA_target]
    type = CurlCurlField
    variable = A
    coeff = ${steel_reluctivity}
    block = target
  []
  [curlcurlA_vacuum]
    type = CurlCurlField
    variable = A
    coeff = ${vacuum_reluctivity}
    block = vacuum_region
  []
  [dAdt_target]
    type = MatVectorTimeDerivative
    variable = A
    material = "electric_conductivity"
    block = target
  []
  [dAdt_coil_vacuum]
    type = CoefVectorTimeDerivative
    variable = A
    coeff = ${vacuum_econductivity}
    block = 'coil vacuum_region'
  []
  [gradV]
    type = CoupledGrad
    variable = A
    coupled_scalar_variable = V
    function = ${copper_econductivity}*sin(${voltage_wfrequency}*t)
    block = coil
  []
[]

[Functions]
  [ss316l-sigma-func]
    type = PiecewiseLinear
    data_file = ../matprops/steel_316L_electrical_conductivity.csv
    format = columns
  []
[]


[Materials]
  [steel-sigma]
    type = CoupledValueFunctionMaterial
    v = T
    prop_name = "electric_conductivity"
    function = ss316l-sigma-func
    block = "target"
  []
  [copper]
    type = GenericConstantMaterial
    prop_names =  'electric_conductivity'
    prop_values = '${copper_econductivity}'
    block = 'coil'
  []
  [vacuum]
    type = GenericConstantMaterial
    prop_names =  'electric_conductivity'
    prop_values = '${vacuum_econductivity}'
    block = 'vacuum_region'
  []
[]

[AuxKernels]
  [P]
    type = JouleHeatingAux
    variable = P
    vector_potential = A
    skip = ${skip_t_af}
    block = target
    execute_on = timestep_end
  []
  [Vt]
    type = ParsedAux
    variable = Vt
    coupled_variables = V
    use_xyzt = true
    expression = sin(${voltage_wfrequency}*t)*V
    block = coil
    execute_on = timestep_end
    enable = ${visualization}
  []
  [E]
    type = VectorTimeDerivativeAux
    variable = E
    coupled_vector_variable = A
    coeff = -1
    block = target
    execute_on = timestep_end
    enable = ${visualization}
  []
  [B]
    type = CurlAux
    variable = B
    coupled_vector_variable = A
    execute_on = timestep_end
    enable = ${visualization}
  []
[]

[BCs]
  [plane]
    type = VectorCurlPenaltyDirichletBC
    variable = A
    boundary = 'coil_in coil_out terminal_plane'
    penalty = 1e14
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = cholesky
  start_time = 0.0
  end_time = ${end_t_af}
  dt = ${delta_t_af}
[]

[Outputs]
  exodus = ${visualization}
[]

[MultiApps]
  [VLaplace]
    type = FullSolveMultiApp
    input_files = VLaplace.i
    execute_on = initial
    clone_parent_mesh = true
  []
[]

[Transfers]
  [pull_potential]
    type = MultiAppCopyTransfer
    from_multi_app = VLaplace
    source_variable = V
    variable = V
  []
[]
