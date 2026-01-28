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

function GetTotalCargoValue: real;
var
  Ware: integer;
  Total: real;
begin
  Total := 0;
  for Ware := Copper to Wheat do
    Total := Total + (1.0 * Cargo[Ware] * BaseWarePrice[Ware]);
  GetTotalCargoValue := Total;
end;

function GetTotalCargoWeight: integer;
var
  Ware: integer;
  Total: integer;
begin
  Total := 0;
  for Ware := Copper to Wheat do
    Total := Total + Cargo[Ware];
  GetTotalCargoWeight := Total;
end;

function ToStrWithCommas(Func10_arg_0: real): str_15;
var
  Func10_var_2: str_15;
  Func10_var_0: integer;

  function ZeroPad3(Func11_arg_0: real): str_15;
  begin
    Str(Func11_arg_0:1:0, Func10_var_2);
    for Func10_var_0 := 1 to 2 do
      if Length(Func10_var_2) < 3 then
        Func10_var_2 := '0' + Func10_var_2;
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

procedure ShowStormScreen;
begin
  if StormCountryName = ' ' then
    ShowScrFile((BasePath + 'goodwthr.scr'))
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
  if StormCountryName = ' ' then
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
  if ShipDamage <= 0 then
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
  if PressedKey = #68 then
  begin
    ShowHelpScreen;
    PressedKey := GetPressedKey;
  end;
  GetPressedKey := PressedKey;
end;

function CountryNameToIndex(CountryName: TCountryName): integer;
begin
  if CountryName = TurkeyName then
    CountryNameToIndex := Turkey
  else if CountryName = IsraelName then
    CountryNameToIndex := Israel
  else if CountryName = EgyptName then
    CountryNameToIndex := Egypt;
end;

function CountryIndexToName(CountryIndex: integer): TCountryName;
begin
  case CountryIndex of
    Turkey: CountryIndexToName := TurkeyName;
    Israel: CountryIndexToName := IsraelName;
    Egypt: CountryIndexToName := EgyptName;
  end;
end;

function ShowOptions(
  OptionRects: TRectArray;
  { Option count of 100 + N means flags that the option's unselected doesn't need to be restored
    when Enter is pressed, e.g., when the screen is exited afterwards }
  OptionCount: integer
): integer;
var
  SelectedOption: integer;
  SelectedOptionOriginalPic: arr_byte_800;
  PressedKey: char;
  NeedsRestoreOnEnter: boolean;
begin
  NeedsRestoreOnEnter := False;
  if OptionCount > 100 then
    OptionCount := OptionCount - 100
  else
    NeedsRestoreOnEnter := True;

  SelectedOption := 1;
  repeat
    with OptionRects[SelectedOption] do
    begin
      GetPic(SelectedOptionOriginalPic, X1, Y1, X2, Y2);
      ColorTable(3, 2, 1, 0);
      PutPic(SelectedOptionOriginalPic, X1, Y2);
      repeat
        PressedKey := GetPressedKey;
      until PressedKey in [#72, #75, #80, #77, ' ', #13, #27];
      ColorTable(0, 1, 2, 3);

      if (PressedKey <> #13) or NeedsRestoreOnEnter then
        PutPic(SelectedOptionOriginalPic, X1, Y2);

      case PressedKey of
        #72, #75: SelectedOption := SelectedOption - 1;
        ' ', #80, #77: SelectedOption := SelectedOption + 1;
        #27: SelectedOption := -1;
      end;

      if SelectedOption = 0 then
        SelectedOption := OptionCount
      else if SelectedOption = OptionCount + 1 then
        SelectedOption := 1;
    end;
  until (PressedKey = #13) or (PressedKey = #27);
  ShowOptions := SelectedOption;
end;

function InputReal(
  { Ignored if 0 }
  MinNumber: integer;
  { Ignored if 0 }
  MaxNumber: integer;
  MaxDigits: integer
): real;
var
  PressedKey: char;
  CurrentNumber: real;
  ShouldReturn: boolean;
  CurrentX: integer;
  CurrentY: integer;
  Unused: array[1..4] of byte;
  DigitCount: integer;
  Unused2: integer;
  MaxNumberString: string[5];
  MinNumberString: string[5];
begin
  CurrentX := WhereX;
  CurrentY := WhereY;
  DigitCount := 0;
  repeat
  begin
    CurrentNumber := 0;
    for DigitCount := 1 to DigitCount do
    begin
      Write(' ');
    end;
    ShouldReturn := False;
    DigitCount := 0;
    GotoXY(CurrentX, CurrentY);
    repeat
    begin
      PressedKey := GetPressedKey;
      case PressedKey of
        #68: ShowHelpScreen;
        '0': begin
          if DigitCount < MaxDigits then
          begin
            CurrentNumber := 10 * CurrentNumber + Ord(PressedKey) - 48;
            if (CurrentNumber <> 0) or (DigitCount = 0) then
              Write(PressedKey);
            DigitCount := DigitCount + 1;
          end;
        end;
        '1'..'9': begin
          if DigitCount < MaxDigits then
          begin
            CurrentNumber := 10 * CurrentNumber + Ord(PressedKey) - 48;
            Write(PressedKey);
            if CurrentNumber <> 0 then
              DigitCount := DigitCount + 1;
          end;
        end;
        #8: begin
          if DigitCount > 0 then
          begin
            CurrentNumber := Int(CurrentNumber / 10);
            Write(#8, ' ', #8);
            DigitCount := DigitCount - 1;
          end;
        end;
        #13: begin
          if DigitCount > 0 then
            ShouldReturn := True;
        end;
        #27: begin
          CurrentNumber := -1;
          ShouldReturn := True;
        end;
      end;
      if DigitCount = MaxDigits then
      begin
        Sound(700);
        Delay(50);
        NoSound;
        Delay(80);
      end;
    end
    until ShouldReturn;
    if (not ((MinNumber = 0) and (MaxNumber = 0))) and
        (((CurrentNumber >= 0) and (CurrentNumber > MaxNumber)) or
        ((CurrentNumber <= 0) and (CurrentNumber < MinNumber))) then
    begin
      GotoXY(2, 10);
      Str(MinNumber, MinNumberString);
      Str(MaxNumber, MaxNumberString);
      ShowMessage(87, '', MaxNumberString + ' -ל ' + MinNumberString + ' ןיב רפסמ סנכה אנ', #7);
      GotoXY(CurrentX, CurrentY);
      ShouldReturn := False;
    end;
  end
  until ShouldReturn;
  InputReal := CurrentNumber;
end;

{ Unused }
function InputInteger(
  MinNumber: integer;
  MaxNumber: integer;
  MaxDigits: integer
): integer;
begin
  InputInteger := Trunc(InputReal(MinNumber, MaxNumber, MaxDigits));
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
        Write('ןכ')
      else
        Write('אל');
    end;
  end
  until ((Func20_var_8 = #13) and (Func20_var_4 > 0));
  InputYesNo := Func20_var_9;
end;

procedure PlayDay;
var
  CopperPriceIsrael: integer;
  CopperPriceTurkey: integer;
  CopperPriceEgypt: integer;
  OlivesPriceIsrael: integer;
  OlivesPriceTurkey: integer;
  OlivesPriceEgypt: integer;
  WheatPriceIsrael: integer;
  WheatPriceTurkey: integer;
  WheatPriceEgypt: integer;
  MainMenuOptionCount: integer;
  Func21_var_89: integer;
  Func21_var_88: boolean;
  MainMenuOptionRects: TRectArray;
  CountryNameX1: integer;
  CountryNameX2: integer;
  Unused: array[1..4] of byte;

  procedure ShowHUD;
  begin
    GotoXY(73, 1);
    Write(CurrentCountryName:6);
    GotoXY(32, 3);
    Write(DayName[Day]);
    GotoXY(32, 5);
    Write(TimeOfDay:2);
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
    Write(CopperPriceTurkey:4);
    GotoXY(30, 23);
    Write(OlivesPriceTurkey:4);
    GotoXY(30, 25);
    Write(WheatPriceTurkey:4);
    GotoXY(16, 21);
    Write(CopperPriceIsrael:4);
    GotoXY(16, 23);
    Write(OlivesPriceIsrael:4);
    GotoXY(16, 25);
    Write(WheatPriceIsrael:4);
    GotoXY(2, 21);
    Write(CopperPriceEgypt:4);
    GotoXY(2, 23);
    Write(OlivesPriceEgypt:4);
    GotoXY(2, 25);
    Write(WheatPriceEgypt:4);
  end;

  function Func23(Func23_arg_0: byte): boolean;
  begin
    if Func23_arg_0 = 26 then
      Func23 := True
    else
      Func23 := False;
  end;

  function CannotAfford(LostAmount: real): boolean;
  begin
    if LostAmount > Money then
    begin
      ShowMessage(87, '', '!ףסכ קיפסמ ךתושרב ןיא', #7);
      CannotAfford := True;
    end
    else
      CannotAfford := False;
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
          Func25_var_28 := Trunc(InputReal(0, 0, 8));
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
          Func25_var_26 := Trunc(InputReal(0, 0, 8));
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
          Func25_var_24 := Trunc(InputReal(0, 0, 8));
        until Func25_var_24 >= 0;
      end
      until Func27(Func25_var_24, Func25_arg_4);
    end;
    if Func25_arg_0 > (GetTotalCargoValue / 10) then
    begin
      repeat
      begin
        ShowMessage(78, '?תתל ןכומ התא ףסכ המכ', '', '');
        GotoXY(20, 16);
        repeat
          Func25_var_18 := Trunc(InputReal(0, 0, 8));
        until Func25_var_18 >= 0;
      end
      until Func26(Func25_var_18, Func25_arg_0);
    end;
    Func25_var_12 := Func25_var_28 * BaseWarePrice[Copper] + Func25_var_26 * BaseWarePrice[Olives] +
        Func25_var_24 * BaseWarePrice[Wheat] + Func25_var_18;
    Func25_var_6 := (GetTotalCargoValue + Func25_arg_0) / (Random(6) + 4);
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

  { Outcome types for ApplyBadOutcome }
  const
    LoseCargo = 'מ';
    SinkingShip = 'ש';
    AddDamage = 'נ';
    LoseMoney = 'כ';

  procedure ApplyBadOutcome(
    OutcomeType: char;
    var OutWare: integer;
    var OutAmountString: str_7
  );
  var
    IsOutWareSet: boolean;
    Ware: integer;
    ExtraLostWare: integer;
    ExtraLostAmount: integer;
    LostAmount: integer;
  begin
    LostAmount := 0;
    IsOutWareSet := False;
    if OutcomeType = LoseCargo then
    begin
      for Ware := Copper to Wheat do
      begin
        if (not IsOutWareSet) and (Cargo[Ware] > 2) then
        begin
          LostAmount := Trunc((20.0 + Random(21)) / 100 * Cargo[Ware]);
          if LostAmount < 1 then
            LostAmount := 1;
          Cargo[Ware] := Cargo[Ware] - Trunc(LostAmount);
          OutWare := Ware;
          IsOutWareSet := True;
        end;
      end;
    end
    else if OutcomeType = SinkingShip then
    begin
      if GetTotalCargoWeight <= (3 * ShipCapacity) then
      begin
        ApplyBadOutcome(LoseCargo, OutWare, OutAmountString);
        Val(OutAmountString, LostAmount, Ware);
      end
      else
      begin
        OutWare := Copper;
        if Cargo[Olives] > Cargo[Copper] then
          OutWare := Olives;
        if Cargo[Wheat] > Cargo[OutWare] then
          OutWare := Wheat;
        LostAmount := GetTotalCargoWeight - 3 * ShipCapacity;
        if LostAmount >= Cargo[OutWare] then
        begin
          LostAmount := Cargo[OutWare];
          Cargo[OutWare] := 0;
        end
        else
        begin
          Cargo[OutWare] := Cargo[OutWare] - Trunc(LostAmount);
          ApplyBadOutcome(LoseCargo, ExtraLostWare, OutAmountString);
          Val(OutAmountString, ExtraLostAmount, Ware);
          if ExtraLostWare = OutWare then
            LostAmount := LostAmount + ExtraLostAmount
          else
            Cargo[ExtraLostWare] := Cargo[ExtraLostWare] + ExtraLostAmount;
        end;
      end;
    end
    else if OutcomeType = LoseMoney then
    begin
      LostAmount := 10 * Trunc(Money / (Random(40) + 40));
      Money := Money - LostAmount;
    end
    else if OutcomeType = AddDamage then
    begin
      LostAmount := 10 * Trunc((Money + GetTotalCargoValue) / (Random(30) + 50));
      if LostAmount < 100 then
        LostAmount := 100;
      ShipDamage := ShipDamage + LostAmount;
    end;
    Str(LostAmount, OutAmountString);
  end;

  procedure GenerateNewPrices;
  begin
    CopperPriceIsrael := BaseWarePrice[Copper] - 500 + Random(11) * 100;
    OlivesPriceIsrael := BaseWarePrice[Olives] - 150 + Random(7) * 50;
    WheatPriceIsrael := BaseWarePrice[Wheat] - 15 + Random(8) * 5;
    CopperPriceTurkey := BaseWarePrice[Copper] - 500 + Random(11) * 100;
    OlivesPriceTurkey := BaseWarePrice[Olives] - 150 + Random(7) * 50;
    WheatPriceTurkey := BaseWarePrice[Wheat] - 15 + Random(8) * 5;
    CopperPriceEgypt := BaseWarePrice[Copper] - 500 + Random(11) * 100;
    OlivesPriceEgypt := BaseWarePrice[Olives] - 150 + Random(7) * 50;
    WheatPriceEgypt := BaseWarePrice[Wheat] - 15 + Random(8) * 5;
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
    Func31_var_23: TRectArray;
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
        Turkey: begin
          case Ware of
            Copper: CopperPriceTurkey := NewPrice;
            Olives: OlivesPriceTurkey := NewPrice;
            Wheat: WheatPriceTurkey := NewPrice;
          end;
          GotoXY(7, 2 + 21 * (UpDownFlag - 1));
          Writeln('היכרותב' + WareName[Ware] + '' + 'ה ריחמ':27);
          GotoXY(7, 3 + 21 * (UpDownFlag - 1));
          Writeln('!!םילקש ' + NewPriceString + UpDownString:25);
        end;
        Israel: begin
          case Ware of
            Copper: CopperPriceIsrael := NewPrice;
            Olives: OlivesPriceIsrael := NewPrice;
            Wheat: WheatPriceIsrael := NewPrice;
          end;
          GotoXY(7, 2 + 21 * (UpDownFlag - 1));
          Writeln('לארשיב' + WareName[Ware] + '' + 'ה ריחמ':27);
          GotoXY(7, 3 + 21 * (UpDownFlag - 1));
          Writeln('!!םילקש ' + NewPriceString + UpDownString:25);
        end;
        Egypt: begin
          case Ware of
            Copper: CopperPriceEgypt := NewPrice;
            Olives: OlivesPriceEgypt := NewPrice;
            Wheat: WheatPriceEgypt := NewPrice;
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
            for global_var_21 := Copper to Wheat do
            begin
              Func31_var_4[global_var_21] := 0;
            end;
            Func31_var_173 := 50 * (Random(2) + 1);
            Func31_var_175 := 10 * (Random(Func31_var_173) + 2 * Func31_var_173);
            if Func31_var_175 <= Money + BankBalance + GetTotalCargoValue then
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
                Func31_var_103 := '.' + WareName[Func31_var_169] + 'ןוט ' + Func31_var_139;
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
                for global_var_21 := Copper to Wheat do
                begin
                  Cargo[global_var_21] := (Cargo[global_var_21] - Func31_var_4[global_var_21]);
                end;
                PutPic(MessageSign^, 90, 194);
                GotoXY(18, 23);
                Write('.העצוב  הבחרהה');
                WaitForKey;
                Str(Func31_var_0, Func31_var_139);
                if Func31_var_0 > 0 then
                begin
                  if Func31_var_2 > 0 then
                    ShowMessage(87, 'ךנובשחמ וחקלנ לקש ' + Func31_var_139, '.קנבב', '')
                  else
                    ShowMessage(87, '.קנבב ךנובשחמ חקלנ ףסכה', '', '');
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
              Func31_var_23[1].X1 := 54;
              Func31_var_23[1].Y1 := 177;
              Func31_var_23[1].X2 := 198;
              Func31_var_23[1].Y2 := 183;
              Func31_var_23[2].X1 := 78;
              Func31_var_23[2].Y1 := 186;
              Func31_var_23[2].X2 := 198;
              Func31_var_23[2].Y2 := 192;
              repeat
                Func31_var_165 := ShowOptions(Func31_var_23, 2);
              until Func31_var_165 > 0;
              if Func31_var_165 = 1 then
              begin
                Func21_var_88 := True;
                ShowMessage(87, '...תרחמל', '.שדח תווצ םע דבוע התא', '');
              end
              else
              begin
                if Func25(Cargo[Copper], Cargo[Olives], Cargo[Wheat], Money) then
                  ShowMessage(87, '.ךתעצה תא לביק תווצה', '', '')
                else
                begin
                  ShowMessage(87, '.העצהל ברס תווצה', 'אצומ התאו םיימוי ורבע', 'שדח תווצ');
                  Day := Day + 1;
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
            ApplyBadOutcome(LoseMoney, Func31_var_169, Func31_var_155);
            GotoXY(14, 24);
            if (Func31_var_155 > '0') then
            begin
              PutPic(ThievesScreen^, 0, 199);
              Write(('.לקש ' + Func31_var_155):15);
            end
            else
            begin
              ApplyBadOutcome(LoseCargo, Func31_var_169, Func31_var_155);
              if (Func31_var_155 > '0') then
              begin
                PutPic(ThievesScreen^, 0, 199);
                Write('.' + WareName[Func31_var_169] + ' ןוט ' + Func31_var_155:15);
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
              Func31_var_177 := ((CopperPriceIsrael + (50 * Random(30))) - 600);
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
                Func31_var_177 := ((OlivesPriceIsrael + (10 * Random(70))) - 300);
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
                  Func31_var_177 := ((WheatPriceIsrael + (5 * Random(14))) - 40);
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
                Money := Money - Func31_var_177 * Func31_var_171;
                case Func31_var_169 of
                  1: Cargo[Copper] := Cargo[Copper] + Func31_var_171;
                  2: Cargo[Olives] := Cargo[Olives] + Func31_var_171;
                  3: Cargo[Wheat] := Cargo[Wheat] + Func31_var_171;
                end;
                Writeln;
                Writeln('            !!! תינק':25);
                WaitForKey;
              end;
            end
            else
              Func31_var_22 := False;
          end;
        29..30:   begin
            Func31_var_167 := 10 * Trunc((GetTotalCargoValue + Money) / (Random(80) + 150));
            if Func31_var_167 > 0 then
            begin
              ShowScrFile(BasePath + 'fishing.scr');
              ShipDamage := ShipDamage + Func31_var_167;
              GotoXY(20, 3);
              Write(Func31_var_167:4);
              WaitForKey;
            end
            else
              Func31_var_22 := False;
          end;
      end;
    end
    until Func31_var_22;
    LastNightEvent := Func31_var_183;
  end;

  procedure ShowNewDayScreen;
  var
    DaySignBuffer: PSgnBuffer;
    DayString: string[7];
  begin
    Str(Day, DayString);
    DaySignBuffer := LoadSgnFile('day' + DayString);
    ShowScrFile(BasePath + 'newday.scr');
    PutPic(DaySignBuffer^, 165, 89);
    Dispose(DaySignBuffer);
    WaitForKey;
  end;

  procedure ShowBuyScreen(
    CopperPrice: integer;
    OlivesPrice: integer;
    WheatPrice: integer
  );
  var
    Unused: integer;
    Func34_var_94: integer;
    Func34_var_92: integer;
    Func34_var_86: real;
    Func34_var_80: real;
    Func34_var_0: TRectArray;
  begin
    Func34_var_80 := 0;
    if Money < WheatPrice then
      ShowMessage(87, 'ךל רשפאמ וניא ךפסכ', 'תורוחס תינק', '')
    else
    begin
      case CountryNameToIndex(CurrentCountryName) of
        Turkey:   begin
            PutPic(BuyTurkeyWindow^, 1, 142);
            Func34_var_0[1].X1 := 177;
            Func34_var_0[1].Y1 := 2;
            Func34_var_0[1].X2 := 236;
            Func34_var_0[1].Y2 := 18;
            Func34_var_0[2].X1 := 72;
            Func34_var_0[2].Y1 := 2;
            Func34_var_0[2].X2 := 131;
            Func34_var_0[2].Y2 := 18;
            Func34_var_0[3].X1 := 180;
            Func34_var_0[3].Y1 := 65;
            Func34_var_0[3].X2 := 237;
            Func34_var_0[3].Y2 := 80;
          end;
        Israel:   begin
            PutPic(BuyIsraelWindow^, 1, 142);
            Func34_var_0[1].X1 := 177;
            Func34_var_0[1].Y1 := 2;
            Func34_var_0[1].X2 := 236;
            Func34_var_0[1].Y2 := 18;
            Func34_var_0[2].X1 := 8;
            Func34_var_0[2].Y1 := 2;
            Func34_var_0[2].X2 := 67;
            Func34_var_0[2].Y2 := 18;
            Func34_var_0[3].X1 := 179;
            Func34_var_0[3].Y1 := 86;
            Func34_var_0[3].X2 := 236;
            Func34_var_0[3].Y2 := 101;
          end;
        Egypt:   begin
            PutPic(BuyEgyptWindow^, 1, 142);
            Func34_var_0[1].X1 := 177;
            Func34_var_0[1].Y1 := 2;
            Func34_var_0[1].X2 := 236;
            Func34_var_0[1].Y2 := 18;
            Func34_var_0[2].X1 := 177;
            Func34_var_0[2].Y1 := 33;
            Func34_var_0[2].X2 := 236;
            Func34_var_0[2].Y2 := 49;
            Func34_var_0[3].X1 := 179;
            Func34_var_0[3].Y1 := 86;
            Func34_var_0[3].X2 := 236;
            Func34_var_0[3].Y2 := 101;
          end;
      end;
      Func34_var_92 := ShowOptions(Func34_var_0, 103);
      if Func34_var_92 > 0 then
      begin
        case Func34_var_92 of
          Copper: Func34_var_94 := CopperPrice;
          Olives: Func34_var_94 := OlivesPrice;
          Wheat: Func34_var_94 := WheatPrice;
        end;
        if Money < Func34_var_94 then
          ShowMessage(87, 'ךל רשפאמ וניא ךפסכ', WareName[Func34_var_92] + 'תונקל', '')
        else
        begin
          repeat
          begin
            PutPic(BuySign^, 22, 138);
            GotoXY(6, 15);
            Write(Trunc(Money / Func34_var_94));
            GotoXY(6, 17);
            Func34_var_80 := InputReal(0, 0, 8);
            Func34_var_86 := 1.0 * Func34_var_80 * Func34_var_94;
          end
          until not CannotAfford(Func34_var_86);
        end;
        if Func34_var_80 > 0 then
        begin
          Money := Money - Func34_var_86;
          Cargo[Func34_var_92] := Cargo[Func34_var_92] + Trunc(Func34_var_80);
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
    Unused: integer;
    Func35_var_92: integer;
    Func35_var_86: real;
    Func35_var_80: real;
    Func35_var_0: TRectArray;

    function Func36(Func36_arg_2: real; Func36_arg_0: integer): boolean;
    begin
      if Func36_arg_2 > Cargo[Func36_arg_0] then
      begin
        ShowMessage(87, 'הברה ךכ-לכ ךל ןיא', 'רוכמל' + WareName[Func36_arg_0], #7);
        Func36 := True;
      end
      else
        Func36 := False;
    end;

  begin
    if (Cargo[Copper] = 0) and (Cargo[Olives] = 0) and (Cargo[Wheat] = 0) then
      ShowMessage(87, ' ', 'רוכמל  הרוחס  ךל  ןיא', ' ')
    else
    begin
      case CountryNameToIndex(CurrentCountryName) of
        Turkey: PutPic(SellTurkeyWindow^, 0, 142);
        Israel: PutPic(SellIsraelWindow^, 0, 142);
        Egypt: PutPic(SellEgyptWindow^, 0, 142);
      end;
      Func35_var_0[1].X1 := 19;
      Func35_var_0[1].Y1 := 26;
      Func35_var_0[2].X1 := 19;
      Func35_var_0[2].Y1 := 42;
      Func35_var_0[3].X1 := 19;
      Func35_var_0[3].Y1 := 58;
      if CurrentCountryName = EgyptName then
      begin
        Func35_var_0[1].X2 := 58;
        Func35_var_0[1].Y2 := 34;
        Func35_var_0[2].X2 := 57;
        Func35_var_0[2].Y2 := 50;
        Func35_var_0[3].X2 := 57;
        Func35_var_0[3].Y2 := 66;
      end
      else
      begin
        Func35_var_0[1].X2 := 59;
        Func35_var_0[1].Y2 := 35;
        Func35_var_0[2].X2 := 59;
        Func35_var_0[2].Y2 := 51;
        Func35_var_0[3].X2 := 59;
        Func35_var_0[3].Y2 := 67;
      end;
      Func35_var_92 := ShowOptions(Func35_var_0, 103);
      if Func35_var_92 > 0 then
      begin
        if Cargo[Func35_var_92] > 0 then
        begin
          repeat
          begin
            PutPic(SellSign^, 120, 60);
            GotoXY(21, 7);
            Func35_var_80 := InputReal(0, 0, 8);
          end
          until not Func36(Func35_var_80, Func35_var_92);
        end
        else
        begin
          ShowMessage(87, 'רוכמל' + WareName[Func35_var_92] + 'ךל ןיא', #7, '');
          Func35_var_80 := 0;
        end;
        if Func35_var_80 = -1 then
          Func35_var_80 := 0;

        case Func35_var_92 of
          Copper: Func35_var_86 := 1.0 * Func35_var_80 * Func35_arg_4;
          Olives: Func35_var_86 := 1.0 * Func35_var_80 * Func35_arg_2;
          Wheat: Func35_var_86 := 1.0 * Func35_var_80 * Func35_arg_0;
        end;
        Money := Money + Func35_var_86;
        Cargo[Func35_var_92] := Cargo[Func35_var_92] - Trunc(Func35_var_80);
      end;
    end;
  end;

  procedure Func37;
  var
    Func37_var_87: integer;
    Func37_var_86: byte;
    Func37_var_6: TRectArray;
    Func37_var_0: real;
  begin
    Func37_var_86 := 0;
    PutPic(BankWindow^, 0, 142);
    Func37_var_6[1].X1 := 97;
    Func37_var_6[1].Y1 := 7;
    Func37_var_6[1].X2 := 149;
    Func37_var_6[1].Y2 := 16;
    Func37_var_6[2].X1 := 16;
    Func37_var_6[2].Y1 := 7;
    Func37_var_6[2].X2 := 64;
    Func37_var_6[2].Y2 := 16;
    Func37_var_87 := ShowOptions(Func37_var_6, 102);
    case Func37_var_87 of
      1: begin
        if (Money <= 0) then
          ShowMessage(87, ' ', '! דיקפהל ףסכ ךל ןיא' + '', ' ')
        else
        begin
          repeat
          begin
            PutPic(DepositSign^, 11, 139);
            GotoXY(5, 17);
            Func37_var_0 := InputReal(0, 0, 8);
            if Func37_var_0 <= 0 then
              Func37_var_86 := 1
            else
            begin
              if Func37_var_0 <= Money then
              begin
                BankBalance := (BankBalance + Func37_var_0);
                Money := (Money - Func37_var_0);
                ShowMessage(87, ' ', 'ףסכה תא לביק קנבה דיקפ', ' ');
                Func37_var_86 := 1;
              end
              else
                ShowMessage(87, ' ', '! ףסכ הברה ךכ לכ ךל ןיא' + '', ' ');
            end;
          end
          until Func37_var_86 = 1;
        end;
      end;
      2: begin
        if BankBalance > 0 then
        begin
          repeat
          begin
            PutPic(WithdrawSign^, 11, 139);
            GotoXY(5, 17);
            Func37_var_0 := InputReal(0, 0, 8);
            if Func37_var_0 < 0 then
              Func37_var_86 := 1
            else
            begin
              if Func37_var_0 <= BankBalance then
              begin
                GotoXY(1, 1);
                BankBalance := BankBalance - Func37_var_0;
                Money := Money + Func37_var_0;
                if not (Func37_var_0 = 0) then
                  ShowMessage(87, ' ', 'ףסכה תא תלביק', ' ');
                Func37_var_86 := 1;
              end
              else
                ShowMessage(87, ' ', '! קנבב הזכ ףסכ םוכס ךל ןיא' + '', ' ');
            end;
          end
          until Func37_var_86 = 1;
        end
        else
          ShowMessage(87, ' ', '! קנבב ףסכ ךל ןיא' + '', ' ');
      end;
    end;
  end;

  function Func38(Func38_arg_0: integer): boolean;
  var
    Func38_unused_0: array[1..3] of byte;
  begin
    if Func38_arg_0 > ShipCapacity then
    begin
      PutPic(OverweightWindow^, 0, 142);
      GotoXY(53, 16);
      if InputYesNo then
        Func38 := False
      else
        Func38 := True;
    end
    else
      Func38 := False;
  end;

  procedure ToggleCountryHighlight(CountryName: TCountryName);
  var
    CountryNamePic: PWinBuffer;
  begin
    case CountryNameToIndex(CountryName) of
      Turkey: begin
        CountryNameX1 := 256;
        CountryNameX2 := 303;
      end;
      Israel: begin
        CountryNameX1 := 147;
        CountryNameX2 := 190;
      end;
      Egypt: begin
        CountryNameX1 := 44;
        CountryNameX2 := 86;
      end;
    end;
    New(CountryNamePic);
    GetPic(CountryNamePic^, CountryNameX1, 146, CountryNameX2, 155);
    ColorTable(3, 2, 1, 0);
    PutPic(CountryNamePic^, CountryNameX1, 155);
    ColorTable(0, 1, 2, 3);
    Dispose(CountryNamePic);
  end;

  procedure TravelFlow(CurrentStormCountryName: TCountryName);
  var
    ShouldAbortTravel: boolean;
    DidArriveSafely: boolean;
    TravelDuration: integer;
    ChosenDestination: integer;
    Unused: byte;
    FullTravelOptionRects: TRectArray;
    TravelOptionRects: TRectArray;
    ShipX: integer;
    ShipY: integer;
    { Negative number means travel was aborted }
    GuardShipCount: integer;
    TravelEndTime: byte;

    procedure AnimateTravel(
      FromX: integer;
      FromY: integer;
      ToX: integer;
      ToY: integer;
      Unused: integer
    );
    var
      X: integer;
      Y: integer;
      ShipPic: arr_byte_129;
      Unused2: arr_byte_129;
      I: integer;
      TotalMinutes: integer;
      Minute: integer;
    begin
      GotoXY(34, 17);
      if Money > 10000.0 then
        GotoXY(33, 17);

      if Money > 100000.0 then
        GotoXY(32, 17);

      Write(ToStrWithCommas(Money):5);
      PutPic(MapWindow^, 0, 142);
      GetPic(ShipPic, FromX, FromY, FromX + 18, FromY + 14);
      Minute := 0;
      TotalMinutes := (TravelEndTime - TimeOfDay) * 60;
      X := FromX;
      Y := FromY + 14;
      for I := 1 to TotalMinutes do
      begin
        Minute := Minute + 1;
        if Minute < 60 then
        begin
          GotoXY(35, 5);
          if Minute < 10 then
            Write(0);
          if Minute mod 15 = 0 then
            Write(Minute);
        end
        else
        begin
          Minute := 0;
          TimeOfDay := TimeOfDay + 1;
          GotoXY(32, 5);
          Write(TimeOfDay:2, ':00');
        end;
        ShipX := Round(0.0 + FromX + I / TotalMinutes * (ToX - FromX));
        ShipY := Round(0.0 + FromY + I / TotalMinutes * (ToY - FromY) + 14);
        PutPic(ShipPic, ShipX, ShipY);
        Delay(15);
        X := ShipX;
        Y := ShipY;
        ShipY := ShipY - 14;
      end;
      GetPic(MapWindow^, 0, 0, 240, 142);
    end;

    procedure DoTravelEvent(
      CurrentShipDamage: real;
      CurrentCargoWeight: integer;
      CurrentTravelDuration: integer;
      CurrentRisk: integer
    );
    var
      Unused: array[1..4] of byte;
      Ware: integer;
      RandomEvent: integer;
      FoundAmount: integer;
      LostAmountString: string[7];
      OriginalDestination: TCountryName;
      OriginalTravelDestination: byte;
      CurrentShipX: integer;
      CurrentShipY: integer;
      Unused2: real;
      IsHighRiskEventForced: boolean;
      IsShipDamaged: boolean;

      procedure PiratesFlow(Func43_arg_2: integer; Func43_arg_0: integer);
      var
        Func43_var_106: integer;
        Func43_var_104: integer;
        Func43_var_102: integer;
        Func43_var_100: integer;
        Func43_var_98: integer;
        Func43_var_92: string[5];
        Func43_var_12: TRectArray;
        Func43_var_6: real;
        Func43_var_0: real;

        procedure Func44(Func44_arg_0: integer);
        begin
          if Random(Func44_arg_0) = 0 then
          begin
            Func43_var_0 := 10 * Trunc(
              ((Random(15) + 5) / 1000.0) * (Money + GetTotalCargoValue)
            );
            Str(Func43_var_0:1:0, Func43_var_92);
            ShipDamage := ShipDamage + Func43_var_0;
            if Func44_arg_0 = 2 then
              ShowMessage(87, 'םרגנ ,ףסונב', 'יוושב קזנ הניפסל', '.םילקש ' + Func43_var_92)
            else
              ShowMessage(87, 'ךתניפס ,ךלזמ עורל', '.ברקה ידכ ךות העגפנ', '.ח"ש ' + Func43_var_92 + ' קזנה יווש');
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
          if (Func45_var_7 < (Func43_arg_2 - Func43_var_98)) or (((Func43_arg_2 - Func43_var_98) <= 0) and (Random(6) = 1)) then
          begin
            ShowMessage(87, '- ךשוממ ברק רחאל', '! םיטריפה תא תסבה', '');
            if (Random(3) = 1) then
            begin
              ShipCapacity := (ShipCapacity + 50);
              ShowMessage(87, 'תניפס תא יבשב תחקל', 'הניפסה תלוביקו ,םיה ידדוש', '.ןוט 50-ב הלדג ךלש');
            end
            else
            begin
              Func43_arg_2 := Func43_arg_2 + Func43_var_98;
              Func43_var_6 := Int((Money + GetTotalCargoValue + BankBalance) / 100) * (Random(15) + 5) +
                  Func43_arg_2 * (Money + GetTotalCargoValue + BankBalance) / 10;
              if Func43_var_6 < 100 then
                Func43_var_6 := 100;
              Func43_var_6 := 5 * Int(Func43_var_6 / 5);
              Str(Func43_var_6:1:0, Func43_var_92);
              ShowMessage(87, ' לש ןומטמ תאצמ', 'םתניפס לע לקש ' + Func43_var_92, '');
              Money := Money + Func43_var_6;
            end;
            Func44(4);
          end
          else
          begin
            Str(Func43_arg_2, Func43_var_92);
            if Func43_arg_2 = 0 then
              ShowMessage(87, ',רמשמ תוניפס תנגה אלל', 'םיטריפה ידי לע תסבוה התא', '')
            else if Func43_arg_2 = 1 then
              ShowMessage(87, 'תניפס לע ורבגתה םיטריפה', 'ךלש רמשמה', '')
            else if Func43_arg_2 > 1 then
              ShowMessage(87, 'תא וחצינ םיטריפה', 'ךלש רמשמה תוניפס ' + Func43_var_92, '');
            Func43_arg_2 := Func43_arg_2 + Func43_var_98;
            if Func43_arg_2 > 3 then
              Func43_arg_2 := 3;
            Func12(5, Ware, Func45_var_1);
            if Func45_var_1 > Money then
            begin
              Func43_var_0 := (((1.0 * (Random(15) + 5)) * Cargo[Ware]) / 100);
              if Func43_arg_2 < 3 then
                Func43_var_0 := Func43_var_0 + ((3 - Func43_arg_2) * Cargo[Ware]) div 10;
              if Func43_var_0 < 1 then
                Func43_var_0 := 1;
              Cargo[Ware] := (Cargo[Ware] - Trunc(Func43_var_0));
              Str(Trunc(Func43_var_0):1, LostAmountString);
              ShowMessage(
                87,
                '     השק ברק ירחא',
                ' םיה ידדוש ךממ ובנג',
                WareName[Ware] + 'ןוט ' + LostAmountString
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
                Str(Func43_var_0:1:0, LostAmountString);
                ShowMessage(
                  87,
                  (('םילקש ' + LostAmountString) + ' ךממ ובנג םה'),
                  '',
                  ''
                );
                Func44(2);
              end
              else
              begin
                Func43_var_0 := (Int(
                  ((((Random(15) + 35) - (10 * Func43_arg_2)) / 1000) * ((GetTotalCargoValue + Money) + BankBalance))
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
        Write(GuardShipCount:2);
        Func43_var_12[1].X1 := 108;
        Func43_var_12[1].Y1 := 117;
        Func43_var_12[1].X2 := 133;
        Func43_var_12[1].Y2 := 123;
        Func43_var_12[2].X1 := 72;
        Func43_var_12[2].Y1 := 117;
        Func43_var_12[2].X2 := 96;
        Func43_var_12[2].Y2 := 123;
        Func43_var_12[3].X1 := 7;
        Func43_var_12[3].Y1 := 117;
        Func43_var_12[3].X2 := 58;
        Func43_var_12[3].Y2 := 123;
        Func43_var_104 := ShowOptions(Func43_var_12, 3);
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

      function IsShipSinking(Func46_arg_0: integer): boolean;
      var
        SinkingChance: integer;
      begin
        SinkingChance := 30000;
        if Func46_arg_0 > ShipCapacity + 70 then
          SinkingChance := 1
        else if Func46_arg_0 > ShipCapacity + 60 then
          SinkingChance := 2
        else if Func46_arg_0 > ShipCapacity + 40 then
          SinkingChance := 3
        else if Func46_arg_0 > ShipCapacity + 20 then
          SinkingChance := 4
        else if Func46_arg_0 > ShipCapacity then
          SinkingChance := 6;
        if Random(SinkingChance) = 0 then
          IsShipSinking := True
        else
          IsShipSinking := False;
      end;

      function ShouldDoHighRiskEvent(CurrentDamage: real; CurrentRisk: integer): boolean;
      begin
        ShouldDoHighRiskEvent := (Random(1 + Trunc((CurrentDamage + 399) / 400) + 2 * CurrentRisk) > 0)
            and (Random(2) = 1);
      end;

      procedure ChangeTravelDestination;
      begin
        PutPic(ChangeWindow^, 0, 142);
        OriginalDestination := TravelDestination;
        if TravelDestination = IsraelName then
          TravelDestination := TurkeyName
        else
          TravelDestination := IsraelName;
        Delay(1500);
        ShowMessage(87, 'תוקזח תוחורמ האצותכ', 'תעגה ,טוונב תועטו', OriginalDestination + 'ל םוקמב ' + TravelDestination + 'ל');
        if (TravelStart = EgyptName) and (TravelDestination = TurkeyName) then
          TravelEndTime := TravelEndTime + 4;
      end;

    begin
      HadTravelEvent := False;
      DidArriveSafely := False;
      if ShouldDoHighRiskEvent(CurrentShipDamage, CurrentRisk) then
      begin
        if CurrentShipDamage > 0 then
          IsShipDamaged := True
        else
          IsHighRiskEventForced := Random(3) = 1;
        { IsShipDamaged might be uninitalized here. If it's a day travel, the value comes from
          TravelOptionRects and is either 182 if you're in Egypt/Israel or 237 if you're in turkey.
          If it's a night travel, the value is 0, due to reading the input in the Night yes/no
          screen, at least on DOSBox }
        if IsShipDamaged or IsHighRiskEventForced then
        begin
          ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
          if (StormCountryName = CurrentCountryName) or (StormCountryName = TravelDestination) then
          begin
            PutPic(StormWindow^, 0, 142);
            WaitForKey;
            if GetTotalCargoValue > 10000 then
            begin
              ApplyBadOutcome(LoseCargo, Ware, LostAmountString);
              ShowMessage(87, 'ךתניפסמ ופטש םיהובגה םילגה', '.' + WareName[Ware] + ' ןוט ' + LostAmountString, '');
              ShowHUD;
            end
            else
            begin
              ApplyBadOutcome(AddDamage, Ware, LostAmountString);
              ShowMessage(87, 'ךתניפסל םרגנ הרעסה בקע', '.ח"ש ' + LostAmountString + ' יוושב קזנ', '');
            end;
          end
          else
          begin
            ApplyBadOutcome(AddDamage, Ware, LostAmountString);
            if TimeOfDay > 16 then
            begin
              PutPic(ShoalWindow^, 0, 142);
              ShowMessage(87, 'םיעורגה תוארה יאנת בקע', '.ןוטרש לע תילע - הלילב', '');
              ShowMessage(87, 'קזנ ךתניפסל םרגנ', '.ח"ש ' + LostAmountString + ' יוושב', '');
            end
            else
            begin
              PutPic(DamagedWindow^, 0, 142);
              if IsShipDamaged then
                ShowMessage(87, 'הקוזינה ךתניפסב העיסנה', LostAmountString + '-ב קזנה תא הרימחה', '.םיפסונ לקש')
              else
                ShowMessage(87, 'קזנ ךתניפסל םרגנ', '.ח"ש ' + LostAmountString + ' יוושב', '');
            end;
          end;
        end
        else
          ChangeTravelDestination;
        HadTravelEvent := True;
      end;
      if (not HadTravelEvent) and (CurrentCargoWeight > ShipCapacity) then
      begin
        if IsShipSinking(CurrentCargoWeight) then
        begin
          ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
          PutPic(SinkingWindow^, 0, 142);
          WaitForKey;
          ApplyBadOutcome(SinkingShip, Ware, LostAmountString);
          ShowMessage(87, 'םיל ךילשהל תצלאנ', WareName[Ware] + 'ןוט ' + LostAmountString, '');
          ShowHUD;
          HadTravelEvent := True;
        end;
      end;
      if (not HadTravelEvent) and (((TimeOfDay + CurrentTravelDuration) + (CurrentTravelDuration div 2)) <= 20) then
      begin
        if Random(12) = 0 then
        begin
          CurrentShipX := ShipX;
          CurrentShipY := ShipY;
          OriginalTravelDestination := CountryNameToIndex(TravelDestination);
          AnimateTravel(
            CurrentShipX,
            CurrentShipY,
            MapCoordinates[OriginalTravelDestination].X,
            MapCoordinates[OriginalTravelDestination].Y,
            9
          );
          if Random(2) = 1 then
            ShowMessage(87, 'תינמז רוגס ' + TravelDestination + ' למנ', 'דבכ לפרע בקע', '')
          else
          begin
            PutPic(StrikeWindow^, 0, 142);
            WaitForKey;
            ShowMessage(87, 'םישובישו התיבש לשב', TravelDestination + ' למנ ,הדובעב', 'רוגס ');
          end;
          ShowMessage(87, '', (TravelStart + 'ל רוזחל ךילע'), '');
          TravelDestination := TravelStart;
          TravelEndTime := (TimeOfDay + (CurrentTravelDuration div 2));
          AnimateTravel(
            MapCoordinates[OriginalTravelDestination].X,
            MapCoordinates[OriginalTravelDestination].Y,
            CurrentShipX,
            CurrentShipY,
            9
          );
          TravelEndTime := (TimeOfDay + (CurrentTravelDuration div 2));
          HadTravelEvent := True;
        end;
      end;
      RandomEvent := Random(20) + 1;
      if TimeOfDay >= 16 then
        if RandomEvent > 15 then
          RandomEvent := 1;
      if not HadTravelEvent then
      begin
        case RandomEvent of
          1..6: begin
            ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
            HadTravelEvent := True;
            PiratesFlow(GuardShipCount, CurrentCargoWeight);
          end;
          7: ChangeTravelDestination;
          9, 10: begin
            ShowMessage(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
            PutPic(DesertedWindow^, 0, 142);
            Ware := 0;
            repeat
            begin
              Ware := Ware + 1;
              FoundAmount := Trunc(
                (Random(25) + 11) / 100.0 * (Money + GetTotalCargoValue) / BaseWarePrice[Ware]
              );
              if FoundAmount > 0 then
              begin
                GotoXY(45, 16);
                Write(WareName[Ware], ' ןוט ', FoundAmount);
                case Ware of
                  Copper: Cargo[Copper] := Cargo[Copper] + FoundAmount;
                  Olives: Cargo[Olives] := Cargo[Olives] + FoundAmount;
                  Wheat: Cargo[Wheat] := Cargo[Wheat] + FoundAmount;
                end;
                HadTravelEvent := True;
              end;
            end
            until HadTravelEvent or (Ware = Wheat);
            WaitForKey;
            ShowHUD;
          end;
          8, 11..20: DidArriveSafely := True;
        end;
      end;
    end;

    procedure DoTravel;
    var
      CurrentWaypoint: byte;
      DestinationIndex: byte;
      NextWaypoint: byte;
      Func49_var_0: byte;

      { Risk > 0 means 1/3 higher guard ship cost }
      procedure ShowGuardShipWindow(var CurrentRisk: integer);
      var
        GuardShipPrice: real;
        Line1: TMessageLine;
        Line2: TMessageLine;
        Line3: TMessageLine;
        PriceString: string[7];
      begin
        PutPic(GuardsWindow^, 0, 142);
        GuardShipPrice := 5 * Trunc((GetTotalCargoValue + Money) / (200 + Random(100)));
        if GuardShipPrice < 75 then
          GuardShipPrice := 75;
        if CurrentRisk > 0 then
          GuardShipPrice := GuardShipPrice + GuardShipPrice / 3;
        GuardShipPrice := 5 * Int(GuardShipPrice / 5);
        Str(GuardShipPrice:1:0, PriceString);
        GotoXY(1, 15);
        Line3 := '? הצור התא תוניפס המכ';
        if GuardShipPrice <= Money then
        begin
          Line2 := 'ח"ש ' + PriceString;
          if CurrentRisk = 0 then
            Line1 := 'רמשמ תניפס לכ ריחמ'
          else
          begin
            Line1 := 'םישרוד רמשמה תוניפס ילעב';
            if (StormCountryName = CurrentCountryName) or (StormCountryName = TravelDestination) then
              Line2 := '.רעוסה םיה לשב ,' + Line2
            else
              Line2 := 'רבגומה ןוכיסה לשב ' + Line2;
          end;
          ShowMessage(78, Line1, Line2, Line3);
          repeat
          begin
            GotoXY(4, 17);
            Write('':4);
            GotoXY(4, 17);
            GuardShipCount := Trunc(InputReal(0, 0, 3));
          end
          until not CannotAfford(1.0 * GuardShipPrice * GuardShipCount);
        end
        else
        begin
          ShowMessage(78, 'םלשל ףסכ ךל ןיא', 'רמשמ תוניפסל', '');
          GuardShipCount := 0;
          repeat
            LastPressedKey := GetPressedKey;
          until LastPressedKey in [#13, #27];
          if LastPressedKey = #27 then
            GuardShipCount := -1;
        end;
        if GuardShipCount > 0 then
          Money := Money - GuardShipCount * GuardShipPrice;
      end;

    begin
      ShowGuardShipWindow(Risk);
      if GuardShipCount < 0 then
        TravelDestination := TravelStart
      else
      begin
        Func49_var_0 := (TravelEndTime - TimeOfDay) div 2;
        TravelEndTime := TravelEndTime - Func49_var_0;
        CurrentWaypoint := CountryNameToIndex(TravelStart);
        DestinationIndex := CountryNameToIndex(TravelDestination);
        NextWaypoint := MapWaypoints[CurrentWaypoint, DestinationIndex];
        AnimateTravel(
          MapCoordinates[CurrentWaypoint].X,
          MapCoordinates[CurrentWaypoint].Y,
          MapCoordinates[NextWaypoint].X,
          MapCoordinates[NextWaypoint].Y,
          9
        );
        TravelEndTime := TimeOfDay + Func49_var_0;
        CurrentWaypoint := NextWaypoint;
        DoTravelEvent(ShipDamage, GetTotalCargoWeight, TravelDuration, Risk);
        DestinationIndex := CountryNameToIndex(TravelDestination);
        NextWaypoint := MapWaypoints[CurrentWaypoint, DestinationIndex];
        if NextWaypoint > 0 then
        begin
          Func49_var_0 := Func49_var_0 div 2;
          TravelEndTime := TravelEndTime - Ord(Func49_var_0);
        end;
        while NextWaypoint > 0 do
        begin
          AnimateTravel(
            MapCoordinates[CurrentWaypoint].X,
            MapCoordinates[CurrentWaypoint].Y,
            MapCoordinates[NextWaypoint].X,
            MapCoordinates[NextWaypoint].Y,
            9
          );
          TravelEndTime := TimeOfDay + Func49_var_0;
          CurrentWaypoint := NextWaypoint;
          NextWaypoint := MapWaypoints[CurrentWaypoint, DestinationIndex];
        end;
        AnimateTravel(
          MapCoordinates[CurrentWaypoint].X,
          MapCoordinates[CurrentWaypoint].Y,
          MapCoordinates[DestinationIndex].X,
          MapCoordinates[DestinationIndex].Y,
          9
        );
        if DidArriveSafely then
          ShowMessage(78, '', '! !  ם ו ל ש ב   ת ע ג ה', '');
      end;
    end;

  begin
    TravelDuration := 0;
    TravelStart := CurrentCountryName;
    ShouldAbortTravel := False;
    Risk := 0;
    PutPic(MapWindow^, 0, 142);
    FullTravelOptionRects[Turkey].X1 := 144;
    FullTravelOptionRects[Turkey].Y1 := 2;
    FullTravelOptionRects[Turkey].X2 := 182;
    FullTravelOptionRects[Turkey].Y2 := 9;
    FullTravelOptionRects[Israel].X1 := 228;
    FullTravelOptionRects[Israel].Y1 := 106;
    FullTravelOptionRects[Israel].X2 := 237;
    FullTravelOptionRects[Israel].Y2 := 137;
    FullTravelOptionRects[Egypt].X1 := 75;
    FullTravelOptionRects[Egypt].Y1 := 134;
    FullTravelOptionRects[Egypt].X2 := 111;
    FullTravelOptionRects[Egypt].Y2 := 141;
    global_var_21 := Turkey;
    for global_var_23 := Turkey to Egypt do
    begin
      if global_var_23 <> CountryNameToIndex(TravelStart) then
      begin
        TravelOptionRects[global_var_21] := FullTravelOptionRects[global_var_23];
        global_var_21 := global_var_21 + 1;
      end;
    end;
    case CountryNameToIndex(CurrentCountryName) of
      Turkey: ChosenDestination := ShowOptions(TravelOptionRects, 2) + 1;
      Israel: ChosenDestination := ShowOptions(TravelOptionRects, 2) * 2 - 1;
      Egypt: ChosenDestination := ShowOptions(TravelOptionRects, 2);
    end;
    if ChosenDestination > 0 then
    begin
      TravelDestination := CountryIndexToName(ChosenDestination);
      if (TravelStart = IsraelName) or (TravelDestination = IsraelName) then
        TravelDuration := 4
      else
        TravelDuration := 8;
      if (not ShouldAbortTravel) and (TimeOfDay + TravelDuration > 20) then
      begin
        ShowMessage(87, 'תרחואמ העשה', 'עיגהל לכות אלו', 'םויה םשל');
        TravelDestination := TravelStart;
        ShouldAbortTravel := True;
      end;
      if not ShouldAbortTravel then
      begin
        if TimeOfDay + TravelDuration > 16 then
        begin
          PutPic(NightWindow^, 0, 142);
          GotoXY(4, 17);
          if not InputYesNo then
            GuardShipCount := -1
          else
          begin
            TravelEndTime := TimeOfDay + TravelDuration;
            Risk := 2;
            if (CurrentStormCountryName = CurrentCountryName) or (CurrentStormCountryName = TravelDestination) then
              Risk := 4;
            DoTravel;
          end;
        end
        else
        begin
          if (CurrentStormCountryName = CurrentCountryName) or (CurrentStormCountryName = TravelDestination) then
            Risk := 3;
          TravelEndTime := TimeOfDay + TravelDuration;
          DoTravel;
        end;
      end;
      if GuardShipCount < 0 then
        TravelDestination := TravelStart;
      CurrentCountryName := TravelDestination;
      if GuardShipCount >= 0 then
      begin
        GotoXY(73, 1);
        Write(CurrentCountryName:6);
        ToggleCountryHighlight(TravelStart);
        ToggleCountryHighlight(CurrentCountryName);
        WaitForKey;
      end;
    end;
  end;

  procedure Func51(var OutShipDamage: real);
  var
    DamageToRepair: integer;
    RemainingDamageString: string[10];

    function CannotAfford(LostAmount: real): boolean;
    begin
      if LostAmount > 0 then
      begin
        if LostAmount > Money then
        begin
          ShowMessage(87, '', 'ףסכ הברה ךכ-לכ ךל ןיא', #7);
          CannotAfford := True;
        end
        else
          CannotAfford := False;
      end;
    end;

  begin
    repeat
    begin
      PutPic(RepairWindow^, 0, 142);
      GotoXY(21, 17);
      Write(OutShipDamage:4:0);
      GotoXY(5, 17);
      DamageToRepair := Trunc(InputReal(0, 0, 5));
    end
    until not CannotAfford(DamageToRepair);
    if DamageToRepair >= 0 then
    begin
      Money := Money - DamageToRepair;
      OutShipDamage := OutShipDamage - DamageToRepair;
      if OutShipDamage < 0 then
        OutShipDamage := 0;

      Str(OutShipDamage:1:0, RemainingDamageString);
      if OutShipDamage = 0 then
        ShowMessage(87, '', 'ןיטולחל הניקת תעכ הניפסה', '')
      else
        ShowMessage(87, '', 'ח"ש ' + RemainingDamageString + ' ךסב קזנ ראשנ', '');
    end;
  end;

  function Func53: boolean;
  begin
    Func53 := ShipDamage > (Money + BankBalance + GetTotalCargoValue);
  end;

const
  Buy = 1;
  Sell = 2;
  Travel = 3;
  Bank = 4;
  Stay = 5;
  Repair = 6;
begin
  GotoXY(1, 2);
  TimeOfDay := 8;
  Func21_var_88 := False;
  GenerateNewPrices;
  ShowNewDayScreen;
  if Day = 7 then
  begin
    ShowMessage(87, '.ןורחאה רחסמה םוי והז', 'םויה ףוסב רוכמל רוכז', ',ךתרוחס לכ תא');
    ShowMessage(87, 'רובצתש תודוקנהש ןויכמ', 'םוכס יפ לע הנעבקת', '! ךדיב רתוויש ףסכה');
  end;
  UpdateStorm(StormCountryName);
  ShowStormScreen;
  GotoXY(1, 10);
  if Day > 1 then
    Func31;
  if not ((Day > 7) or Func21_var_88) then
  begin
    PutPic(MainScreen^, 0, 199);
    GetPic(global_var_2060^, 0, 0, 240, 142);
    ToggleCountryHighlight(CurrentCountryName);
    repeat
    begin
      PutPic(global_var_2060^, 0, 142);
      ShowHUD;
      TextColor(3);
      MainMenuOptionRects[Buy].X1 := 131;
      MainMenuOptionRects[Buy].Y1 := 36;
      MainMenuOptionRects[Buy].X2 := 177;
      MainMenuOptionRects[Buy].Y2 := 45;
      MainMenuOptionRects[Sell].X1 := 126;
      MainMenuOptionRects[Sell].Y1 := 51;
      MainMenuOptionRects[Sell].X2 := 174;
      MainMenuOptionRects[Sell].Y2 := 60;
      MainMenuOptionRects[Travel].X1 := 125;
      MainMenuOptionRects[Travel].Y1 := 67;
      MainMenuOptionRects[Travel].X2 := 171;
      MainMenuOptionRects[Travel].Y2 := 76;
      MainMenuOptionRects[Bank].X1 := 81;
      MainMenuOptionRects[Bank].Y1 := 83;
      MainMenuOptionRects[Bank].X2 := 167;
      MainMenuOptionRects[Bank].Y2 := 92;
      MainMenuOptionRects[Stay].X1 := 42;
      MainMenuOptionRects[Stay].Y1 := 99;
      MainMenuOptionRects[Stay].X2 := 162;
      MainMenuOptionRects[Stay].Y2 := 108;
      MainMenuOptionRects[Repair].X1 := 33;
      MainMenuOptionRects[Repair].Y1 := 114;
      MainMenuOptionRects[Repair].X2 := 160;
      MainMenuOptionRects[Repair].Y2 := 123;
      if ShipDamage = 0 then
        MainMenuOptionCount := 5
      else
      begin
        PutPic(RepairOptionPic^, 35, 123);
        MainMenuOptionCount := 6;
      end;
      Func21_var_89 := ShowOptions(MainMenuOptionRects, MainMenuOptionCount);
      case Func21_var_89 of
        Buy: begin
          if CurrentCountryName = IsraelName then
            ShowBuyScreen(CopperPriceIsrael, OlivesPriceIsrael, WheatPriceIsrael)
          else if CurrentCountryName = TurkeyName then
            ShowBuyScreen(CopperPriceTurkey, OlivesPriceTurkey, WheatPriceTurkey)
          else
            ShowBuyScreen(CopperPriceEgypt, OlivesPriceEgypt, WheatPriceEgypt);
        end;
        Sell: begin
          if CurrentCountryName = IsraelName then
            Func35(CopperPriceIsrael, OlivesPriceIsrael, WheatPriceIsrael);
          if CurrentCountryName = TurkeyName then
            Func35(CopperPriceTurkey, OlivesPriceTurkey, WheatPriceTurkey);
          if CurrentCountryName = EgyptName then
            Func35(CopperPriceEgypt, OlivesPriceEgypt, WheatPriceEgypt);
        end;
        Travel: begin
          if TimeOfDay > 16 then
            ShowMessage(87, 'עוסנל ןתינ אל', 'תרחואמ הכ העשב', '')
          else if (ShipDamage > 1000) then
            ShowMessage(87, 'וניא ךתניפסל םרגנש קזנה', '.גילפהל ךל רשפאמ', '' )
          else if not Func38(GetTotalCargoWeight) then
            TravelFlow(StormCountryName);
        end;
        Bank: begin
          if (ClosedBankDay = Day) then
            ShowMessage(87, '', 'םויה  רוגס  קנבה ', '')
          else
            Func37;
        end;
        Stay: begin
          PutPic(StayWindow^, 0, 142);
          if Day = 7 then
            ShowMessage(78, ',םיתסה רחסמה עובש', 'קחשמה םויסל  ───┘  שקה', '');
          repeat
            LastPressedKey := GetPressedKey;
          until LastPressedKey in [#27, #13];
        end;
        Repair: begin
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
  MapCoordinates[1].X := 191;
  MapCoordinates[1].Y := 23;
  MapCoordinates[2].X := 198;
  MapCoordinates[2].Y := 86;
  MapCoordinates[3].X := 123;
  MapCoordinates[3].Y := 113;
  MapCoordinates[4].X := 198;
  MapCoordinates[4].Y := 50;
  MapCoordinates[5].X := 161;
  MapCoordinates[5].Y := 96;
  MapCoordinates[6].X := 123;
  MapCoordinates[6].Y := 40;
  MapCoordinates[7].X := 123;
  MapCoordinates[7].Y := 70;
  MapCoordinates[8].X := 196;
  MapCoordinates[8].Y := 45;
  for I := 1 to 8 do
  begin
    for J := 1 to 8 do
    begin
      MapWaypoints[I, J] := 0;
    end;
  end;
  MapWaypoints[1, 2] := 4;
  MapWaypoints[2, 1] := 4;
  MapWaypoints[3, 2] := 5;
  MapWaypoints[2, 3] := 5;
  MapWaypoints[1, 3] := 6;
  MapWaypoints[3, 1] := 6;
  MapWaypoints[6, 2] := 7;
  MapWaypoints[5, 1] := 8;
  WaitForKey;
end;
procedure StartWeek;
begin
  ShowScrFile((BasePath + 'intro.scr'));
  MapWindow := LoadWinFile('map');
  Unused1 := 1;
  BankBalance := 0;
  ShipCapacity := 100;
  CurrentCountryName := IsraelName;
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
