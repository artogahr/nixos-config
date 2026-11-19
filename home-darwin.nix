{
  importDir,
  ...
}:
{
  imports = importDir ./modules/common ++ importDir ./modules/darwin/home;
}
