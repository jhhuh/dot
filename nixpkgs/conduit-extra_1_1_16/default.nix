{ mkDerivation, async, attoparsec, base, blaze-builder, bytestring
, bytestring-builder, conduit, criterion, directory, exceptions
, filepath, hspec, monad-control, network, primitive, process
, QuickCheck, resourcet, stdenv, stm, streaming-commons, text
, transformers, transformers-base
}:
mkDerivation {
  pname = "conduit-extra";
  version = "1.1.16";
  sha256 = "bd72c1bacd5f59a74a73a0aa115b8314f0a1dc1b24d939e52a983113c960f8d5";
  revision = "1";
  editedCabalFile = "1lyhm601bag34x1rvf8hr9cs8nqab735q7jm00si41m0my5gfj01";
  libraryHaskellDepends = [
    async attoparsec base blaze-builder bytestring conduit directory
    exceptions filepath monad-control network primitive process
    resourcet stm streaming-commons text transformers transformers-base
  ];
  testHaskellDepends = [
    async attoparsec base blaze-builder bytestring bytestring-builder
    conduit directory exceptions hspec process QuickCheck resourcet stm
    streaming-commons text transformers transformers-base
  ];
  benchmarkHaskellDepends = [
    base blaze-builder bytestring bytestring-builder conduit criterion
    transformers
  ];
  homepage = "http://github.com/snoyberg/conduit";
  description = "Batteries included conduit: adapters for common libraries";
  license = stdenv.lib.licenses.mit;
}
