{ prev, final }:
let
  name = "power_menu.sh";
  script_src = builtins.readFile ./power_menu.sh;
  script = (prev.writeScriptBin name script_src).overrideAttrs (old: {
    buildCommand = ''
      ${old.buildCommand}
       patchShebangs $out'';
  });
  my-buildInputs = with final; [
    util-linux
    procps
    gnused
    nettools
    rofi
    systemd
  ];
in prev.symlinkJoin {
  name = name;
  paths = [ script ] ++ my-buildInputs;
  buildInputs = [ prev.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
}
