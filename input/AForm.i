!include Constants.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_meshed_oval_coil_and_solid_target.e
  second_order = true
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
  [E]
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
    Coefficient = ${copper_econductivity}
    block = target
  []
  [dAdt_coil_vacuum]
    type = CoefVectorTimeDerivative
    variable = A
    Coefficient = ${vacuum_econductivity}
    block = 'coil vacuum_region'
  []
  [gradV]
    type = CoupledGrad
    variable = A
    coupled_scalar_variable = V
    function = ${copper_econductivity}*${voltage_amplitude}*(1-cos(${voltage_frequency}*t))
    block = coil
  []
[]

[AuxKernels]
  [E]
    type = VectorTimeDerivativeAux
    variable = E
    vector_variable = A
    execute_on = timestep_end
  []
  [P]
    type = JouleHeatingAux
    variable = P
    electric_field = E
    block = target
    execute_on = timestep_end
  []
[]

[Materials]
  [copper]
    type = GenericConstantMaterial
    prop_names = electrical_conductivity
    prop_values = ${copper_econductivity}
  []
[]

[BCs]
  [plane]
    type = VectorCurlPenaltyDirichletBC
    variable = A
    # boundary = 'terminal_face coil_in coil_out'
    boundary = 'coil_in coil_out'
    penalty = 1e8
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = lu
  num_steps = 1
[]

[MultiApps]
  [VLaplace]
    type = FullSolveMultiApp
    input_files = VLaplace.i
    execute_on = initial
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
