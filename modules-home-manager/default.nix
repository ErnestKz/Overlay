_: _:
{
  ek.modules.home-manager =
    { shiva = import ./shiva;
      common = import ./common;
      channable = import ./channable;
    } ;
}
