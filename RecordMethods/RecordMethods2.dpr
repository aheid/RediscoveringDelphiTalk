program RecordMethods2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TImplBase = class;
  TImpl = class of TImplBase;

  TRec = record
  strict private
    FValue: integer;
    FImpl: TImpl;
  public
    class function Create(const Value: integer; const Impl: TImpl): TRec; static;

    procedure Print;
  end;

  TImplBase = class
  public
    class function GetString(const Value: integer): string; virtual; abstract;
  end;

  TDing = class(TImplBase)
  public
    class function GetString(const Value: integer): string; override;
  end;

function NewDingRec(const Value: integer): TRec;
begin
  result := TRec.Create(Value, TDing);
end;

{ TRec }

class function TRec.Create(const Value: integer; const Impl: TImpl): TRec;
begin
  result.FValue := Value;
  result.FImpl := Impl;
end;

procedure TRec.Print;
begin
  WriteLn(FImpl.GetString(FValue));
end;

{ TDing }

class function TDing.GetString(const Value: integer): string;
var
  i: Integer;
begin
  result := '';
  for i := 0 to Value-1 do
    result := result.Trim + ' ding';
end;

var
  r: TRec;
begin
  r := NewDingRec(3);
  r.Print;

  ReadLn;
end.
