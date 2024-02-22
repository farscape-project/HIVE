#pragma once

#include "VectorKernel.h"

/**
 *  Weak form contribution corresponding to -f*grad(p)
 */
class CoupledGrad : public VectorKernel
{
public:
  static InputParameters validParams();

  CoupledGrad(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  /// coupled scalar variable
  MooseVariable & _p_var;
  unsigned int _p_var_num;

  const VariableGradient & _grad_p;
  const VariablePhiGradient & _grad_phi;

  /// Optional function value
  const Function & _function;
};
