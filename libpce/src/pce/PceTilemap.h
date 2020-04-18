#ifndef PCETILEMAP_H
#define PCETILEMAP_H


#include "util/TArray.h"
#include "util/TTwoDArray.h"
#include "util/TByte.h"
#include "util/TGraphic.h"
#include "pce/PceTileId.h"

namespace Pce {


class PceTilemap {
public:
  
  PceTilemap();
  
  void resize(int w, int h);
  const PceTileId& getTileId(int x, int y) const;
  void setTileId(int x, int y, const PceTileId& tileId);
  
  void read(const char* src, int w, int h);
  
/*  void toColorGraphic(BlackT::TGraphic& dst,
                      const MdVram& vram,
                      const MdPalette& pal);
  
  void toGrayscaleGraphic(BlackT::TGraphic& dst,
                      const MdVram& vram); */
  
  BlackT::TTwoDArray<PceTileId> tileIds;
protected:
};


}


#endif
