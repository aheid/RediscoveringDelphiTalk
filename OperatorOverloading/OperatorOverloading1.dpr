program OperatorOverloading1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Variants;

type
  Reference<T> = record
  strict private
    type Ptr = ^T;
  strict private
    FPtr: Ptr;
  private
    function GetValue: T;
    procedure SetValue(const Value: T);
  public
    class operator Implicit(var v: T): Reference<T>;

    property Value: T read GetValue write SetValue;
  end;

{ Reference<T> }

function Reference<T>.GetValue: T;
begin
  result := FPtr^;
end;

class operator Reference<T>.Implicit(var v: T): Reference<T>;
begin
  result.FPtr := @v;
end;

procedure Reference<T>.SetValue(const Value: T);
begin
  FPtr^ := Value;
end;


function Sql(const SqlStatement: string; const QueryResults: TArray<Reference<Variant>>): boolean;
begin
  // run actual query here
  QueryResults[0].Value := 42;
  QueryResults[1].Value := 'foo';
  result := True;
end;


var
  id, name: variant;
begin
  Sql('select id, name from table', [id, name]);

  WriteLn( VarToStr(id) );
  WriteLn( VarToStr(name) );

  ReadLn;
end.
