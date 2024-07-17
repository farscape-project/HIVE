[Mesh]
  type = FileMesh
  file = ../mesh/vac_oval_coil_solid_target.e
  second_order = true
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
    value = 1
  []
  [out]
    type = DirichletBC
    variable = V
    boundary = coil_out
    value = 0
  []
[]

[Executioner]
  type = Steady
  solve_type = LINEAR
  petsc_options_iname = '-pc_type -ksp_rtol'
  petsc_options_value = 'hypre    1e-12'
[]
