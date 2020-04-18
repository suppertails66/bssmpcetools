#include "smpce/SmPceMsgScriptDecmp.h"
#include "smpce/SmPceVarScriptDecmp.h"
#include "smpce/SmPceFileIndex.h"
#include "smpce/SmPceGraphic.h"
#include "pce/okiadpcm.h"
#include "pce/PcePalette.h"
#include "util/TBufStream.h"
#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TGraphic.h"
#include "util/TStringConversion.h"
#include "util/TPngConversion.h"
#include "util/TCsv.h"
#include "util/TSoundFile.h"
#include "util/TFileManip.h"
#include <string>
#include <iostream>

using namespace std;
using namespace BlackT;
using namespace Pce;

int main(int argc, char* argv[]) {
  if (argc < 3) {
    cout << "Bishoujo Senshi Sailor Moon (PC-Engine CD) file extractor" << endl;
    cout << "Usage: " << argv[0] << " [iso] [outprefix]" << endl;
    return 0;
  }
  
  string inputFile = string(argv[1]);
  string outPrefix = string(argv[2]);
  
  if (!TFileManip::fileExists(inputFile)) {
    cerr << "Error: input file '" << inputFile << "' does not exist" << endl;
    return 1;
  }
  
  TIfstream ifs(inputFile.c_str(), ios_base::binary);
  ifs.seek(0x29000);
  
  SmPceFileIndex index;
  ifs.seek(0x29000);
  index.read(ifs, 5177);
  
  for (int i = 0; i < index.entries.size(); i++) {
    TBufStream scrifs(index.entries[i].getByteSize());
    ifs.seek(index.entries[i].getBytePos());
    scrifs.writeFrom(ifs, index.entries[i].getByteSize());
    scrifs.seek(0);
    string fname = outPrefix + index.entries[i].hash + ".bin";
    scrifs.save(fname.c_str());
  }
  
  return 0;
}
