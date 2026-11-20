home:
let
  devices = {
    fukurowl-pc.id = "NHJCTQA-NXIMAVC-2364GRY-AJN6LYI-CSFKP6E-MFN4AKT-HODWJ6C-3H5SOA6";
    fukurowl-macbook.id = "R5EUXSQ-NSAM6WQ-J4D2SIM-FRPRYWH-DOBGOOB-YMVJIZP-F4JKZER-FUEYUQ4";
    # Container 128 on proxmox2. Its discovery is off, so it needs a fixed address.
    vault = {
      id = "UBSZXYK-7NIF57Y-EKECXHQ-Q6Q3WPU-XOIVTSB-C55VZIV-4TYZG3D-QBCCKQG";
      addresses = [ "tcp://10.0.0.28:22000" ];
    };
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
