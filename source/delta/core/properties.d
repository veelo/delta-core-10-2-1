module delta.core.properties;

import core.sys.windows.windows;
import core.sys.windows.wtypes: BSTR;
import std.utf: toUTFz, encode;
import std.conv: to;
import std.algorithm: each;

import delta.core.dll;
import System.Classes: TObject;

template GenBoolProperty(string name, bool read = true, bool write = true)
{
    static if(read && write)
	{
		const char[] GenBoolProperty = 
		`@property void `~name~`(bool value) {
			setPropertyBool(_reference, "`~name~`", value);
		}`;
	}
}

template GenFloatProperty(string name, bool read = true, bool write = true)
{
    static if(read && write)
	{
		const char[] GenFloatProperty = 
		`@property void `~name~`(float value) {
			setPropertyFloat(_reference, "`~name~`", value);
		}
		
		@property float `~name~`() {
			return getPropertyFloat(_reference, "`~name~`");
		}
		`;
	}
}

template GenShortProperty(string name, bool read = true, bool write = true)
{
    static if(read && write)
	{
		const char[] GenShortProperty = 
		`@property void `~name~`(short value) {
			setPropertyShort(_reference, "`~name~`", value);
		}
		
		@property short `~name~`() {
			return getPropertyShort(_reference, "`~name~`");
		}
		`;
	}
}

template GenIntProperty(string name, bool read = true, bool write = true)
{
    static if(read && write)
	{
		const char[] GenIntProperty = 
		`@property void `~name~`(int value) {
			setPropertyInt(_reference, "`~name~`", value);
		}
		
		@property int `~name~`() {
			return getPropertyInt(_reference, "`~name~`");
		}
		`;
	}
}

template GenUIntProperty(string name, bool read = true, bool write = true)
{
    static if(read && write)
	{
		const char[] GenUIntProperty = 
		`@property void `~name~`(uint value) {
			setPropertyUInt(_reference, "`~name~`", value);
		}
		
		@property uint `~name~`() {
			return getPropertyUInt(_reference, "`~name~`");
		}
		`;
	}
}

template GenStringProperty(string name, bool read = true, bool write = true)
{
    static if(read && write)
	{
		const char[] GenStringProperty = 
		`@property void `~name~`(string value) {
			setPropertyString(_reference, "`~name~`", value);
		}
		
		@property string `~name~`() {
			return getPropertyString(_reference, "`~name~`");
		}
		`;
	}
}

template GenEnumProperty(string name, alias EnumType, bool read = true, bool write = true)
{
    import std.traits:fullyQualifiedName;
	
	static if(read && write)
	{
		// Generate getter first because of return type trait
		
		const char[] GenEnumProperty = 
		`
		@property `~fullyQualifiedName!EnumType~` `~name~`() {
			import std.conv:to;
			string s = getPropertyEnum(_reference, "`~name~`");
			return s.to!(`~fullyQualifiedName!EnumType~`);
		}
		
		@property void `~name~`(`~fullyQualifiedName!EnumType~` value)
		{
			import std.conv:to;
			setPropertyEnum(_reference, "`~name~`", value.to!string);
		}
		`;
	}
}

template GenSetProperty(string name, alias SetType, bool read = true, bool write = true)
{
    import std.traits:fullyQualifiedName;
	
	static if(read && write)
	{
		const char[] GenSetProperty = 
		`
		// TODO
		@property void `~name~`(`~fullyQualifiedName!SetType~`[] value)
		{
			import std.conv:to;
			//setPropertyEnum(_reference, "`~name~`", value.to!string);
		}
		
		@property `~fullyQualifiedName!SetType~`[] `~name~`() {
			import std.conv:to;
			//string s = getPropertyEnum(_reference, "`~name~`");
			//return s.to!(`~fullyQualifiedName!SetType~`);
			return [];
		}
		`;
	}
}

template GenObjectProperty(string name, alias classType, bool read = true, bool write = true)
{
    static if(read && write)
	{
		import std.traits:fullyQualifiedName;
		enum className = fullyQualifiedName!classType;
		
		const char[] GenObjectProperty = 
		`
		private `~className~` _`~name~`;

		@property `~className~` `~name~`() 
		{
			int r = cast(int) cast(void*) getPropertyReference(_reference, "`~name~`");
			
			if(r == 0)
			{
				_`~name~` = null;
			}
			else if (_`~name~` is null || _`~name~`.reference != r)
			{
				_`~name~` = new `~className~`(r);
			}
			return _`~name~`;
		}
		
		@property void `~name~`(`~className~` value) 
		{
			if (value is null) 
			{
				setPropertyReference(_reference, "`~name~`", 0);
			}
			else
			{
				
				setPropertyReference(_reference, "`~name~`", value.reference);
			}
			_`~name~` = value;
			
		}
		`;
	}
}

struct IntegerArrayProperty(BaseType)
{
	private TObject _obj;
	private string _propertyName;
	
	this(TObject obj, string propertyName) 
	{ 
		_obj = obj; 
		_propertyName = propertyName;
	}
	
	BaseType opIndex(int index)
	{ 
		int r = getIntegerIndexedPropertyReference(_obj.reference, _propertyName, index);
		return new BaseType(r); 
	}
}

template GenIntegerIndexedProperty(string name, alias ArrayType)
{
	const char[] GenIntegerIndexedProperty = 
	`
	
	@property IntegerArrayProperty!`~ArrayType.stringof~` `~name~`()
	{
		return IntegerArrayProperty!`~ArrayType.stringof~`(this, "`~name~`");
	}`;
}

void setPropertyReference(int reference1, string name, int value)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertyReference");
	alias extern(Windows) void function(int, char*, int) FN;
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

int getPropertyReference(int reference, string name)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertyReference");
	alias extern(Windows) int function(int, char*) FN;
	auto fn = cast(FN) fp;
	return fn(reference, pChar);
}

int getIntegerIndexedPropertyReference(int reference, string name, int index)
{
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getIntegerIndexedPropertyReference");
	alias extern(Windows) int function(int, char*, int) FN;
	auto fn = cast(FN) fp;
	return fn(reference, pChar, index);
}

void setPropertyShort(int reference, string name, short value)
{
	alias extern(Windows) void function(int, char*, short) FN;
	
	auto pChar = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertySmallInt");
	auto fn = cast(FN) fp;
	fn(reference, pChar, value);
}

short getPropertyShort(int reference1, string name)
{
	alias extern(Windows) short function(int, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertySmallInt");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyInt(int reference, string name, int value)
{
	alias extern(Windows) void function(int, char*, int) FN;
	auto pChar = toUTFz!(char*)(name);

	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertyInteger");
	auto fn = cast(FN) fp;
	fn(reference, pChar, value);
}

int getPropertyInt(int reference1, string name)
{
	alias extern(Windows) int function(int, char*) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertyInteger");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyUInt(int reference1, string name, uint value)
{
	alias extern(Windows) void function(int, char*, int) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertyCardinal");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

uint getPropertyUInt(int reference1, string name)
{
	alias extern(Windows) uint function(int, char*) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertyCardinal");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyEnum(int reference, string name, string value)
{
	alias extern(Windows) void function(int, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertyEnum");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, pCharValue);
}

string getPropertyEnum(int reference, string name)
{
	alias extern(Windows) void function(int, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertyEnum");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}

void setPropertySet(int reference, string name, string value)
{
	alias extern(Windows) void function(int, char*, char*) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertySet");
	auto fn = cast(FN) fp;
	fn(reference, pCharName, pCharValue);
}

void setPropertyBool(int reference1, string name, bool value)
{
	alias extern(Windows) void function(int, char*, bool) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertyBoolean");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

void setPropertyFloat(int reference1, string name, float value)
{
	alias extern(Windows) void function(int, char*, float) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertySingle");
	auto fn = cast(FN) fp;
	fn(reference1, pChar, value);
}

float getPropertyFloat(int reference1, string name)
{
	alias extern(Windows) float function(int, char*) FN;
	
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertySingle");
	auto fn = cast(FN) fp;
	return fn(reference1, pChar);
}

void setPropertyString(int reference1, string name, string value)
{
	alias extern(Windows) void function(int, char*, BSTR) FN;
	auto pCharName = toUTFz!(char*)(name);
	auto pCharValue = toUTFz!(char*)(value);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "setPropertyString");
	auto fn = cast(FN) fp;
	
	wchar[] ws;
	value.each!(c => encode(ws, c));
	BSTR bStr = SysAllocStringLen(ws.ptr, cast(UINT) ws.length);
	
	fn(reference1, pCharName, bStr);
	SysFreeString(bStr);
}

string getPropertyString(int reference, string name)
{
	alias extern(Windows) void function(int, char*, out BSTR) FN;
	auto pChar = toUTFz!(char*)(name);
	
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "getPropertyString");
	auto fn = cast(FN) fp;
	
	BSTR bStr;
	fn(reference, pChar, bStr);
	
	string s = to!string(bStr[0 .. SysStringLen(bStr)]);
	SysFreeString(bStr);
	
	return s;
}