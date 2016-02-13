{ composableDerivation, fetchurl, pcre, openssl, readline, libxml2, geos, apacheAnt, jdk }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {

  name = "monetdb-2009-05-01";

  src = fetchurl {
    url = https://www.monetdb.org/downloads/sources/Jul2015-SP2/MonetDB-11.21.13.tar.bz2;
    sha256 = "0mzdk3jr9dyqw2xx73wkfcrrci1w7wzdg1lpzqf2gfblh12r0xln";
  };

  flags = edf { name = "geom"; enable = { buildInputs = [geos]; }; }
          // {
            java = { buildInputs = [ (apacheAnt.override {}) jdk /* must be 1.5 */ ]; };
            /* perl TODO export these (SWIG only if its present) HAVE_PERL=1 HAVE_PERL_DEVEL=1 HAVE_PERL_SWIG=1 */
          };

  buildInputs = [ (pcre.override { unicodeSupport = true; })
                   openssl readline libxml2 ]; # optional python perl php java ?

  cfg = {
    geomSupport = true;
    javaSupport = true;
  };

  configurePhase = ":";
  buildPhase = ":";

  installPhase = ''
    mkdir $TMP/build
    sh monetdb-install.sh --build=$TMP/build --prefix=$out --enable-sql --enable-xquery
  '';

  meta = {
    description = "A open-source database system for high-performance applications in data mining, OLAP, GIS, XML Query, text and multimedia retrieval";
    homepage = http://monetdb.cwi.nl/;
    license = "MonetDB Public License"; # very similar to Mozilla public license (MPL) Version see 1.1 http://monetdb.cwi.nl/Legal/MonetDBLicense-1.1.html
  };
}
