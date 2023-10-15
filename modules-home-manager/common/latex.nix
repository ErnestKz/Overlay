{ pkgs, ... }:
with { inherit (pkgs) texlive ; };
let
  tex_packages =
    {
      inherit (texlive)
        minted
        upquote
        xstring
        framed
        catchfile
        scheme-medium
        fvextra
        blindtext
        breakurl
        tocbibind
        # graphicx
        # longtable
        # bigstrut
        multirow
        was
        # enumerate
        # makeidx
        # gensymb
        url
        wrapfig
        capt-of
        csquotes
        todonotes
        sfmath
        titlesec
      ;
    }
  ; 
in   
{
  home.packages = [ (texlive.combine tex_packages) ];
}
  
