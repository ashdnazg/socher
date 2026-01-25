
function Func1: char; forward;
procedure Func2;
var
  Func2_var_0: char;
begin
  repeat
  Func2_var_0 := Func1;
  until (((Func2_var_0 = #13) or (Func2_var_0 = #27)) and (not KeyPressed));
end;
procedure Func3(
  Func3_arg_108: byte;
  Func3_arg_72: str_35;
  Func3_arg_36: str_35;
  Func3_arg_0: str_35
);
begin
  GetPic(global_var_296, 10, (138 - 29), (10 + 221), 138);
  PutPic(global_var_2252^, 10, 138);
  GotoXY((29 - Length(Func3_arg_72)), 15);
  Write(Func3_arg_72);
  GotoXY((29 - Length(Func3_arg_36)), 16);
  Write(Func3_arg_36);
  GotoXY((29 - Length(Func3_arg_0)), 17);
  Write(Func3_arg_0);
  if ((Func3_arg_108 = 87) or (Func3_arg_108 = 82)) then
  begin
    Func2;
    PutPic(global_var_296, 10, 138);
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
    Func8_var_0 := (Func8_var_0 + ((1.0 * global_var_152[Func8_var_6]) * global_var_116[Func8_var_6]));
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
    Func9_var_0 := (Func9_var_0 + global_var_152[Func9_var_2]);
  end;
  Func9 := Func9_var_0;
end;
function Func10(Func10_arg_0: real): str_15;
var
  Func10_var_2: str_15;
  Func10_var_0: integer;
function Func11(Func11_arg_0: real): str_15;
begin
  Str(Func11_arg_0:1:0, Func10_var_2);
  for Func10_var_0 := 1 to 2 do
  begin
    if (Length(Func10_var_2) < 3) then
    begin
      Func10_var_2 := (#48 + Func10_var_2);
    end;
  end;
  Func11 := Func10_var_2;
end;
begin
  if (Func10_arg_0 <= 999) then
  begin
    Str(Func10_arg_0:1:0, Func10_var_2);
    Func10 := Func10_var_2;
  end
  else
  begin
    Func10 := ((Func10(Int((Func10_arg_0 / 1000))) + ',') + Func11((1000 * Frac((Func10_arg_0 / 1000)))));
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
    if ((((1.0 * global_var_152[Func12_var_0]) * global_var_116[Func12_var_0]) > Func12_arg_0) and
 (global_var_152[Func12_var_0] >= Func12_arg_8)) then
    begin
      Func12_arg_4 := Func12_var_0;
      Func12_arg_0 := ((1.0 * global_var_152[Func12_var_0]) * global_var_116[Func12_var_0]);
    end;
  end;
end;
procedure Func13;
begin
  if (global_var_66 = ' ') then
  begin
    ShowScrFile((BasePath + 'goodwthr.scr'));
  end
  else
  begin
    GotoXY(28, 20);
    ShowScrFile((BasePath + 'badwthr.scr'));
    Write(global_var_66:6);
  end;
  Func2;
end;
procedure Func14;
var
  Func14_var_13: PScrBuffer;
  Func14_var_11: integer;
  Func14_var_9: integer;
  Func14_var_0: str_8;
begin
  Func14_var_11 := WhereX;
  Func14_var_9 := WhereY;
  New(Func14_var_13);
  GetPic(Func14_var_13^, 0, 0, 319, 199);
  ColorTable(0, 1, 2, 3);
  PutPic(global_var_2220^, 0, 199);
  GotoXY(9, 7);
  if (global_var_66 = ' ') then
  begin
    Write('האנ':17);
  end
  else
  begin
    Write((global_var_66 + ' רוזאב הרעס'):17);
  end;
  GotoXY(9, 12);
  Write(global_var_95:17:0);
  GotoXY(9, 17);
  Str(global_var_77, Func14_var_0);
  Write(('ןוט ' + Func14_var_0):17);
  GotoXY(9, 22);
  Str(global_var_83:1:0, Func14_var_0);
  if (global_var_83 <= 0) then
  begin
    Write('ןיקת':17);
  end
  else
  begin
    Write((('לקש ' + Func14_var_0) + ' לש קזנ'):17);
  end;
  repeat
  Read(KBD, global_var_107);
  until (not KeyPressed);
  ColorTable(0, 1, 2, 3);
  PutPic(Func14_var_13^, 0, 199);
  GotoXY(Func14_var_11, Func14_var_9);
  Dispose(Func14_var_13);
end;
function Func1;
var
  Func1_var_0: char;
begin
  Read(KBD, Func1_var_0);
  if ((Func1_var_0 = #27) and KeyPressed) then
  begin
    Read(KBD, Func1_var_0);
  end;
  if (Func1_var_0 = #68) then
  begin
    Func14;
    Func1_var_0 := Func1;
  end;
  Func1 := Func1_var_0;
end;
function Func15(Func15_arg_0: str_10): integer;
begin
  if (Func15_arg_0 = 'היכרות') then
  begin
    Func15 := 1;
  end
  else
  begin
    if (Func15_arg_0 = 'לארשי') then
    begin
      Func15 := 2;
    end
    else
    begin
      if (Func15_arg_0 = 'םירצמ') then
      begin
        Func15 := 3;
      end;
    end;
  end;
end;
function Func16(Func16_arg_0: integer): str_10;
begin
  case Func16_arg_0 of
    1:   begin
        Func16 := 'היכרות';
      end;
    2:   begin
        Func16 := 'לארשי';
      end;
    3:   begin
        Func16 := 'םירצמ';
      end;
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
    Func17_var_1 := Func1;
    until (Func17_var_1 in [#72, #75, #80, #77, #32, #13, #27]);
    ColorTable(0, 1, 2, 3);
    if ((Func17_var_1 <> #13) or Func17_var_0) then
    begin
      PutPic(Func17_var_2, field_0, field_6);
    end;
    case Func17_var_1 of
      #72, #75:   begin
          Func17_var_802 := (Func17_var_802 - 1);
        end;
      #32, #80, #77:   begin
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
  Func18_unused_16: arr_byte_4;
  Func18_var_14: integer;
  Func18_unused_12: arr_byte_2;
  Func18_var_6: str_5;
  Func18_var_0: str_5;
begin
  Func18_var_22 := WhereX;
  Func18_var_20 := WhereY;
  Func18_var_14 := 0;
  repeat
  begin
    Func18_var_25 := 0;
    for Func18_var_14 := 1 to Func18_var_14 do
    begin
      Write(#32);
    end;
    Func18_var_24 := False;
    Func18_var_14 := 0;
    GotoXY(Func18_var_22, Func18_var_20);
    repeat
    begin
      Func18_var_31 := Func1;
      case Func18_var_31 of
        #68:   begin
            Func14;
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
              Write(#8, #32, #8);
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
      Func3(
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
function Func20: boolean;
var
  Func20_var_9: boolean;
  Func20_var_8: char;
  Func20_var_6: integer;
  Func20_var_4: integer;
  Func20_var_2: integer;
  Func20_var_0: integer;
begin
  Func20_var_2 := WhereX;
  Func20_var_0 := WhereY;
  Func20_var_4 := 0;
  repeat
  begin
    GotoXY(Func20_var_2, Func20_var_0);
    Func20_var_8 := Func1;
    case Func20_var_8 of
      #139, #102, #70:   begin
          Func20_var_9 := True;
          Func20_var_4 := (Func20_var_4 + 1);
        end;
      #140, #107, #75:   begin
          Func20_var_9 := False;
          Func20_var_4 := (Func20_var_4 + 1);
        end;
      #27, #32:   begin
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
  Func20 := Func20_var_9;
end;
procedure Func21;
var
  Func21_var_109: integer;
  Func21_var_107: integer;
  Func21_var_105: integer;
  Func21_var_103: integer;
  Func21_var_101: integer;
  Func21_var_99: integer;
  Func21_var_97: integer;
  Func21_var_95: integer;
  Func21_var_93: integer;
  Func21_var_91: integer;
  Func21_var_89: integer;
  Func21_var_88: boolean;
  Func21_var_8: arr_record_1479674575002027080_10;
  Func21_var_6: integer;
  Func21_var_4: integer;
  Func21_unused_0: arr_byte_4;
procedure Func22;
begin
  GotoXY(73, 1);
  Write(global_var_33:6);
  GotoXY(32, 3);
  Write(global_var_158[global_var_79]);
  GotoXY(32, 5);
  Write(global_var_81:2);
  Write(':00');
  GotoXY(32, 17);
  Write(#32:8);
  GotoXY(34, 17);
  if (global_var_89 >= 10000.0) then
  begin
    GotoXY(33, 17);
  end;
  if (global_var_89 >= 100000.0) then
  begin
    GotoXY(32, 17);
  end;
  Write(Func10(global_var_89):5);
  GotoXY(32, 9);
  Write(global_var_152[1]:3);
  GotoXY(32, 11);
  Write(global_var_152[2]:3);
  GotoXY(32, 13);
  Write(#32:5);
  GotoXY(32, 13);
  Write(global_var_152[3]:3);
  GotoXY(30, 21);
  Write(Func21_var_107:4);
  GotoXY(30, 23);
  Write(Func21_var_101:4);
  GotoXY(30, 25);
  Write(Func21_var_95:4);
  GotoXY(16, 21);
  Write(Func21_var_109:4);
  GotoXY(16, 23);
  Write(Func21_var_103:4);
  GotoXY(16, 25);
  Write(Func21_var_97:4);
  GotoXY(2, 21);
  Write(Func21_var_105:4);
  GotoXY(2, 23);
  Write(Func21_var_99:4);
  GotoXY(2, 25);
  Write(Func21_var_93:4);
end;
function Func23(Func23_arg_0: byte): boolean;
begin
  if (Func23_arg_0 = 26) then
  begin
    Func23 := True;
  end
  else
  begin
    Func23 := False;
  end;
end;
function Func24(Func24_arg_0: real): boolean;
begin
  if (Func24_arg_0 > global_var_89) then
  begin
    Func3(
      87,
      '',
      '!ףסכ קיפסמ ךתושרב ןיא',
      #7
    );
    Func24 := True;
  end
  else
  begin
    Func24 := False;
  end;
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
  Func25_unused_0: arr_byte_6;
function Func26(Func26_arg_6: real; Func26_arg_0: real): boolean;
begin
  if (Func26_arg_6 < 0) then
  begin
    Func26_arg_6 := 0;
  end;
  if (Func26_arg_6 <= Func26_arg_0) then
  begin
    Func26 := True;
  end
  else
  begin
    Func3(87, '', '!הז םוכס ךתושרב ןיא', #7);
    Func26 := False;
  end;
end;
function Func27(var Func27_arg_6: integer; Func27_arg_0: real): boolean;
begin
  if (Func27_arg_6 < 0) then
  begin
    Func27_arg_6 := 0;
  end;
  if (Func27_arg_6 <= Func27_arg_0) then
  begin
    Func27 := True;
  end
  else
  begin
    Func3(87, '', '!הז םוכס ךתושרב ןיא', #7);
    Func27 := False;
  end;
end;
begin
  Func25_var_28 := 0;
  Func25_var_26 := 0;
  Func25_var_24 := 0;
  Func25_var_18 := 0;
  if (Func25_arg_12 > 0) then
  begin
    repeat
    begin
      Func3(
        78,
        (('?תתל ןכומ התא' + global_var_122[1]) + 'ןוט המכ'),
        '',
        ''
      );
      GotoXY(20, 16);
      repeat
      Func25_var_28 := Trunc(Func18(0, 0, 8));
      until (Func25_var_28 >= 0);
    end
    until ((Func25_var_28 >= 0) and Func27(Func25_var_28, Func25_arg_12));
  end;
  if (Func25_arg_8 > 0) then
  begin
    repeat
    begin
      Func3(
        78,
        (('?תתל ןכומ התא' + global_var_122[2]) + 'ןוט המכ'),
        '',
        ''
      );
      GotoXY(20, 16);
      repeat
      Func25_var_26 := Trunc(Func18(0, 0, 8));
      until (Func25_var_26 >= 0);
    end
    until Func27(Func25_var_26, Func25_arg_8);
  end;
  if (Func25_arg_4 > 0) then
  begin
    repeat
    begin
      Func3(
        78,
        (('?תתל ןכומ התא' + global_var_122[3]) + 'ןוט המכ'),
        '',
        ''
      );
      GotoXY(20, 16);
      repeat
      Func25_var_24 := Trunc(Func18(0, 0, 8));
      until (Func25_var_24 >= 0);
    end
    until Func27(Func25_var_24, Func25_arg_4);
  end;
  if (Func25_arg_0 > (Func8 / 10)) then
  begin
    repeat
    begin
      Func3(
        78,
        '?תתל ןכומ התא ףסכ המכ',
        '',
        ''
      );
      GotoXY(20, 16);
      repeat
      Func25_var_18 := Trunc(Func18(0, 0, 8));
      until (Func25_var_18 >= 0);
    end
    until Func26(Func25_var_18, Func25_arg_0);
  end;
  Func25_var_12 := ((((Func25_var_28 * global_var_116[1]) + (Func25_var_26 * global_var_116[2])) + (Func25_var_24 *
 global_var_116[3])) + Func25_var_18);
  Func25_var_6 := ((Func8 + Func25_arg_0) / (Random(6) + 4));
  if (Func25_var_12 > Func25_var_6) then
  begin
    Func25_arg_0 := (Func25_arg_0 - Func25_var_18);
    Func25_arg_12 := (Func25_arg_12 - Func25_var_28);
    Func25_arg_8 := (Func25_arg_8 - Func25_var_26);
    Func25_arg_4 := (Func25_arg_4 - Func25_var_24);
    Func25 := True;
  end
  else
  begin
    Func25 := False;
  end;
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
      if ((not Func28_var_8) and (global_var_152[Func28_var_6] > 2)) then
      begin
        Func28_var_0 := Trunc(
          (((20.0 + Random(21)) / 100) * global_var_152[Func28_var_6])
        );
        if (Func28_var_0 < 1) then
        begin
          Func28_var_0 := 1;
        end;
        global_var_152[Func28_var_6] := (global_var_152[Func28_var_6] - Ord(Func28_var_0));
        Func28_arg_4 := Func28_var_6;
        Func28_var_8 := True;
      end;
    end;
  end
  else
  begin
    if (Func28_arg_8 = 153) then
    begin
      if (Func9 <= (3 * global_var_77)) then
      begin
        Func28(142, Func28_arg_4, Func28_arg_0);
        Val(Func28_arg_0, Func28_var_0, Func28_var_6);
      end
      else
      begin
        Func28_arg_4 := 1;
        if (global_var_152[2] > global_var_152[1]) then
        begin
          Func28_arg_4 := 2;
        end;
        if (global_var_152[3] > global_var_152[Func28_arg_4]) then
        begin
          Func28_arg_4 := 3;
        end;
        Func28_var_0 := (Func9 - (3 * global_var_77));
        if (Func28_var_0 >= global_var_152[Func28_arg_4]) then
        begin
          Func28_var_0 := global_var_152[Func28_arg_4];
          global_var_152[Func28_arg_4] := 0;
        end
        else
        begin
          global_var_152[Func28_arg_4] := (global_var_152[Func28_arg_4] - Ord(Func28_var_0));
          Func28(142, Func28_var_4, Func28_arg_0);
          Val(Func28_arg_0, Func28_var_2, Func28_var_6);
          if (Func28_var_4 = Func28_arg_4) then
          begin
            Func28_var_0 := (Func28_var_0 + Func28_var_2);
          end
          else
          begin
            global_var_152[Func28_var_4] := (global_var_152[Func28_var_4] + Func28_var_2);
          end;
        end;
      end;
    end
    else
    begin
      if (Func28_arg_8 = 139) then
      begin
        Func28_var_0 := (10 * Trunc((global_var_89 / (Random(40) + 40))));
        global_var_89 := (global_var_89 - Func28_var_0);
      end
      else
      begin
        if (Func28_arg_8 = 144) then
        begin
          Func28_var_0 := (10 * Trunc(((global_var_89 + Func8) / (Random(30) + 50))));
          if (Func28_var_0 < 100) then
          begin
            Func28_var_0 := 100;
          end;
          global_var_83 := (global_var_83 + Func28_var_0);
        end;
      end;
    end;
  end;
  Str(Func28_var_0, Func28_arg_0);
end;
procedure Func29;
begin
  Func21_var_109 := ((global_var_116[1] - 500) + (Random(11) * 100));
  Func21_var_103 := ((global_var_116[2] - 150) + (Random(7) * 50));
  Func21_var_97 := ((global_var_116[3] - 15) + (Random(8) * 5));
  Func21_var_107 := ((global_var_116[1] - 500) + (Random(11) * 100));
  Func21_var_101 := ((global_var_116[2] - 150) + (Random(7) * 50));
  Func21_var_95 := ((global_var_116[3] - 15) + (Random(8) * 5));
  Func21_var_105 := ((global_var_116[1] - 500) + (Random(11) * 100));
  Func21_var_99 := ((global_var_116[2] - 150) + (Random(7) * 50));
  Func21_var_93 := ((global_var_116[3] - 15) + (Random(8) * 5));
end;
procedure Func30(var Func30_arg_0: str_10);
var
  Func30_unused_0: arr_byte_2;
begin
  if ((Random(8) < 3) and (global_var_79 <> 1)) then
  begin
    Func30_arg_0 := Func16((Random(3) + 1));
  end
  else
  begin
    Func30_arg_0 := #32;
  end;
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
  Func31_var_103: str_35;
  Func31_var_23: arr_record_1479674575002027080_10;
  Func31_var_22: boolean;
  Func31_var_16: real;
  Func31_var_10: real;
  Func31_var_4: arr_integer_3;
  Func31_var_2: integer;
  Func31_var_0: integer;
procedure Func32(
  Func32_arg_6: integer;
  Func32_arg_4: integer;
  Func32_arg_2: integer;
  Func32_arg_0: integer
);
var
  Func32_var_8: str_6;
  Func32_var_0: str_7;
begin
  if (Func32_arg_6 = 1) then
  begin
    Func32_var_8 := '-ל ץפק';
  end
  else
  begin
    Func32_var_8 := '-ל דרי';
  end;
  Str(Func32_arg_2, Func32_var_0);
  case Func32_arg_4 of
    1:   begin
        case Func32_arg_0 of
          1:   begin
              Func21_var_107 := Func32_arg_2;
            end;
          2:   begin
              Func21_var_101 := Func32_arg_2;
            end;
          3:   begin
              Func21_var_95 := Func32_arg_2;
            end;
        end;
        GotoXY(7, (2 + (21 * (Func32_arg_6 - 1))));
        Writeln(
          'היכרותב' + global_var_122[Func32_arg_0] + '' + 'ה ריחמ':27
        );
        GotoXY(7, (3 + (21 * (Func32_arg_6 - 1))));
        Writeln('!!םילקש ' + Func32_var_0 + Func32_var_8:25);
      end;
    2:   begin
        case Func32_arg_0 of
          1:   begin
              Func21_var_109 := Func32_arg_2;
            end;
          2:   begin
              Func21_var_103 := Func32_arg_2;
            end;
          3:   begin
              Func21_var_97 := Func32_arg_2;
            end;
        end;
        GotoXY(7, (2 + (21 * (Func32_arg_6 - 1))));
        Writeln(
          'לארשיב' + global_var_122[Func32_arg_0] + '' + 'ה ריחמ':27
        );
        GotoXY(7, (3 + (21 * (Func32_arg_6 - 1))));
        Writeln('!!םילקש ' + Func32_var_0 + Func32_var_8:25);
      end;
    3:   begin
        case Func32_arg_0 of
          1:   begin
              Func21_var_105 := Func32_arg_2;
            end;
          2:   begin
              Func21_var_99 := Func32_arg_2;
            end;
          3:   begin
              Func21_var_93 := Func32_arg_2;
            end;
        end;
        GotoXY(7, (2 + (21 * (Func32_arg_6 - 1))));
        Writeln(
          'םירצמב' + global_var_122[Func32_arg_0] + '' + 'ה ריחמ':27
        );
        GotoXY(7, (3 + (21 * (Func32_arg_6 - 1))));
        Writeln('!!םילקש ' + Func32_var_0 + Func32_var_8:25);
      end;
  end;
  Func2;
end;
begin
  repeat
  begin
    Func31_var_22 := True;
    repeat
    Func31_var_183 := (Random(30) + 1);
    until (((((((((((((Func31_var_183 <> global_var_105) and (not ((Func31_var_183 in [1..2]) and (global_var_105 in [1..2]))))
 and (not ((Func31_var_183 in [3..4]) and (global_var_105 in [3..4])))) and (not ((Func31_var_183 in [5..6]) and
 (global_var_105 in [5..6])))) and (not ((Func31_var_183 in [7..8]) and (global_var_105 in [7..8])))) and (not ((Func31_var_183
 in [9..10]) and (global_var_105 in [9..10])))) and (not ((Func31_var_183 in [11..12]) and (global_var_105 in [11..12])))) and
 (not ((Func31_var_183 in [13..18]) and (global_var_105 in [13..18])))) and (not ((Func31_var_183 in [19..20]) and
 (global_var_105 in [19..20])))) and (not ((Func31_var_183 in [21..22]) and (global_var_105 in [21..22])))) and (not
 ((Func31_var_183 in [23..26]) and (global_var_105 in [23..26])))) and (not ((Func31_var_183 in [27..28]) and (global_var_105
 in [27..28])))) and (not ((Func31_var_183 in [29..30]) and (global_var_105 in [29..30]))));
    if ((global_var_89 > 20000.0) and (Random(6) = 1)) then
    begin
      Func31_var_183 := 15;
    end;
    if ((global_var_89 > 45000.0) and (Random(6) = 1)) then
    begin
      Func31_var_183 := 15;
    end;
    case Func31_var_183 of
      1..2:   begin
          PutPic(global_var_2204^, 0, 199);
          Func31_var_181 := (Random(3) + 1);
          Func31_var_179 := ((global_var_116[1] + 1100) + (100 * Random(5)));
          Func32(1, Func31_var_181, Func31_var_179, 1);
        end;
      3..4:   begin
          PutPic(global_var_2196^, 0, 199);
          Func31_var_181 := (Random(3) + 1);
          Func31_var_179 := ((global_var_116[2] + 200) + (50 * Random(4)));
          Func32(1, Func31_var_181, Func31_var_179, 2);
        end;
      5..6:   begin
          PutPic(global_var_2188^, 0, 199);
          Func31_var_181 := (Random(3) + 1);
          Func31_var_179 := ((global_var_116[3] + 20) + (Random(5) * 5));
          Func32(1, Func31_var_181, Func31_var_179, 3);
        end;
      7..8:   begin
          PutPic(global_var_2208^, 0, 199);
          Func31_var_181 := (Random(3) + 1);
          Func31_var_179 := ((global_var_116[1] - 1100) - (100 * Random(5)));
          Func32(2, Func31_var_181, Func31_var_179, 1);
        end;
      9..10:   begin
          PutPic(global_var_2200^, 0, 199);
          Func31_var_181 := (Random(3) + 1);
          Func31_var_179 := ((global_var_116[2] - 150) - (Random(3) * 50));
          Func32(2, Func31_var_181, Func31_var_179, 2);
        end;
      11..12:   begin
          PutPic(global_var_2192^, 0, 199);
          Func31_var_181 := (Random(3) + 1);
          Func31_var_179 := ((global_var_116[3] - 15) - (Random(3) * 5));
          Func32(2, Func31_var_181, Func31_var_179, 3);
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
          if (Func31_var_175 <= ((global_var_89 + global_var_95) + Func8)) then
          begin
            PutPic(global_var_2176^, 0, 199);
            GotoXY(29, 14);
            Write(Func31_var_173:3);
            if (global_var_89 > Func31_var_175) then
            begin
              Func31_var_2 := Func31_var_175;
            end
            else
            begin
              if (global_var_95 > Func31_var_175) then
              begin
                Func31_var_0 := Func31_var_175;
              end
              else
              begin
                if ((global_var_89 + global_var_95) > Func31_var_175) then
                begin
                  Func31_var_2 := Trunc(global_var_89);
                  Func31_var_0 := (Func31_var_175 - Func31_var_2);
                  Str(Func31_var_0, Func31_var_139);
                end
                else
                begin
                  Func12(1, Func31_var_169, Func31_var_10);
                  if (Func31_var_10 >= Func31_var_175) then
                  begin
                    Func31_var_163 := Round(
                      ((1.0 * Func31_var_175) / global_var_116[Func31_var_169])
                    );
                    Func31_var_4[Func31_var_169] := Func31_var_163;
                    Str(Func31_var_163, Func31_var_139);
                  end
                  else
                  begin
                    Str(global_var_152[Func31_var_169], Func31_var_139);
                    Func31_var_4[Func31_var_169] := global_var_152[Func31_var_169];
                    if ((global_var_89 > global_var_95) or (global_var_89 >= Func31_var_2)) then
                    begin
                      Func31_var_2 := (Func31_var_175 - Trunc(Func31_var_10));
                      if (Func31_var_2 > global_var_89) then
                      begin
                        Func31_var_2 := Trunc(global_var_89);
                      end;
                      Str(Func31_var_2, Func31_var_139);
                    end
                    else
                    begin
                      Func31_var_0 := (Func31_var_175 - Trunc(Func31_var_10));
                      if (Func31_var_0 > global_var_95) then
                      begin
                        Func31_var_0 := Trunc(global_var_95);
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
              Func31_var_103 := (((#46 + global_var_122[Func31_var_169]) + 'ןוט ') + Func31_var_139);
              if ((Func31_var_2 + Func31_var_0) > 0) then
              begin
                Func31_var_103 := (Func31_var_103 + ' ףסונבו');
              end;
              Write(Func31_var_103:22);
            end;
            GotoXY(18, 18);
            if Func20 then
            begin
              global_var_77 := (global_var_77 + Func31_var_173);
              global_var_89 := (global_var_89 - Func31_var_2);
              global_var_95 := (global_var_95 - Func31_var_0);
              for global_var_21 := 1 to 3 do
              begin
                global_var_152[global_var_21] := (global_var_152[global_var_21] - Func31_var_4[global_var_21]);
              end;
              PutPic(global_var_2252^, 90, 194);
              GotoXY(18, 23);
              Write('.העצוב  הבחרהה');
              Func2;
              Str(Func31_var_0, Func31_var_139);
              if (Func31_var_0 > 0) then
              begin
                if (Func31_var_2 > 0) then
                begin
                  Func3(
                    87,
                    ('ךנובשחמ וחקלנ לקש ' + Func31_var_139),
                    '.קנבב',
                    ''
                  );
                end
                else
                begin
                  Func3(
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
          if (global_var_79 < 6) then
          begin
            PutPic(global_var_2184^, 0, 199);
            GotoXY(7, 3);
            Write(global_var_152[1]:5);
            GotoXY(7, 4);
            Write(global_var_152[2]:5);
            GotoXY(7, 5);
            Write(global_var_152[3]:5);
            GotoXY(7, 6);
            Write(global_var_89:5:0);
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
              Func3(
                87,
                '...תרחמל',
                '.שדח תווצ םע דבוע התא',
                ''
              );
            end
            else
            begin
              if Func25(
                global_var_152[1],
                global_var_152[2],
                global_var_152[3],
                global_var_89
              ) then
              begin
                Func3(87, '.ךתעצה תא לביק תווצה', '', '');
              end
              else
              begin
                Func3(
                  87,
                  '.העצהל ברס תווצה',
                  'אצומ התאו םיימוי ורבע',
                  'שדח תווצ'
                );
                global_var_79 := (global_var_79 + 1);
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
            PutPic(global_var_2180^, 0, 199);
            Write(('.לקש ' + Func31_var_155):15);
          end
          else
          begin
            Func28(142, Func31_var_169, Func31_var_155);
            if (Func31_var_155 > '0') then
            begin
              PutPic(global_var_2180^, 0, 199);
              Write(
                (((#46 + global_var_122[Func31_var_169]) + ' ןוט ') + Func31_var_155):15
              );
            end
            else
            begin
              Func31_var_22 := False;
            end;
          end;
          if Func31_var_22 then
          begin
            Func2;
          end;
        end;
      23..26:   begin
          if (global_var_152[1] > 1) then
          begin
            PutPic(global_var_2172^, 0, 199);
            Func31_var_177 := ((Func21_var_109 + (50 * Random(30))) - 600);
            Str(Func31_var_177, Func31_var_147);
            Str(global_var_152[1], Func31_var_139);
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
              'ול רוכמת םא ,' + global_var_122[1] + 'לש ןוט לכל':34
            );
            GotoXY(3, WhereY);
            Writeln('.ךלש ןוטה ' + Func31_var_139 + ' תא':34);
            Writeln;
            GotoXY(3, WhereY);
            Write(
              '(ל/כ) ? ול רוכמל ןינועמ התא םאה':34
            );
            GotoXY(3, WhereY);
            if Func20 then
            begin
              global_var_89 := (global_var_89 + ((1.0 * Func31_var_177) * global_var_152[1]));
              global_var_152[1] := 0;
              GotoXY(3, (WhereY + 2));
              Write('!!! רכמנ':25);
              Func2;
            end;
          end
          else
          begin
            if (global_var_152[2] > 1) then
            begin
              PutPic(global_var_2172^, 0, 199);
              Func31_var_177 := ((Func21_var_103 + (10 * Random(70))) - 300);
              Str(Func31_var_177, Func31_var_147);
              Str(global_var_152[2], Func31_var_139);
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
                'ול רוכמת םא ,' + global_var_122[2] + 'לש ןוט לכל':34
              );
              GotoXY(3, WhereY);
              Writeln('.ךלש ןוטה ' + Func31_var_139 + ' תא':34);
              Writeln;
              GotoXY(3, WhereY);
              Write(
                '(ל/כ) ? ול רוכמל ןינועמ התא םאה':34
              );
              GotoXY(3, WhereY);
              if Func20 then
              begin
                global_var_89 := (global_var_89 + ((1.0 * Func31_var_177) * global_var_152[2]));
                global_var_152[2] := 0;
                GotoXY(3, (WhereY + 2));
                Write('!!! רכמנ':25);
                Func2;
              end;
            end
            else
            begin
              if (global_var_152[3] > 1) then
              begin
                PutPic(global_var_2172^, 0, 199);
                Func31_var_177 := ((Func21_var_97 + (5 * Random(14))) - 40);
                Str(Func31_var_177, Func31_var_147);
                Str(global_var_152[3], Func31_var_139);
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
                  'ול רוכמת םא ,' + global_var_122[3] + 'לש ןוט לכל':34
                );
                GotoXY(3, WhereY);
                Writeln('.ךלש ןוטה ' + Func31_var_139 + ' תא':34);
                Writeln;
                GotoXY(3, WhereY);
                Write(
                  '(ל/כ) ? ול רוכמל ןינועמ התא םאה':34
                );
                GotoXY(3, WhereY);
                if Func20 then
                begin
                  global_var_89 := (global_var_89 + ((1.0 * Func31_var_177) * global_var_152[3]));
                  global_var_152[3] := 0;
                  GotoXY(3, (WhereY + 2));
                  Write('!!! רכמנ':25);
                  Func2;
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
          Func31_var_177 := (5 * ((global_var_116[Func31_var_169] div 10) + (Random(global_var_116[Func31_var_169]) div 5)));
          Func31_var_16 := (Random((Trunc((0.75 * global_var_89)) + 1)) + (0.25 * global_var_89));
          Func31_var_171 := (5 * Trunc(
            (((Func31_var_16 / global_var_116[Func31_var_169]) / 5) + 1)
          ));
          if ((((1.0 * Func31_var_177) * Func31_var_171) <= global_var_89) and (global_var_89 > 0)) then
          begin
            PutPic(global_var_2172^, 0, 199);
            Str(Func31_var_177, Func31_var_147);
            Str(Func31_var_171, Func31_var_139);
            if (Func31_var_139 = '1') then
            begin
              Func31_var_139 := '';
            end;
            GotoXY(3, 2);
            Writeln(
              global_var_122[Func31_var_169] + ' ןוט ' + Func31_var_139 + ' ךל רוכמל ןינועמ רחוס':34
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
            if Func20 then
            begin
              global_var_89 := (global_var_89 - (Func31_var_177 * Func31_var_171));
              case Func31_var_169 of
                1:   begin
                    global_var_152[1] := (global_var_152[1] + Func31_var_171);
                  end;
                2:   begin
                    global_var_152[2] := (global_var_152[2] + Func31_var_171);
                  end;
                3:   begin
                    global_var_152[3] := (global_var_152[3] + Func31_var_171);
                  end;
              end;
              Writeln;
              Writeln('            !!! תינק':25);
              Func2;
            end;
          end
          else
          begin
            Func31_var_22 := False;
          end;
        end;
      29..30:   begin
          Func31_var_167 := (10 * Trunc(((Func8 + global_var_89) / (Random(80) + 150))));
          if (Func31_var_167 > 0) then
          begin
            ShowScrFile((BasePath + 'fishing.scr'));
            global_var_83 := (global_var_83 + Func31_var_167);
            GotoXY(20, 3);
            Write(Func31_var_167:4);
            Func2;
          end
          else
          begin
            Func31_var_22 := False;
          end;
        end;
    end;
  end
  until Func31_var_22;
  global_var_105 := Func31_var_183;
end;
procedure Func33;
var
  Func33_var_8: PSgnBuffer;
  Func33_var_0: str_7;
begin
  Str(global_var_79, Func33_var_0);
  Func33_var_8 := LoadSgnFile(('day' + Func33_var_0));
  ShowScrFile((BasePath + 'newday.scr'));
  PutPic(Func33_var_8^, 165, 89);
  Dispose(Func33_var_8);
  Func2;
end;
procedure Func34(
  Func34_arg_4: integer;
  Func34_arg_2: integer;
  Func34_arg_0: integer
);
var
  Func34_unused_96: arr_byte_2;
  Func34_var_94: integer;
  Func34_var_92: integer;
  Func34_var_86: real;
  Func34_var_80: real;
  Func34_var_0: arr_record_1479674575002027080_10;
begin
  Func34_var_80 := 0;
  if (global_var_89 < Func34_arg_0) then
  begin
    Func3(
      87,
      'ךל רשפאמ וניא ךפסכ',
      'תורוחס תינק',
      ''
    );
  end
  else
  begin
    case Func15(global_var_33) of
      1:   begin
          PutPic(global_var_2096^, 1, 142);
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
      2:   begin
          PutPic(global_var_2092^, 1, 142);
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
      3:   begin
          PutPic(global_var_2100^, 1, 142);
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
      if (global_var_89 < Func34_var_94) then
      begin
        Func3(
          87,
          'ךל רשפאמ וניא ךפסכ',
          (global_var_122[Func34_var_92] + 'תונקל'),
          ''
        );
      end
      else
      begin
        repeat
        begin
          PutPic(global_var_2228^, 22, 138);
          GotoXY(6, 15);
          Write(Trunc((global_var_89 / Func34_var_94)));
          GotoXY(6, 17);
          Func34_var_80 := Func18(0, 0, 8);
          Func34_var_86 := ((1.0 * Func34_var_80) * Func34_var_94);
        end
        until (not Func24(Func34_var_86));
      end;
      if (Func34_var_80 > 0) then
      begin
        global_var_89 := (global_var_89 - Func34_var_86);
        global_var_152[Func34_var_92] := (global_var_152[Func34_var_92] + Trunc(Func34_var_80));
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
  Func35_unused_94: arr_byte_2;
  Func35_var_92: integer;
  Func35_var_86: real;
  Func35_var_80: real;
  Func35_var_0: arr_record_1479674575002027080_10;
function Func36(Func36_arg_2: real; Func36_arg_0: integer): boolean;
begin
  if (Func36_arg_2 > global_var_152[Func36_arg_0]) then
  begin
    Func3(
      87,
      'הברה ךכ-לכ ךל ןיא',
      ('רוכמל' + global_var_122[Func36_arg_0]),
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
  if (((global_var_152[1] = 0) and (global_var_152[2] = 0)) and (global_var_152[3] = 0)) then
  begin
    Func3(
      87,
      #32,
      'רוכמל  הרוחס  ךל  ןיא',
      #32
    );
  end
  else
  begin
    case Func15(global_var_33) of
      1:   begin
          PutPic(global_var_2108^, 0, 142);
        end;
      2:   begin
          PutPic(global_var_2104^, 0, 142);
        end;
      3:   begin
          PutPic(global_var_2112^, 0, 142);
        end;
    end;
    Func35_var_0[1].field_0 := 19;
    Func35_var_0[1].field_2 := 26;
    Func35_var_0[2].field_0 := 19;
    Func35_var_0[2].field_2 := 42;
    Func35_var_0[3].field_0 := 19;
    Func35_var_0[3].field_2 := 58;
    if (global_var_33 = 'םירצמ') then
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
      if (global_var_152[Func35_var_92] > 0) then
      begin
        repeat
        begin
          PutPic(global_var_2232^, 120, 60);
          GotoXY(21, 7);
          Func35_var_80 := Func18(0, 0, 8);
        end
        until (not Func36(Func35_var_80, Func35_var_92));
      end
      else
      begin
        Func3(
          87,
          (('רוכמל' + global_var_122[Func35_var_92]) + 'ךל ןיא'),
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
      global_var_89 := (global_var_89 + Func35_var_86);
      global_var_152[Func35_var_92] := (global_var_152[Func35_var_92] - Trunc(Func35_var_80));
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
  PutPic(global_var_2088^, 0, 142);
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
        if (global_var_89 <= 0) then
        begin
          Func3(
            87,
            #32,
            ('! דיקפהל ףסכ ךל ןיא' + ''),
            #32
          );
        end
        else
        begin
          repeat
          begin
            PutPic(global_var_2240^, 11, 139);
            GotoXY(5, 17);
            Func37_var_0 := Func18(0, 0, 8);
            if (Func37_var_0 <= 0) then
            begin
              Func37_var_86 := 1;
            end
            else
            begin
              if (Func37_var_0 <= global_var_89) then
              begin
                global_var_95 := (global_var_95 + Func37_var_0);
                global_var_89 := (global_var_89 - Func37_var_0);
                Func3(
                  87,
                  #32,
                  'ףסכה תא לביק קנבה דיקפ',
                  #32
                );
                Func37_var_86 := 1;
              end
              else
              begin
                Func3(
                  87,
                  #32,
                  ('! ףסכ הברה ךכ לכ ךל ןיא' + ''),
                  #32
                );
              end;
            end;
          end
          until (Func37_var_86 = 1);
        end;
      end;
    2:   begin
        if (global_var_95 > 0) then
        begin
          repeat
          begin
            PutPic(global_var_2236^, 11, 139);
            GotoXY(5, 17);
            Func37_var_0 := Func18(0, 0, 8);
            if (Func37_var_0 < 0) then
            begin
              Func37_var_86 := 1;
            end
            else
            begin
              if (Func37_var_0 <= global_var_95) then
              begin
                GotoXY(1, 1);
                global_var_95 := (global_var_95 - Func37_var_0);
                global_var_89 := (global_var_89 + Func37_var_0);
                if (not (Func37_var_0 = 0)) then
                begin
                  Func3(87, #32, 'ףסכה תא תלביק', #32);
                end;
                Func37_var_86 := 1;
              end
              else
              begin
                Func3(
                  87,
                  #32,
                  ('! קנבב הזכ ףסכ םוכס ךל ןיא' + ''),
                  #32
                );
              end;
            end;
          end
          until (Func37_var_86 = 1);
        end
        else
        begin
          Func3(
            87,
            #32,
            ('! קנבב ףסכ ךל ןיא' + ''),
            #32
          );
        end;
      end;
  end;
end;
function Func38(Func38_arg_0: integer): boolean;
var
  Func38_unused_0: arr_byte_3;
begin
  if (Func38_arg_0 > global_var_77) then
  begin
    PutPic(global_var_2152^, 0, 142);
    GotoXY(53, 16);
    if Func20 then
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
procedure Func39(Func39_arg_0: str_10);
var
  Func39_var_0: PWinBuffer;
begin
  case Func15(Func39_arg_0) of
    1:   begin
        Func21_var_6 := 256;
        Func21_var_4 := 303;
      end;
    2:   begin
        Func21_var_6 := 147;
        Func21_var_4 := 190;
      end;
    3:   begin
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
procedure Func40(Func40_arg_0: str_10);
var
  Func40_var_173: boolean;
  Func40_var_172: boolean;
  Func40_var_170: integer;
  Func40_var_168: integer;
  Func40_unused_167: arr_byte_1;
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
  if (global_var_89 > 10000.0) then
  begin
    GotoXY(33, 17);
  end;
  if (global_var_89 > 100000.0) then
  begin
    GotoXY(32, 17);
  end;
  Write(Func10(global_var_89):5);
  PutPic(global_var_2064^, 0, 142);
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
  GetPic(global_var_2064^, 0, 0, 240, 142);
end;
procedure Func42(
  Func42_arg_6: real;
  Func42_arg_4: integer;
  Func42_arg_2: integer;
  Func42_arg_0: integer
);
var
  Func42_unused_38: arr_byte_4;
  Func42_var_36: integer;
  Func42_var_34: integer;
  Func42_var_32: integer;
  Func42_var_24: str_7;
  Func42_var_13: str_10;
  Func42_var_12: byte;
  Func42_var_10: integer;
  Func42_var_8: integer;
  Func42_unused_2: arr_byte_6;
  Func42_var_1: boolean;
  Func42_var_0: boolean;
procedure Func43(Func43_arg_2: integer; Func43_arg_0: integer);
var
  Func43_var_106: integer;
  Func43_var_104: integer;
  Func43_var_102: integer;
  Func43_var_100: integer;
  Func43_var_98: integer;
  Func43_var_92: str_5;
  Func43_var_12: arr_record_1479674575002027080_10;
  Func43_var_6: real;
  Func43_var_0: real;
procedure Func44(Func44_arg_0: integer);
begin
  if (Random(Func44_arg_0) = 0) then
  begin
    Func43_var_0 := (10 * Trunc(
      (((Random(15) + 5) / 1000.0) * (global_var_89 + Func8))
    ));
    Str(Func43_var_0:1:0, Func43_var_92);
    global_var_83 := (global_var_83 + Func43_var_0);
    if (Func44_arg_0 = 2) then
    begin
      Func3(
        87,
        'םרגנ ,ףסונב',
        'יוושב קזנ הניפסל',
        ('.םילקש ' + Func43_var_92)
      );
    end
    else
    begin
      Func3(
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
  Func45_unused_0: arr_byte_1;
begin
  PutPic(global_var_2120^, 0, 142);
  Func45_var_7 := Random(4);
  if ((Func45_var_7 < (Func43_arg_2 - Func43_var_98)) or (((Func43_arg_2 - Func43_var_98) <= 0) and (Random(6) = 1))) then
  begin
    Func3(
      87,
      '- ךשוממ ברק רחאל',
      '! םיטריפה תא תסבה',
      ''
    );
    if (Random(3) = 1) then
    begin
      global_var_77 := (global_var_77 + 50);
      Func3(
        87,
        'תניפס תא יבשב תחקל',
        'הניפסה תלוביקו ,םיה ידדוש',
        '.ןוט 50-ב הלדג ךלש'
      );
    end
    else
    begin
      Func43_arg_2 := (Func43_arg_2 + Func43_var_98);
      Func43_var_6 := ((Int((((global_var_89 + Func8) + global_var_95) / 100)) * (Random(15) + 5)) + ((Func43_arg_2 *
 ((global_var_89 + Func8) + global_var_95)) / 10));
      if (Func43_var_6 < 100) then
      begin
        Func43_var_6 := 100;
      end;
      Func43_var_6 := (5 * Int((Func43_var_6 / 5)));
      Str(Func43_var_6:1:0, Func43_var_92);
      Func3(
        87,
        ' לש ןומטמ תאצמ',
        ('םתניפס לע לקש ' + Func43_var_92),
        ''
      );
      global_var_89 := (global_var_89 + Func43_var_6);
    end;
    Func44(4);
  end
  else
  begin
    Str(Func43_arg_2, Func43_var_92);
    if (Func43_arg_2 = 0) then
    begin
      Func3(
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
        Func3(
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
          Func3(
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
    if (Func45_var_1 > global_var_89) then
    begin
      Func43_var_0 := (((1.0 * (Random(15) + 5)) * global_var_152[Func42_var_36]) / 100);
      if (Func43_arg_2 < 3) then
      begin
        Func43_var_0 := (Func43_var_0 + (((3 - Func43_arg_2) * global_var_152[Func42_var_36]) div 10));
      end;
      if (Func43_var_0 < 1) then
      begin
        Func43_var_0 := 1;
      end;
      global_var_152[Func42_var_36] := (global_var_152[Func42_var_36] - Trunc(Func43_var_0));
      Str(Trunc(Func43_var_0):1, Func42_var_24);
      Func3(
        87,
        '     השק ברק ירחא',
        ' םיה ידדוש ךממ ובנג',
        ((global_var_122[Func42_var_36] + 'ןוט ') + Func42_var_24)
      );
      Func44(2);
    end
    else
    begin
      if (global_var_89 > 500) then
      begin
        Func43_var_0 := (10 * Trunc(
          (Random(Trunc((0.015 * global_var_89))) + (global_var_89 / 200))
        ));
        if (Func43_arg_2 < 3) then
        begin
          Func43_var_0 := (Func43_var_0 + ((3 - Func43_arg_2) * Trunc((global_var_89 / 10))));
        end;
        Func43_var_0 := Trunc(Func43_var_0);
        global_var_89 := (global_var_89 - Func43_var_0);
        Str(Func43_var_0:1:0, Func42_var_24);
        Func3(
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
          ((((Random(15) + 35) - (10 * Func43_arg_2)) / 1000) * ((Func8 + global_var_89) + global_var_95))
        ) * 10);
        if (Func43_var_0 < 100) then
        begin
          Func43_var_0 := 100;
        end;
        Str(Func43_var_0:1:0, Func43_var_92);
        global_var_83 := (global_var_83 + Func43_var_0);
        Func3(
          87,
          'ךתניפס ,ךלזמ עורל',
          '.ברקה ידכ ךות העגפנ',
          (('ח"ש ' + Func43_var_92) + ' קזנה יווש')
        );
      end;
    end;
  end;
  Func22;
end;
begin
  PutPic(global_var_2116^, 0, 142);
  Func2;
  PutPic(global_var_2244^, 4, 139);
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
        PutPic(global_var_2124^, 0, 142);
        if (Func43_arg_0 > (0.81 * global_var_77)) then
        begin
          Func43_var_102 := 0;
        end
        else
        begin
          Func43_var_106 := (((global_var_77 div 30) - (Func43_arg_0 div 30)) + 1);
          if (Func43_var_106 < 1) then
          begin
            Func43_var_106 := 1;
          end;
          Func43_var_102 := Random(Func43_var_106);
        end;
        if (Func43_var_102 > 0) then
        begin
          Func43_var_100 := Random(((Trunc(global_var_83) div 30) + 1));
        end;
        if (Func43_var_100 > 0) then
        begin
          Func43_var_102 := 0;
        end;
        if (Func43_var_102 = 0) then
        begin
          if (Func43_arg_0 > (0.5 * global_var_77)) then
          begin
            Func3(
              87,
              'אלו ,ידמ הדבכ ךתניפס',
              'חורבל החילצה',
              ''
            );
          end
          else
          begin
            if (global_var_83 > 0) then
            begin
              Func3(
                87,
                'בקע חורבל תחלצה אל',
                'ךתניפסבש קזנה',
                ''
              );
            end
            else
            begin
              Func3(
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
          Func3(87, '', '! !  םהמ  טלמהל  תחלצה', '');
        end;
      end;
    3:   begin
        Func43_var_98 := 1;
        PutPic(global_var_2128^, 0, 142);
        if Func25(
          global_var_152[1],
          global_var_152[2],
          global_var_152[3],
          global_var_89
        ) then
        begin
          Func3(
            87,
            'לבקל וטילחה םיה ידדוש',
            'ךתעצה תא',
            ''
          );
          Func22;
        end
        else
        begin
          Func3(
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
  if (Func46_arg_0 > (global_var_77 + 70)) then
  begin
    Func46_var_0 := 1;
  end
  else
  begin
    if (Func46_arg_0 > (global_var_77 + 60)) then
    begin
      Func46_var_0 := 2;
    end
    else
    begin
      if (Func46_arg_0 > (global_var_77 + 40)) then
      begin
        Func46_var_0 := 3;
      end
      else
      begin
        if (Func46_arg_0 > (global_var_77 + 20)) then
        begin
          Func46_var_0 := 4;
        end
        else
        begin
          if (Func46_arg_0 > global_var_77) then
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
  PutPic(global_var_2076^, 0, 142);
  Func42_var_13 := global_var_55;
  if (global_var_55 = 'לארשי') then
  begin
    global_var_55 := 'היכרות';
  end
  else
  begin
    global_var_55 := 'לארשי';
  end;
  Delay(1500);
  Func3(
    87,
    'תוקזח תוחורמ האצותכ',
    'תעגה ,טוונב תועטו',
    (((Func42_var_13 + 'ל םוקמב ') + global_var_55) + 'ל')
  );
  if ((global_var_44 = 'םירצמ') and (global_var_55 = 'היכרות')) then
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
    if (Func42_var_0 or Func42_var_1) then
    begin
      Func3(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
      if ((global_var_66 = global_var_33) or (global_var_66 = global_var_55)) then
      begin
        PutPic(global_var_2136^, 0, 142);
        Func2;
        if (Func8 > 10000) then
        begin
          Func28(142, Func42_var_36, Func42_var_24);
          Func3(
            87,
            'ךתניפסמ ופטש םיהובגה םילגה',
            (((#46 + global_var_122[Func42_var_36]) + ' ןוט ') + Func42_var_24),
            ''
          );
          Func22;
        end
        else
        begin
          Func28(144, Func42_var_36, Func42_var_24);
          Func3(
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
        if (global_var_81 > 16) then
        begin
          PutPic(global_var_2072^, 0, 142);
          Func3(
            87,
            'םיעורגה תוארה יאנת בקע',
            '.ןוטרש לע תילע - הלילב',
            ''
          );
          Func3(
            87,
            'קזנ ךתניפסל םרגנ',
            (('.ח"ש ' + Func42_var_24) + ' יוושב'),
            ''
          );
        end
        else
        begin
          PutPic(global_var_2140^, 0, 142);
          if Func42_var_0 then
          begin
            Func3(
              87,
              'הקוזינה ךתניפסב העיסנה',
              (Func42_var_24 + '-ב קזנה תא הרימחה'),
              '.םיפסונ לקש'
            );
          end
          else
          begin
            Func3(
              87,
              'קזנ ךתניפסל םרגנ',
              (('.ח"ש ' + Func42_var_24) + ' יוושב'),
              ''
            );
          end;
        end;
      end;
    end
    else
    begin
      Func48;
    end;
    global_var_109 := True;
  end;
  if ((not global_var_109) and (Func42_arg_4 > global_var_77)) then
  begin
    if Func46(Func42_arg_4) then
    begin
      Func3(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
      PutPic(global_var_2132^, 0, 142);
      Func2;
      Func28(153, Func42_var_36, Func42_var_24);
      Func3(
        87,
        'םיל ךילשהל תצלאנ',
        ((global_var_122[Func42_var_36] + 'ןוט ') + Func42_var_24),
        ''
      );
      Func22;
      global_var_109 := True;
    end;
  end;
  if ((not global_var_109) and (((global_var_81 + Func42_arg_2) + (Func42_arg_2 div 2)) <= 20)) then
  begin
    if (Random(12) = 0) then
    begin
      Func42_var_10 := Func40_var_5;
      Func42_var_8 := Func40_var_3;
      Func42_var_12 := Func15(global_var_55);
      Func41(
        Func42_var_10,
        Func42_var_8,
        global_var_264[Func42_var_12].field_0,
        global_var_264[Func42_var_12].field_2,
        9
      );
      if (Random(2) = 1) then
      begin
        Func3(
          87,
          (('תינמז רוגס ' + global_var_55) + ' למנ'),
          'דבכ לפרע בקע',
          ''
        );
      end
      else
      begin
        PutPic(global_var_2080^, 0, 142);
        Func2;
        Func3(
          87,
          'םישובישו התיבש לשב',
          (global_var_55 + ' למנ ,הדובעב'),
          'רוגס '
        );
      end;
      Func3(
        87,
        '',
        (global_var_44 + 'ל רוזחל ךילע'),
        ''
      );
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
  Func42_var_34 := (Random(20) + 1);
  if (global_var_81 >= 16) then
  begin
    if (Func42_var_34 > 15) then
    begin
      Func42_var_34 := 1;
    end;
  end;
  if (not global_var_109) then
  begin
    case Func42_var_34 of
      1..6:   begin
          Func3(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
          global_var_109 := True;
          Func43(Func40_var_1, Func42_arg_4);
        end;
      7:   begin
          Func48;
        end;
      9, 10:   begin
          Func3(87, '', 'ה ר צ ע נ   ה נ י פ ס ה', '');
          PutPic(global_var_2160^, 0, 142);
          Func42_var_36 := 0;
          repeat
          begin
            Func42_var_36 := (Func42_var_36 + 1);
            Func42_var_32 := Trunc(
              ((((Random(25) + 11) / 100.0) * (global_var_89 + Func8)) / global_var_116[Func42_var_36])
            );
            if (Func42_var_32 > 0) then
            begin
              GotoXY(45, 16);
              Write(
                global_var_122[Func42_var_36],
                ' ןוט ',
                Func42_var_32
              );
              case Func42_var_36 of
                1:   begin
                    global_var_152[1] := (global_var_152[1] + Func42_var_32);
                  end;
                2:   begin
                    global_var_152[2] := (global_var_152[2] + Func42_var_32);
                  end;
                3:   begin
                    global_var_152[3] := (global_var_152[3] + Func42_var_32);
                  end;
              end;
              global_var_109 := True;
            end;
          end
          until (global_var_109 or (Func42_var_36 = 3));
          Func2;
          Func22;
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
  Func50_var_80: str_35;
  Func50_var_44: str_35;
  Func50_var_8: str_35;
  Func50_var_0: str_7;
begin
  PutPic(global_var_2156^, 0, 142);
  Func50_var_116 := (5 * Trunc(((Func8 + global_var_89) / (200 + Random(100)))));
  if (Func50_var_116 < 75) then
  begin
    Func50_var_116 := 75;
  end;
  if (Func50_arg_0 > 0) then
  begin
    Func50_var_116 := (Func50_var_116 + (Func50_var_116 / 3));
  end;
  Func50_var_116 := (5 * Int((Func50_var_116 / 5)));
  Str(Func50_var_116:1:0, Func50_var_0);
  GotoXY(1, 15);
  Func50_var_8 := '? הצור התא תוניפס המכ';
  if (Func50_var_116 <= global_var_89) then
  begin
    Func50_var_44 := ('ח"ש ' + Func50_var_0);
    if (Func50_arg_0 = 0) then
    begin
      Func50_var_80 := 'רמשמ תניפס לכ ריחמ';
    end
    else
    begin
      Func50_var_80 := 'םישרוד רמשמה תוניפס ילעב';
      if ((global_var_66 = global_var_33) or (global_var_66 = global_var_55)) then
      begin
        Func50_var_44 := ('.רעוסה םיה לשב ,' + Func50_var_44);
      end
      else
      begin
        Func50_var_44 := ('רבגומה ןוכיסה לשב ' + Func50_var_44);
      end;
    end;
    Func3(78, Func50_var_80, Func50_var_44, Func50_var_8);
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
    Func3(
      78,
      'םלשל ףסכ ךל ןיא',
      'רמשמ תוניפסל',
      ''
    );
    Func40_var_1 := 0;
    repeat
    global_var_107 := Func1;
    until (global_var_107 in [#13, #27]);
    if (global_var_107 = #27) then
    begin
      Func40_var_1 := -1;
    end;
  end;
  if (Func40_var_1 > 0) then
  begin
    global_var_89 := (global_var_89 - (Func40_var_1 * Func50_var_116));
  end;
end;
begin
  Func50(global_var_103);
  if (Func40_var_1 < 0) then
  begin
    global_var_55 := global_var_44;
  end
  else
  begin
    Func49_var_0 := ((Func40_var_0 - Ord(global_var_81)) div 2);
    Func40_var_0 := (Func40_var_0 - Ord(Func49_var_0));
    Func49_var_3 := Func15(global_var_44);
    Func49_var_2 := Func15(global_var_55);
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
      global_var_83,
      Func9,
      Func40_var_170,
      global_var_103
    );
    Func49_var_2 := Func15(global_var_55);
    Func49_var_1 := global_var_200[Func49_var_3, Func49_var_2];
    if (Func49_var_1 > 0) then
    begin
      Func49_var_0 := (Func49_var_0 div 2);
      Func40_var_0 := (Func40_var_0 - Ord(Func49_var_0));
    end;
    while (Func49_var_1 > 0) do
    begin
      Func41(
        global_var_264[Func49_var_3].field_0,
        global_var_264[Func49_var_3].field_2,
        global_var_264[Func49_var_1].field_0,
        global_var_264[Func49_var_1].field_2,
        9
      );
      Func40_var_0 := (global_var_81 + Func49_var_0);
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
    begin
      Func3(78, '', '! !  ם ו ל ש ב   ת ע ג ה', '');
    end;
  end;
end;
begin
  Func40_var_170 := 0;
  global_var_44 := global_var_33;
  Func40_var_173 := False;
  global_var_103 := 0;
  PutPic(global_var_2064^, 0, 142);
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
    if (global_var_23 <> Func15(global_var_44)) then
    begin
      Func40_var_7[global_var_21] := Func40_var_87[global_var_23];
      global_var_21 := (global_var_21 + 1);
    end;
  end;
  case Func15(global_var_33) of
    1:   begin
        Func40_var_168 := (Func17(Func40_var_7, 2) + 1);
      end;
    2:   begin
        Func40_var_168 := ((Func17(Func40_var_7, 2) * 2) - 1);
      end;
    3:   begin
        Func40_var_168 := Func17(Func40_var_7, 2);
      end;
  end;
  if (Func40_var_168 > 0) then
  begin
    global_var_55 := Func16(Func40_var_168);
    if ((global_var_44 = 'לארשי') or (global_var_55 = 'לארשי')) then
    begin
      Func40_var_170 := 4;
    end
    else
    begin
      Func40_var_170 := 8;
    end;
    if ((not Func40_var_173) and ((global_var_81 + Func40_var_170) > 20)) then
    begin
      Func3(
        87,
        'תרחואמ העשה',
        'עיגהל לכות אלו',
        'םויה םשל'
      );
      global_var_55 := global_var_44;
      Func40_var_173 := True;
    end;
    if (not Func40_var_173) then
    begin
      if ((global_var_81 + Func40_var_170) > 16) then
      begin
        PutPic(global_var_2148^, 0, 142);
        GotoXY(4, 17);
        if (not Func20) then
        begin
          Func40_var_1 := -1;
        end
        else
        begin
          Func40_var_0 := (global_var_81 + Func40_var_170);
          global_var_103 := 2;
          if ((Func40_arg_0 = global_var_33) or (Func40_arg_0 = global_var_55)) then
          begin
            global_var_103 := 4;
          end;
          Func49;
        end;
      end
      else
      begin
        if ((Func40_arg_0 = global_var_33) or (Func40_arg_0 = global_var_55)) then
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
    global_var_33 := global_var_55;
    if (Func40_var_1 >= 0) then
    begin
      GotoXY(73, 1);
      Write(global_var_33:6);
      Func39(global_var_44);
      Func39(global_var_33);
      Func2;
    end;
  end;
end;
procedure Func51(var Func51_arg_0: real);
var
  Func51_var_11: integer;
  Func51_var_0: str_10;
function Func52(Func52_arg_0: real): boolean;
begin
  if (Func52_arg_0 > 0) then
  begin
    if (Func52_arg_0 > global_var_89) then
    begin
      Func3(
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
    PutPic(global_var_2144^, 0, 142);
    GotoXY(21, 17);
    Write(Func51_arg_0:4:0);
    GotoXY(5, 17);
    Func51_var_11 := Trunc(Func18(0, 0, 5));
  end
  until (not Func52(Func51_var_11));
  if (Func51_var_11 >= 0) then
  begin
    global_var_89 := (global_var_89 - Func51_var_11);
    Func51_arg_0 := (Func51_arg_0 - Func51_var_11);
    if (Func51_arg_0 < 0) then
    begin
      Func51_arg_0 := 0;
    end;
    Str(Func51_arg_0:1:0, Func51_var_0);
    if (Func51_arg_0 = 0) then
    begin
      Func3(
        87,
        '',
        'ןיטולחל הניקת תעכ הניפסה',
        ''
      );
    end
    else
    begin
      Func3(
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
  Func53 := (global_var_83 > ((global_var_89 + global_var_95) + Func8));
end;
begin
  GotoXY(1, 2);
  global_var_81 := 8;
  Func21_var_88 := False;
  Func29;
  Func33;
  if (global_var_79 = 7) then
  begin
    Func3(
      87,
      '.ןורחאה רחסמה םוי והז',
      'םויה ףוסב רוכמל רוכז',
      ',ךתרוחס לכ תא'
    );
    Func3(
      87,
      'רובצתש תודוקנהש ןויכמ',
      'םוכס יפ לע הנעבקת',
      '! ךדיב רתוויש ףסכה'
    );
  end;
  Func30(global_var_66);
  Func13;
  GotoXY(1, 10);
  if (global_var_79 > 1) then
  begin
    Func31;
  end;
  if (not ((global_var_79 > 7) or Func21_var_88)) then
  begin
    PutPic(global_var_2216^, 0, 199);
    GetPic(global_var_2060^, 0, 0, 240, 142);
    Func39(global_var_33);
    repeat
    begin
      PutPic(global_var_2060^, 0, 142);
      Func22;
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
      if (global_var_83 = 0) then
      begin
        Func21_var_91 := 5;
      end
      else
      begin
        PutPic(global_var_2224^, 35, 123);
        Func21_var_91 := 6;
      end;
      Func21_var_89 := Func17(Func21_var_8, Func21_var_91);
      case Func21_var_89 of
        1:   begin
            if (global_var_33 = 'לארשי') then
            begin
              Func34(Func21_var_109, Func21_var_103, Func21_var_97);
            end
            else
            begin
              if (global_var_33 = 'היכרות') then
              begin
                Func34(Func21_var_107, Func21_var_101, Func21_var_95);
              end
              else
              begin
                Func34(Func21_var_105, Func21_var_99, Func21_var_93);
              end;
            end;
          end;
        2:   begin
            if (global_var_33 = 'לארשי') then
            begin
              Func35(Func21_var_109, Func21_var_103, Func21_var_97);
            end;
            if (global_var_33 = 'היכרות') then
            begin
              Func35(Func21_var_107, Func21_var_101, Func21_var_95);
            end;
            if (global_var_33 = 'םירצמ') then
            begin
              Func35(Func21_var_105, Func21_var_99, Func21_var_93);
            end;
          end;
        3:   begin
            if (global_var_81 > 16) then
            begin
              Func3(
                87,
                'עוסנל ןתינ אל',
                'תרחואמ הכ העשב',
                ''
              );
            end
            else
            begin
              if (global_var_83 > 1000) then
              begin
                Func3(
                  87,
                  'וניא ךתניפסל םרגנש קזנה',
                  '.גילפהל ךל רשפאמ',
                  ''
                );
              end
              else
              begin
                if (not Func38(Func9)) then
                begin
                  Func40(global_var_66);
                end;
              end;
            end;
          end;
        4:   begin
            if (global_var_101 = global_var_79) then
            begin
              Func3(87, '', 'םויה  רוגס  קנבה ', '');
            end
            else
            begin
              Func37;
            end;
          end;
        5:   begin
            PutPic(global_var_2068^, 0, 142);
            if (global_var_79 = 7) then
            begin
              Func3(
                78,
                ',םיתסה רחסמה עובש',
                'קחשמה םויסל  ───┘  שקה',
                ''
              );
            end;
            repeat
            global_var_107 := Func1;
            until (global_var_107 in [#27, #13]);
          end;
        6:   begin
            if (global_var_110 <> global_var_79) then
            begin
              Func51(global_var_83);
            end
            else
            begin
              Func3(
                87,
                'רוגס למנב םינוקיתה ףיצר',
                'ןיתמהל ץלאת - םויה',
                'רחמ דע'
              );
            end;
          end;
      end;
    end
    until ((Func21_var_89 = 5) and (global_var_107 <> #27));
    if ((global_var_79 < 7) and Func53) then
    begin
      global_var_79 := 7;
      Func3(
        87,
        'תא ןקתל ךתורשפאב ןיא',
        '-ךתניפסל םרגנש קזנה',
        '! !  ם י ת ס ה   ק ח ש מ ה'
      );
    end;
  end;
end;
procedure Func54;
var
  Func54_var_93: byte;
  Func54_var_92: byte;
  Func54_var_16: file;
  Func54_var_0: str_15;
begin
  GraphColorMode;
  TextColor(3);
  Palette(0);
  GraphBackground(1);
  GetDir(0, Func54_var_0);
  if (Func54_var_0 = 'A:\') then
  begin
    BasePath := 'B:\';
  end
  else
  begin
    BasePath := '\kika\socher_b\';
  end;
  ShowScrFile((BasePath + 'mifne.scr'));
  Func2;
  ShowScrFile((BasePath + 'credits.scr'));
  global_var_116[1] := 3000;
  global_var_116[2] := 500;
  global_var_116[3] := 50;
  global_var_122[1] := ' תשוחנ ';
  global_var_122[2] := ' םיתיז ';
  global_var_122[3] := ' הטיח ';
  global_var_158[1] := 'ןושאר';
  global_var_158[2] := '  ינש';
  global_var_158[3] := 'ישילש';
  global_var_158[4] := 'יעיבר';
  global_var_158[5] := 'ישימח';
  global_var_158[6] := ' ישיש';
  global_var_158[7] := 'יעיבש';
  global_var_2216 := LoadScrFile('mainscrn');
  global_var_2168 := LoadScrFile('newday');
  global_var_2220 := LoadScrFile('help');
  global_var_2184 := LoadScrFile('crew');
  global_var_2172 := LoadScrFile('socher');
  global_var_2176 := LoadScrFile('expand');
  global_var_2180 := LoadScrFile('thieves');
  global_var_2188 := LoadScrFile('wheatup');
  global_var_2192 := LoadScrFile('wheatdn');
  global_var_2196 := LoadScrFile('olivesup');
  global_var_2200 := LoadScrFile('olivesdn');
  global_var_2204 := LoadScrFile('copperup');
  global_var_2208 := LoadScrFile('copperdn');
  New(global_var_2060);
  global_var_2068 := LoadWinFile('stay');
  global_var_2144 := LoadWinFile('repair');
  global_var_2160 := LoadWinFile('deserted');
  global_var_2140 := LoadWinFile('damaged');
  global_var_2148 := LoadWinFile('night');
  global_var_2152 := LoadWinFile('overwght');
  global_var_2156 := LoadWinFile('guards');
  global_var_2116 := LoadWinFile('pirates');
  global_var_2120 := LoadWinFile('confront');
  global_var_2124 := LoadWinFile('runaway');
  global_var_2128 := LoadWinFile('offer');
  global_var_2076 := LoadWinFile('change');
  global_var_2132 := LoadWinFile('sinking');
  global_var_2136 := LoadWinFile('storm');
  global_var_2072 := LoadWinFile('sirton');
  global_var_2080 := LoadWinFile('strike');
  global_var_2084 := LoadWinFile('arafel');
  global_var_2088 := LoadWinFile('bank');
  global_var_2096 := LoadWinFile('buyturk');
  global_var_2092 := LoadWinFile('buyisr');
  global_var_2100 := LoadWinFile('buyegpt');
  global_var_2108 := LoadWinFile('sellturk');
  global_var_2104 := LoadWinFile('sellisr');
  global_var_2112 := LoadWinFile('sellegpt');
  global_var_2228 := LoadSgnFile('buy');
  global_var_2232 := LoadSgnFile('sell');
  global_var_2236 := LoadSgnFile('withrow');
  global_var_2240 := LoadSgnFile('deposit');
  global_var_2252 := LoadSgnFile('message');
  global_var_2244 := LoadSgnFile('pirates');
  New(global_var_2224);
  Assign(Func54_var_16, 'line_6.lin');
  Reset(Func54_var_16);
  BlockRead(Func54_var_16, global_var_2224^, 3);
  Close(Func54_var_16);
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
  for Func54_var_93 := 1 to 8 do
  begin
    for Func54_var_92 := 1 to 8 do
    begin
      global_var_200[Func54_var_93, Func54_var_92] := 0;
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
  Func2;
end;
procedure Func55;
begin
  ShowScrFile((BasePath + 'intro.scr'));
  global_var_2064 := LoadWinFile('map');
  global_var_108 := 1;
  global_var_95 := 0;
  global_var_77 := 100;
  global_var_33 := 'לארשי';
  global_var_66 := #32;
  global_var_83 := 0;
  global_var_110 := (Random(7) + 1);
  global_var_101 := (Random(7) + 1);
  global_var_152[1] := 0;
  global_var_152[2] := 0;
  global_var_152[3] := 0;
  global_var_101 := 0;
  global_var_89 := 5000;
  global_var_105 := 0;
  Func2;
end;
procedure Func56(Func56_arg_0: real);
var
  Func56_var_312: file_record_13866380471399314824;
  Func56_var_15: arr_record_13866380471399314824_11;
  Func56_var_13: integer;
  Func56_var_11: integer;
  Func56_var_9: integer;
  Func56_var_8: byte;
  Func56_unused_0: arr_byte_8;
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
    Func57_var_26 := Func1;
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
  if (IOResult <> 0) then
  begin
    Rewrite(Func56_var_312);
    Close(Func56_var_312);
  end
  else
  begin
    while (not EOF(Func56_var_312)) do
    begin
      Read(Func56_var_312, Func56_var_15[Func56_var_13]);
      if ((Func56_var_11 = 0) and (Func56_var_15[Func56_var_13].field_21 < Func56_arg_0)) then
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
  begin
    Func56_var_13 := 11;
  end;
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
    GotoXY(11, (3 + (2 * Func56_var_9)));
    Write(Func56_var_15[Func56_var_9].field_21:6:0);
    GotoXY(20, (3 + (2 * Func56_var_9)));
    Write(Func56_var_15[Func56_var_9].field_0:16);
  end;
  if (Func56_var_11 = 0) then
  begin
    global_var_2248 := LoadSgnFile('score');
    PutPic(global_var_2248^, 7, 130);
    GotoXY(3, 10);
    if (Func56_arg_0 > 999) then
    begin
      Write(Func10(Func56_arg_0):6);
    end
    else
    begin
      Write(Func10(Func56_arg_0):4);
    end;
    Dispose(global_var_2248);
  end;
  Func2;
end;
begin
  Func54;
  repeat
  begin
    global_var_79 := 1;
    Func55;
    repeat
    begin
      Func21;
      global_var_79 := Succ(global_var_79);
    end
    until (global_var_79 > 7);
    Func56((global_var_89 + global_var_95));
    GraphColorMode;
    GraphBackground(1);
    Func3(
      78,
      'ןינועמ התא םאה',
      '(ל/כ) ? ףסונ קחשמב',
      ''
    );
    GotoXY(7, 16);
  end
  until (not Func20);
end.
