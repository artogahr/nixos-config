# File type associations based on installed applications
{ pkgs, lib, ... }:
{
  xdg.mimeApps.defaultApplications = {
    # Images
    "image/png" = [ "org.kde.gwenview.desktop" ];
    "image/jpeg" = [ "org.kde.gwenview.desktop" ];
    "image/jpg" = [ "org.kde.gwenview.desktop" ];
    "image/gif" = [ "org.kde.gwenview.desktop" ];
    "image/bmp" = [ "org.kde.gwenview.desktop" ];
    "image/webp" = [ "org.kde.gwenview.desktop" ];
    "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
    "image/tiff" = [ "org.kde.gwenview.desktop" ];
    "image/x-ico" = [ "org.kde.gwenview.desktop" ];
    "image/x-icon" = [ "org.kde.gwenview.desktop" ];

    # PDFs
    "application/pdf" = [ "org.kde.okular.desktop" ];

    # Archives
    "application/zip" = [ "org.kde.dolphin.desktop" ];
    "application/x-tar" = [ "org.kde.dolphin.desktop" ];
    "application/x-compressed-tar" = [ "org.kde.dolphin.desktop" ];
    "application/x-bzip-compressed-tar" = [ "org.kde.dolphin.desktop" ];
    "application/x-xz-compressed-tar" = [ "org.kde.dolphin.desktop" ];
    "application/x-7z-compressed" = [ "org.kde.dolphin.desktop" ];
    "application/x-rar-compressed" = [ "org.kde.dolphin.desktop" ];
    "application/gzip" = [ "org.kde.dolphin.desktop" ];

    # Video
    "video/mp4" = [ "org.kde.haruna.desktop" ];
    "video/x-matroska" = [ "org.kde.haruna.desktop" ];
    "video/webm" = [ "org.kde.haruna.desktop" ];
    "video/x-msvideo" = [ "org.kde.haruna.desktop" ];
    "video/quicktime" = [ "org.kde.haruna.desktop" ];
    "video/x-ms-wmv" = [ "org.kde.haruna.desktop" ];

    # Audio
    "audio/mpeg" = [ "org.kde.haruna.desktop" ];
    "audio/mp3" = [ "org.kde.haruna.desktop" ];
    "audio/ogg" = [ "org.kde.haruna.desktop" ];
    "audio/flac" = [ "org.kde.haruna.desktop" ];
    "audio/wav" = [ "org.kde.haruna.desktop" ];
    "audio/x-vorbis+ogg" = [ "org.kde.haruna.desktop" ];

    # Text/Documents
    "text/plain" = [ "org.kde.kate.desktop" ];
    "text/markdown" = [ "org.kde.kate.desktop" ];
    "application/x-extension-txt" = [ "org.kde.kate.desktop" ];
    "application/vnd.oasis.opendocument.text" = [ "onlyoffice-desktopeditors.desktop" ];
    "application/vnd.oasis.opendocument.spreadsheet" = [ "onlyoffice-desktopeditors.desktop" ];
    "application/vnd.oasis.opendocument.presentation" = [ "onlyoffice-desktopeditors.desktop" ];
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "onlyoffice-desktopeditors.desktop" ];
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "onlyoffice-desktopeditors.desktop" ];
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "onlyoffice-desktopeditors.desktop" ];

    # Code
    "text/x-nix" = [ "org.kde.kate.desktop" ];
    "text/x-shellscript" = [ "org.kde.kate.desktop" ];
    "text/x-python" = [ "org.kde.kate.desktop" ];
    "text/x-c++src" = [ "org.kde.kate.desktop" ];
    "text/x-csrc" = [ "org.kde.kate.desktop" ];
    "text/x-java" = [ "org.kde.kate.desktop" ];
    "text/x-rust" = [ "org.kde.kate.desktop" ];
    "text/x-go" = [ "org.kde.kate.desktop" ];
    "application/json" = [ "org.kde.kate.desktop" ];
    "application/xml" = [ "org.kde.kate.desktop" ];
    "text/html" = [ "firefox.desktop" ];
    "text/css" = [ "org.kde.kate.desktop" ];
    "text/javascript" = [ "org.kde.kate.desktop" ];
    "text/typescript" = [ "org.kde.kate.desktop" ];

    # Typst
    "application/x-typst" = [ "typst.desktop" ];

    # Web
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/about" = [ "firefox.desktop" ];

    # Directories
    "inode/directory" = [ "org.kde.dolphin.desktop" ];

    # Custom handlers
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
  };
}
