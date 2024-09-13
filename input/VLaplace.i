!include Parameters.i

[Mesh]
[]

[Variables]
  [V]
    family = LAGRANGE
    order = FIRST
  []
[]

[Kernels]
  [laplacianV]
    type = Diffusion
    variable = V
    block = coil
  []
  [null]
    type = NullKernel
    variable = V
    block = 'target vacuum_region'
  []
[]

[BCs]
  [in]
    type = DirichletBC
    variable = V
    boundary = coil_in
    value = ${voltage_amplitude}
  []
  [out]
    type = DirichletBC
    variable = V
    boundary = coil_out
    value = 0
  []
[]

[Postprocessors]
  [I(in){A}]
    type = SideDiffusiveFluxIntegral
    variable = V
    boundary = coil_in
    diffusivity = -${copper_econductivity}
  []
  [I(out){A}]
    type = SideDiffusiveFluxIntegral
    variable = V
    boundary = coil_out
    diffusivity = ${copper_econductivity}
  []
[]

[Executioner]
  type = Steady
  solve_type = LINEAR
  petsc_options_iname = '-pc_type -ksp_rtol'
  petsc_options_value = 'hypre    1e-12'
[]
