#pragma once

#include "MooseApp.h"

class hiveApp : public MooseApp
{
public:
  static InputParameters validParams();

  hiveApp(InputParameters parameters);
  virtual ~hiveApp();

  static void registerApps();
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s);
};
