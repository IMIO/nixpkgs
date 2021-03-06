{ lib, stdenv, fetchurl, glib, meson, ninja, pkg-config, gettext
, gobject-introspection, fixDarwinDylibNames, gnome3
}:

let
  pname = "json-glib";
  version = "1.4.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0ixwyis47v5bkx6h8a1iqlw3638cxcv57ivxv4gw2gaig51my33j";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ meson ninja pkg-config gettext gobject-introspection glib ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  outputs = [ "out" "dev" ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    homepage = "https://wiki.gnome.org/Projects/JsonGlib";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lethalman ];
    platforms = with platforms; unix;
  };
}
