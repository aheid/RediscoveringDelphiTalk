unit Events;

interface

uses
  System.SysUtils, Events.Detail;

type
  Event = record
  {$REGION 'Implementation details'}
  strict private
    FImpl: Events.Detail.IEvent;
  private
    property Impl: Events.Detail.IEvent read FImpl;
  {$ENDREGION}
  public
    class function Create(): Event; static;

    procedure Signal;
    procedure WaitFor(const Timeout: cardinal);

    /// <summary>
    ///  Assign nil to release implementation
    /// </summary>
    class operator Implicit(const Impl: Events.Detail.IEvent): Event;
  end;

implementation

{ Event }

class function Event.Create: Event;
begin
  result := Events.Detail.EventImpl.Create();
end;

class operator Event.Implicit(const Impl: Events.Detail.IEvent): Event;
begin
  result.FImpl := Impl;
end;

procedure Event.Signal;
begin
  Impl.Signal;
end;

procedure Event.WaitFor(const Timeout: cardinal);
begin
  Impl.WaitFor(Timeout);
end;

end.
