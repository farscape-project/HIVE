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
  [V]
    family = LAGRANGE
    order = FIRST
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
  [P]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [curlcurlA_coil_target]
    type = CurlCurlField
    variable = A
    coeff = ${copper_reluctivity}
    block = 'coil target'
  []
  [curlcurlA_vacuum]
    type = CurlCurlField
    variable = A
    coeff = ${vacuum_reluctivity}
    block = vacuum_region
  []
  [dAdt_target]
    type = CoefVectorTimeDerivative
    variable = A
    coeff = ${copper_econductivity}
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

[AuxKernels]
  [Vt]
    type = ParsedAux
    variable = Vt
    coupled_variables = V
    use_xyzt = true
    expression = sin(${voltage_wfrequency}*t)*V
    execute_on = timestep_end
  []
  [E]
    type = VectorTimeDerivativeAux
    variable = E
    coupled_vector_variable = A
    coeff = -1
    execute_on = timestep_end
  []
  [B]
    type = CurlAux
    variable = B
    coupled_vector_variable = A
    execute_on = timestep_end
  []
  [P]
    type = JouleHeatingAux
    variable = P
    vector_potential = A
    sigma = ${copper_econductivity}
    block = target
    execute_on = timestep_end
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
  num_steps = 1
[]

[Outputs]
  exodus = true
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
