program WinShell;

{$mode fpc}{$H+}

uses SysUtils;

const
  space_cnt: integer = 0;

var
  sys_file: Text;
  bak_file: Text;
  S: String;
  mode: String;

BEGIN
  if ParamCount() > 0 then Begin
    if FileExists('C:' + '\WINDOWS\SYSTEM.INI') then Begin
      mode := ParamStr(1);
      Assign(sys_file, 'C:' + '\WINDOWS\SYSTEM.INI');
      Assign(bak_file, 'C:' + '\WINDOWS\SYSTEM.BAK');

      if mode = 'get' then Begin
        Reset(sys_file);
        While not Eof(sys_file) do Begin
          ReadLn(sys_file, S);
          if LowerCase(Copy(S, 1 + space_cnt, 6)) = 'shell=' then
              WriteLn(S)
        End;
        Close(sys_file);
      End;

      if (mode = 'backup') or (mode = 'setnbackup') or (mode = 'set') then Begin
        Reset(sys_file);
        ReWrite(bak_file);
        While not Eof(sys_file) do Begin
          ReadLn(sys_file, S);
          WriteLn(bak_file, S);
        End;
        Close(sys_file);
        Close(bak_file);

        if (mode = 'set') or (mode = 'setnbackup') then Begin
          Reset(bak_file);
          ReWrite(sys_file);
          While not Eof(bak_file) do Begin
            ReadLn(bak_file, S);
            //While S[space_cnt + 1] = ' ' do Begin
            //  space_cnt := space_cnt + 1;
            //End;
            if LowerCase(Copy(S, 1 + space_cnt, 6)) = 'shell=' then
              WriteLn(sys_file, Copy(S, 1, 6 + space_cnt) + ParamStr(2))
            Else
              WriteLn(sys_file, S);
          End;
          Close(sys_file);
          Close(bak_file);
        End;
      End;

      if mode = 'restore' then Begin
        Reset(bak_file);
        ReWrite(sys_file);
        While not Eof(bak_file) do Begin
          ReadLn(bak_file, S);
          WriteLn(sys_file, S);
        End;
        Close(sys_file);
        Close(bak_file);
      End;

      if (mode = 'set') or (mode = 'restore') or (mode = 'delbackup') then
        Erase(bak_file);

    End Else WriteLn('Error: SYSTEM.INI not found');

  End Else Begin
    WriteLn('cmds: get, set, setnbackup, backup, restore, delbackup');
  End;
END.