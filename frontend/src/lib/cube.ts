export enum Sticker {
  YELLOW,
  WHITE,
  BLUE,
  RED,
  GREEN,
  ORANGE,
}
type StickerRow = { fst : Sticker; snd : Sticker; trd : Sticker }
type Layer = {
  front: StickerRow;
  right: StickerRow;
  back: StickerRow;
  left: StickerRow;
}
type Face = { fst : StickerRow; snd : StickerRow; trd : StickerRow }
export type Cube = {
  top_face: Face;
  top_layer: Layer;
  middle_layer: Layer;
  bottom_layer: Layer;
  bottom_face: Face;
};

function stickerFromJson(json: any): Sticker {
  const sticker_to_color_map = new Map<string, Sticker>([
    ["BLUE", Sticker.BLUE],
    ["GREEN", Sticker.GREEN],
    ["RED", Sticker.RED],
    ["YELLOW", Sticker.YELLOW],
    ["WHITE", Sticker.WHITE],
    ["ORANGE", Sticker.ORANGE],
  ]);
  const sticker = sticker_to_color_map.get(json[0]);
  if (sticker == undefined) {
    throw Error("Unable to parse json as Cube")
  }
  return sticker;
}

function rowFromJson(json: any): StickerRow {
  return {
    fst: stickerFromJson(json.fst),
    snd: stickerFromJson(json.snd),
    trd: stickerFromJson(json.trd),
  };
}

function layerFromJson(json: any): Layer {
  return {
    front: rowFromJson(json.front),
    right: rowFromJson(json.right),
    back: rowFromJson(json.back),
    left: rowFromJson(json.left),
  };
}

function faceFromJson(json: any): Face {
  return {
    fst: rowFromJson(json.fst),
    snd: rowFromJson(json.snd),
    trd: rowFromJson(json.trd),
  };
}

export function cubeFromJson(json: any): Cube {
  return {
    top_face: faceFromJson(json.top_face), 
    top_layer: layerFromJson(json.top_layer), 
    middle_layer: layerFromJson(json.middle_layer), 
    bottom_layer: layerFromJson(json.bottom_layer), 
    bottom_face: faceFromJson(json.bottom_face), 
  }
}
