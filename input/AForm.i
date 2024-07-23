!include Parameters.i

[Mesh]
  type = FileMesh
  file = ../mesh/vac_oval_coil_solid_target_coarse.e
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
    function = ${copper_econductivity}*${voltage_amplitude}*sin(${voltage_wfrequency}*t)
    block = coil
  []
[]

[AuxKernels]
  [P]
    type = TimeAveragedJouleHeatingAux
    variable = P
    power_prev = P
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

[Postprocessors]
  [max-P]
    type = ElementExtremeValue
    variable = P
  []
[]

[Executioner]
  type = Transient
  solve_type = LINEAR
  petsc_options_iname = -pc_type
  petsc_options_value = lu
  start_time = 0.0
  end_time = ${end_t}
  dt = ${delta_t}
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

[Outputs]
  csv = true
[]
