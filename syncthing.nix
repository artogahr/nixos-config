home:
let
  devices = {
    fukurowl-pc.id = "NHJCTQA-NXIMAVC-2364GRY-AJN6LYI-CSFKP6E-MFN4AKT-HODWJ6C-3H5SOA6";
    fukurowl-macbook.id = "R5EUXSQ-NSAM6WQ-J4D2SIM-FRPRYWH-DOBGOOB-YMVJIZP-F4JKZER-FUEYUQ4";
  };

  folder = dir: ignore: {
    path = "${home}/${dir}";
    devices = builtins.attrNames devices;
    ignorePatterns = [ "(?d).DS_Store" ] ++ ignore;
  };
in
{
  inherit devices;

  folders = {
    documents = folder "Documents" [ "/Codex" ];
    pictures = folder "Pictures" [ "/Photos Library.photoslibrary" ];
    videos = folder "Videos" [ ];
    music = folder "Music" [ ];
  };
}
