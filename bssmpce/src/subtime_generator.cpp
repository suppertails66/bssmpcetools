#include "util/TIfstream.h"
#include "util/TOfstream.h"
#include "util/TBufStream.h"
#include "util/TFileManip.h"
#include "util/TStringConversion.h"
#include "util/TGraphic.h"
#include "util/TPngConversion.h"
#include "util/TOpt.h"
#include "util/TArray.h"
#include "util/TByte.h"
#include "util/TFileManip.h"
#include "pce/PceSpritePattern.h"
#include "pce/PcePalette.h"
#include "pce/PcePaletteLine.h"
#include <iostream>
#include <string>

using namespace std;
using namespace BlackT;
using namespace Pce;

//const static int patternsPerRow = 16;

int main(int argc, char* argv[]) {
  if (argc < 2) {
    cout << "Subtitle split wait sequence generator" << endl;
    cout << "Usage: " << argv[0] << " <framecount>" << endl;
    
    return 0;
  }
  
  int framecount = TStringConversion::stringToInt(string(argv[1]));
  
  int mainCount = framecount / 60;
  int subCount = framecount % 60;
  
/*  bool subCountWasZero = (subCount == 0);
  int totalOps = mainCount + (subCountWasZero ? 0 : 1);
  subCount -= totalOps;
  if (!subCountWasZero && (subCount == 0)) {
    // subcount was not zero, but became zero when we accounted for
    // the frame delay per op.
    // but since subcount is now zero, it no longer needs an op, so that
    // frame delay no longer counts.
    // which means we need to increment the subcount.
    // which means that it will be nonzero.
    // which means there now IS an op and WILL be a frame delay.
    // so we need to decrement the subcount.
    // which means it's now zero, and there will be no delay, so
    // we need to increment it...
    // you get the picture.
    // so we cheat instead.    
    --mainCount;
    subCount = 61;
  }
  else if (subCount < 0) {
    int amt = -(subCount / 60) + 1;
    mainCount -= amt;
    subCount += amt;
    
//    if (subCount == 0) {
//      subCount = 60;
//    }
//    else if (subCount < 0) {
      subCount = (subCount % 60) + 60;
//    }
  } */
  
  for (int i = 0; i < mainCount; i++) {
    cout << "  op16\n"
         << "  (\n"
         << "    [\n"
         << "      pushLong       60\n"
         << "      retVar\n"
         << "    ]\n"
         << "  )"
         << endl;
  }
  
  if (subCount != 0) {
    cout << "  op16\n"
         << "  (\n"
         << "    [\n"
         << "      pushLong       " << subCount << "\n"
         << "      retVar\n"
         << "    ]\n"
         << "  )"
         << endl;
  }
  
  return 0;
}
