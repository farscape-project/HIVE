//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

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
  Real _coef;
};
