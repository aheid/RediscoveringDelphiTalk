program AnonymousMethods3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TIntegerFunc = reference to function(): integer;

  TIntegerFuncImpl = class(TInterfacedObject, TIntegerFunc)
    function Invoke(): integer;
  end;

function TIntegerFuncImpl.Invoke: integer;
begin
  result := 42;
end;

var
  f: TIntegerFunc;
begin
  f := TIntegerFuncImpl.Create();

  WriteLn( f() );

  ReadLn;
end.
