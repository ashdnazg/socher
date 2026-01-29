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
  WaitForKeyFlag: byte;
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
  if (WaitForKeyFlag = 87) or (WaitForKeyFlag = 82) then
  begin
    WaitForKey;
    PutPic(PreMessageBackground, 10, 138);
  end;
end;

procedure ShowScrFile(Path: TPath);
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

function LoadWinFile(FileName: TPath): PWinBuffer;
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

function LoadSgnFile(FileName: TPath): PSgnBuffer;
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

function LoadScrFile(FileName: TPath): PScrBuffer;
var
  ScrFile: file;
  Contents: PScrBuffer;
begin
  Assign(ScrFile, BasePath + FileName + '.scr');
  {$I-} Reset(ScrFile); {$I+}
  if IOResult <> 0 then
    Writeln('םיק וניא ', BasePath, FileName, '.scr ץבק')
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

function ToStrWithCommas(Number: real): TMoneyString;
var
  NumberString: TMoneyString;
  I: integer;

  function ZeroPad3(NumberSegment: real): TMoneyString;
  begin
    Str(NumberSegment:1:0, NumberString);
    for I := 1 to 2 do
      if Length(NumberString) < 3 then
        NumberString := '0' + NumberString;
    ZeroPad3 := NumberString;
  end;

begin
  if Number <= 999 then
  begin
    Str(Number:1:0, NumberString);
    ToStrWithCommas := NumberString;
  end
  else
  begin
    ToStrWithCommas := ToStrWithCommas(Int(Number / 1000)) + ',' + ZeroPad3(1000 * Frac(Number / 1000));
  end;
end;

procedure GetMostValuableCargo(
  MinCargo: integer;
  var OutWare: integer;
  var OutValue: real
);
var
  Ware: integer;
begin
  OutWare := 0;
  OutValue := 0;
  for Ware := Copper to Wheat do
  begin
    if (1.0 * Cargo[Ware] * BaseWarePrice[Ware] > OutValue) and
        (Cargo[Ware] >= MinCargo) then
    begin
      OutWare := Ware;
      OutValue := 1.0 * Cargo[Ware] * BaseWarePrice[Ware];
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
  SelectedOptionOriginalPic: array[1..800] of byte;
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
      Write(' ');
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
  Ret: boolean;
  PressedKey: char;
  I: integer;
  InputLength: integer;
  X: integer;
  Y: integer;
begin
  X := WhereX;
  Y := WhereY;
  InputLength := 0;
  repeat
  begin
    GotoXY(X, Y);
    PressedKey := GetPressedKey;
    case PressedKey of
      'כ', 'f', 'F': begin
        Ret := True;
        InputLength := InputLength + 1;
      end;
      'ל', 'k', 'K': begin
        Ret := False;
        InputLength := InputLength + 1;
      end;
      #27, ' ': Ret := not Ret;
      else begin
        if PressedKey <> #13 then
        begin
          for I := 1 to 2 do
          begin
            Sound(700);
            Delay(50);
            NoSound;
            Delay(80);
          end;
        end;
      end
    end;
    if InputLength > 0 then
    begin
      if Ret then
        Write('ןכ')
      else
        Write('אל');
    end;
  end
  until (PressedKey = #13) and (InputLength > 0);
  InputYesNo := Ret;
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
  ChosenMainMenuOption: integer;
  ShouldSkipDay: boolean;
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

  function UnusedFunction(Input: byte): boolean;
  begin
    if Input = 26 then
      UnusedFunction := True
    else
      UnusedFunction := False;
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

  function OfferFlow(
    var InOutCopper: integer;
    var InOutOlives: integer;
    var InOutWheat: integer;
    var InOutMoney: real
  ): boolean;
  var
    OfferedCopper: integer;
    OfferedOlives: integer;
    OfferedWheat: integer;
    OfferedAmount: real;
    TotalOfferValue: real;
    AcceptThreshold: real;
    Unused: real;

    function CanAffordMoney(OfferedAmount: real; AvailableMoney: real): boolean;
    begin
      if OfferedAmount < 0 then
        OfferedAmount := 0;
      if OfferedAmount <= AvailableMoney then
        CanAffordMoney := True
      else
      begin
        ShowMessage(87, '', '!הז םוכס ךתושרב ןיא', #7);
        CanAffordMoney := False;
      end;
    end;

    function CanAffordWare(var OfferedAmount: integer; AvailableCargo: real): boolean;
    begin
      if OfferedAmount < 0 then
        OfferedAmount := 0;

      if OfferedAmount <= AvailableCargo then
        CanAffordWare := True
      else
      begin
        ShowMessage(87, '', '!הז םוכס ךתושרב ןיא', #7);
        CanAffordWare := False;
      end;
    end;

  begin
    OfferedCopper := 0;
    OfferedOlives := 0;
    OfferedWheat := 0;
    OfferedAmount := 0;
    if InOutCopper > 0 then
    begin
      repeat
      begin
        ShowMessage(78,'?תתל ןכומ התא' + WareName[Copper] + 'ןוט המכ', '', '');
        GotoXY(20, 16);
        repeat
          OfferedCopper := Trunc(InputReal(0, 0, 8));
        until OfferedCopper >= 0;
      end
      until (OfferedCopper >= 0) and CanAffordWare(OfferedCopper, InOutCopper);
    end;
    if InOutOlives > 0 then
    begin
      repeat
      begin
        ShowMessage(78,'?תתל ןכומ התא' + WareName[Olives] + 'ןוט המכ', '', '');
        GotoXY(20, 16);
        repeat
          OfferedOlives := Trunc(InputReal(0, 0, 8));
        until OfferedOlives >= 0;
      end
      until CanAffordWare(OfferedOlives, InOutOlives);
    end;
    if InOutWheat > 0 then
    begin
      repeat
      begin
        ShowMessage(78, (('?תתל ןכומ התא' + WareName[Wheat]) + 'ןוט המכ'), '', '');
        GotoXY(20, 16);
        repeat
          OfferedWheat := Trunc(InputReal(0, 0, 8));
        until OfferedWheat >= 0;
      end
      until CanAffordWare(OfferedWheat, InOutWheat);
    end;
    if InOutMoney > (GetTotalCargoValue / 10) then
    begin
      repeat
      begin
        ShowMessage(78, '?תתל ןכומ התא ףסכ המכ', '', '');
        GotoXY(20, 16);
        repeat
          OfferedAmount := Trunc(InputReal(0, 0, 8));
        until OfferedAmount >= 0;
      end
      until CanAffordMoney(OfferedAmount, InOutMoney);
    end;
    TotalOfferValue := OfferedCopper * BaseWarePrice[Copper] + OfferedOlives * BaseWarePrice[Olives] +
        OfferedWheat * BaseWarePrice[Wheat] + OfferedAmount;
    AcceptThreshold := (GetTotalCargoValue + InOutMoney) / (Random(6) + 4);
    if TotalOfferValue > AcceptThreshold then
    begin
      InOutMoney := InOutMoney - OfferedAmount;
      InOutCopper := InOutCopper - OfferedCopper;
      InOutOlives := InOutOlives - OfferedOlives;
      InOutWheat := InOutWheat - OfferedWheat;
      OfferFlow := True;
    end
    else
      OfferFlow := False;
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
    var OutAmountString: TNumberString
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

  procedure DoDayStartEvent;
  var
    RandomEvent: integer;
    SpecialPriceCountry: integer;
    SpecialPrice: integer;
    MerchantPrice: integer;
    ExpandPrice: integer;
    ExpandAmount: integer;
    MerchantSupply: integer;
    Ware: integer;
    FishingBoatDamage: integer;
    ChosenCrewOption: integer;
    ExpandWareCost: integer;
    LostAmountString: TNumberString;
    MerchantPriceString: TNumberString;
    StringBuffer: TNumberString;
    ExpandWareCostString: TMessageLine;
    CrewOptionRects: TRectArray;
    DidEventHappen: boolean;
    MerchantSupplyBaseValue: real;
    MostValuableCargoValue: real;
    ExpandWareCosts: array[1..3] of integer;
    ExpandMoneyCost: integer;
    ExpandBankBalanceCost: integer;

    const
      PriceUp = 1;
      PriceDown = 2;

    procedure UpdateSpecialPrices(
      UpDownFlag: integer;
      Country: integer;
      NewPrice: integer;
      Ware: integer
    );
    var
      UpDownString: string[6];
      NewPriceString: TNumberString;
    begin
      if UpDownFlag = PriceUp then
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
      DidEventHappen := True;
      repeat
        RandomEvent := (Random(30) + 1);
      until (RandomEvent <> LastNightEvent) and (not ((RandomEvent in [1..2]) and (LastNightEvent in [1..2])))
          and (not ((RandomEvent in [3..4]) and (LastNightEvent in [3..4])))
          and (not ((RandomEvent in [5..6]) and (LastNightEvent in [5..6])))
          and (not ((RandomEvent in [7..8]) and (LastNightEvent in [7..8])))
          and (not ((RandomEvent in [9..10]) and (LastNightEvent in [9..10])))
          and (not ((RandomEvent in [11..12]) and (LastNightEvent in [11..12])))
          and (not ((RandomEvent in [13..18]) and (LastNightEvent in [13..18])))
          and (not ((RandomEvent in [19..20]) and (LastNightEvent in [19..20])))
          and (not ((RandomEvent in [21..22]) and (LastNightEvent in [21..22])))
          and (not ((RandomEvent in [23..26]) and (LastNightEvent in [23..26])))
          and (not ((RandomEvent in [27..28]) and (LastNightEvent in [27..28])))
          and (not ((RandomEvent in [29..30]) and (LastNightEvent in [29..30])));
      if (Money > 20000.0) and (Random(6) = 1) then
        RandomEvent := 15;

      if (Money > 45000.0) and (Random(6) = 1) then
        RandomEvent := 15;

      case RandomEvent of
        1..2: begin
          PutPic(CopperUpScreen^, 0, 199);
          SpecialPriceCountry := Random(3) + 1;
          SpecialPrice := BaseWarePrice[Copper] + 1100 + 100 * Random(5);
          UpdateSpecialPrices(PriceUp, SpecialPriceCountry, SpecialPrice, Copper);
        end;
        3..4: begin
          PutPic(OlivesUpScreen^, 0, 199);
          SpecialPriceCountry := Random(3) + 1;
          SpecialPrice := BaseWarePrice[Olives] + 200 + 50 * Random(4);
          UpdateSpecialPrices(PriceUp, SpecialPriceCountry, SpecialPrice, Olives);
        end;
        5..6: begin
          PutPic(WheatUpScreen^, 0, 199);
          SpecialPriceCountry := Random(3) + 1;
          SpecialPrice := BaseWarePrice[Wheat] + 20 + Random(5) * 5;
          UpdateSpecialPrices(PriceUp, SpecialPriceCountry, SpecialPrice, Wheat);
        end;
        7..8: begin
          PutPic(CopperDownScreen^, 0, 199);
          SpecialPriceCountry := Random(3) + 1;
          SpecialPrice := BaseWarePrice[Copper] - 1100 - 100 * Random(5);
          UpdateSpecialPrices(PriceDown, SpecialPriceCountry, SpecialPrice, Copper);
        end;
        9..10: begin
          PutPic(OlivesDownScreen^, 0, 199);
          SpecialPriceCountry := Random(3) + 1;
          SpecialPrice := BaseWarePrice[Olives] - 150 - Random(3) * 50;
          UpdateSpecialPrices(PriceDown, SpecialPriceCountry, SpecialPrice, Olives);
        end;
        11..12: begin
          PutPic(WheatDownScreen^, 0, 199);
          SpecialPriceCountry := Random(3) + 1;
          SpecialPrice := BaseWarePrice[Wheat] - 15 - Random(3) * 5;
          UpdateSpecialPrices(PriceDown, SpecialPriceCountry, SpecialPrice, Wheat);
        end;
        13..18: begin
          ExpandMoneyCost := 0;
          ExpandBankBalanceCost := 0;
          Ware := 0;
          for Iter := Copper to Wheat do
            ExpandWareCosts[Iter] := 0;
          ExpandAmount := 50 * (Random(2) + 1);
          ExpandPrice := 10 * (Random(ExpandAmount) + 2 * ExpandAmount);
          if ExpandPrice <= Money + BankBalance + GetTotalCargoValue then
          begin
            PutPic(ExpandScreen^, 0, 199);
            GotoXY(29, 14);
            Write(ExpandAmount:3);
            if Money > ExpandPrice then
              ExpandMoneyCost := ExpandPrice
            else if BankBalance > ExpandPrice then
              ExpandBankBalanceCost := ExpandPrice
            else if Money + BankBalance > ExpandPrice then
            begin
              ExpandMoneyCost := Trunc(Money);
              ExpandBankBalanceCost := ExpandPrice - ExpandMoneyCost;
              Str(ExpandBankBalanceCost, StringBuffer);
            end
            else
            begin
              GetMostValuableCargo(1, Ware, MostValuableCargoValue);
              if MostValuableCargoValue >= ExpandPrice then
              begin
                ExpandWareCost := Round((1.0 * ExpandPrice / BaseWarePrice[Ware]));
                ExpandWareCosts[Ware] := ExpandWareCost;
                Str(ExpandWareCost, StringBuffer);
              end
              else
              begin
                Str(Cargo[Ware], StringBuffer);
                ExpandWareCosts[Ware] := Cargo[Ware];
                if (Money > BankBalance) or (Money >= ExpandMoneyCost) then
                begin
                  ExpandMoneyCost := ExpandPrice - Trunc(MostValuableCargoValue);
                  if ExpandMoneyCost > Money then
                    ExpandMoneyCost := Trunc(Money);
                  Str(ExpandMoneyCost, StringBuffer);
                end
                else
                begin
                  ExpandBankBalanceCost := ExpandPrice - Trunc(MostValuableCargoValue);
                  if ExpandBankBalanceCost > BankBalance then
                    ExpandBankBalanceCost := Trunc(BankBalance);
                  Str(ExpandBankBalanceCost, StringBuffer);
                end;
              end;
            end;
            GotoXY(18, 15);
            if ExpandMoneyCost + ExpandBankBalanceCost > 0 then
              Write('ח"ש ', ExpandMoneyCost + ExpandBankBalanceCost);
            GotoXY(15, 16);
            if (Ware > 0) and (ExpandWareCosts[Ware] > 0) then
            begin
              Str(ExpandWareCosts[Ware], StringBuffer);
              ExpandWareCostString := '.' + WareName[Ware] + 'ןוט ' + StringBuffer;
              if ExpandMoneyCost + ExpandBankBalanceCost > 0 then
                ExpandWareCostString := ExpandWareCostString + ' ףסונבו';
              Write(ExpandWareCostString:22);
            end;
            GotoXY(18, 18);
            if InputYesNo then
            begin
              ShipCapacity := ShipCapacity + ExpandAmount;
              Money := Money - ExpandMoneyCost;
              BankBalance := BankBalance - ExpandBankBalanceCost;
              for Iter := Copper to Wheat do
                Cargo[Iter] := (Cargo[Iter] - ExpandWareCosts[Iter]);
              PutPic(MessageSign^, 90, 194);
              GotoXY(18, 23);
              Write('.העצוב  הבחרהה');
              WaitForKey;
              Str(ExpandBankBalanceCost, StringBuffer);
              if ExpandBankBalanceCost > 0 then
              begin
                if ExpandMoneyCost > 0 then
                  ShowMessage(87, 'ךנובשחמ וחקלנ לקש ' + StringBuffer, '.קנבב', '')
                else
                  ShowMessage(87, '.קנבב ךנובשחמ חקלנ ףסכה', '', '');
              end;
            end;
          end
          else
            DidEventHappen := False;
        end;
        19..20: begin
          if Day < 6 then
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
            CrewOptionRects[1].X1 := 54;
            CrewOptionRects[1].Y1 := 177;
            CrewOptionRects[1].X2 := 198;
            CrewOptionRects[1].Y2 := 183;
            CrewOptionRects[2].X1 := 78;
            CrewOptionRects[2].Y1 := 186;
            CrewOptionRects[2].X2 := 198;
            CrewOptionRects[2].Y2 := 192;
            repeat
              ChosenCrewOption := ShowOptions(CrewOptionRects, 2);
            until ChosenCrewOption > 0;
            if ChosenCrewOption = 1 then
            begin
              ShouldSkipDay := True;
              ShowMessage(87, '...תרחמל', '.שדח תווצ םע דבוע התא', '');
            end
            else
            begin
              if OfferFlow(Cargo[Copper], Cargo[Olives], Cargo[Wheat], Money) then
                ShowMessage(87, '.ךתעצה תא לביק תווצה', '', '')
              else
              begin
                ShowMessage(87, '.העצהל ברס תווצה', 'אצומ התאו םיימוי ורבע', 'שדח תווצ');
                Day := Day + 1;
                ShouldSkipDay := True;
              end;
            end;
          end
          else
            DidEventHappen := False;
        end;
        21..22: begin
          ApplyBadOutcome(LoseMoney, Ware, LostAmountString);
          GotoXY(14, 24);
          if LostAmountString > '0' then
          begin
            PutPic(ThievesScreen^, 0, 199);
            Write('.לקש ' + LostAmountString:15);
          end
          else
          begin
            ApplyBadOutcome(LoseCargo, Ware, LostAmountString);
            if LostAmountString > '0' then
            begin
              PutPic(ThievesScreen^, 0, 199);
              Write('.' + WareName[Ware] + ' ןוט ' + LostAmountString:15);
            end
            else
              DidEventHappen := False;
          end;
          if DidEventHappen then
            WaitForKey;
        end;
        23..26: begin
          if Cargo[Copper] > 1 then
          begin
            PutPic(SocherScreen^, 0, 199);
            MerchantPrice := CopperPriceIsrael + 50 * Random(30) - 600;
            Str(MerchantPrice, MerchantPriceString);
            Str(Cargo[Copper], StringBuffer);
            GotoXY(3, 2);
            Writeln('.הרוחסל תופיחדב קוקז רחוס':34);
            GotoXY(3, WhereY);
            Writeln('ח"ש ' + MerchantPriceString + ' ךל עיצהל ןכומ אוה':34);
            GotoXY(3, WhereY);
            Writeln('ול רוכמת םא ,' + WareName[Copper] + 'לש ןוט לכל':34);
            GotoXY(3, WhereY);
            Writeln('.ךלש ןוטה ' + StringBuffer + ' תא':34);
            Writeln;
            GotoXY(3, WhereY);
            Write('(ל/כ) ? ול רוכמל ןינועמ התא םאה':34);
            GotoXY(3, WhereY);
            if InputYesNo then
            begin
              Money := Money + 1.0 * MerchantPrice * Cargo[Copper];
              Cargo[Copper] := 0;
              GotoXY(3, WhereY + 2);
              Write('!!! רכמנ':25);
              WaitForKey;
            end;
          end
          else if Cargo[Olives] > 1 then
          begin
            PutPic(SocherScreen^, 0, 199);
            MerchantPrice := OlivesPriceIsrael + 10 * Random(70) - 300;
            Str(MerchantPrice, MerchantPriceString);
            Str(Cargo[Olives], StringBuffer);
            GotoXY(3, 2);
            Writeln('.הרוחסל תופיחדב קוקז רחוס':34);
            GotoXY(3, WhereY);
            Writeln('ח"ש ' + MerchantPriceString + ' ךל עיצהל ןכומ אוה':34);
            GotoXY(3, WhereY);
            Writeln('ול רוכמת םא ,' + WareName[Olives] + 'לש ןוט לכל':34);
            GotoXY(3, WhereY);
            Writeln('.ךלש ןוטה ' + StringBuffer + ' תא':34);
            Writeln;
            GotoXY(3, WhereY);
            Write('(ל/כ) ? ול רוכמל ןינועמ התא םאה':34);
            GotoXY(3, WhereY);
            if InputYesNo then
            begin
              Money := Money + 1.0 * MerchantPrice * Cargo[Olives];
              Cargo[Olives] := 0;
              GotoXY(3, WhereY + 2);
              Write('!!! רכמנ':25);
              WaitForKey;
            end;
          end
          else if Cargo[Wheat] > 1 then
          begin
            PutPic(SocherScreen^, 0, 199);
            MerchantPrice := WheatPriceIsrael + 5 * Random(14) - 40;
            Str(MerchantPrice, MerchantPriceString);
            Str(Cargo[Wheat], StringBuffer);
            GotoXY(3, 2);
            Writeln('.הרוחסל תופיחדב קוקז רחוס':34);
            GotoXY(3, WhereY);
            Writeln('ח"ש ' + MerchantPriceString + ' ךל עיצהל ןכומ אוה':34);
            GotoXY(3, WhereY);
            Writeln('ול רוכמת םא ,' + WareName[Wheat] + 'לש ןוט לכל':34);
            GotoXY(3, WhereY);
            Writeln('.ךלש ןוטה ' + StringBuffer + ' תא':34);
            Writeln;
            GotoXY(3, WhereY);
            Write('(ל/כ) ? ול רוכמל ןינועמ התא םאה':34);
            GotoXY(3, WhereY);
            if InputYesNo then
            begin
              Money := Money + 1.0 * MerchantPrice * Cargo[Wheat];
              Cargo[Wheat] := 0;
              GotoXY(3, WhereY + 2);
              Write('!!! רכמנ':25);
              WaitForKey;
            end;
          end
          else
            DidEventHappen := False;
        end;
        27..28: begin
          Ware := Random(3) + 1;
          MerchantPrice := 5 * (BaseWarePrice[Ware] div 10 + Random(BaseWarePrice[Ware]) div 5);
          MerchantSupplyBaseValue := Random(Trunc(0.75 * Money) + 1) + 0.25 * Money;
          MerchantSupply := 5 * Trunc(MerchantSupplyBaseValue / BaseWarePrice[Ware] / 5 + 1);
          if (1.0 * MerchantPrice * MerchantSupply <= Money) and (Money > 0) then
          begin
            PutPic(SocherScreen^, 0, 199);
            Str(MerchantPrice, MerchantPriceString);
            Str(MerchantSupply, StringBuffer);
            if StringBuffer = '1' then
              StringBuffer := '';
            GotoXY(3, 2);
            Writeln(WareName[Ware] + ' ןוט ' + StringBuffer + ' ךל רוכמל ןינועמ רחוס':34);
            Writeln;
            GotoXY(3, WhereY);
            Writeln('ןוטל לקש ' + MerchantPriceString + ' ריחמב':34);
            Writeln;
            GotoXY(3, WhereY);
            Write('(ל/כ) ? תונקל ןינועמ התא םאה':34);
            GotoXY(3, WhereY);
            if InputYesNo then
            begin
              Money := Money - MerchantPrice * MerchantSupply;
              case Ware of
                1: Cargo[Copper] := Cargo[Copper] + MerchantSupply;
                2: Cargo[Olives] := Cargo[Olives] + MerchantSupply;
                3: Cargo[Wheat] := Cargo[Wheat] + MerchantSupply;
              end;
              Writeln;
              Writeln('            !!! תינק':25);
              WaitForKey;
            end;
          end
          else
            DidEventHappen := False;
        end;
        29..30: begin
          FishingBoatDamage := 10 * Trunc((GetTotalCargoValue + Money) / (Random(80) + 150));
          if FishingBoatDamage > 0 then
          begin
            ShowScrFile(BasePath + 'fishing.scr');
            ShipDamage := ShipDamage + FishingBoatDamage;
            GotoXY(20, 3);
            Write(FishingBoatDamage:4);
            WaitForKey;
          end
          else
            DidEventHappen := False;
        end;
      end;
    end
    until DidEventHappen;
    LastNightEvent := RandomEvent;
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
    ChosenWarePrice: integer;
    ChosenWare: integer;
    TotalCost: real;
    AmountToBuy: real;
    BuyOptionRects: TRectArray;
  begin
    AmountToBuy := 0;
    if Money < WheatPrice then
      ShowMessage(87, 'ךל רשפאמ וניא ךפסכ', 'תורוחס תינק', '')
    else
    begin
      case CountryNameToIndex(CurrentCountryName) of
        Turkey:   begin
            PutPic(BuyTurkeyWindow^, 1, 142);
            BuyOptionRects[Copper].X1 := 177;
            BuyOptionRects[Copper].Y1 := 2;
            BuyOptionRects[Copper].X2 := 236;
            BuyOptionRects[Copper].Y2 := 18;
            BuyOptionRects[Olives].X1 := 72;
            BuyOptionRects[Olives].Y1 := 2;
            BuyOptionRects[Olives].X2 := 131;
            BuyOptionRects[Olives].Y2 := 18;
            BuyOptionRects[Wheat].X1 := 180;
            BuyOptionRects[Wheat].Y1 := 65;
            BuyOptionRects[Wheat].X2 := 237;
            BuyOptionRects[Wheat].Y2 := 80;
          end;
        Israel:   begin
            PutPic(BuyIsraelWindow^, 1, 142);
            BuyOptionRects[Copper].X1 := 177;
            BuyOptionRects[Copper].Y1 := 2;
            BuyOptionRects[Copper].X2 := 236;
            BuyOptionRects[Copper].Y2 := 18;
            BuyOptionRects[Olives].X1 := 8;
            BuyOptionRects[Olives].Y1 := 2;
            BuyOptionRects[Olives].X2 := 67;
            BuyOptionRects[Olives].Y2 := 18;
            BuyOptionRects[Wheat].X1 := 179;
            BuyOptionRects[Wheat].Y1 := 86;
            BuyOptionRects[Wheat].X2 := 236;
            BuyOptionRects[Wheat].Y2 := 101;
          end;
        Egypt:   begin
            PutPic(BuyEgyptWindow^, 1, 142);
            BuyOptionRects[Copper].X1 := 177;
            BuyOptionRects[Copper].Y1 := 2;
            BuyOptionRects[Copper].X2 := 236;
            BuyOptionRects[Copper].Y2 := 18;
            BuyOptionRects[Olives].X1 := 177;
            BuyOptionRects[Olives].Y1 := 33;
            BuyOptionRects[Olives].X2 := 236;
            BuyOptionRects[Olives].Y2 := 49;
            BuyOptionRects[Wheat].X1 := 179;
            BuyOptionRects[Wheat].Y1 := 86;
            BuyOptionRects[Wheat].X2 := 236;
            BuyOptionRects[Wheat].Y2 := 101;
          end;
      end;
      ChosenWare := ShowOptions(BuyOptionRects, 103);
      if ChosenWare > 0 then
      begin
        case ChosenWare of
          Copper: ChosenWarePrice := CopperPrice;
          Olives: ChosenWarePrice := OlivesPrice;
          Wheat: ChosenWarePrice := WheatPrice;
        end;
        if Money < ChosenWarePrice then
          ShowMessage(87, 'ךל רשפאמ וניא ךפסכ', WareName[ChosenWare] + 'תונקל', '')
        else
        begin
          repeat
          begin
            PutPic(BuySign^, 22, 138);
            GotoXY(6, 15);
            Write(Trunc(Money / ChosenWarePrice));
            GotoXY(6, 17);
            AmountToBuy := InputReal(0, 0, 8);
            TotalCost := 1.0 * AmountToBuy * ChosenWarePrice;
          end
          until not CannotAfford(TotalCost);
        end;
        if AmountToBuy > 0 then
        begin
          Money := Money - TotalCost;
          Cargo[ChosenWare] := Cargo[ChosenWare] + Trunc(AmountToBuy);
        end;
      end;
    end;
  end;

  procedure Func35(
    CopperPrice: integer;
    OlivesPrice: integer;
    WheatPrice: integer
  );
  var
    Unused: integer;
    ChosenWare: integer;
    Revenue: real;
    AmountToSell: real;
    SellOptionRects: TRectArray;

    function HasInsufficientCargo(Amount: real; Ware: integer): boolean;
    begin
      if Amount > Cargo[Ware] then
      begin
        ShowMessage(87, 'הברה ךכ-לכ ךל ןיא', 'רוכמל' + WareName[Ware], #7);
        HasInsufficientCargo := True;
      end
      else
        HasInsufficientCargo := False;
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
      SellOptionRects[Copper].X1 := 19;
      SellOptionRects[Copper].Y1 := 26;
      SellOptionRects[Olives].X1 := 19;
      SellOptionRects[Olives].Y1 := 42;
      SellOptionRects[Wheat].X1 := 19;
      SellOptionRects[Wheat].Y1 := 58;
      if CurrentCountryName = EgyptName then
      begin
        SellOptionRects[Copper].X2 := 58;
        SellOptionRects[Copper].Y2 := 34;
        SellOptionRects[Olives].X2 := 57;
        SellOptionRects[Olives].Y2 := 50;
        SellOptionRects[Wheat].X2 := 57;
        SellOptionRects[Wheat].Y2 := 66;
      end
      else
      begin
        SellOptionRects[Copper].X2 := 59;
        SellOptionRects[Copper].Y2 := 35;
        SellOptionRects[Olives].X2 := 59;
        SellOptionRects[Olives].Y2 := 51;
        SellOptionRects[Wheat].X2 := 59;
        SellOptionRects[Wheat].Y2 := 67;
      end;
      ChosenWare := ShowOptions(SellOptionRects, 103);
      if ChosenWare > 0 then
      begin
        if Cargo[ChosenWare] > 0 then
        begin
          repeat
          begin
            PutPic(SellSign^, 120, 60);
            GotoXY(21, 7);
            AmountToSell := InputReal(0, 0, 8);
          end
          until not HasInsufficientCargo(AmountToSell, ChosenWare);
        end
        else
        begin
          ShowMessage(87, 'רוכמל' + WareName[ChosenWare] + 'ךל ןיא', #7, '');
          AmountToSell := 0;
        end;
        if AmountToSell = -1 then
          AmountToSell := 0;

        case ChosenWare of
          Copper: Revenue := 1.0 * AmountToSell * CopperPrice;
          Olives: Revenue := 1.0 * AmountToSell * OlivesPrice;
          Wheat: Revenue := 1.0 * AmountToSell * WheatPrice;
        end;
        Money := Money + Revenue;
        Cargo[ChosenWare] := Cargo[ChosenWare] - Trunc(AmountToSell);
      end;
    end;
  end;

  procedure ShowBankWindow;
  var
    ChosenOption: integer;
    DidFinishFlag: byte;
    BankOptionRects: TRectArray;
    Amount: real;

  const
    Deposit = 1;
    Withdraw = 2;

  begin
    DidFinishFlag := 0;
    PutPic(BankWindow^, 0, 142);
    BankOptionRects[Deposit].X1 := 97;
    BankOptionRects[Deposit].Y1 := 7;
    BankOptionRects[Deposit].X2 := 149;
    BankOptionRects[Deposit].Y2 := 16;
    BankOptionRects[Withdraw].X1 := 16;
    BankOptionRects[Withdraw].Y1 := 7;
    BankOptionRects[Withdraw].X2 := 64;
    BankOptionRects[Withdraw].Y2 := 16;
    ChosenOption := ShowOptions(BankOptionRects, 102);
    case ChosenOption of
      Deposit: begin
        if Money <= 0 then
          ShowMessage(87, ' ', '! דיקפהל ףסכ ךל ןיא' + '', ' ')
        else
        begin
          repeat
          begin
            PutPic(DepositSign^, 11, 139);
            GotoXY(5, 17);
            Amount := InputReal(0, 0, 8);
            if Amount <= 0 then
              DidFinishFlag := 1
            else if Amount <= Money then
            begin
              BankBalance := BankBalance + Amount;
              Money := Money - Amount;
              ShowMessage(87, ' ', 'ףסכה תא לביק קנבה דיקפ', ' ');
              DidFinishFlag := 1;
            end
            else
              ShowMessage(87, ' ', '! ףסכ הברה ךכ לכ ךל ןיא' + '', ' ');
          end
          until DidFinishFlag = 1;
        end;
      end;
      Withdraw: begin
        if BankBalance > 0 then
        begin
          repeat
          begin
            PutPic(WithdrawSign^, 11, 139);
            GotoXY(5, 17);
            Amount := InputReal(0, 0, 8);
            if Amount < 0 then
              DidFinishFlag := 1
            else if Amount <= BankBalance then
            begin
              GotoXY(1, 1);
              BankBalance := BankBalance - Amount;
              Money := Money + Amount;
              if not (Amount = 0) then
                ShowMessage(87, ' ', 'ףסכה תא תלביק', ' ');
              DidFinishFlag := 1;
            end
            else
              ShowMessage(87, ' ', '! קנבב הזכ ףסכ םוכס ךל ןיא' + '', ' ');
          end
          until DidFinishFlag = 1;
        end
        else
          ShowMessage(87, ' ', '! קנבב ףסכ ךל ןיא' + '', ' ');
      end;
    end;
  end;

  function AskOverweight(TotalCargoWeight: integer): boolean;
  var
    Unused: array[1..3] of byte;
  begin
    if TotalCargoWeight > ShipCapacity then
    begin
      PutPic(OverweightWindow^, 0, 142);
      GotoXY(53, 16);
      if InputYesNo then
        AskOverweight := False
      else
        AskOverweight := True;
    end
    else
      AskOverweight := False;
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
      ShipPic: array[1..129] of byte;
      Unused2: array[1..129] of byte;
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
      LostAmountString: TNumberString;
      OriginalDestination: TCountryName;
      OriginalTravelDestination: byte;
      CurrentShipX: integer;
      CurrentShipY: integer;
      Unused2: real;
      IsHighRiskEventForced: boolean;
      IsShipDamaged: boolean;

      procedure PiratesFlow(CurrentGuardShipCount: integer; CurrentCargoWeight2: integer);
      var
        RunAwayChance: integer;
        ChosenPiratesOption: integer;
        { Running away succeeds if this equals 0 }
        RunAwayControl: integer;
        { Running away fails if this is bigger than 0 }
        DamagedRunAwayControl: integer;
        GuardShipCountAdjustment: integer;
        StringBuffer: string[5];
        PiratesOptionRects: TRectArray;
        Booty: real;
        LostAmount: real;

        procedure ApplyConfrontDamage(DamageChance: integer);
        begin
          if Random(DamageChance) = 0 then
          begin
            LostAmount := 10 * Trunc((Random(15) + 5) / 1000.0 * (Money + GetTotalCargoValue));
            Str(LostAmount:1:0, StringBuffer);
            ShipDamage := ShipDamage + LostAmount;
            if DamageChance = 2 then
              ShowMessage(87, 'םרגנ ,ףסונב', 'יוושב קזנ הניפסל', '.םילקש ' + StringBuffer)
            else
              ShowMessage(87, 'ךתניפס ,ךלזמ עורל', '.ברקה ידכ ךות העגפנ', '.ח"ש ' + StringBuffer + ' קזנה יווש');
          end;
        end;

        procedure ConfrontPirates;
        var
          WinningDifficulty: integer;
          MostValuableCargoValue: real;
          Unused: byte;
        begin
          PutPic(ConfrontWindow^, 0, 142);
          WinningDifficulty := Random(4);
          if (WinningDifficulty < CurrentGuardShipCount - GuardShipCountAdjustment) or
              ((CurrentGuardShipCount - GuardShipCountAdjustment <= 0) and (Random(6) = 1)) then
          begin
            ShowMessage(87, '- ךשוממ ברק רחאל', '! םיטריפה תא תסבה', '');
            if Random(3) = 1 then
            begin
              ShipCapacity := ShipCapacity + 50;
              ShowMessage(87, 'תניפס תא יבשב תחקל', 'הניפסה תלוביקו ,םיה ידדוש', '.ןוט 50-ב הלדג ךלש');
            end
            else
            begin
              CurrentGuardShipCount := CurrentGuardShipCount + GuardShipCountAdjustment;
              Booty := Int((Money + GetTotalCargoValue + BankBalance) / 100) * (Random(15) + 5) +
                  CurrentGuardShipCount * (Money + GetTotalCargoValue + BankBalance) / 10;
              if Booty < 100 then
                Booty := 100;
              Booty := 5 * Int(Booty / 5);
              Str(Booty:1:0, StringBuffer);
              ShowMessage(87, ' לש ןומטמ תאצמ', 'םתניפס לע לקש ' + StringBuffer, '');
              Money := Money + Booty;
            end;
            ApplyConfrontDamage(4);
          end
          else
          begin
            Str(CurrentGuardShipCount, StringBuffer);
            if CurrentGuardShipCount = 0 then
              ShowMessage(87, ',רמשמ תוניפס תנגה אלל', 'םיטריפה ידי לע תסבוה התא', '')
            else if CurrentGuardShipCount = 1 then
              ShowMessage(87, 'תניפס לע ורבגתה םיטריפה', 'ךלש רמשמה', '')
            else if CurrentGuardShipCount > 1 then
              ShowMessage(87, 'תא וחצינ םיטריפה', 'ךלש רמשמה תוניפס ' + StringBuffer, '');
            CurrentGuardShipCount := CurrentGuardShipCount + GuardShipCountAdjustment;
            if CurrentGuardShipCount > 3 then
              CurrentGuardShipCount := 3;
            GetMostValuableCargo(5, Ware, MostValuableCargoValue);
            if MostValuableCargoValue > Money then
            begin
              LostAmount := 1.0 * (Random(15) + 5) * Cargo[Ware] / 100;
              if CurrentGuardShipCount < 3 then
                LostAmount := LostAmount + (3 - CurrentGuardShipCount) * Cargo[Ware] div 10;
              if LostAmount < 1 then
                LostAmount := 1;
              Cargo[Ware] := Cargo[Ware] - Trunc(LostAmount);
              Str(Trunc(LostAmount):1, LostAmountString);
              ShowMessage(87, '     השק ברק ירחא', ' םיה ידדוש ךממ ובנג',
                  WareName[Ware] + 'ןוט ' + LostAmountString);
              ApplyConfrontDamage(2);
            end
            else
            begin
              if Money > 500 then
              begin
                LostAmount := 10 * Trunc(Random(Trunc(0.015 * Money)) + Money / 200);
                if CurrentGuardShipCount < 3 then
                  LostAmount := LostAmount + (3 - CurrentGuardShipCount) * Trunc(Money / 10);
                LostAmount := Trunc(LostAmount);
                Money := Money - LostAmount;
                Str(LostAmount:1:0, LostAmountString);
                ShowMessage(87, 'םילקש ' + LostAmountString + ' ךממ ובנג םה', '', '');
                ApplyConfrontDamage(2);
              end
              else
              begin
                LostAmount := Int((Random(15) + 35 - 10 * CurrentGuardShipCount) / 1000 *
                    (GetTotalCargoValue + Money + BankBalance)) * 10;
                if LostAmount < 100 then
                  LostAmount := 100;
                Str(LostAmount:1:0, StringBuffer);
                ShipDamage := ShipDamage + LostAmount;
                ShowMessage(87, 'ךתניפס ,ךלזמ עורל', '.ברקה ידכ ךות העגפנ', 'ח"ש ' + StringBuffer + ' קזנה יווש');
              end;
            end;
          end;
          ShowHUD;
        end;

      const
        Confront = 1;
        RunAway = 2;
        Offer = 3;

      begin
        PutPic(PiratesWindow^, 0, 142);
        WaitForKey;
        PutPic(PiratesSign^, 4, 139);
        GotoXY(18, 17);
        Write(GuardShipCount:2);
        PiratesOptionRects[Confront].X1 := 108;
        PiratesOptionRects[Confront].Y1 := 117;
        PiratesOptionRects[Confront].X2 := 133;
        PiratesOptionRects[Confront].Y2 := 123;
        PiratesOptionRects[RunAway].X1 := 72;
        PiratesOptionRects[RunAway].Y1 := 117;
        PiratesOptionRects[RunAway].X2 := 96;
        PiratesOptionRects[RunAway].Y2 := 123;
        PiratesOptionRects[Offer].X1 := 7;
        PiratesOptionRects[Offer].Y1 := 117;
        PiratesOptionRects[Offer].X2 := 58;
        PiratesOptionRects[Offer].Y2 := 123;
        ChosenPiratesOption := ShowOptions(PiratesOptionRects, 3);
        case ChosenPiratesOption of
          Confront: begin
            GuardShipCountAdjustment := 0;
            ConfrontPirates;
          end;
          RunAway: begin
            DamagedRunAwayControl := 0;
            GuardShipCountAdjustment := 1;
            PutPic(RunAwayWindow^, 0, 142);
            if CurrentCargoWeight2 > 0.81 * ShipCapacity then
              RunAwayControl := 0
            else
            begin
              RunAwayChance := ShipCapacity div 30 - CurrentCargoWeight2 div 30 + 1;
              if RunAwayChance < 1 then
                RunAwayChance := 1;
              RunAwayControl := Random(RunAwayChance);
            end;
            if RunAwayControl > 0 then
              DamagedRunAwayControl := Random(Trunc(ShipDamage) div 30 + 1);
            if DamagedRunAwayControl > 0 then
              RunAwayControl := 0;
            if RunAwayControl = 0 then
            begin
              if CurrentCargoWeight2 > 0.5 * ShipCapacity then
                ShowMessage(87, 'אלו ,ידמ הדבכ ךתניפס', 'חורבל החילצה', '')
              else if ShipDamage > 0 then
                ShowMessage(87, 'בקע חורבל תחלצה אל', 'ךתניפסבש קזנה', '')
              else
                ShowMessage(87, 'החילצה הריהמה םיטריפה תניפס', 'ךתניפס תא גישהל', '');
              ConfrontPirates;
            end
            else
              ShowMessage(87, '', '! !  םהמ  טלמהל  תחלצה', '');
          end;
          Offer: begin
            GuardShipCountAdjustment := 1;
            PutPic(OfferWindow^, 0, 142);
            if OfferFlow(Cargo[Copper], Cargo[Olives], Cargo[Wheat], Money) then
            begin
              ShowMessage(87, 'לבקל וטילחה םיה ידדוש', 'ךתעצה תא', '');
              ShowHUD;
            end
            else
            begin
              ShowMessage(87, 'תא םיחוד םיה ידדוש', '! ךתוא םיפקותו ךתעצה', '');
              ConfrontPirates;
            end;
          end;
        end;
      end;

      function IsShipSinking(CurrentCargoWeight2: integer): boolean;
      var
        SinkingChance: integer;
      begin
        SinkingChance := 30000;
        if CurrentCargoWeight2 > ShipCapacity + 70 then
          SinkingChance := 1
        else if CurrentCargoWeight2 > ShipCapacity + 60 then
          SinkingChance := 2
        else if CurrentCargoWeight2 > ShipCapacity + 40 then
          SinkingChance := 3
        else if CurrentCargoWeight2 > ShipCapacity + 20 then
          SinkingChance := 4
        else if CurrentCargoWeight2 > ShipCapacity then
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
      HalfTravelTime: byte;

      { Risk > 0 means 1/3 higher guard ship cost }
      procedure ShowGuardShipWindow(var CurrentRisk: integer);
      var
        GuardShipPrice: real;
        Line1: TMessageLine;
        Line2: TMessageLine;
        Line3: TMessageLine;
        PriceString: TNumberString;
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
        HalfTravelTime := (TravelEndTime - TimeOfDay) div 2;
        TravelEndTime := TravelEndTime - HalfTravelTime;
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
        TravelEndTime := TimeOfDay + HalfTravelTime;
        CurrentWaypoint := NextWaypoint;
        DoTravelEvent(ShipDamage, GetTotalCargoWeight, TravelDuration, Risk);
        DestinationIndex := CountryNameToIndex(TravelDestination);
        NextWaypoint := MapWaypoints[CurrentWaypoint, DestinationIndex];
        if NextWaypoint > 0 then
        begin
          HalfTravelTime := HalfTravelTime div 2;
          TravelEndTime := TravelEndTime - HalfTravelTime;
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
          TravelEndTime := TimeOfDay + HalfTravelTime;
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
    Iter := Turkey;
    for CountryIter := Turkey to Egypt do
    begin
      if CountryIter <> CountryNameToIndex(TravelStart) then
      begin
        TravelOptionRects[Iter] := FullTravelOptionRects[CountryIter];
        Iter := Iter + 1;
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
  ShouldSkipDay := False;
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
    DoDayStartEvent;
  if not ((Day > 7) or ShouldSkipDay) then
  begin
    PutPic(MainScreen^, 0, 199);
    GetPic(MainMenuPic^, 0, 0, 240, 142);
    ToggleCountryHighlight(CurrentCountryName);
    repeat
    begin
      PutPic(MainMenuPic^, 0, 142);
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
      ChosenMainMenuOption := ShowOptions(MainMenuOptionRects, MainMenuOptionCount);
      case ChosenMainMenuOption of
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
          else if ShipDamage > 1000 then
            ShowMessage(87, 'וניא ךתניפסל םרגנש קזנה', '.גילפהל ךל רשפאמ', '' )
          else if not AskOverweight(GetTotalCargoWeight) then
            TravelFlow(StormCountryName);
        end;
        Bank: begin
          if ClosedBankDay = Day then
            ShowMessage(87, '', 'םויה  רוגס  קנבה ', '')
          else
            ShowBankWindow;
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
    until (ChosenMainMenuOption = 5) and (LastPressedKey <> #27);
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
  CurrentDir: string[15];
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
  New(MainMenuPic);
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
    for J := 1 to 8 do
      MapWaypoints[I, J] := 0;
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
  Unused3 := 1;
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

procedure HighScoreFlow(FinalScore: real);
type
  TPlayerName = string[20];
  THighScoreEntry = record
    PlayerName: TPlayerName;
    Score: real;
  end;
var
  WinnersFile: file of THighScoreEntry;
  HighScores: array[1..11] of THighScoreEntry;
  HighScoreCount: integer;
  NewHighScoreIndex: integer;
  I: integer;
  Unused: byte;
  Unused2: array[1..8] of byte;
  procedure InputString(var OutString: TPlayerName; MaxLength: integer);
  var
    PressedKey: char;
    InputLength: integer;
    HebrewIndex: integer;
    IsFinished: boolean;
    CurrentString: TPlayerName;
  const
    LowerCaseLatin: string[27] = 'tcdsvuzjyhlfkonibxg;p.mera,';
    UpperCaseLatin: string[27] = 'TCDSVUZJYHLFKONIBXG:P>MERA<';
    Hebrew: string[38] = 'אבגדהוזחטיךכלםמןנסעףפץצקרשת1234567890 ';
  begin
    IsFinished := False;
    CurrentString := '';
    InputLength := 0;
    repeat
    begin
      PressedKey := GetPressedKey;
      HebrewIndex := Pos(PressedKey, LowerCaseLatin) + Pos(PressedKey, UpperCaseLatin) + Pos(PressedKey, Hebrew);
      if HebrewIndex > 0 then
      begin
        Write(Hebrew[HebrewIndex], #8, #8);
        InputLength := InputLength + 1;
        CurrentString := Hebrew[HebrewIndex] + CurrentString;
      end
      else if (PressedKey = #8) and (InputLength > 0) then
      begin
        Write('  ', #8);
        CurrentString := Copy(CurrentString, 2, InputLength);
        InputLength := (InputLength - 1);
      end
      else if (PressedKey = #13) and (InputLength > 0) then
        IsFinished := True;
      if InputLength = MaxLength then
        IsFinished := True;
    end
    until IsFinished;
    OutString := CurrentString;
  end;
begin
  Unused := 0;
  HighScoreCount := 1;
  NewHighScoreIndex := 0;
  Assign(WinnersFile, 'winners.win');
  {$I-} Reset(WinnersFile); {$I+}
  if IOResult <> 0 then
  begin
    Rewrite(WinnersFile);
    Close(WinnersFile);
  end
  else
  begin
    while (not EOF(WinnersFile)) do
    begin
      Read(WinnersFile, HighScores[HighScoreCount]);
      if (NewHighScoreIndex = 0) and (HighScores[HighScoreCount].Score < FinalScore) then
      begin
        NewHighScoreIndex := HighScoreCount;
        HighScoreCount := (HighScoreCount + 1);
        HighScores[HighScoreCount] := HighScores[(HighScoreCount - 1)];
        HighScores[NewHighScoreIndex].Score := FinalScore;
      end;
      HighScoreCount := HighScoreCount + 1;
    end;
  end;
  Close(WinnersFile);
  if (HighScoreCount <= 10) and (NewHighScoreIndex = 0) then
  begin
    NewHighScoreIndex := HighScoreCount;
    HighScoreCount := HighScoreCount + 1;
    HighScores[HighScoreCount] := HighScores[HighScoreCount - 1];
    HighScores[NewHighScoreIndex].Score := FinalScore;
  end;
  if HighScoreCount > 11 then
    HighScoreCount := 11;
  if NewHighScoreIndex <> 0 then
  begin
    ShowScrFile(BasePath + 'in_10.scr');
    GotoXY(28, 20);
    InputString(HighScores[NewHighScoreIndex].PlayerName, 16);
    Rewrite(WinnersFile);
    for I := 1 to HighScoreCount - 1 do
      Write(WinnersFile, HighScores[I]);
    Close(WinnersFile);
  end;
  ShowScrFile(BasePath + 'first_10.scr');
  for I := 1 to HighScoreCount - 1 do
  begin
    GotoXY(11, 3 + 2 * I);
    Write(HighScores[I].Score:6:0);
    GotoXY(20, 3 + 2 * I);
    Write(HighScores[I].PlayerName:16);
  end;
  if NewHighScoreIndex = 0 then
  begin
    ScoreSign := LoadSgnFile('score');
    PutPic(ScoreSign^, 7, 130);
    GotoXY(3, 10);
    if FinalScore > 999 then
      Write(ToStrWithCommas(FinalScore):6)
    else
      Write(ToStrWithCommas(FinalScore):4);
    Dispose(ScoreSign);
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
    HighScoreFlow(Money + BankBalance);
    GraphColorMode;
    GraphBackground(1);
    ShowMessage(78, 'ןינועמ התא םאה', '(ל/כ) ? ףסונ קחשמב', '');
    GotoXY(7, 16);
  end
  until not InputYesNo;
end.
