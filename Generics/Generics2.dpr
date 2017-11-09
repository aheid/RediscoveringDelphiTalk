program Generics2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  Functional = record
  type
    TBindArg1 = record end;
    TBindArg2 = record end;
  public
    class function Bind<T1, T2, R>(const F: TFunc<T1, T2, R>; const BindArg1: TBindArg1; const Arg2: T2): TFunc<T1, R>; overload; static;
    class function Bind<T1, T2, R>(const F: TFunc<T1, T2, R>; const Arg1: T1; const BindArg2: TBindArg2): TFunc<T2, R>; overload; static;
    class function Bind<T1, T2, R>(const F: TFunc<T1, T2, R>; const Arg1: T1; const Arg2: T2): TFunc<R>; overload; static;
  end;

function _1: Functional.TBindArg1; begin end;
function _2: Functional.TBindArg2; begin end;

{ Functional }

class function Functional.Bind<T1, T2, R>(const F: TFunc<T1, T2, R>; const BindArg1: TBindArg1; const Arg2: T2): TFunc<T1, R>;
begin
  result :=
    function(Arg1: T1): R
    begin
      result := F(Arg1, Arg2);
    end;
end;

class function Functional.Bind<T1, T2, R>(const F: TFunc<T1, T2, R>; const Arg1: T1;
  const BindArg2: TBindArg2): TFunc<T2, R>;
begin
  result :=
    function(Arg2: T2): R
    begin
      result := F(Arg1, Arg2);
    end;
end;

class function Functional.Bind<T1, T2, R>(const F: TFunc<T1, T2, R>; const Arg1: T1;
  const Arg2: T2): TFunc<R>;
begin
  result :=
    function(): R
    begin
      result := F(Arg1, Arg2);
    end;
end;

var
  f: TFunc<boolean, string>;
begin
  f := Functional.Bind<boolean, boolean, string>(BoolToStr, _1, True);

  WriteLn( f(False) );

  ReadLn;
end.
