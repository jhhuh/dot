{ python3Packages }:
let
  self = python3Packages.callPackage this {};
  this = { lib
         , buildPythonPackage
         , fetchPypi
         , requests
         }:

           buildPythonPackage rec {
             pname = "vastai";
             version = "0.2.2";

             #  disabled = ; # requires python version >=3.7

             src = fetchPypi {
               inherit pname version;
               sha256 = "a506c257176de8a01774ef18fd0a28075668d5173fb362a67e7779eab2399bc5";
             };

             propagatedBuildInputs = [
               requests
             ];

             meta = with lib; {
               description = "Vast.ai Python CLI";
               homepage = https://github.com/vast-ai/vast-python; license = licenses.mit;
               # maintainers = [ maintainers. ];
             };
           };

in self
