{ prev, final }:
let
  name = "horseman_wallpaper.sh";
  script_src = builtins.readFile ./horseman_wallpaper.sh;
  script = (prev.writeScriptBin name script_src).overrideAttrs (old: {
    buildCommand = ''
      ${old.buildCommand}
       patchShebangs $out'';
  });
  my-buildInputs = with final; [ imagemagick ];
in
prev.symlinkJoin {
  name = name;
  paths = [ script ] ++ my-buildInputs;
  buildInputs = [ prev.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
}
