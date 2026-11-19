{
  importDir,
  ...
}:
{
  imports = importDir ./modules/common ++ importDir ./modules/linux/home;
}
