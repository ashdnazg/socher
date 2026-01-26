function GetPressedKey: char; forward;

procedure WaitForKey;
var
  PressedKey: char;
begin
  repeat
  PressedKey := GetPressedKey;
  until ((PressedKey = #13) or (PressedKey = #27)) and not KeyPressed;
end;

procedure ShowMessage(
  Func3_arg_108: byte;
  Line1: TMessageLine;
  Line2: TMessageLine;
  Line3: TMessageLine
);
begin
  GetPic(PreMessageBackground, 10, 138 - 29, 10 + 221, 138);
  PutPic(MessageSign^, 10, 138);
  GotoXY(29 - Length(Line1), 15);
  Write(Line1);
  GotoXY(29 - Length(Line2), 16);
  Write(Line2);
  GotoXY(29 - Length(Line3), 17);
  Write(Line3);
  if (Func3_arg_108 = 87) or (Func3_arg_108 = 82) then
  begin
    WaitForKey;
    PutPic(PreMessageBackground, 10, 138);
  end;
end;

procedure ShowScrFile(Path: str_30);
var
  ScrFile: file;
  Contents: PScrBuffer;
begin
  Assign(ScrFile, Path);
  {$I-} Reset(ScrFile); {$I+}
  if IOResult <> 0 then
    Writeln('םיק וניא ', Path, ' ץבק')
  else
  begin
    New(Contents);
    BlockRead(ScrFile, Contents^, 126);
    Close(ScrFile);
    PutPic(Contents^, 0, 199);
    Dispose(Contents);
  end;
end;

function LoadWinFile(FileName: str_30): PWinBuffer;
var
  WinFile: file;
  Contents: PWinBuffer;
  NumBlocks: integer;
begin
  Assign(WinFile, (FileName + '.win'));
  {$I-} Reset(WinFile); {$I+}
  if IOResult <> 0 then
    Writeln('םיק וניא ', FileName, '.win ץבק')
  else
  begin
    New(Contents);
    NumBlocks := 8832 div 128;
    BlockRead(WinFile, Contents^, NumBlocks);
    Close(WinFile);
  end;
  GotoXY(1, 24);
  LoadWinFile := Contents;
end;

function LoadSgnFile(FileName: str_30): PSgnBuffer;
var
  SgnFile: file;
  Contents: PSgnBuffer;
  NumBlocks: integer;
begin
  if FileName <> 'day7' then
    Assign(SgnFile, BasePath + FileName + '.sgn')
  else
    Assign(SgnFile, 'day7.sgn');

  {$I-} Reset(SgnFile); {$I+}
  if IOResult <> 0 then
    Writeln('םיק וניא ', BasePath, FileName, '.sgn ץבק')
  else
  begin
    New(Contents);
    NumBlocks := FileSize(SgnFile);
    BlockRead(SgnFile, Contents^, NumBlocks);
    Close(SgnFile);
  end;
  LoadSgnFile := Contents;
end;

function LoadScrFile(Func7_arg_0: str_30): PScrBuffer;
var
  ScrFile: file;
  Contents: PScrBuffer;
begin
  Assign(ScrFile, BasePath + Func7_arg_0 + '.scr');
  {$I-} Reset(ScrFile); {$I+}
  if IOResult <> 0 then
    Writeln('םיק וניא ', BasePath, Func7_arg_0, '.scr ץבק')
  else
  begin
    New(Contents);
    BlockRead(ScrFile, Contents^, 126);
    Close(ScrFile);
  end;
  GotoXY(1, 24);
  LoadScrFile := Contents;
end;

function Func8: real;
var
  Func8_var_6: integer;
  Func8_var_0: real;
begin
  Func8_var_0 := 0;
  for Func8_var_6 := 1 to 3 do
  begin
    Func8_var_0 := (Func8_var_0 + ((1.0 * Cargo[Func8_var_6]) * BaseWarePrice[Func8_var_6]));
  end;
  Func8 := Func8_var_0;
end;
function Func9: integer;
var
  Func9_var_2: integer;
  Func9_var_0: integer;
begin
  Func9_var_0 := 0;
  for Func9_var_2 := 1 to 3 do
  begin
    Func9_var_0 := (Func9_var_0 + Cargo[Func9_var_2]);
  end;
  Func9 := Func9_var_0;
end;

function ToStrWithCommas(Func10_arg_0: real): str_15;
var
  Func10_var_2: str_15;
  Func10_var_0: integer;

  function ZeroPad3(Func11_arg_0: real): str_15;
  begin
    Str(Func11_arg_0:1:0, Func10_var_2);
    for Func10_var_0 := 1 to 2 do
    begin
      if Length(Func10_var_2) < 3 then
      begin
        Func10_var_2 := '0' + Func10_var_2;
      end;
    end;
    ZeroPad3 := Func10_var_2;
  end;

begin
  if Func10_arg_0 <= 999 then
  begin
    Str(Func10_arg_0:1:0, Func10_var_2);
    ToStrWithCommas := Func10_var_2;
  end
  else
  begin
    ToStrWithCommas := ToStrWithCommas(Int(Func10_arg_0 / 1000)) + ',' + ZeroPad3(1000 * Frac(Func10_arg_0 / 1000));
  end;
end;

procedure Func12(
  Func12_arg_8: integer;
  var Func12_arg_4: integer;
  var Func12_arg_0: real
);
var
  Func12_var_0: integer;
begin
  Func12_arg_4 := 0;
  Func12_arg_0 := 0;
  for Func12_var_0 := 1 to 3 do
  begin
    if ((((1.0 * Cargo[Func12_var_0]) * BaseWarePrice[Func12_var_0]) > Func12_arg_0) and
 (Cargo[Func12_var_0] >= Func12_arg_8)) then
    begin
      Func12_arg_4 := Func12_var_0;
      Func12_arg_0 := ((1.0 * Cargo[Func12_var_0]) * BaseWarePrice[Func12_var_0]);
    end;
  end;
end;

procedure Func13;
begin
  if (StormCountryName = ' ') then
  begin
    ShowScrFile((BasePath + 'goodwthr.scr'));
  end
  else
  begin
    GotoXY(28, 20);
    ShowScrFile((BasePath + 'badwthr.scr'));
    Write(StormCountryName:6);
  end;
  WaitForKey;
end;

procedure ShowHelpScreen;
var
  CurrentScreenContents: PScrBuffer;
  CurrentX: integer;
  CurrentY: integer;
  Buffer: string[8];
begin
  CurrentX := WhereX;
  CurrentY := WhereY;
  New(CurrentScreenContents);
  GetPic(CurrentScreenContents^, 0, 0, 319, 199);
  ColorTable(0, 1, 2, 3);
  PutPic(HelpScreen^, 0, 199);
  GotoXY(9, 7);
  if (StormCountryName = ' ') then
    Write('האנ':17)
  else
    Write(StormCountryName + ' רוזאב הרעס':17);
  GotoXY(9, 12);
  Write(BankBalance:17:0);
  GotoXY(9, 17);
  Str(ShipCapacity, Buffer);
  Write('ןוט ' + Buffer:17);
  GotoXY(9, 22);
  Str(ShipDamage:1:0, Buffer);
  if (ShipDamage <= 0) then
    Write('ןיקת':17)
  else
    Write('לקש ' + Buffer + ' לש קזנ':17);
  repeat
    Read(KBD, LastPressedKey);
  until not KeyPressed;
  ColorTable(0, 1, 2, 3);
  PutPic(CurrentScreenContents^, 0, 199);
  GotoXY(CurrentX, CurrentY);
  Dispose(CurrentScreenContents);
end;

function GetPressedKey;
var
  PressedKey: char;
begin
  Read(KBD, PressedKey);
  if (PressedKey = #27) and KeyPressed then
    Read(KBD, PressedKey);
  if (PressedKey = #68) then
  begin
    ShowHelpScreen;
    PressedKey := GetPressedKey;
  end;
  GetPressedKey := PressedKey;
end;

function CountryNameToIndex(CountryName: TCountryName): integer;
begin
  if CountryName = 'היכרות' then
    CountryNameToIndex := Turkey
  else if CountryName = 'לארשי' then
    CountryNameToIndex := Israel
  else if CountryName = 'םירצמ' then
    CountryNameToIndex := Egypt;
end;

function CountryIndexToName(CountryIndex: integer): TCountryName;
begin
  case CountryIndex of
    Turkey: CountryIndexToName := 'היכרות';
    Israel: CountryIndexToName := 'לארשי';
    Egypt: CountryIndexToName := 'םירצמ';
  end;
end;

function Func17(
  Func17_arg_2: arr_record_1479674575002027080_10;
  Func17_arg_0: integer
): integer;
var
  Func17_var_802: integer;
  Func17_var_2: arr_byte_800;
  Func17_var_1: char;
  Func17_var_0: boolean;
begin
  Func17_var_0 := False;
  if (Func17_arg_0 > 100) then
  begin
    Func17_arg_0 := (Func17_arg_0 - 100);
  end
  else
  begin
    Func17_var_0 := True;
  end;
  Func17_var_802 := 1;
  repeat
  with Func17_arg_2[Func17_var_802] do
  begin
    GetPic(Func17_var_2, field_0, field_2, field_4, field_6);
    ColorTable(3, 2, 1, 0);
    PutPic(Func17_var_2, field_0, field_6);
    repeat
    Func17_var_1 := GetPressedKey;
    until (Func17_var_1 in [#72, #75, #80, #77, ' ', #13, #27]);
    ColorTable(0, 1, 2, 3);
    if ((Func17_var_1 <> #13) or Func17_var_0) then
    begin
      PutPic(Func17_var_2, field_0, field_6);
    end;
    case Func17_var_1 of
      #72, #75:   begin
          Func17_var_802 := (Func17_var_802 - 1);
        end;
      ' ', #80, #77:   begin
          Func17_var_802 := (Func17_var_802 + 1);
        end;
      #27:   begin
          Func17_var_802 := -1;
        end;
    end;
    if (Func17_var_802 = 0) then
    begin
      Func17_var_802 := Func17_arg_0;
    end
    else
    begin
      if (Func17_var_802 = (Func17_arg_0 + 1)) then
      begin
        Func17_var_802 := 1;
      end;
    end;
  end;
  until ((Func17_var_1 = #13) or (Func17_var_1 = #27));
  Func17 := Func17_var_802;
end;

function Func18(
  Func18_arg_4: integer;
  Func18_arg_2: integer;
  Func18_arg_0: integer
): real;
var
  Func18_var_31: char;
  Func18_var_25: real;
  Func18_var_24: boolean;
  Func18_var_22: integer;
  Func18_var_20: integer;
  Func18_unused_16: array[1..4] of byte;
  Func18_var_14: integer;
  Func18_unused_12: array[1..2] of byte;
  Func18_var_6: string[5];
  Func18_var_0: string[5];
begin
  Func18_var_22 := WhereX;
  Func18_var_20 := WhereY;
  Func18_var_14 := 0;
  repeat
  begin
    Func18_var_25 := 0;
    for Func18_var_14 := 1 to Func18_var_14 do
    begin
      Write(' ');
    end;
    Func18_var_24 := False;
    Func18_var_14 := 0;
    GotoXY(Func18_var_22, Func18_var_20);
    repeat
    begin
      Func18_var_31 := GetPressedKey;
      case Func18_var_31 of
        #68:   begin
            ShowHelpScreen;
          end;
        #48:   begin
            if (Func18_var_14 < Func18_arg_0) then
            begin
              Func18_var_25 := (((10 * Func18_var_25) + Ord(Func18_var_31)) - 48);
              if ((Func18_var_25 <> 0) or (Func18_var_14 = 0)) then
              begin
                Write(Func18_var_31);
              end;
              Func18_var_14 := (Func18_var_14 + 1);
            end;
          end;
        #49..#57:   begin
            if (Func18_var_14 < Func18_arg_0) then
            begin
              Func18_var_25 := (((10 * Func18_var_25) + Ord(Func18_var_31)) - 48);
              Write(Func18_var_31);
              if (Func18_var_25 <> 0) then
              begin
                Func18_var_14 := (Func18_var_14 + 1);
              end;
            end;
          end;
        #8:   begin
            if (Func18_var_14 > 0) then
            begin
              Func18_var_25 := Int((Func18_var_25 / 10));
              Write(#8, ' ', #8);
              Func18_var_14 := (Func18_var_14 - 1);
            end;
          end;
        #13:   begin
            if (Func18_var_14 > 0) then
            begin
              Func18_var_24 := True;
            end;
          end;
        #27:   begin
            Func18_var_25 := -1;
            Func18_var_24 := True;
          end;
      end;
      if (Func18_var_14 = Func18_arg_0) then
      begin
        Sound(700);
        Delay(50);
        NoSound;
        Delay(80);
      end;
    end
    until Func18_var_24;
    if ((not ((Func18_arg_4 = 0) and (Func18_arg_2 = 0))) and (((Func18_var_25 >= 0) and (Func18_var_25 > Func18_arg_2)) or
 ((Func18_var_25 <= 0) and (Func18_var_25 < Func18_arg_4)))) then
    begin
      GotoXY(2, 10);
      Str(Func18_arg_4, Func18_var_0);
      Str(Func18_arg_2, Func18_var_6);
      ShowMessage(
        87,
        '',
        (((Func18_var_6 + ' -ל ') + Func18_var_0) + ' ןיב רפסמ סנכה אנ'),
        #7
      );
      GotoXY(Func18_var_22, Func18_var_20);
      Func18_var_24 := False;
    end;
  end
  until Func18_var_24;
  Func18 := Func18_var_25;
end;

function Func19(
  Func19_arg_4: integer;
  Func19_arg_2: integer;
  Func19_arg_0: integer
): integer;
begin
  Func19 := Trunc(Func18(Func19_arg_4, Func19_arg_2, Func19_arg_0));
end;

function InputYesNo: boolean;
var
  Func20_var_9: boolean;
  Func20_var_8: char;
  Func20_var_6: integer;
  Func20_var_4: integer;
  X: integer;
  Y: integer;
begin
  X := WhereX;
  Y := WhereY;
  Func20_var_4 := 0;
  repeat
  begin
    GotoXY(X, Y);
    Func20_var_8 := GetPressedKey;
    case Func20_var_8 of
      #139, #102, #70:   begin
          Func20_var_9 := True;
          Func20_var_4 := (Func20_var_4 + 1);
        end;
      #140, #107, #75:   begin
          Func20_var_9 := False;
          Func20_var_4 := (Func20_var_4 + 1);
        end;
      #27, ' ':   begin
          Func20_var_9 := (not Func20_var_9);
        end;
      else   begin
          if (Func20_var_8 <> #13) then
          begin
            for Func20_var_6 := 1 to 2 do
            begin
              Sound(700);
              Delay(50);
              NoSound;
              Delay(80);
            end;
          end;
        end
    end;
    if (Func20_var_4 > 0) then
    begin
      if Func20_var_9 then
      begin
        Write('ןכ');
      end
      else
      begin
        Write('אל');
      end;
    end;
  end
  until ((Func20_var_8 = #13) and (Func20_var_4 > 0));
  InputYesNo := Func20_var_9;
end;

procedure PlayDay;
var
  PriceCopperIsrael: integer;
  PriceCopperTurkey: integer;
  PriceCopperEgypt: integer;
  PriceOlivesIsrael: integer;
  PriceOlivesTurkey: integer;
  PriceOlivesEgypt: integer;
  PriceWheatIsrael: integer;
  PriceWheatTurkey: integer;
  PriceWheatEgypt: integer;
  Func21_var_91: integer;
  Func21_var_89: integer;
  Func21_var_88: boolean;
  Func21_var_8: arr_record_1479674575002027080_10;
  Func21_var_6: integer;
  Func21_var_4: integer;
  Func21_unused_0: array[1..4] of byte;

  procedure ShowHUD;
  begin
    GotoXY(73, 1);
    Write(CurrentCountryName:6);
    GotoXY(32, 3);
    Write(DayName[Day]);
    GotoXY(32, 5);
    Write(global_var_81:2);
    Write(':00');
    GotoXY(32, 17);
    Write(' ':8);
    GotoXY(34, 17);
    if (Money >= 10000.0) then
      GotoXY(33, 17);
    if (Money >= 100000.0) then
      GotoXY(32, 17);
    Write(ToStrWithCommas(Money):5);
    GotoXY(32, 9);
    Write(Cargo[Copper]:3);
    GotoXY(32, 11);
    Write(Cargo[Olives]:3);
    GotoXY(32, 13);
    Write(' ':5);
    GotoXY(32, 13);
    Write(Cargo[Wheat]:3);
    GotoXY(30, 21);
    Write(PriceCopperTurkey:4);
    GotoXY(30, 23);
    Write(PriceOlivesTurkey:4);
    GotoXY(30, 25);
    Write(PriceWheatTurkey:4);
    GotoXY(16, 21);
    Write(PriceCopperIsrael:4);
    GotoXY(16, 23);
    Write(PriceOlivesIsrael:4);
    GotoXY(16, 25);
    Write(PriceWheatIsrael:4);
    GotoXY(2, 21);
    Write(PriceCopperEgypt:4);
    GotoXY(2, 23);
    Write(PriceOlivesEgypt:4);
    GotoXY(2, 25);
    Write(PriceWheatEgypt:4);
  end;

  function Func23(Func23_arg_0: byte): boolean;
  begin
    if Func23_arg_0 = 26 then
      Func23 := True
    else
      Func23 := False;
  end;

  function Func24(Func24_arg_0: real): boolean;
  begin
    if Func24_arg_0 > Money then
    begin
      ShowMessage(87, '', '!ףסכ קיפסמ ךתושרב ןיא', #7);
      Func24 := True;
    end
    else
      Func24 := False;
  end;

  function Func25(
    var Func25_arg_12: integer;
    var Func25_arg_8: integer;
    var Func25_arg_4: integer;
    var Func25_arg_0: real
  ): boolean;
  var
    Func25_var_28: integer;
    Func25_var_26: integer;
    Func25_var_24: integer;
    Func25_var_18: real;
    Func25_var_12: real;
    Func25_var_6: real;
    Func25_unused_0: array[1..6] of byte;

    function Func26(Func26_arg_6: real; Func26_arg_0: real): boolean;
    begin
      if Func26_arg_6 < 0 then
        Func26_arg_6 := 0;
      if Func26_arg_6 <= Func26_arg_0 then
        Func26 := True
      else
      begin
        ShowMessage(87, '', '!הז םוכס ךתושרב ןיא', #7);
        Func26 := False;
      end;
    end;

    function Func27(var Func27_arg_6: integer; Func27_arg_0: real): boolean;
    begin
      if Func27_arg_6 < 0 then
        Func27_arg_6 := 0;

      if Func27_arg_6 <= Func27_arg_0 then
        Func27 := True
      else
      begin
        ShowMessage(87, '', '!הז םוכס ךתושרב ןיא', #7);
        Func27 := False;
      end;
    end;

  begin
    Func25_var_28 := 0;
    Func25_var_26 := 0;
    Func25_var_24 := 0;
    Func25_var_18 := 0;
    if Func25_arg_12 > 0 then
    begin
      repeat
      begin
        ShowMessage(78,'?תתל ןכומ התא' + WareName[Copper] + 'ןוט המכ', '', '');
        GotoXY(20, 16);
        repeat
          Func25_var_28 := Trunc(Func18(0, 0, 8));
        until Func25_var_28 >= 0;
      end
      until (Func25_var_28 >= 0) and Func27(Func25_var_28, Func25_arg_12);
    end;
    if Func25_arg_8 > 0 then
    begin
      repeat
      begin
        ShowMessage(78,'?תתל ןכומ התא' + WareName[Olives] + 'ןוט המכ', '', '');
        GotoXY(20, 16);
        repeat
          Func25_var_26 := Trunc(Func18(0, 0, 8));
        until Func25_var_26 >= 0;
      end
      until Func27(Func25_var_26, Func25_arg_8);
    end;
    if Func25_arg_4 > 0 then
    begin
      repeat
      begin
        ShowMessage(78, (('?תתל ןכומ התא' + WareName[Wheat]) + 'ןוט המכ'), '', '');
        GotoXY(20, 16);
        repeat
          Func25_var_24 := Trunc(Func18(0, 0, 8));
        until Func25_var_24 >= 0;
      end
      until Func27(Func25_var_24, Func25_arg_4);
    end;
    if Func25_arg_0 > (Func8 / 10) then
    begin
      repeat
      begin
        ShowMessage(78, '?תתל ןכומ התא ףסכ המכ', '', '');
        GotoXY(20, 16);
        repeat
          Func25_var_18 := Trunc(Func18(0, 0, 8));
        until Func25_var_18 >= 0;
      end
      until Func26(Func25_var_18, Func25_arg_0);
    end;
    Func25_var_12 := Func25_var_28 * BaseWarePrice[Copper] + Func25_var_26 * BaseWarePrice[Olives] +
        Func25_var_24 * BaseWarePrice[Wheat] + Func25_var_18;
    Func25_var_6 := (Func8 + Func25_arg_0) / (Random(6) + 4);
    if Func25_var_12 > Func25_var_6 then
    begin
      Func25_arg_0 := Func25_arg_0 - Func25_var_18;
      Func25_arg_12 := Func25_arg_12 - Func25_var_28;
      Func25_arg_8 := Func25_arg_8 - Func25_var_26;
      Func25_arg_4 := Func25_arg_4 - Func25_var_24;
      Func25 := True;
    end
    else
      Func25 := False;
  end;

  procedure Func28(
    Func28_arg_8: byte;
    var Func28_arg_4: integer;
    var Func28_arg_0: str_7
  );
  var
    Func28_var_8: boolean;
    Func28_var_6: integer;
    Func28_var_4: integer;
    Func28_var_2: integer;
    Func28_var_0: integer;
  begin
    Func28_var_0 := 0;
    Func28_var_8 := False;
    if (Func28_arg_8 = 142) then
    begin
      for Func28_var_6 := 1 to 3 do
      begin
        if ((not Func28_var_8) and (Cargo[Func28_var_6] > 2)) then
        begin
          Func28_var_0 := Trunc(
            (((20.0 + Random(21)) / 100) * Cargo[Func28_var_6])
          );
          if (Func28_var_0 < 1) then
          begin
            Func28_var_0 := 1;
          end;
          Cargo[Func28_var_6] := (Cargo[Func28_var_6] - Ord(Func28_var_0));
          Func28_arg_4 := Func28_var_6;
          Func28_var_8 := True;
        end;
      end;
    end
    else
    begin
      if (Func28_arg_8 = 153) then
      begin
        if (Func9 <= (3 * ShipCapacity)) then
        begin
          Func28(142, Func28_arg_4, Func28_arg_0);
          Val(Func28_arg_0, Func28_var_0, Func28_var_6);
        end
        else
        begin
          Func28_arg_4 := 1;
          if (Cargo[Olives] > Cargo[Copper]) then
          begin
            Func28_arg_4 := 2;
          end;
          if (Cargo[Wheat] > Cargo[Func28_arg_4]) then
          begin
            Func28_arg_4 := 3;
          end;
          Func28_var_0 := (Func9 - (3 * ShipCapacity));
          if (Func28_var_0 >= Cargo[Func28_arg_4]) then
          begin
            Func28_var_0 := Cargo[Func28_arg_4];
            Cargo[Func28_arg_4] := 0;
          end
          else
          begin
            Cargo[Func28_arg_4] := (Cargo[Func28_arg_4] - Ord(Func28_var_0));
            Func28(142, Func28_var_4, Func28_arg_0);
            Val(Func28_arg_0, Func28_var_2, Func28_var_6);
            if (Func28_var_4 = Func28_arg_4) then
            begin
              Func28_var_0 := (Func28_var_0 + Func28_var_2);
            end
            else
            begin
              Cargo[Func28_var_4] := (Cargo[Func28_var_4] + Func28_var_2);
            end;
          end;
        end;
      end
      else
      begin
        if (Func28_arg_8 = 139) then
        begin
          Func28_var_0 := (10 * Trunc((Money / (Random(40) + 40))));
          Money := (Money - Func28_var_0);
        end
        else
        begin
          if (Func28_arg_8 = 144) then
          begin
            Func28_var_0 := (10 * Trunc(((Money + Func8) / (Random(30) + 50))));
            if (Func28_var_0 < 100) then
            begin
              Func28_var_0 := 100;
            end;
            ShipDamage := (ShipDamage + Func28_var_0);
          end;
        end;
      end;
    end;
    Str(Func28_var_0, Func28_arg_0);
  end;

  procedure GenerateNewPrices;
  begin
    PriceCopperIsrael := BaseWarePrice[Copper] - 500 + Random(11) * 100;
    PriceOlivesIsrael := BaseWarePrice[Olives] - 150 + Random(7) * 50;
    PriceWheatIsrael := BaseWarePrice[Wheat] - 15 + Random(8) * 5;
    PriceCopperTurkey := BaseWarePrice[Copper] - 500 + Random(11) * 100;
    PriceOlivesTurkey := BaseWarePrice[Olives] - 150 + Random(7) * 50;
    PriceWheatTurkey := BaseWarePrice[Wheat] - 15 + Random(8) * 5;
    PriceCopperEgypt := BaseWarePrice[Copper] - 500 + Random(11) * 100;
    PriceOlivesEgypt := BaseWarePrice[Olives] - 150 + Random(7) * 50;
    PriceWheatEgypt := BaseWarePrice[Wheat] - 15 + Random(8) * 5;
  end;

  procedure UpdateStorm(var OutStormCountryName: TCountryName);
  var
    Unused: integer;
  begin
    if (Random(8) < 3) and (Day <> 1) then
      OutStormCountryName := CountryIndexToName(Random(3) + 1)
    else
      OutStormCountryName := ' ';
  end;

  procedure Func31;
  var
    Func31_var_183: integer;
    Func31_var_181: integer;
    Func31_var_179: integer;
    Func31_var_177: integer;
    Func31_var_175: integer;
    Func31_var_173: integer;
    Func31_var_171: integer;
    Func31_var_169: integer;
    Func31_var_167: integer;
    Func31_var_165: integer;
    Func31_var_163: integer;
    Func31_var_155: str_7;
    Func31_var_147: str_7;
    Func31_var_139: str_7;
    Func31_var_103: TMessageLine;
    Func31_var_23: arr_record_1479674575002027080_10;
    Func31_var_22: boolean;
    Func31_var_16: real;
    Func31_var_10: real;
    Func31_var_4: array[1..3] of integer;
    Func31_var_2: integer;
    Func31_var_0: integer;

    procedure UpdateSpecialPrices(
      { 1 = Up, 2 = Down }
      UpDownFlag: integer;
      Country: integer;
      NewPrice: integer;
      Ware: integer
    );
    var
      UpDownString: string[6];
      NewPriceString: str_7;
    begin
      if UpDownFlag = 1 then
        UpDownString := '-ל ץפק'
      else
        UpDownString := '-ל דרי';
      Str(NewPrice, NewPriceString);
      case Country of
        Turkey:   begin
            case Ware of
              Copper: PriceCopperTurkey := NewPrice;
              Olives: PriceOlivesTurkey := NewPrice;
              Wheat: PriceWheatTurkey := NewPrice;
            end;
            GotoXY(7, 2 + 21 * (UpDownFlag - 1));
            Writeln('היכרותב' + WareName[Ware] + '' + 'ה ריחמ':27);
            GotoXY(7, 3 + 21 * (UpDownFlag - 1));
            Writeln('!!םילקש ' + NewPriceString + UpDownString:25);
          end;
        Israel:   begin
            case Ware of
              Copper: PriceCopperIsrael := NewPrice;
              Olives: PriceOlivesIsrael := NewPrice;
              Wheat: PriceWheatIsrael := NewPrice;
            end;
            GotoXY(7, 2 + 21 * (UpDownFlag - 1));
            Writeln('לארשיב' + WareName[Ware] + '' + 'ה ריחמ':27);
            GotoXY(7, 3 + 21 * (UpDownFlag - 1));
            Writeln('!!םילקש ' + NewPriceString + UpDownString:25);
          end;
        Egypt:   begin
            case Ware of
              Copper: PriceCopperEgypt := NewPrice;
              Olives: PriceOlivesEgypt := NewPrice;
              Wheat: PriceWheatEgypt := NewPrice;
            end;
            GotoXY(7, 2 + 21 * (UpDownFlag - 1));
            Writeln('םירצמב' + WareName[Ware] + '' + 'ה ריחמ':27);
            GotoXY(7, 3 + 21 * (UpDownFlag - 1));
            Writeln('!!םילקש ' + NewPriceString + UpDownString:25);
          end;
      end;
      WaitForKey;
    end;

  begin
    repeat
    begin
      Func31_var_22 := True;
      repeat
      Func31_var_183 := (Random(30) + 1);
      until (((((((((((((Func31_var_183 <> LastNightEvent) and (not ((Func31_var_183 in [1..2]) and (LastNightEvent in [1..2]))))
  and (not ((Func31_var_183 in [3..4]) and (LastNightEvent in [3..4])))) and (not ((Func31_var_183 in [5..6]) and
  (LastNightEvent in [5..6])))) and (not ((Func31_var_183 in [7..8]) and (LastNightEvent in [7..8])))) and (not ((Func31_var_183
  in [9..10]) and (LastNightEvent in [9..10])))) and (not ((Func31_var_183 in [11..12]) and (LastNightEvent in [11..12])))) and
  (not ((Func31_var_183 in [13..18]) and (LastNightEvent in [13..18])))) and (not ((Func31_var_183 in [19..20]) and
  (LastNightEvent in [19..20])))) and (not ((Func31_var_183 in [21..22]) and (LastNightEvent in [21..22])))) and (not
  ((Func31_var_183 in [23..26]) and (LastNightEvent in [23..26])))) and (not ((Func31_var_183 in [27..28]) and (LastNightEvent
  in [27..28])))) and (not ((Func31_var_183 in [29..30]) and (LastNightEvent in [29..30]))));
      if ((Money > 20000.0) and (Random(6) = 1)) then
      begin
        Func31_var_183 := 15;
      end;
      if ((Money > 45000.0) and (Random(6) = 1)) then
      begin
        Func31_var_183 := 15;
      end;
      case Func31_var_183 of
        1..2:   begin
            PutPic(CopperUpScreen^, 0, 199);
            Func31_var_181 := (Random(3) + 1);
            Func31_var_179 := ((BaseWarePrice[1] + 1100) + (100 * Random(5)));
            UpdateSpecialPrices(1, Func31_var_181, Func31_var_179, 1);
          end;
        3..4:   begin
            PutPic(OlivesUpScreen^, 0, 199);
            Func31_var_181 := (Random(3) + 1);
            Func31_var_179 := ((BaseWarePrice[2] + 200) + (50 * Random(4)));
            UpdateSpecialPrices(1, Func31_var_181, Func31_var_179, 2);
          end;
        5..6:   begin
            PutPic(WheatUpScreen^, 0, 199);
            Func31_var_181 := (Random(3) + 1);
            Func31_var_179 := ((BaseWarePrice[3] + 20) + (Random(5) * 5));
            UpdateSpecialPrices(1, Func31_var_181, Func31_var_179, 3);
          end;
        7..8:   begin
            PutPic(CopperDownScreen^, 0, 199);
            Func31_var_181 := (Random(3) + 1);
            Func31_var_179 := ((BaseWarePrice[1] - 1100) - (100 * Random(5)));
            UpdateSpecialPrices(2, Func31_var_181, Func31_var_179, 1);
          end;
        9..10:   begin
            PutPic(OlivesDownScreen^, 0, 199);
            Func31_var_181 := (Random(3) + 1);
            Func31_var_179 := ((BaseWarePrice[2] - 150) - (Random(3) * 50));
            UpdateSpecialPrices(2, Func31_var_181, Func31_var_179, 2);
          end;
        11..12:   begin
            PutPic(WheatDownScreen^, 0, 199);
            Func31_var_181 := (Random(3) + 1);
            Func31_var_179 := ((BaseWarePrice[3] - 15) - (Random(3) * 5));
            UpdateSpecialPrices(2, Func31_var_181, Func31_var_179, 3);
          end;
        13..18:   begin
            Func31_var_2 := 0;
            Func31_var_0 := 0;
            Func31_var_169 := 0;
            for global_var_21 := 1 to 3 do
            begin
              Func31_var_4[global_var_21] := 0;
            end;
            Func31_var_173 := (50 * (Random(2) + 1));
            Func31_var_175 := (10 * (Random(Func31_var_173) + (2 * Func31_var_173)));
            if (Func31_var_175 <= ((Money + BankBalance) + Func8)) then
            begin
              PutPic(ExpandScreen^, 0, 199);
              GotoXY(29, 14);
              Write(Func31_var_173:3);
              if (Money > Func31_var_175) then
              begin
                Func31_var_2 := Func31_var_175;
              end
              else
              begin
                if (BankBalance > Func31_var_175) then
                begin
                  Func31_var_0 := Func31_var_175;
                end
                else
                begin
                  if ((Money + BankBalance) > Func31_var_175) then
                  begin
                    Func31_var_2 := Trunc(Money);
                    Func31_var_0 := (Func31_var_175 - Func31_var_2);
                    Str(Func31_var_0, Func31_var_139);
                  end
                  else
                  begin
                    Func12(1, Func31_var_169, Func31_var_10);
                    if (Func31_var_10 >= Func31_var_175) then
                    begin
                      Func31_var_163 := Round(
                        ((1.0 * Func31_var_175) / BaseWarePrice[Func31_var_169])
                      );
                      Func31_var_4[Func31_var_169] := Func31_var_163;
                      Str(Func31_var_163, Func31_var_139);
                    end
                    else
                    begin
                      Str(Cargo[Func31_var_169], Func31_var_139);
                      Func31_var_4[Func31_var_169] := Cargo[Func31_var_169];
                      if ((Money > BankBalance) or (Money >= Func31_var_2)) then
                      begin
                        Func31_var_2 := (Func31_var_175 - Trunc(Func31_var_10));
                        if (Func31_var_2 > Money) then
                        begin
                          Func31_var_2 := Trunc(Money);
                        end;
                        Str(Func31_var_2, Func31_var_139);
                      end
                      else
                      begin
                        Func31_var_0 := (Func31_var_175 - Trunc(Func31_var_10));
                        if (Func31_var_0 > BankBalance) then
                        begin
                          Func31_var_0 := Trunc(BankBalance);
                        end;
                        Str(Func31_var_0, Func31_var_139);
                      end;
                    end;
                  end;
                end;
              end;
              GotoXY(18, 15);
              if ((Func31_var_2 + Func31_var_0) > 0) then
              begin
                Write('ח"ש ', (Func31_var_2 + Func31_var_0));
              end;
              GotoXY(15, 16);
              if ((Func31_var_169 > 0) and (Func31_var_4[Func31_var_169] > 0)) then
              begin
                Str(Func31_var_4[Func31_var_169], Func31_var_139);
                Func31_var_103 := (((#46 + WareName[Func31_var_169]) + 'ןוט ') + Func31_var_139);
                if ((Func31_var_2 + Func31_var_0) > 0) then
                begin
                  Func31_var_103 := (Func31_var_103 + ' ףסונבו');
                end;
                Write(Func31_var_103:22);
              end;
              GotoXY(18, 18);
              if InputYesNo then
              begin
                ShipCapacity := (ShipCapacity + Func31_var_173);
                Money := (Money - Func31_var_2);
                BankBalance := (BankBalance - Func31_var_0);
                for global_var_21 := 1 to 3 do
                begin
                  Cargo[global_var_21] := (Cargo[global_var_21] - Func31_var_4[global_var_21]);
                end;
                PutPic(MessageSign^, 90, 194);
                GotoXY(18, 23);
                Write('.העצוב  הבחרהה');
                WaitForKey;
                Str(Func31_var_0, Func31_var_139);
                if (Func31_var_0 > 0) then
                begin
                  if (Func31_var_2 > 0) then
                  begin
                    ShowMessage(
                      87,
                      ('ךנובשחמ וחקלנ לקש ' + Func31_var_139),
                      '.קנבב',
                      ''
                    );
                  end
                  else
                  begin
                    ShowMessage(
                      87,
                      '.קנבב ךנובשחמ חקלנ ףסכה',
                      '',
                      ''
                    );
                  end;
                end;
              end;
            end
            else
            begin
              Func31_var_22 := False;
            end;
          end;
        19..20:   begin
            if (Day < 6) then
            begin
              PutPic(CrewScreen^, 0, 199);
              GotoXY(7, 3);
              Write(Cargo[Copper]:5);
              GotoXY(7, 4);
              Write(Cargo[Olives]:5);
              GotoXY(7, 5);
              Write(Cargo[Wheat]:5);
              GotoXY(7, 6);
              Write(Money:5:0);
              Func31_var_23[1].field_0 := 54;
              Func31_var_23[1].field_2 := 177;
              Func31_var_23[1].field_4 := 198;
              Func31_var_23[1].field_6 := 183;
              Func31_var_23[2].field_0 := 78;
              Func31_var_23[2].field_2 := 186;
              Func31_var_23[2].field_4 := 198;
              Func31_var_23[2].field_6 := 192;
              repeat
              Func31_var_165 := Func17(Func31_var_23, 2);
              until (Func31_var_165 > 0);
              if (Func31_var_165 = 1) then
              begin
                Func21_var_88 := True;
                ShowMessage(
                  87,
                  '...תרחמל',
                  '.שדח תווצ םע דבוע התא',
                  ''
                );
              end
              else
              begin
                if Func25(
                  Cargo[Copper],
                  Cargo[Olives],
                  Cargo[Wheat],
                  Money
                ) then
                begin
                  ShowMessage(87, '.ךתעצה תא לביק תווצה', '', '');
                end
                else
                begin
                  ShowMessage(
                    87,
                    '.העצהל ברס תווצה',
                    'אצומ התאו םיימוי ורבע',
                    'שדח תווצ'
                  );
                  Day := (Day + 1);
                  Func21_var_88 := True;
                end;
              end;
            end
            else
            begin
              Func31_var_22 := False;
            end;
          end;
        21..22:   begin
            Func28(139, Func31_var_169, Func31_var_155);
            GotoXY(14, 24);
            if (Func31_var_155 > '0') then
            begin
              PutPic(ThievesScreen^, 0, 199);
              Write(('.לקש ' + Func31_var_155):15);
            end
            else
            begin
              Func28(142, Func31_var_169, Func31_var_155);
              if (Func31_var_155 > '0') then
              begin
                PutPic(ThievesScreen^, 0, 199);
                Write(
                  (((#46 + WareName[Func31_var_169]) + ' ןוט ') + Func31_var_155):15
                );
              end
              else
              begin
                Func31_var_22 := False;
              end;
            end;
            if Func31_var_22 then
            begin
              WaitForKey;
            end;
          end;
        23..26:   begin
            if (Cargo[Copper] > 1) then
            begin
              PutPic(SocherScreen^, 0, 199);
              Func31_var_177 := ((PriceCopperIsrael + (50 * Random(30))) - 600);
              Str(Func31_var_177, Func31_var_147);
              Str(Cargo[Copper], Func31_var_139);
              GotoXY(3, 2);
              Writeln(
                '.הרוחסל תופיחדב קוקז רחוס':34
              );
              GotoXY(3, WhereY);
              Writeln(
                'ח"ש ' + Func31_var_147 + ' ךל עיצהל ןכומ אוה':34
              );
              GotoXY(3, WhereY);
              Writeln(
                'ול רוכמת םא ,' + WareName[1] + 'לש ןוט לכל':34
              );
              GotoXY(3, WhereY);
              Writeln('.ךלש ןוטה ' + Func31_var_139 + ' תא':34);
              Writeln;
              GotoXY(3, WhereY);
              Write(
                '(ל/כ) ? ול רוכמל ןינועמ התא םאה':34
              );
              GotoXY(3, WhereY);
              if InputYesNo then
              begin
                Money := (Money + ((1.0 * Func31_var_177) * Cargo[Copper]));
                Cargo[Copper] := 0;
                GotoXY(3, (WhereY + 2));
                Write('!!! רכמנ':25);
                WaitForKey;
              end;
            end
            else
            begin
              if (Cargo[Olives] > 1) then
              begin
                PutPic(SocherScreen^, 0, 199);
                Func31_var_177 := ((PriceOlivesIsrael + (10 * Random(70))) - 300);
                Str(Func31_var_177, Func31_var_147);
                Str(Cargo[Olives], Func31_var_139);
                GotoXY(3, 2);
                Writeln(
                  '.הרוחסל תופיחדב קוקז רחוס':34
                );
                GotoXY(3, WhereY);
                Writeln(
                  'ח"ש ' + Func31_var_147 + ' ךל עיצהל ןכומ אוה':34
                );
                GotoXY(3, WhereY);
                Writeln(
                  'ול רוכמת םא ,' + WareName[2] + 'לש ןוט לכל':34
                );
                GotoXY(3, WhereY);
                Writeln('.ךלש ןוטה ' + Func31_var_139 + ' תא':34);
                Writeln;
                GotoXY(3, WhereY);
                Write(
                  '(ל/כ) ? ול רוכמל ןינועמ התא םאה':34
                );
                GotoXY(3, WhereY);
                if InputYesNo then
                begin
                  Money := (Money + ((1.0 * Func31_var_177) * Cargo[Olives]));
                  Cargo[Olives] := 0;
                  GotoXY(3, (WhereY + 2));
                  Write('!!! רכמנ':25);
                  WaitForKey;
                end;
              end
              else
              begin
                if (Cargo[Wheat] > 1) then
                begin
                  PutPic(SocherScreen^, 0, 199);
                  Func31_var_177 := ((PriceWheatIsrael + (5 * Random(14))) - 40);
                  Str(Func31_var_177, Func31_var_147);
                  Str(Cargo[Wheat], Func31_var_139);
                  GotoXY(3, 2);
                  Writeln(
                    '.הרוחסל תופיחדב קוקז רחוס':34
                  );
                  GotoXY(3, WhereY);
                  Writeln(
                    'ח"ש ' + Func31_var_147 + ' ךל עיצהל ןכומ אוה':34
                  );
                  GotoXY(3, WhereY);
                  Writeln(
                    'ול רוכמת םא ,' + WareName[3] + 'לש ןוט לכל':34
                  );
                  GotoXY(3, WhereY);
                  Writeln('.ךלש ןוטה ' + Func31_var_139 + ' תא':34);
                  Writeln;
                  GotoXY(3, WhereY);
                  Write(
                    '(ל/כ) ? ול רוכמל ןינועמ התא םאה':34
                  );
                  GotoXY(3, WhereY);
                  if InputYesNo then
                  begin
                    Money := (Money + ((1.0 * Func31_var_177) * Cargo[Wheat]));
                    Cargo[Wheat] := 0;
                    GotoXY(3, (WhereY + 2));
                    Write('!!! רכמנ':25);
                    WaitForKey;
                  end;
                end
                else
                begin
                  Func31_var_22 := False;
                end;
              end;
            end;
          end;
        27..28:   begin
            Func31_var_169 := (Random(3) + 1);
            Func31_var_177 := (5 * ((BaseWarePrice[Func31_var_169] div 10) + (Random(BaseWarePrice[Func31_var_169]) div 5)));
            Func31_var_16 := (Random((Trunc((0.75 * Money)) + 1)) + (0.25 * Money));
            Func31_var_171 := (5 * Trunc(
              (((Func31_var_16 / BaseWarePrice[Func31_var_169]) / 5) + 1)
            ));
            if ((((1.0 * Func31_var_177) * Func31_var_171) <= Money) and (Money > 0)) then
            begin
              PutPic(SocherScreen^, 0, 199);
              Str(Func31_var_177, Func31_var_147);
              Str(Func31_var_171, Func31_var_139);
              if (Func31_var_139 = '1') then
              begin
                Func31_var_139 := '';
              end;
              GotoXY(3, 2);
              Writeln(
                WareName[Func31_var_169] + ' ןוט ' + Func31_var_139 + ' ךל רוכמל ןינועמ רחוס':34
              );
              Writeln;
              GotoXY(3, WhereY);
              Writeln(
                'ןוטל לקש ' + Func31_var_147 + ' ריחמב':34
              );
              Writeln;
              GotoXY(3, WhereY);
              Write(
                '(ל/כ) ? תונקל ןינועמ התא םאה':34
              );
              GotoXY(3, WhereY);
              if InputYesNo then
              begin
                Money := (Money - (Func31_var_177 * Func31_var_171));
                case Func31_var_169 of
                  1:   begin
                      Cargo[Copper] := (Cargo[Copper] + Func31_var_171);
                    end;
                  2:   begin
                      Cargo[Olives] := (Cargo[Olives] + Func31_var_171);
                    end;
                  3:   begin
                      Cargo[Wheat] := (Cargo[Wheat] + Func31_var_171);
                    end;
                end;
                Writeln;
                Writeln('            !!! תינק':25);
                WaitForKey;
              end;
            end
            else
            begin
              Func31_var_22 := False;
            end;
          end;
        29..30:   begin
            Func31_var_167 := (10 * Trunc(((Func8 + Money) / (Random(80) + 150))));
            if (Func31_var_167 > 0) then
            begin
              ShowScrFile((BasePath + 'fishing.scr'));
              ShipDamage := (ShipDamage + Func31_var_167);
              GotoXY(20, 3);
              Write(Func31_var_167:4);
              WaitForKey;
            end
            else
            begin
              Func31_var_22 := False;
            end;
          end;
      end;
    end
    until Func31_var_22;
    LastNightEvent := Func31_var_183;
  end;

  procedure Func33;
  var
    Func33_var_8: PSgnBuffer;
    Func33_var_0: str_7;
  begin
    Str(Day, Func33_var_0);
    Func33_var_8 := LoadSgnFile(('day' + Func33_var_0));
    ShowScrFile((BasePath + 'newday.scr'));
    PutPic(Func33_var_8^, 165, 89);
    Dispose(Func33_var_8);
    WaitForKey;
  end;

  procedure Func34(
    Func34_arg_4: integer;
    Func34_arg_2: integer;
    Func34_arg_0: integer
  );
  var
    Func34_unused_96: array[1..2] of byte;
    Func34_var_94: integer;
    Func34_var_92: integer;
    Func34_var_86: real;
    Func34_var_80: real;
    Func34_var_0: arr_record_1479674575002027080_10;
  begin
    Func34_var_80 := 0;
    if (Money < Func34_arg_0) then
    begin
      ShowMessage(
        87,
        'ךל רשפאמ וניא ךפסכ',
        'תורוחס תינק',
        ''
      );
    end
    else
    begin
      case CountryNameToIndex(CurrentCountryName) of
        Turkey:   begin
            PutPic(BuyTurkeyWindow^, 1, 142);
            Func34_var_0[1].field_0 := 177;
            Func34_var_0[1].field_2 := 2;
            Func34_var_0[1].field_4 := 236;
            Func34_var_0[1].field_6 := 18;
            Func34_var_0[2].field_0 := 72;
            Func34_var_0[2].field_2 := 2;
            Func34_var_0[2].field_4 := 131;
            Func34_var_0[2].field_6 := 18;
            Func34_var_0[3].field_0 := 180;
            Func34_var_0[3].field_2 := 65;
            Func34_var_0[3].field_4 := 237;
            Func34_var_0[3].field_6 := 80;
          end;
        Israel:   begin
            PutPic(BuyIsraelWindow^, 1, 142);
            Func34_var_0[1].field_0 := 177;
            Func34_var_0[1].field_2 := 2;
            Func34_var_0[1].field_4 := 236;
            Func34_var_0[1].field_6 := 18;
            Func34_var_0[2].field_0 := 8;
            Func34_var_0[2].field_2 := 2;
            Func34_var_0[2].field_4 := 67;
            Func34_var_0[2].field_6 := 18;
            Func34_var_0[3].field_0 := 179;
            Func34_var_0[3].field_2 := 86;
            Func34_var_0[3].field_4 := 236;
            Func34_var_0[3].field_6 := 101;
          end;
        Egypt:   begin
            PutPic(BuyEgyptWindow^, 1, 142);
            Func34_var_0[1].field_0 := 177;
            Func34_var_0[1].field_2 := 2;
            Func34_var_0[1].field_4 := 236;
            Func34_var_0[1].field_6 := 18;
            Func34_var_0[2].field_0 := 177;
            Func34_var_0[2].field_2 := 33;
            Func34_var_0[2].field_4 := 236;
            Func34_var_0[2].field_6 := 49;
            Func34_var_0[3].field_0 := 179;
            Func34_var_0[3].field_2 := 86;
            Func34_var_0[3].field_4 := 236;
            Func34_var_0[3].field_6 := 101;
          end;
      end;
      Func34_var_92 := Func17(Func34_var_0, 103);
      if (Func34_var_92 > 0) then
      begin
        case Func34_var_92 of
          1:   begin
              Func34_var_94 := Func34_arg_4;
            end;
          2:   begin
              Func34_var_94 := Func34_arg_2;
            end;
          3:   begin
              Func34_var_94 := Func34_arg_0;
            end;
        end;
        if (Money < Func34_var_94) then
        begin
          ShowMessage(
            87,
            'ךל רשפאמ וניא ךפסכ',
            (WareName[Func34_var_92] + 'תונקל'),
            ''
          );
        end
        else
        begin
          repeat
          begin
            PutPic(BuySign^, 22, 138);
            GotoXY(6, 15);
            Write(Trunc((Money / Func34_var_94)));
            GotoXY(6, 17);
            Func34_var_80 := Func18(0, 0, 8);
            Func34_var_86 := ((1.0 * Func34_var_80) * Func34_var_94);
          end
          until (not Func24(Func34_var_86));
        end;
        if (Func34_var_80 > 0) then
        begin
          Money := (Money - Func34_var_86);
          Cargo[Func34_var_92] := (Cargo[Func34_var_92] + Trunc(Func34_var_80));
        end;
      end;
    end;
  end;

  procedure Func35(
    Func35_arg_4: integer;
    Func35_arg_2: integer;
    Func35_arg_0: integer
  );
  var
    Func35_unused_94: array[1..2] of byte;
    Func35_var_92: integer;
    Func35_var_86: real;
    Func35_var_80: real;
    Func35_var_0: arr_record_1479674575002027080_10;

    function Func36(Func36_arg_2: real; Func36_arg_0: integer): boolean;
    begin
      if (Func36_arg_2 > Cargo[Func36_arg_0]) then
      begin
        ShowMessage(
          87,
          'הברה ךכ-לכ ךל ןיא',
          ('רוכמל' + WareName[Func36_arg_0]),
          #7
        );
        Func36 := True;
      end
      else
      begin
        Func36 := False;
      end;
    end;

  begin
    if (((Cargo[Copper] = 0) and (Cargo[Olives] = 0)) and (Cargo[Wheat] = 0)) then
    begin
      ShowMessage(
        87,
        ' ',
        'רוכמל  הרוחס  ךל  ןיא',
        ' '
      );
    end
    else
    begin
      case CountryNameToIndex(CurrentCountryName) of
        Turkey: PutPic(SellTurkeyWindow^, 0, 142);
        Israel: PutPic(SellIsraelWindow^, 0, 142);
        Egypt: PutPic(SellEgyptWindow^, 0, 142);
      end;
      Func35_var_0[1].field_0 := 19;
      Func35_var_0[1].field_2 := 26;
      Func35_var_0[2].field_0 := 19;
      Func35_var_0[2].field_2 := 42;
      Func35_var_0[3].field_0 := 19;
      Func35_var_0[3].field_2 := 58;
      if (CurrentCountryName = 'םירצמ') then
      begin
        Func35_var_0[1].field_4 := 58;
        Func35_var_0[1].field_6 := 34;
        Func35_var_0[2].field_4 := 57;
        Func35_var_0[2].field_6 := 50;
        Func35_var_0[3].field_4 := 57;
        Func35_var_0[3].field_6 := 66;
      end
      else
      begin
        Func35_var_0[1].field_4 := 59;
        Func35_var_0[1].field_6 := 35;
        Func35_var_0[2].field_4 := 59;
        Func35_var_0[2].field_6 := 51;
        Func35_var_0[3].field_4 := 59;
        Func35_var_0[3].field_6 := 67;
      end;
      Func35_var_92 := Func17(Func35_var_0, 103);
      if (Func35_var_92 > 0) then
      begin
        if (Cargo[Func35_var_92] > 0) then
        begin
          repeat
          begin
            PutPic(SellSign^, 120, 60);
            GotoXY(21, 7);
            Func35_var_80 := Func18(0, 0, 8);
          end
          until (not Func36(Func35_var_80, Func35_var_92));
        end
        else
        begin
          ShowMessage(
            87,
            (('רוכמל' + WareName[Func35_var_92]) + 'ךל ןיא'),
            #7,
            ''
          );
          Func35_var_80 := 0;
        end;
        if (Func35_var_80 = -1) then
        begin
          Func35_var_80 := 0;
        end;
        case Func35_var_92 of
          1:   begin
              Func35_var_86 := ((1.0 * Func35_var_80) * Func35_arg_4);
            end;
          2:   begin
              Func35_var_86 := ((1.0 * Func35_var_80) * Func35_arg_2);
            end;
          3:   begin
              Func35_var_86 := ((1.0 * Func35_var_80) * Func35_arg_0);
            end;
        end;
        Money := (Money + Func35_var_86);
        Cargo[Func35_var_92] := (Cargo[Func35_var_92] - Trunc(Func35_var_80));
      end;
    end;
  end;

  procedure Func37;
  var
    Func37_var_87: integer;
    Func37_var_86: byte;
    Func37_var_6: arr_record_1479674575002027080_10;
    Func37_var_0: real;
  begin
    Func37_var_86 := 0;
    PutPic(BankWindow^, 0, 142);
    Func37_var_6[1].field_0 := 97;
    Func37_var_6[1].field_2 := 7;
    Func37_var_6[1].field_4 := 149;
    Func37_var_6[1].field_6 := 16;
    Func37_var_6[2].field_0 := 16;
    Func37_var_6[2].field_2 := 7;
    Func37_var_6[2].field_4 := 64;
    Func37_var_6[2].field_6 := 16;
    Func37_var_87 := Func17(Func37_var_6, 102);
    case Func37_var_87 of
      1:   begin
          if (Money <= 0) then
          begin
            ShowMessage(
              87,
              ' ',
              ('! דיקפהל ףסכ ךל ןיא' + ''),
              ' '
            );
          end
          else
          begin
            repeat
            begin
              PutPic(DepositSign^, 11, 139);
              GotoXY(5, 17);
              Func37_var_0 := Func18(0, 0, 8);
              if (Func37_var_0 <= 0) then
              begin
                Func37_var_86 := 1;
              end
              else
              begin
                if (Func37_var_0 <= Money) then
                begin
                  BankBalance := (BankBalance + Func37_var_0);
                  Money := (Money - Func37_var_0);
                  ShowMessage(
                    87,
                    ' ',
                    'ףסכה תא לביק קנבה דיקפ',
                    ' '
                  );
                  Func37_var_86 := 1;
                end
                else
                begin
                  ShowMessage(
                    87,
                    ' ',
                    ('! ףסכ הברה ךכ לכ ךל ןיא' + ''),
                    ' '
                  );
                end;
              end;
            end
            until (Func37_var_86 = 1);
          end;
        end;
      2:   begin
          if (BankBalance > 0) then
          begin
            repeat
            begin
              PutPic(WithdrawSign^, 11, 139);
              GotoXY(5, 17);
              Func37_var_0 := Func18(0, 0, 8);
              if (Func37_var_0 < 0) then
              begin
                Func37_var_86 := 1;
              end
              else
              begin
                if (Func37_var_0 <= BankBalance) then
                begin
                  GotoXY(1, 1);
                  BankBalance := (BankBalance - Func37_var_0);
                  Money := (Money + Func37_var_0);
                  if (not (Func37_var_0 = 0)) then
                  begin
                    ShowMessage(87, ' ', 'ףסכה תא תלביק', ' ');
                  end;
                  Func37_var_86 := 1;
                end
                else
                begin
                  ShowMessage(
                    87,
                    ' ',
                    ('! קנבב הזכ ףסכ םוכס ךל ןיא' + ''),
                    ' '
                  );
                end;
              end;
            end
            until (Func37_var_86 = 1);
          end
          else
          begin
            ShowMessage(
              87,
              ' ',
              ('! קנבב ףסכ ךל ןיא' + ''),
              ' '
            );
          end;
        end;
    end;
  end;

  function Func38(Func38_arg_0: integer): boolean;
  var
    Func38_unused_0: array[1..3] of byte;
  begin
    if (Func38_arg_0 > ShipCapacity) then
    begin
      PutPic(OverweightWindow^, 0, 142);
      GotoXY(53, 16);
      if InputYesNo then
      begin
        Func38 := False;
      end
      else
      begin
        Func38 := True;
      end;
    end
    else
    begin
      Func38 := False;
    end;
  end;

  procedure Func39(CountryName: TCountryName);
  var
    Func39_var_0: PWinBuffer;
  begin
    case CountryNameToIndex(CountryName) of
      Turkey:   begin
          Func21_var_6 := 256;
          Func21_var_4 := 303;
        end;
      Israel:   begin
          Func21_var_6 := 147;
          Func21_var_4 := 190;
        end;
      Egypt:   begin
          Func21_var_6 := 44;
          Func21_var_4 := 86;
        end;
    end;
    New(Func39_var_0);
    GetPic(
      Func39_var_0^,
      Func21_var_6,
      146,
      Func21_var_4,
      155
    );
    ColorTable(3, 2, 1, 0);
    PutPic(Func39_var_0^, Func21_var_6, 155);
    ColorTable(0, 1, 2, 3);
    Dispose(Func39_var_0);
  end;

  procedure Func40(Func40_arg_0: TCountryName);
  var
    Func40_var_173: boolean;
    Func40_var_172: boolean;
    Func40_var_170: integer;
    Func40_var_168: integer;
    Func40_unused_167: byte;
    Func40_var_87: arr_record_1479674575002027080_10;
    Func40_var_7: arr_record_1479674575002027080_10;
    Func40_var_5: integer;
    Func40_var_3: integer;
    Func40_var_1: integer;
    Func40_var_0: byte;

    procedure Func41(
      Func41_arg_8: integer;
      Func41_arg_6: integer;
      Func41_arg_4: integer;
      Func41_arg_2: integer;
      Func41_arg_0: integer
    );
    var
      Func41_var_266: integer;
      Func41_var_264: integer;
      Func41_var_135: arr_byte_129;
      Func41_unused_6: arr_byte_129;
      Func41_var_4: integer;
      Func41_var_2: integer;
      Func41_var_0: integer;
    begin
      GotoXY(34, 17);
      if (Money > 10000.0) then
      begin
        GotoXY(33, 17);
      end;
      if (Money > 100000.0) then
      begin
        GotoXY(32, 17);
      end;
      Write(ToStrWithCommas(Money):5);
      PutPic(MapWindow^, 0, 142);
      GetPic(
        Func41_var_135,
        Func41_arg_8,
        Func41_arg_6,
        (Func41_arg_8 + 18),
        (Func41_arg_6 + 14)
      );
      Func41_var_0 := 0;
      Func41_var_2 := ((Func40_var_0 - Ord(global_var_81)) * 60);
      Func41_var_266 := Func41_arg_8;
      Func41_var_264 := (Func41_arg_6 + 14);
      for Func41_var_4 := 1 to Func41_var_2 do
      begin
        Func41_var_0 := (Func41_var_0 + 1);
        if (Func41_var_0 < 60) then
        begin
          GotoXY(35, 5);
          if (Func41_var_0 < 10) then
          begin
            Write(0);
          end;
          if ((Func41_var_0 mod 15) = 0) then
          begin
            Write(Func41_var_0);
          end;
        end
        else
        begin
          Func41_var_0 := 0;
          global_var_81 := (global_var_81 + 1);
          GotoXY(32, 5);
          Write(global_var_81:2, ':00');
        end;
        Func40_var_5 := Round(
          ((0.0 + Func41_arg_8) + ((Func41_var_4 / Func41_var_2) * (Func41_arg_4 - Func41_arg_8)))
        );
        Func40_var_3 := Round(
          (((0.0 + Func41_arg_6) + ((Func41_var_4 / Func41_var_2) * (Func41_arg_2 - Func41_arg_6))) + 14)
        );
        PutPic(Func41_var_135, Func40_var_5, Func40_var_3);
        Delay(15);
        Func41_var_266 := Func40_var_5;
        Func41_var_264 := Func40_var_3;
        Func40_var_3 := (Func40_var_3 - 14);
      end;
      GetPic(MapWindow^, 0, 0, 240, 142);
    end;

    procedure Func42(
      Func42_arg_6: real;
      Func42_arg_4: integer;
      Func42_arg_2: integer;
      Func42_arg_0: integer
    );
    var
      Func42_unused_38: array[1..4] of byte;
      Func42_var_36: integer;
      Func42_var_34: integer;
      Func42_var_32: integer;
      Func42_var_24: str_7;
      Func42_var_13: TCountryName;
      Func42_var_12: byte;
      Func42_var_10: integer;
      Func42_var_8: integer;
      Func42_unused_2: array[1..6] of byte;
      Func42_var_1: boolean;
      Func42_var_0: boolean;

      procedure Func43(Func43_arg_2: integer; Func43_arg_0: integer);
      var
        Func43_var_106: integer;
        Func43_var_104: integer;
        Func43_var_102: integer;
        Func43_var_100: integer;
        Func43_var_98: integer;
        Func43_var_92: string[5];
        Func43_var_12: arr_record_1479674575002027080_10;
        Func43_var_6: real;
        Func43_var_0: real;

        procedure Func44(Func44_arg_0: integer);
        begin
          if (Random(Func44_arg_0) = 0) then
          begin
            Func43_var_0 := (10 * Trunc(
              (((Random(15) + 5) / 1000.0) * (Money + Func8))
            ));
            Str(Func43_var_0:1:0, Func43_var_92);
            ShipDamage := (ShipDamage + Func43_var_0);
            if (Func44_arg_0 = 2) then
            begin
              ShowMessage(
                87,
                'םרגנ ,ףסונב',
                'יוושב קזנ הניפסל',
                ('.םילקש ' + Func43_var_92)
              );
            end
            else
            begin
              ShowMessage(
                87,
                'ךתניפס ,ךלזמ עורל',
                '.ברקה ידכ ךות העגפנ',
                (('.ח"ש ' + Func43_var_92) + ' קזנה יווש')
              );
            end;
          end;
        end;

        procedure Func45;
        var
          Func45_var_7: integer;
          Func45_var_1: real;
          Func45_unused_0: byte;
        begin
          PutPic(ConfrontWindow^, 0, 142);
          Func45_var_7 := Random(4);
          if ((Func45_var_7 < (Func43_arg_2 - Func43_var_98)) or (((Func43_arg_2 - Func43_var_98) <= 0) and (Random(6) = 1))) then
          begin
            ShowMessage(
              87,
              '- ךשוממ ברק רחאל',
              '! םיטריפה תא תסבה',
              ''
            );
            if (Random(3) = 1) then
            begin
              ShipCapacity := (ShipCapacity + 50);
              ShowMessage(
                87,
                'תניפס תא יבשב תחקל',
                'הניפסה תלוביקו ,םיה ידדוש',
                '.ןוט 50-ב הלדג ךלש'
              );
            end
            else
            begin
              Func43_arg_2 := (Func43_arg_2 + Func43_var_98);
              Func43_var_6 := ((Int((((Money + Func8) + BankBalance) / 100)) * (Random(15) + 5)) + ((Func43_arg_2 *
        ((Money + Func8) + BankBalance)) / 10));
              if (Func43_var_6 < 100) then
              begin
                Func43_var_6 := 100;
              end;
              Func43_var_6 := (5 * Int((Func43_var_6 / 5)));
              Str(Func43_var_6:1:0, Func43_var_92);
              ShowMessage(
                87,
                ' לש ןומטמ תאצמ',
                ('םתניפס לע לקש ' + Func43_var_92),
                ''
              );
              Money := (Money + Func43_var_6);
            end;
            Func44(4);
          end
          else
          begin
            Str(Func43_arg_2, Func43_var_92);
            if (Func43_arg_2 = 0) then
            begin
              ShowMessage(
                87,
                ',רמשמ תוניפס תנגה אלל',
                'םיטריפה ידי לע תסבוה התא',
                ''
              );
            end
            else
            begin
              if (Func43_arg_2 = 1) then
              begin
                ShowMessage(
                  87,
                  'תניפס לע ורבגתה םיטריפה',
                  'ךלש רמשמה',
                  ''
                );
              end
              else
              begin
                if (Func43_arg_2 > 1) then
                begin
                  ShowMessage(
                    87,
                    'תא וחצינ םיטריפה',
                    ('ךלש רמשמה תוניפס ' + Func43_var_92),
                    ''
                  );
                end;
              end;
            end;
            Func43_arg_2 := (Func43_arg_2 + Func43_var_98);
            if (Func43_arg_2 > 3) then
            begin
              Func43_arg_2 := 3;
            end;
            Func12(5, Func42_var_36, Func45_var_1);
            if (Func45_var_1 > Money) then
            begin
              Func43_var_0 := (((1.0 * (Random(15) + 5)) * Cargo[Func42_var_36]) / 100);
              if (Func43_arg_2 < 3) then
              begin
                Func43_var_0 := (Func43_var_0 + (((3 - Func43_arg_2) * Cargo[Func42_var_36]) div 10));
              end;
              if (Func43_var_0 < 1) then
              begin
                Func43_var_0 := 1;
              end;
              Cargo[Func42_var_36] := (Cargo[Func42_var_36] - Trunc(Func43_var_0));
              Str(Trunc(Func43_var_0):1, Func42_var_24);
              ShowMessage(
                87,
                '     השק ברק ירחא',
                ' םיה ידדוש ךממ ובנג',
                ((WareName[Func42_var_36] + 'ןוט ') + Func42_var_24)
              );
              Func44(2);
            end
            else
            begin
              if (Money > 500) then
              begin
                Func43_var_0 := (10 * Trunc(
                  (Random(Trunc((0.015 * Money))) + (Money / 200))
                ));
                if (Func43_arg_2 < 3) then
                begin
                  Func43_var_0 := (Func43_var_0 + ((3 - Func43_arg_2) * Trunc((Money / 10))));
                end;
                Func43_var_0 := Trunc(Func43_var_0);
                Money := (Money - Func43_var_0);
                Str(Func43_var_0:1:0, Func42_var_24);
                ShowMessage(
                  87,
                  (('םילקש ' + Func42_var_24) + ' ךממ ובנג םה'),
                  '',
                  ''
                );
                Func44(2);
              end
              else
              begin
                Func43_var_0 := (Int(
                  ((((Random(15) + 35) - (10 * Func43_arg_2)) / 1000) * ((Func8 + Money) + BankBalance))
                ) * 10);
                if (Func43_var_0 < 100) then
                begin
                  Func43_var_0 := 100;
                end;
                Str(Func43_var_0:1:0, Func43_var_92);
                ShipDamage := (ShipDamage + Func43_var_0);
                ShowMessage(
                  87,
                  'ךתניפס ,ךלזמ עורל',
                  '.ברקה ידכ ךות העגפנ',
                  (('ח"ש ' + Func43_var_92) + ' קזנה יווש')
                );
              end;
            end;
          end;
          ShowHUD;
        end;

      begin
        PutPic(PiratesWindow^, 0, 142);
        WaitForKey;
        PutPic(PiratesSign^, 4, 139);
        GotoXY(18, 17);
        Write(Func40_var_1:2);
        Func43_var_12[1].field_0 := 108;
        Func43_var_12[1].field_2 := 117;
        Func43_var_12[1].field_4 := 133;
        Func43_var_12[1].field_6 := 123;
        Func43_var_12[2].field_0 := 72;
        Func43_var_12[2].field_2 := 117;
        Func43_var_12[2].field_4 := 96;
        Func43_var_12[2].field_6 := 123;
        Func43_var_12[3].field_0 := 7;
        Func43_var_12[3].field_2 := 117;
        Func43_var_12[3].field_4 := 58;
        Func43_var_12[3].field_6 := 123;
        Func43_var_104 := Func17(Func43_var_12, 3);
        case Func43_var_104 of
          1:   begin
              Func43_var_98 := 0;
              Func45;
            end;
          2:   begin
              Func43_var_100 := 0;
              Func43_var_98 := 1;
              PutPic(RunAwayWindow^, 0, 142);
              if (Func43_arg_0 > (0.81 * ShipCapacity)) then
              begin
                Func43_var_102 := 0;
              end
              else
              begin
                Func43_var_106 := (((ShipCapacity div 30) - (Func43_arg_0 div 30)) + 1);
                if (Func43_var_106 < 1) then
                begin
                  Func43_var_106 := 1;
                end;
                Func43_var_102 := Random(Func43_var_106);
              end;
              if (Func43_var_102 > 0) then
              begin
                Func43_var_100 := Random(((Trunc(ShipDamage) div 30) + 1));
              end;
              if (Func43_var_100 > 0) then
              begin
                Func43_var_102 := 0;
              end;
              if (Func43_var_102 = 0) then
              begin
                if (Func43_arg_0 > (0.5 * ShipCapacity)) then
                begin
                  ShowMessage(
                    87,
                    'אלו ,ידמ הדבכ ךתניפס',
                    'חורבל החילצה',
                    ''
                  );
                end
                else
                begin
                  if (ShipDamage > 0) then
                  begin
                    ShowMessage(
                      87,
                      'בקע חורבל תחלצה אל',
                      'ךתניפסבש קזנה',
                      ''
                    );
                  end
                  else
                  begin
                    ShowMessage(
                      87,
                      'החילצה הריהמה םיטריפה תניפס',
                      'ךתניפס תא גישהל',
                      ''
                    );
                  end;
                end;
                Func45;
              end
              else
              begin
                ShowMessage(87, '', '! !  םהמ  טלמהל  תחלצה', '');
              end;
            end;
          3:   begin
              Func43_var_98 := 1;
              PutPic(OfferWindow^, 0, 142);
              if Func25(
                Cargo[Copper],
                Cargo[Olives],
                Cargo[Wheat],
                Money
              ) then
              begin
                ShowMessage(
                  87,
                  'לבקל וטילחה םיה ידדוש',
                  'ךתעצה תא',
                  ''
                );
                ShowHUD;
              end
              else
              begin
                ShowMessage(
                  87,
                  'תא םיחוד םיה ידדוש',
                  '! ךתוא םיפקותו ךתעצה',
                  ''
                );
                Func45;
              end;
            end;
        end;
      end;

      function Func46(Func46_arg_0: integer): boolean;
      var
        Func46_var_0: integer;
      begin
        Func46_var_0 := 30000;
        if (Func46_arg_0 > (ShipCapacity + 70)) then
        begin
          Func46_var_0 := 1;
        end
        else
        begin
          if (Func46_arg_0 > (ShipCapacity + 60)) then
          begin
            Func46_var_0 := 2;
          end
          else
          begin
            if (Func46_arg_0 > (ShipCapacity + 40)) then
            begin
              Func46_var_0 := 3;
            end
            else
            begin
              if (Func46_arg_0 > (ShipCapacity + 20)) then
              begin
                Func46_var_0 := 4;
              end
              else
              begin
                if (Func46_arg_0 > ShipCapacity) then
                begin
                  Func46_var_0 := 6;
                end;
              end;
            end;
          end;
        end;
        if (Random(Func46_var_0) = 0) then
        begin
          Func46 := True;
        end
        else
        begin
          Func46 := False;
        end;
      end;

      function Func47(Func47_arg_2: real; Func47_arg_0: integer): boolean;
      begin
        Func47 := ((Random(
          ((1 + Trunc(((Func47_arg_2 + 399) / 400))) + (2 * Func47_arg_0))
        ) > 0) and (Random(2) = 1));
      end;

      procedure Func48;
      begin
        PutPic(ChangeWindow^, 0, 142);
        Func42_var_13 := global_var_55;
        if global_var_55 = 'לארשי' then
          global_var_55 := 'היכרות'
        else
          global_var_55 := 'לארשי';
        Delay(1500);
        ShowMessage(
          87,
          'תוקזח תוחורמ האצותכ',
          'תעגה ,טוונב תועטו',
          Func42_var_13 + 'ל םוקמב ' + global_var_55 + 'ל'
        );
        if (global_var_44 = 'םירצמ') and (global_var_55 = 'היכרות') then
        begin
          Func40_var_0 := (Func40_var_0 + 4);
        end;
      end;

    begin
      global_var_109 := False;
      Func40_var_172 := False;
      if Func47(Func42_arg_6, Func42_arg_0) then
      begin
        if (Func42_arg_6 > 0) then
        begin
          Func42_var_0 := True;
        end
        else
        begin
          Func42_var_1 := (Random(3) = 1);
        end;
        if Func42_var_0 or Func42_var_1 then
        begin
          ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
          if (StormCountryName = CurrentCountryName) or (StormCountryName = global_var_55) then
          begin
            PutPic(StormWindow^, 0, 142);
            WaitForKey;
            if Func8 > 10000 then
            begin
              Func28(142, Func42_var_36, Func42_var_24);
              ShowMessage(
                87,
                'ךתניפסמ ופטש םיהובגה םילגה',
                (((#46 + WareName[Func42_var_36]) + ' ןוט ') + Func42_var_24),
                ''
              );
              ShowHUD;
            end
            else
            begin
              Func28(144, Func42_var_36, Func42_var_24);
              ShowMessage(
                87,
                'ךתניפסל םרגנ הרעסה בקע',
                (('.ח"ש ' + Func42_var_24) + ' יוושב קזנ'),
                ''
              );
            end;
          end
          else
          begin
            Func28(144, Func42_var_36, Func42_var_24);
            if global_var_81 > 16 then
            begin
              PutPic(ShoalWindow^, 0, 142);
              ShowMessage(87, 'םיעורגה תוארה יאנת בקע', '.ןוטרש לע תילע - הלילב', '');
              ShowMessage(87, 'קזנ ךתניפסל םרגנ', '.ח"ש ' + Func42_var_24 + ' יוושב', '');
            end
            else
            begin
              PutPic(DamagedWindow^, 0, 142);
              if Func42_var_0 then
                ShowMessage(87, 'הקוזינה ךתניפסב העיסנה', Func42_var_24 + '-ב קזנה תא הרימחה', '.םיפסונ לקש')
              else
                ShowMessage(87, 'קזנ ךתניפסל םרגנ', '.ח"ש ' + Func42_var_24 + ' יוושב', '');
            end;
          end;
        end
        else
          Func48;
        global_var_109 := True;
      end;
      if ((not global_var_109) and (Func42_arg_4 > ShipCapacity)) then
      begin
        if Func46(Func42_arg_4) then
        begin
          ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
          PutPic(SinkingWindow^, 0, 142);
          WaitForKey;
          Func28(153, Func42_var_36, Func42_var_24);
          ShowMessage(
            87,
            'םיל ךילשהל תצלאנ',
            ((WareName[Func42_var_36] + 'ןוט ') + Func42_var_24),
            ''
          );
          ShowHUD;
          global_var_109 := True;
        end;
      end;
      if ((not global_var_109) and (((global_var_81 + Func42_arg_2) + (Func42_arg_2 div 2)) <= 20)) then
      begin
        if Random(12) = 0 then
        begin
          Func42_var_10 := Func40_var_5;
          Func42_var_8 := Func40_var_3;
          Func42_var_12 := CountryNameToIndex(global_var_55);
          Func41(
            Func42_var_10,
            Func42_var_8,
            global_var_264[Func42_var_12].field_0,
            global_var_264[Func42_var_12].field_2,
            9
          );
          if Random(2) = 1 then
            ShowMessage(87, 'תינמז רוגס ' + global_var_55 + ' למנ', 'דבכ לפרע בקע', '')
          else
          begin
            PutPic(StrikeWindow^, 0, 142);
            WaitForKey;
            ShowMessage(87, 'םישובישו התיבש לשב', global_var_55 + ' למנ ,הדובעב', 'רוגס ');
          end;
          ShowMessage(87, '', (global_var_44 + 'ל רוזחל ךילע'), '');
          global_var_55 := global_var_44;
          Func40_var_0 := (global_var_81 + (Func42_arg_2 div 2));
          Func41(
            global_var_264[Func42_var_12].field_0,
            global_var_264[Func42_var_12].field_2,
            Func42_var_10,
            Func42_var_8,
            9
          );
          Func40_var_0 := (global_var_81 + (Func42_arg_2 div 2));
          global_var_109 := True;
        end;
      end;
      Func42_var_34 := Random(20) + 1;
      if global_var_81 >= 16 then
        if Func42_var_34 > 15 then
          Func42_var_34 := 1;
      if not global_var_109 then
      begin
        case Func42_var_34 of
          1..6:   begin
              ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
              global_var_109 := True;
              Func43(Func40_var_1, Func42_arg_4);
            end;
          7:   begin
              Func48;
            end;
          9, 10:   begin
              ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
              PutPic(DesertedWindow^, 0, 142);
              Func42_var_36 := 0;
              repeat
              begin
                Func42_var_36 := (Func42_var_36 + 1);
                Func42_var_32 := Trunc(
                  ((((Random(25) + 11) / 100.0) * (Money + Func8)) / BaseWarePrice[Func42_var_36])
                );
                if (Func42_var_32 > 0) then
                begin
                  GotoXY(45, 16);
                  Write(WareName[Func42_var_36], ' ןוט ', Func42_var_32);
                  case Func42_var_36 of
                    Copper: Cargo[Copper] := Cargo[Copper] + Func42_var_32;
                    Olives: Cargo[Olives] := Cargo[Olives] + Func42_var_32;
                    Wheat: Cargo[Wheat] := Cargo[Wheat] + Func42_var_32;
                  end;
                  global_var_109 := True;
                end;
              end
              until (global_var_109 or (Func42_var_36 = 3));
              WaitForKey;
              ShowHUD;
            end;
          8, 11..20:   begin
              Func40_var_172 := True;
            end;
        end;
      end;
    end;

    procedure Func49;
    var
      Func49_var_3: byte;
      Func49_var_2: byte;
      Func49_var_1: byte;
      Func49_var_0: byte;

      procedure Func50(var Func50_arg_0: integer);
      var
        Func50_var_116: real;
        Line1: TMessageLine;
        Line2: TMessageLine;
        Line3: TMessageLine;
        Func50_var_0: str_7;
      begin
        PutPic(GuardsWindow^, 0, 142);
        Func50_var_116 := (5 * Trunc(((Func8 + Money) / (200 + Random(100)))));
        if (Func50_var_116 < 75) then
          Func50_var_116 := 75;
        if (Func50_arg_0 > 0) then
          Func50_var_116 := (Func50_var_116 + (Func50_var_116 / 3));
        Func50_var_116 := (5 * Int((Func50_var_116 / 5)));
        Str(Func50_var_116:1:0, Func50_var_0);
        GotoXY(1, 15);
        Line3 := '? הצור התא תוניפס המכ';
        if Func50_var_116 <= Money then
        begin
          Line2 := ('ח"ש ' + Func50_var_0);
          if (Func50_arg_0 = 0) then
            Line1 := 'רמשמ תניפס לכ ריחמ'
          else
          begin
            Line1 := 'םישרוד רמשמה תוניפס ילעב';
            if (StormCountryName = CurrentCountryName) or (StormCountryName = global_var_55) then
              Line2 := ('.רעוסה םיה לשב ,' + Line2)
            else
              Line2 := ('רבגומה ןוכיסה לשב ' + Line2);
          end;
          ShowMessage(78, Line1, Line2, Line3);
          repeat
          begin
            GotoXY(4, 17);
            Write('':4);
            GotoXY(4, 17);
            Func40_var_1 := Trunc(Func18(0, 0, 3));
          end
          until (not Func24(((1.0 * Func50_var_116) * Func40_var_1)));
        end
        else
        begin
          ShowMessage(78, 'םלשל ףסכ ךל ןיא', 'רמשמ תוניפסל', '');
          Func40_var_1 := 0;
          repeat
          LastPressedKey := GetPressedKey;
          until (LastPressedKey in [#13, #27]);
          if LastPressedKey = #27 then
            Func40_var_1 := -1;
        end;
        if (Func40_var_1 > 0) then
          Money := (Money - (Func40_var_1 * Func50_var_116));
      end;

    begin
      Func50(global_var_103);
      if (Func40_var_1 < 0) then
        global_var_55 := global_var_44
      else
      begin
        Func49_var_0 := ((Func40_var_0 - Ord(global_var_81)) div 2);
        Func40_var_0 := (Func40_var_0 - Ord(Func49_var_0));
        Func49_var_3 := CountryNameToIndex(global_var_44);
        Func49_var_2 := CountryNameToIndex(global_var_55);
        Func49_var_1 := global_var_200[Func49_var_3, Func49_var_2];
        Func41(
          global_var_264[Func49_var_3].field_0,
          global_var_264[Func49_var_3].field_2,
          global_var_264[Func49_var_1].field_0,
          global_var_264[Func49_var_1].field_2,
          9
        );
        Func40_var_0 := (global_var_81 + Func49_var_0);
        Func49_var_3 := Func49_var_1;
        Func42(
          ShipDamage,
          Func9,
          Func40_var_170,
          global_var_103
        );
        Func49_var_2 := CountryNameToIndex(global_var_55);
        Func49_var_1 := global_var_200[Func49_var_3, Func49_var_2];
        if Func49_var_1 > 0 then
        begin
          Func49_var_0 := (Func49_var_0 div 2);
          Func40_var_0 := (Func40_var_0 - Ord(Func49_var_0));
        end;
        while Func49_var_1 > 0 do
        begin
          Func41(
            global_var_264[Func49_var_3].field_0,
            global_var_264[Func49_var_3].field_2,
            global_var_264[Func49_var_1].field_0,
            global_var_264[Func49_var_1].field_2,
            9
          );
          Func40_var_0 := global_var_81 + Func49_var_0;
          Func49_var_3 := Func49_var_1;
          Func49_var_1 := global_var_200[Func49_var_3, Func49_var_2];
        end;
        Func41(
          global_var_264[Func49_var_3].field_0,
          global_var_264[Func49_var_3].field_2,
          global_var_264[Func49_var_2].field_0,
          global_var_264[Func49_var_2].field_2,
          9
        );
        if Func40_var_172 then
          ShowMessage(78, '', '! !  ם ו ל ש ב   ת ע ג ה', '');
      end;
    end;

  begin
    Func40_var_170 := 0;
    global_var_44 := CurrentCountryName;
    Func40_var_173 := False;
    global_var_103 := 0;
    PutPic(MapWindow^, 0, 142);
    Func40_var_87[1].field_0 := 144;
    Func40_var_87[1].field_2 := 2;
    Func40_var_87[1].field_4 := 182;
    Func40_var_87[1].field_6 := 9;
    Func40_var_87[2].field_0 := 228;
    Func40_var_87[2].field_2 := 106;
    Func40_var_87[2].field_4 := 237;
    Func40_var_87[2].field_6 := 137;
    Func40_var_87[3].field_0 := 75;
    Func40_var_87[3].field_2 := 134;
    Func40_var_87[3].field_4 := 111;
    Func40_var_87[3].field_6 := 141;
    global_var_21 := 1;
    for global_var_23 := 1 to 3 do
    begin
      if global_var_23 <> CountryNameToIndex(global_var_44) then
      begin
        Func40_var_7[global_var_21] := Func40_var_87[global_var_23];
        global_var_21 := (global_var_21 + 1);
      end;
    end;
    case CountryNameToIndex(CurrentCountryName) of
      Turkey: Func40_var_168 := Func17(Func40_var_7, 2) + 1;
      Israel: Func40_var_168 := Func17(Func40_var_7, 2) * 2 - 1;
      Egypt: Func40_var_168 := Func17(Func40_var_7, 2);
    end;
    if Func40_var_168 > 0 then
    begin
      global_var_55 := CountryIndexToName(Func40_var_168);
      if ((global_var_44 = 'לארשי') or (global_var_55 = 'לארשי')) then
      begin
        Func40_var_170 := 4;
      end
      else
      begin
        Func40_var_170 := 8;
      end;
      if (not Func40_var_173) and ((global_var_81 + Func40_var_170) > 20) then
      begin
        ShowMessage(87, 'תרחואמ העשה', 'עיגהל לכות אלו', 'םויה םשל');
        global_var_55 := global_var_44;
        Func40_var_173 := True;
      end;
      if (not Func40_var_173) then
      begin
        if ((global_var_81 + Func40_var_170) > 16) then
        begin
          PutPic(NightWindow^, 0, 142);
          GotoXY(4, 17);
          if (not InputYesNo) then
          begin
            Func40_var_1 := -1;
          end
          else
          begin
            Func40_var_0 := (global_var_81 + Func40_var_170);
            global_var_103 := 2;
            if ((Func40_arg_0 = CurrentCountryName) or (Func40_arg_0 = global_var_55)) then
            begin
              global_var_103 := 4;
            end;
            Func49;
          end;
        end
        else
        begin
          if ((Func40_arg_0 = CurrentCountryName) or (Func40_arg_0 = global_var_55)) then
          begin
            global_var_103 := 3;
          end;
          Func40_var_0 := (global_var_81 + Func40_var_170);
          Func49;
        end;
      end;
      if (Func40_var_1 < 0) then
      begin
        global_var_55 := global_var_44;
      end;
      CurrentCountryName := global_var_55;
      if (Func40_var_1 >= 0) then
      begin
        GotoXY(73, 1);
        Write(CurrentCountryName:6);
        Func39(global_var_44);
        Func39(CurrentCountryName);
        WaitForKey;
      end;
    end;
  end;

  procedure Func51(var Func51_arg_0: real);
  var
    Func51_var_11: integer;
    Func51_var_0: TCountryName;

    function Func52(Func52_arg_0: real): boolean;
    begin
      if (Func52_arg_0 > 0) then
      begin
        if (Func52_arg_0 > Money) then
        begin
          ShowMessage(
            87,
            '',
            'ףסכ הברה ךכ-לכ ךל ןיא',
            #7
          );
          Func52 := True;
        end
        else
        begin
          Func52 := False;
        end;
      end;
    end;

  begin
    repeat
    begin
      PutPic(RepairWindow^, 0, 142);
      GotoXY(21, 17);
      Write(Func51_arg_0:4:0);
      GotoXY(5, 17);
      Func51_var_11 := Trunc(Func18(0, 0, 5));
    end
    until (not Func52(Func51_var_11));
    if (Func51_var_11 >= 0) then
    begin
      Money := (Money - Func51_var_11);
      Func51_arg_0 := (Func51_arg_0 - Func51_var_11);
      if (Func51_arg_0 < 0) then
      begin
        Func51_arg_0 := 0;
      end;
      Str(Func51_arg_0:1:0, Func51_var_0);
      if (Func51_arg_0 = 0) then
      begin
        ShowMessage(
          87,
          '',
          'ןיטולחל הניקת תעכ הניפסה',
          ''
        );
      end
      else
      begin
        ShowMessage(
          87,
          '',
          (('ח"ש ' + Func51_var_0) + ' ךסב קזנ ראשנ'),
          ''
        );
      end;
    end;
  end;

  function Func53: boolean;
  begin
    Func53 := (ShipDamage > ((Money + BankBalance) + Func8));
  end;

begin
  GotoXY(1, 2);
  global_var_81 := 8;
  Func21_var_88 := False;
  GenerateNewPrices;
  Func33;
  if (Day = 7) then
  begin
    ShowMessage(
      87,
      '.ןורחאה רחסמה םוי והז',
      'םויה ףוסב רוכמל רוכז',
      ',ךתרוחס לכ תא'
    );
    ShowMessage(
      87,
      'רובצתש תודוקנהש ןויכמ',
      'םוכס יפ לע הנעבקת',
      '! ךדיב רתוויש ףסכה'
    );
  end;
  UpdateStorm(StormCountryName);
  Func13;
  GotoXY(1, 10);
  if (Day > 1) then
  begin
    Func31;
  end;
  if (not ((Day > 7) or Func21_var_88)) then
  begin
    PutPic(MainScreen^, 0, 199);
    GetPic(global_var_2060^, 0, 0, 240, 142);
    Func39(CurrentCountryName);
    repeat
    begin
      PutPic(global_var_2060^, 0, 142);
      ShowHUD;
      TextColor(3);
      Func21_var_8[1].field_0 := 131;
      Func21_var_8[1].field_2 := 36;
      Func21_var_8[1].field_4 := 177;
      Func21_var_8[1].field_6 := 45;
      Func21_var_8[2].field_0 := 126;
      Func21_var_8[2].field_2 := 51;
      Func21_var_8[2].field_4 := 174;
      Func21_var_8[2].field_6 := 60;
      Func21_var_8[3].field_0 := 125;
      Func21_var_8[3].field_2 := 67;
      Func21_var_8[3].field_4 := 171;
      Func21_var_8[3].field_6 := 76;
      Func21_var_8[4].field_0 := 81;
      Func21_var_8[4].field_2 := 83;
      Func21_var_8[4].field_4 := 167;
      Func21_var_8[4].field_6 := 92;
      Func21_var_8[5].field_0 := 42;
      Func21_var_8[5].field_2 := 99;
      Func21_var_8[5].field_4 := 162;
      Func21_var_8[5].field_6 := 108;
      Func21_var_8[6].field_0 := 33;
      Func21_var_8[6].field_2 := 114;
      Func21_var_8[6].field_4 := 160;
      Func21_var_8[6].field_6 := 123;
      if (ShipDamage = 0) then
        Func21_var_91 := 5
      else
      begin
        PutPic(RepairOptionPic^, 35, 123);
        Func21_var_91 := 6;
      end;
      Func21_var_89 := Func17(Func21_var_8, Func21_var_91);
      case Func21_var_89 of
        1:   begin
            if CurrentCountryName = 'לארשי' then
              Func34(PriceCopperIsrael, PriceOlivesIsrael, PriceWheatIsrael)
            else if CurrentCountryName = 'היכרות' then
              Func34(PriceCopperTurkey, PriceOlivesTurkey, PriceWheatTurkey)
            else
              Func34(PriceCopperEgypt, PriceOlivesEgypt, PriceWheatEgypt);
          end;
        2:   begin
            if CurrentCountryName = 'לארשי' then
              Func35(PriceCopperIsrael, PriceOlivesIsrael, PriceWheatIsrael);
            if CurrentCountryName = 'היכרות' then
              Func35(PriceCopperTurkey, PriceOlivesTurkey, PriceWheatTurkey);
            if CurrentCountryName = 'םירצמ' then
              Func35(PriceCopperEgypt, PriceOlivesEgypt, PriceWheatEgypt);
          end;
        3:   begin
            if global_var_81 > 16 then
              ShowMessage(87, 'עוסנל ןתינ אל', 'תרחואמ הכ העשב', '')
            else if (ShipDamage > 1000) then
              ShowMessage(87, 'וניא ךתניפסל םרגנש קזנה', '.גילפהל ךל רשפאמ', '' )
            else if not Func38(Func9) then
              Func40(StormCountryName);
          end;
        4:   begin
            if (ClosedBankDay = Day) then
              ShowMessage(87, '', 'םויה  רוגס  קנבה ', '')
            else
              Func37;
          end;
        5:   begin
            PutPic(StayWindow^, 0, 142);
            if Day = 7 then
            begin
              ShowMessage(78, ',םיתסה רחסמה עובש', 'קחשמה םויסל  ───┘  שקה', '');
            end;
            repeat
            LastPressedKey := GetPressedKey;
            until LastPressedKey in [#27, #13];
          end;
        6:   begin
            if ClosedRepairDay <> Day then
              Func51(ShipDamage)
            else
              ShowMessage(87, 'רוגס למנב םינוקיתה ףיצר', 'ןיתמהל ץלאת - םויה', 'רחמ דע');
          end;
      end;
    end
    until (Func21_var_89 = 5) and (LastPressedKey <> #27);
    if (Day < 7) and Func53 then
    begin
      Day := 7;
      ShowMessage(87, 'תא ןקתל ךתורשפאב ןיא', '-ךתניפסל םרגנש קזנה', '! !  ם י ת ס ה   ק ח ש מ ה');
    end;
  end;
end;
procedure Init;
var
  I: byte;
  J: byte;
  Line6File: file;
  CurrentDir: str_15;
begin
  GraphColorMode;
  TextColor(3);
  Palette(0);
  GraphBackground(1);
  GetDir(0, CurrentDir);
  if (CurrentDir = 'A:\') then
  begin
    BasePath := 'B:\';
  end
  else
  begin
    BasePath := '\kika\socher_b\';
  end;
  ShowScrFile((BasePath + 'mifne.scr'));
  WaitForKey;
  ShowScrFile((BasePath + 'credits.scr'));
  BaseWarePrice[Copper] := 3000;
  BaseWarePrice[Olives] := 500;
  BaseWarePrice[Wheat] := 50;
  WareName[Copper] := ' תשוחנ ';
  WareName[Olives] := ' םיתיז ';
  WareName[Wheat] := ' הטיח ';
  DayName[1] := 'ןושאר';
  DayName[2] := '  ינש';
  DayName[3] := 'ישילש';
  DayName[4] := 'יעיבר';
  DayName[5] := 'ישימח';
  DayName[6] := ' ישיש';
  DayName[7] := 'יעיבש';
  MainScreen := LoadScrFile('mainscrn');
  NewDayScreen := LoadScrFile('newday');
  HelpScreen := LoadScrFile('help');
  CrewScreen := LoadScrFile('crew');
  SocherScreen := LoadScrFile('socher');
  ExpandScreen := LoadScrFile('expand');
  ThievesScreen := LoadScrFile('thieves');
  WheatUpScreen := LoadScrFile('wheatup');
  WheatDownScreen := LoadScrFile('wheatdn');
  OlivesUpScreen := LoadScrFile('olivesup');
  OlivesDownScreen := LoadScrFile('olivesdn');
  CopperUpScreen := LoadScrFile('copperup');
  CopperDownScreen := LoadScrFile('copperdn');
  New(global_var_2060);
  StayWindow := LoadWinFile('stay');
  RepairWindow := LoadWinFile('repair');
  DesertedWindow := LoadWinFile('deserted');
  DamagedWindow := LoadWinFile('damaged');
  NightWindow := LoadWinFile('night');
  OverweightWindow := LoadWinFile('overwght');
  GuardsWindow := LoadWinFile('guards');
  PiratesWindow := LoadWinFile('pirates');
  ConfrontWindow := LoadWinFile('confront');
  RunAwayWindow := LoadWinFile('runaway');
  OfferWindow := LoadWinFile('offer');
  ChangeWindow := LoadWinFile('change');
  SinkingWindow := LoadWinFile('sinking');
  StormWindow := LoadWinFile('storm');
  ShoalWindow := LoadWinFile('sirton');
  StrikeWindow := LoadWinFile('strike');
  FogWindow := LoadWinFile('arafel');
  BankWindow := LoadWinFile('bank');
  BuyTurkeyWindow := LoadWinFile('buyturk');
  BuyIsraelWindow := LoadWinFile('buyisr');
  BuyEgyptWindow := LoadWinFile('buyegpt');
  SellTurkeyWindow := LoadWinFile('sellturk');
  SellIsraelWindow := LoadWinFile('sellisr');
  SellEgyptWindow := LoadWinFile('sellegpt');
  BuySign := LoadSgnFile('buy');
  SellSign := LoadSgnFile('sell');
  WithdrawSign := LoadSgnFile('withrow');
  DepositSign := LoadSgnFile('deposit');
  MessageSign := LoadSgnFile('message');
  PiratesSign := LoadSgnFile('pirates');
  New(RepairOptionPic);
  Assign(Line6File, 'line_6.lin');
  Reset(Line6File);
  BlockRead(Line6File, RepairOptionPic^, 3);
  Close(Line6File);
  Randomize;
  global_var_264[1].field_0 := 191;
  global_var_264[1].field_2 := 23;
  global_var_264[2].field_0 := 198;
  global_var_264[2].field_2 := 86;
  global_var_264[3].field_0 := 123;
  global_var_264[3].field_2 := 113;
  global_var_264[4].field_0 := 198;
  global_var_264[4].field_2 := 50;
  global_var_264[5].field_0 := 161;
  global_var_264[5].field_2 := 96;
  global_var_264[6].field_0 := 123;
  global_var_264[6].field_2 := 40;
  global_var_264[7].field_0 := 123;
  global_var_264[7].field_2 := 70;
  global_var_264[8].field_0 := 196;
  global_var_264[8].field_2 := 45;
  for I := 1 to 8 do
  begin
    for J := 1 to 8 do
    begin
      global_var_200[I, J] := 0;
    end;
  end;
  global_var_200[1, 2] := 4;
  global_var_200[2, 1] := 4;
  global_var_200[3, 2] := 5;
  global_var_200[2, 3] := 5;
  global_var_200[1, 3] := 6;
  global_var_200[3, 1] := 6;
  global_var_200[6, 2] := 7;
  global_var_200[5, 1] := 8;
  WaitForKey;
end;
procedure StartWeek;
begin
  ShowScrFile((BasePath + 'intro.scr'));
  MapWindow := LoadWinFile('map');
  Unused1 := 1;
  BankBalance := 0;
  ShipCapacity := 100;
  CurrentCountryName := 'לארשי';
  StormCountryName := ' ';
  ShipDamage := 0;
  ClosedRepairDay := (Random(7) + 1);
  ClosedBankDay := (Random(7) + 1);
  Cargo[Copper] := 0;
  Cargo[Olives] := 0;
  Cargo[Wheat] := 0;
  ClosedBankDay := 0;
  Money := 5000;
  LastNightEvent := 0;
  WaitForKey;
end;
procedure Func56(Func56_arg_0: real);
var
  Func56_var_312: file_record_13866380471399314824;
  Func56_var_15: arr_record_13866380471399314824_11;
  Func56_var_13: integer;
  Func56_var_11: integer;
  Func56_var_9: integer;
  Func56_var_8: byte;
  Func56_unused_0: array[1..8] of byte;
procedure Func57(var Func57_arg_2: str_20; Func57_arg_0: integer);
var
  Func57_var_26: char;
  Func57_var_24: integer;
  Func57_var_22: integer;
  Func57_var_21: boolean;
  Func57_var_0: str_20;
const
  Func57_const_50650: str_27 = 'tcdsvuzjyhlfkonibxg;p.mera,';
const
  Func57_const_50678: str_27 = 'TCDSVUZJYHLFKONIBXG:P>MERA<';
const
  Func57_const_50706: str_38 = 'אבגדהוזחטיךכלםמןנסעףפץצקרשת1234567890 ';
begin
  Func57_var_21 := False;
  Func57_var_0 := '';
  Func57_var_24 := 0;
  repeat
  begin
    Func57_var_26 := GetPressedKey;
    Func57_var_22 := ((Pos(Func57_var_26, Func57_const_50650) + Pos(Func57_var_26, Func57_const_50678)) + Pos(Func57_var_26,
 Func57_const_50706));
    if (Func57_var_22 > 0) then
    begin
      Write(Func57_const_50706[Func57_var_22], #8, #8);
      Func57_var_24 := (Func57_var_24 + 1);
      Func57_var_0 := (Func57_const_50706[Func57_var_22] + Func57_var_0);
    end
    else
    begin
      if ((Func57_var_26 = #8) and (Func57_var_24 > 0)) then
      begin
        Write('  ', #8);
        Func57_var_0 := Copy(Func57_var_0, 2, Func57_var_24);
        Func57_var_24 := (Func57_var_24 - 1);
      end
      else
      begin
        if ((Func57_var_26 = #13) and (Func57_var_24 > 0)) then
        begin
          Func57_var_21 := True;
        end;
      end;
    end;
    if (Func57_var_24 = Func57_arg_0) then
    begin
      Func57_var_21 := True;
    end;
  end
  until Func57_var_21;
  Func57_arg_2 := Func57_var_0;
end;
begin
  Func56_var_8 := 0;
  Func56_var_13 := 1;
  Func56_var_11 := 0;
  Assign(Func56_var_312, 'winners.win');
  {$I-} Reset(Func56_var_312); {$I+}
  if IOResult <> 0 then
  begin
    Rewrite(Func56_var_312);
    Close(Func56_var_312);
  end
  else
  begin
    while (not EOF(Func56_var_312)) do
    begin
      Read(Func56_var_312, Func56_var_15[Func56_var_13]);
      if (Func56_var_11 = 0) and (Func56_var_15[Func56_var_13].field_21 < Func56_arg_0) then
      begin
        Func56_var_11 := Func56_var_13;
        Func56_var_13 := (Func56_var_13 + 1);
        Func56_var_15[Func56_var_13] := Func56_var_15[(Func56_var_13 - 1)];
        Func56_var_15[Func56_var_11].field_21 := Func56_arg_0;
      end;
      Func56_var_13 := (Func56_var_13 + 1);
    end;
  end;
  Close(Func56_var_312);
  if ((Func56_var_13 <= 10) and (Func56_var_11 = 0)) then
  begin
    Func56_var_11 := Func56_var_13;
    Func56_var_13 := (Func56_var_13 + 1);
    Func56_var_15[Func56_var_13] := Func56_var_15[(Func56_var_13 - 1)];
    Func56_var_15[Func56_var_11].field_21 := Func56_arg_0;
  end;
  if (Func56_var_13 > 11) then
    Func56_var_13 := 11;
  if (Func56_var_11 <> 0) then
  begin
    ShowScrFile((BasePath + 'in_10.scr'));
    GotoXY(28, 20);
    Func57(Func56_var_15[Func56_var_11].field_0, 16);
    Rewrite(Func56_var_312);
    for Func56_var_9 := 1 to (Func56_var_13 - 1) do
    begin
      Write(Func56_var_312, Func56_var_15[Func56_var_9]);
    end;
    Close(Func56_var_312);
  end;
  ShowScrFile((BasePath + 'first_10.scr'));
  for Func56_var_9 := 1 to (Func56_var_13 - 1) do
  begin
    GotoXY(11, 3 + 2 * Func56_var_9);
    Write(Func56_var_15[Func56_var_9].field_21:6:0);
    GotoXY(20, 3 + 2 * Func56_var_9);
    Write(Func56_var_15[Func56_var_9].field_0:16);
  end;
  if Func56_var_11 = 0 then
  begin
    global_var_2248 := LoadSgnFile('score');
    PutPic(global_var_2248^, 7, 130);
    GotoXY(3, 10);
    if Func56_arg_0 > 999 then
      Write(ToStrWithCommas(Func56_arg_0):6)
    else
      Write(ToStrWithCommas(Func56_arg_0):4);
    Dispose(global_var_2248);
  end;
  WaitForKey;
end;
begin
  Init;
  repeat
  begin
    Day := 1;
    StartWeek;
    repeat
    begin
      PlayDay;
      Day := Succ(Day);
    end
    until Day > 7;
    Func56(Money + BankBalance);
    GraphColorMode;
    GraphBackground(1);
    ShowMessage(78, 'ןינועמ התא םאה', '(ל/כ) ? ףסונ קחשמב', '');
    GotoXY(7, 16);
  end
  until not InputYesNo;
end.
