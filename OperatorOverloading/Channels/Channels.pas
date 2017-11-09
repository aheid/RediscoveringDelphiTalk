unit Channels;

interface

uses
  System.SysUtils, Channels.Detail;

type
  Channel<T> = record
  {$REGION 'Implementation details'}
  strict private
    FImpl: Channels.Detail.IChannel<T>;
  private
    property Impl: IChannel<T> read FImpl;
  {$ENDREGION}
  public
    class function Create(): Channel<T>; static;

    /// <summary>
    ///  Assign nil to release implementation
    /// </summary>
    class operator Implicit(const Impl: Channels.Detail.IChannel<T>): Channel<T>;

    procedure Close;

    function GetEnumerator(): ChannelEnumerator<T>;

    class operator LessThanOrEqual(const Chan: Channel<T>; const Value: T): boolean; overload;
    class operator LessThanOrEqual(const Chan: Channel<T>; const Values: TArray<T>): boolean; overload;
    class operator LessThanOrEqual(var Value: T; const Chan: Channel<T>): boolean;
    class operator LessThan(const Chan: Channel<T>; const Value: T): boolean;
    class operator LessThan(var Value: T; const Chan: Channel<T>): boolean;
  end;

implementation

{ Channel<T> }

procedure Channel<T>.Close;
begin
  Impl.Close;
end;

class function Channel<T>.Create: Channel<T>;
begin
  result.FImpl := ChannelImpl<T>.Create();
end;

function Channel<T>.GetEnumerator: ChannelEnumerator<T>;
begin
  result := ChannelEnumerator<T>.Create(Impl);
end;

class operator Channel<T>.Implicit(const Impl: IChannel<T>): Channel<T>;
begin
  result.FImpl := Impl;
end;

class operator Channel<T>.LessThanOrEqual(const Chan: Channel<T>;
  const Values: TArray<T>): boolean;
var
  value: T;
begin
  for value in Values do
  begin
    result := Chan.Impl.Send(value);
    if (not result) then
      exit;
  end;
end;

class operator Channel<T>.LessThanOrEqual(const Chan: Channel<T>;
  const Value: T): boolean;
begin
  result := Chan.Impl.Send(Value);
end;

class operator Channel<T>.LessThan(const Chan: Channel<T>;
  const Value: T): boolean;
begin
  result := Chan.Impl.TrySend(Value);
end;

class operator Channel<T>.LessThan(var Value: T;
  const Chan: Channel<T>): boolean;
begin
  result := Chan.Impl.TryRecv(Value);
end;

class operator Channel<T>.LessThanOrEqual(var Value: T;
  const Chan: Channel<T>): boolean;
begin
  result := Chan.Impl.Recv(Value);
end;


end.
