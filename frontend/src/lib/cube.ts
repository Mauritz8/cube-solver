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

function stickerToJson(sticker: Sticker) {
  const sticker_to_color_map = new Map<Sticker, string[]>([
    [Sticker.BLUE, ["BLUE"]],
    [Sticker.GREEN, ["GREEN"]],
    [Sticker.RED, ["RED"]],
    [Sticker.YELLOW, ["YELLOW"]],
    [Sticker.WHITE, ["WHITE"]],
    [Sticker.ORANGE, ["ORANGE"]],
  ]);
  return sticker_to_color_map.get(sticker);
}

function rowFromJson(json: any): StickerRow {
  return {
    fst: stickerFromJson(json.fst),
    snd: stickerFromJson(json.snd),
    trd: stickerFromJson(json.trd),
  };
}

function rowToJson(row: StickerRow) {
  return {
    fst: stickerToJson(row.fst),
    snd: stickerToJson(row.snd),
    trd: stickerToJson(row.trd),
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

function layerToJson(layer: Layer) {
  return {
    front: rowToJson(layer.front),
    right: rowToJson(layer.right),
    back: rowToJson(layer.back),
    left: rowToJson(layer.left),
  };
}

function faceFromJson(json: any): Face {
  return {
    fst: rowFromJson(json.fst),
    snd: rowFromJson(json.snd),
    trd: rowFromJson(json.trd),
  };
}

function faceToJson(face: Face) {
  return {
    fst: rowToJson(face.fst),
    snd: rowToJson(face.snd),
    trd: rowToJson(face.trd),
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

export function cubeToJson(cube: Cube) {
  return {
    top_face: faceToJson(cube.top_face), 
    top_layer: layerToJson(cube.top_layer), 
    middle_layer: layerToJson(cube.middle_layer), 
    bottom_layer: layerToJson(cube.bottom_layer), 
    bottom_face: faceToJson(cube.bottom_face), 
  }
}
