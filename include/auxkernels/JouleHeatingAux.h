#pragma once

#include "AuxKernel.h"

class JouleHeatingAux : public AuxKernel
{
public:
  static InputParameters validParams();

  JouleHeatingAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  /// The electric field
  const VectorVariableValue & _electric_field;

  /// The electrical conductivity
  Real _sigma;
};
