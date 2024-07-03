#pragma once

#include "VectorTimeDerivative.h"

/**
 * Time derivative term multiplied by a coefficient
 */
class CoefVectorTimeDerivative : public VectorTimeDerivative
{
public:
  static InputParameters validParams();

  CoefVectorTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  /// The coefficient the time derivative is multiplied with
  Real _coeff;
};
