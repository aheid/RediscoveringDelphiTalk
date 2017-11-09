program AnonymousMethods2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type TIntegerFunc = reference to function(): integer;

function NewCounter(const Start, Step: integer): TIntegerFunc;
var
  i: integer;
begin
  i := Start;
  result :=
    function(): integer
    begin
      result := i;
      i := i + Step;
    end;
end;

var
  cnt: TIntegerFunc;
  i: integer;
begin
  cnt := NewCounter(100, 3);

  for i := 0 to 9 do
  begin
    WriteLn('i=', i, ' => ', cnt());
  end;

  ReadLn;
end.