program Generics1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.TypInfo;

type
  TPingTag = record end;
  TDingTag = record end;

  TRec = record
    class procedure Ping<TTag>(); static;
  end;

{ TRec }

class procedure TRec.Ping<TTag>;
begin
  if (TypeInfo(TTag) = TypeInfo(TPingTag)) then
    WriteLn('ping')
  else if (TypeInfo(TTag) = TypeInfo(TDingTag)) then
    WriteLn('ding')
  else
    raise EProgrammerNotFound.CreateFmt('Unknown tag type: %s', [GetTypeName(TypeInfo(TTag))]);
end;

begin
  try
    TRec.Ping<TPingTag>();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  ReadLn;
end.
