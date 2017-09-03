unit Delta.Properties;

interface

uses System.SysUtils, System.Classes, System.rtti, System.TypInfo,
  Delta.System.Classes, fmx.forms;

procedure setPropertyValue(const Reference: Integer; const AName: string;
  const value: TValue);

function getPropertyReference(const Reference: Integer; const AName: PAnsiChar)
  : Integer; stdcall;

procedure setPropertyReference(const Reference: Integer; const AName: PAnsiChar;
  const value: Integer); stdcall;

procedure setPropertyBoolean(const Reference: Integer; const AName: PAnsiChar;
  const value: Boolean); stdcall;

procedure setPropertySmallInt(const Reference: Integer; const AName: PAnsiChar;
  const value: SmallInt); stdcall;

function getPropertySmallInt(const Reference: Integer; const AName: PAnsiChar)
  : SmallInt; stdcall;

procedure setPropertyInteger(const Reference: Integer; const AName: PAnsiChar;
  const value: Integer); stdcall;

function getPropertyInteger(const Reference: Integer; const AName: PAnsiChar)
  : Integer; stdcall;

procedure setPropertyCardinal(const Reference: Integer; const AName: PAnsiChar;
  const value: Cardinal); stdcall;

function getPropertyCardinal(const Reference: Integer; const AName: PAnsiChar)
  : Cardinal; stdcall;

procedure setPropertySingle(const Reference: Integer; const AName: PAnsiChar;
  const value: Single); stdcall;

function getPropertySingle(const Reference: Integer; const AName: PAnsiChar)
  : Single; stdcall;

procedure setPropertyString(const Reference: Integer; const AName: PAnsiChar;
  const value: WideString); stdcall;

procedure getPropertyString(const Reference: Integer; const AName: PAnsiChar;
  out value: WideString); stdcall;

procedure setPropertyEnum(const Reference: Integer; const AName: PAnsiChar;
  const value: PAnsiChar); stdcall;

procedure getPropertyEnum(const Reference: Integer; const AName: PAnsiChar;
  out value: WideString); stdcall;

procedure setPropertySet(const Reference: Integer; const AName: PAnsiChar;
  const value: PAnsiChar); stdcall;

function getIntegerIndexedPropertyReference(const Reference: Integer;
  const AName: PAnsiChar; const Index: Integer): Integer; stdcall;

exports setPropertyEnum, getPropertyEnum, setPropertySet, setPropertyReference,
  setPropertySmallInt, getPropertySmallInt, setPropertyInteger,
  setPropertyBoolean, setPropertyString, setPropertySingle, getPropertySingle,
  setPropertyCardinal, getPropertyReference, getPropertyInteger,
  getPropertyCardinal, getPropertyString, getIntegerIndexedPropertyReference;

implementation

procedure setPropertyValue(const Reference: Integer; const AName: string;
  const value: TValue);
var
  context: TRttiContext;
  rttiType: TRttiType;
  prop: TRttiProperty;
  obj: TObject;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      rttiType := (context.GetType(obj.ClassType));
      prop := rttiType.GetProperty(AName);
      prop.SetValue(obj, value);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

function getPropertyValue(const Reference: Integer;
  const AName: string): TValue;
var
  context: TRttiContext;
  rttiType: TRttiType;
  prop: TRttiProperty;
  obj: TObject;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      rttiType := (context.GetType(obj.ClassType));
      prop := rttiType.GetProperty(AName);
      result := prop.getValue(obj);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

function getIndexedPropertyValue(const Reference: Integer; const AName: string;
  const Index: Integer): TValue;
var
  context: TRttiContext;
  rttiType: TRttiType;
  prop: TRttiIndexedProperty;
  obj: TObject;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      rttiType := (context.GetType(obj.ClassType));
      prop := rttiType.GetIndexedProperty(AName);
      result := prop.getValue(obj, [Index])
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

procedure setPropertySmallInt(const Reference: Integer; const AName: PAnsiChar;
  const value: SmallInt); stdcall;
begin
  setPropertyValue(Reference, string(AName), value);
end;

function getPropertySmallInt(const Reference: Integer; const AName: PAnsiChar)
  : SmallInt; stdcall;
begin
  result := getPropertyValue(Reference, string(AName)).AsType<SmallInt>;
end;

procedure setPropertyInteger(const Reference: Integer; const AName: PAnsiChar;
  const value: Integer); stdcall;
begin
  setPropertyValue(Reference, string(AName), value);
end;

function getPropertyInteger(const Reference: Integer; const AName: PAnsiChar)
  : Integer; stdcall;
begin
  result := getPropertyValue(Reference, string(AName)).AsInteger;
end;

procedure setPropertyBoolean(const Reference: Integer; const AName: PAnsiChar;
  const value: Boolean); stdcall;
begin
  setPropertyValue(Reference, string(AName), value);
end;

procedure setPropertySingle(const Reference: Integer; const AName: PAnsiChar;
  const value: Single); stdcall;
begin
  setPropertyValue(Reference, string(AName), value);
end;

function getPropertySingle(const Reference: Integer; const AName: PAnsiChar)
  : Single; stdcall;
begin
  result := getPropertyValue(Reference, string(AName)).AsType<Single>;
end;

procedure setPropertyCardinal(const Reference: Integer; const AName: PAnsiChar;
  const value: Cardinal); stdcall;
begin
  setPropertyValue(Reference, string(AName), value);
end;

function getPropertyCardinal(const Reference: Integer; const AName: PAnsiChar)
  : Cardinal; stdcall;
begin
  result := getPropertyValue(Reference, string(AName)).AsType<Cardinal>;
end;

procedure setPropertyString(const Reference: Integer; const AName: PAnsiChar;
  const value: WideString); stdcall;
begin
  setPropertyValue(Reference, string(AName), string(value));
end;

procedure getPropertyString(const Reference: Integer; const AName: PAnsiChar;
  out value: WideString); stdcall;
var
  s: String;
begin
  s := getPropertyValue(Reference, string(AName)).AsString;
  value := s;
end;

procedure setPropertyEnum(const Reference: Integer; const AName: PAnsiChar;
  const value: PAnsiChar); stdcall;
var
  context: TRttiContext;
  rttiType: TRttiType;
  prop: TRttiProperty;
  obj: TObject;
  v: TValue;
  I: Integer;
begin
  context := TRttiContext.Create;
  try
    obj := TObject(Reference);
    rttiType := (context.GetType(obj.ClassType));
    prop := rttiType.GetProperty(string(AName));
    I := GetEnumValue(prop.PropertyType.Handle, string(value));
    TValue.Make(I, prop.PropertyType.Handle, v);
    prop.SetValue(obj, v);
  finally
    context.Free;
  end;
end;

procedure getPropertyEnum(const Reference: Integer; const AName: PAnsiChar;
  out value: WideString); stdcall;
var
  s: String;
begin
  s := getPropertyValue(Reference, string(AName)).AsString;
  value := s;
end;

procedure setPropertySet(const Reference: Integer; const AName: PAnsiChar;
  const value: PAnsiChar); stdcall;
var
  context: TRttiContext;
  rttiType: TRttiType;
  prop: TRttiProperty;
  obj: TObject;
  v: TValue;
  I: Integer;
begin
  context := TRttiContext.Create;
  try
    obj := TObject(Reference);
    rttiType := (context.GetType(obj.ClassType));
    prop := rttiType.GetProperty(string(AName));
    I := StringToSet(prop.PropertyType.Handle, string(value));
    TValue.Make(I, prop.PropertyType.Handle, v);
    prop.SetValue(obj, v);
  finally
    context.Free;
  end;
end;

procedure setPropertyReference(const Reference: Integer; const AName: PAnsiChar;
  const value: Integer); stdcall;
var
  obj: TObject;
begin
  if value = -1 then
    obj := nil
  else
    obj := TObject(value);
  setPropertyValue(Reference, string(AName), obj);
end;

function getPropertyReference(const Reference: Integer; const AName: PAnsiChar)
  : Integer; stdcall;
begin
  result := Integer(getPropertyValue(Reference, string(AName)).AsObject);
end;

function getIntegerIndexedPropertyReference(const Reference: Integer;
  const AName: PAnsiChar; const Index: Integer): Integer; stdcall;
begin
  result := Integer(getIndexedPropertyValue(Reference, string(AName), Index)
    .AsObject);
end;

end.
