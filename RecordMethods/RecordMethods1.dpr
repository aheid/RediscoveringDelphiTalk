program RecordMethods1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TRec = record
  strict private
    FData: string;
  public
    class function Create(const Data: string): TRec; static;

    procedure AppendData(const NewData: string);

    property Data: string read FData;
  end;

{ TRec }

procedure TRec.AppendData(const NewData: string);
begin
  FData := FData + NewData;
end;

class function TRec.Create(const Data: string): TRec;
begin
  result.FData := Data;
end;

var
  r: TRec;
begin
  r := TRec.Create('foo');
  r.AppendData('bar');

  WriteLn(r.Data);

  ReadLn;
end.
