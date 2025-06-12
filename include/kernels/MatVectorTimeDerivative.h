#pragma once

#include "VectorTimeDerivative.h"

/**
 * Time derivative term multiplied by a material
 */
class MatVectorTimeDerivative : public VectorTimeDerivative
{
public:
  static InputParameters validParams();

  MatVectorTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  // The material the time derivative is multiplied with
  const MaterialProperty<Real> & _coeff;
};
