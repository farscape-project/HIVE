//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "AuxKernel.h"

class VectorTimeDerivativeAux : public VectorAuxKernel
{
public:
  static InputParameters validParams();

  VectorTimeDerivativeAux(const InputParameters & parameters);

protected:
  virtual RealVectorValue computeValue() override;

  VectorMooseVariable & _v_var;

  const VectorVariableValue & _vector_variable;
  const VectorVariableValue & _vector_variable_old;

  /// Electrical conductivity
  const GenericMaterialProperty<Real, false> & _conductivity;
};
