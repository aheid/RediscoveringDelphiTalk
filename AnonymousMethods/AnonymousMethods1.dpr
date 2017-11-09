program AnonymousMethods1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

var
  i: integer;
  p: TProc; // type TProc = reference to procedure;
begin
  i := 123;

  // variable i will be captured by reference
  p :=
    procedure()
    begin
      WriteLn('i = ', i);
    end;

  i := 42;

  p(); // i = 42

  ReadLn;
end.

