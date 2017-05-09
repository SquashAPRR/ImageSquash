unit uFixImageSquash;

interface

// Les balises <img /> ont les données d'une image dans l'attribut alt => on les déplace dans le src
function FixImgAttributes(htmlData: string): string;
// Des balises <v:shape></v:shape> contienent une image dans le alt => on les mets dans une <img /> 
function FixVShape(htmlData: string): string;

var
  // Permet d'indiquer qu'au moins une image à été réparé
  anyImageFixed: boolean;
  
implementation

uses SysUtils, RegularExpressions;

function cleanImageData(srcOrAltAttribute: string): string;
begin
  if srcOrAltAttribute.Contains('data:image') then
    result := srcOrAltAttribute.Substring(0, Pos('"', srcOrAltAttribute)) + srcOrAltAttribute.Substring(Pos('data:image', srcOrAltAttribute) - 1)
  else
    result := srcOrAltAttribute;
end;

// Lis l'attribut passé en paramètre, utilisé pour un attribut de la forme attr="value" (en pas attr='value' ou attr=value)
function readAttribute(htmlNode: string; attribute: string): string;
var
  regexpr: TRegEx;
  match: TMatch;
begin
  regexpr := TRegEx.Create(attribute + '="[\s\S]*?"', [roIgnoreCase, roMultiline]);
  match := regexpr.match(htmlNode);
  if match.Success then
  begin
    // On enleve l'attribut pour ne garder que la valeur
    result := match.Value;
  end;

end;

// Supprime les blocs v:shape, qui continennent les data d'une image pour en faire une image
function FixVShape(htmlData: string): string;
var
  regexpr: TRegEx;
  match: TMatch;
  vshapeNode, imgSrc, imgNode: string;
begin
  // Expression régulière permettant de localiser la balise v:shape
  regexpr := TRegEx.Create('<v:shape [^>]*>[\s\S]*?</v:shape>', [roIgnoreCase, roMultiline]);
  match := regexpr.match(htmlData);

  while match.Success do
  begin
    vshapeNode := match.Value;
    if vshapeNode.Contains('data:image') then
    begin
      // Les données sont dans le alt
      imgSrc := cleanImageData(readAttribute(vshapeNode, 'alt'));
      imgSrc := StringReplace(imgSrc, 'alt', 'src', [rfIgnoreCase]);
      imgNode := '<img ' + imgSrc + ' />';
      htmlData := StringReplace(htmlData, vshapeNode, imgNode, [rfIgnoreCase]);
      anyImageFixed := true;
    end;
    match := match.NextMatch;
  end;
  result := htmlData;
end;

function inverserSrcAlt(imgNode: string): string;
var
  imgNewSrc, imgNewAlt: string;
begin
  imgNewSrc := readAttribute(imgNode, 'alt');
  imgNewSrc := StringReplace(imgNewSrc, 'alt', 'src', [rfIgnoreCase]);
  imgNewAlt := readAttribute(imgNode, 'src');
  imgNewAlt := StringReplace(imgNewAlt, 'src', 'alt', [rfIgnoreCase]);
  // Suppression des attributs
  imgNode := StringReplace(imgNode, readAttribute(imgNode, 'src'), '', [rfIgnoreCase]);
  imgNode := StringReplace(imgNode, readAttribute(imgNode, 'alt'), '', [rfIgnoreCase]);
  // Les données sont polluées par un "Description :" dans la valeur de l'attribut, on ne garde que la data de l'image
  imgNewSrc := cleanImageData(imgNewSrc);

  // Maj
  imgNode := imgNode.Insert(Pos('img ', imgNode) + 3, imgNewAlt);
  imgNode := imgNode.Insert(Pos('img ', imgNode) + 3, imgNewSrc);
  result := imgNode;
end;

// Les images qui sont d'origine en <img > ont leurs balises alt et src inversées
function FixImgAttributes(htmlData: string): string;
var
  regexpr: TRegEx;
  match: TMatch;
  imgNode, previousImgNode: string;
begin
  // Expression régulière permettant de localiser la balise v:shape
  regexpr := TRegEx.Create('<img [^>][\s\S]*?>', [roIgnoreCase, roMultiline]);
  match := regexpr.match(htmlData);

  while match.Success do
  begin
    imgNode := match.Value;
    previousImgNode := imgNode;

    // Si on à les deux attributs, on les inverse
    if (readAttribute(imgNode, 'src') <> '') and (readAttribute(imgNode, 'alt') <> '') then
    begin
      imgNode := inverserSrcAlt(imgNode);
      htmlData := StringReplace(htmlData, previousImgNode, imgNode, [rfIgnoreCase]);
      anyImageFixed := true;
    end;

    match := match.NextMatch;
  end;
  result := htmlData;
end;

end.
