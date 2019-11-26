{ stdenv, fetchurl, lib }:

let
pythonDocs = {
  html = {
    recurseForDerivations = true;
