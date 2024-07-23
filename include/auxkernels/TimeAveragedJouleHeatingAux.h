#pragma once

#include "AuxKernel.h"

class TimeAveragedJouleHeatingAux : public AuxKernel
{
public:
  static InputParameters validParams();

  TimeAveragedJouleHeatingAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  // Sum of powers from previous steps
  const VariableValue & _power_prev;

  /// The electric field
  const VectorVariableValue & _electric_field;

  /// The electrical conductivity
  Real _sigma;

};
