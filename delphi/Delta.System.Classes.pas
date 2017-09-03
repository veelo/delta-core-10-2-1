unit Delta.System.Classes;

interface

uses System.Classes, System.SysUtils, System.UITypes, System.TypInfo,
  System.rtti;

type
  TNotifyEventCallBack = procedure(Reference: Integer;
    DReference, DFuncPointer: Integer); stdcall;

procedure registerNotifyEvent(Reference: Integer; AName: PAnsiChar;
  DReference, DFuncPointer: Integer; CallBack: TNotifyEventCallBack); stdcall;

type
  TNotifyEventWrapper = class(TComponent)
  private
    FCallBack: TNotifyEventCallBack;
    FDReference: Integer;
    FDFuncPointer: Integer;
  public
    constructor Create(Owner: TComponent; DReference, DFuncPointer: Integer;
      CallBack: TNotifyEventCallBack); reintroduce;
  published
    procedure Event(Sender: TObject);
  end;

exports registerNotifyEvent;

implementation

uses Delta.Properties;

procedure registerNotifyEvent(Reference: Integer; AName: PAnsiChar;
  DReference, DFuncPointer: Integer; CallBack: TNotifyEventCallBack); stdcall;
var
  nEvent: TNotifyEvent;
  component: TComponent;
begin
  if Assigned(CallBack) then
  begin
    try
      component := TComponent(Reference);
      nEvent := TNotifyEventWrapper.Create(component, DReference, DFuncPointer,
        CallBack).Event;
      setPropertyValue(Reference, string(AName),
        TValue.From<TNotifyEvent>(nEvent));
    except
    end;
  end
  else
  begin
    setPropertyValue(Reference, string(AName), nil);
  end;
end;

{ TNotifyEventWrapper }

constructor TNotifyEventWrapper.Create(Owner: TComponent;
  DReference, DFuncPointer: Integer; CallBack: TNotifyEventCallBack);
begin
  inherited Create(Owner);
  FCallBack := CallBack;
  FDReference := DReference;
  FDFuncPointer := DFuncPointer;
end;

procedure TNotifyEventWrapper.Event(Sender: TObject);
begin
  FCallBack(Integer(Sender), FDReference, FDFuncPointer);
end;

end.
