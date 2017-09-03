module System.Classes;

import delta.core;
import std.utf: toUTFz;

alias TNotifyEvent = void delegate(TObject sender);

void executeNotifyEvent(TObject object, string delphiEventName, void* framePointer, void* fnPointer)
{
	import core.sys.windows.windows;
	alias extern(Windows) void function(int, int) NotifyEventCallback;
	alias extern(Windows) void function(int, char*, int, NotifyEventCallback) Fn;
	
	void delegate(int, int) dg = (int delphiRef, int dRef) {
		TNotifyEvent ne;
		ne.funcptr = cast(void function(TObject)) fnPointer;
		ne.ptr = cast(void*) dRef;
		ne(cast(TObject) cast(void*) dRef);
	};
	
	auto pChar = toUTFz!(char*)(delphiEventName);
	FARPROC fp = GetProcAddress(deltaLibrary.handle, "registerNotifyEvent");
	Fn fn = cast(Fn) fp;
	fn(object.reference, pChar, cast(int) framePointer, bindDelegate(dg));
}

enum TShiftState {ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMidldle, ssDouble, ssTouch, ssPen, ssCommand, ssHorizontal};

class TBasicAction: TComponent
{
	mixin(GenEvent!("OnExecute", TNotifyEvent));
	
	this(int reference)
	{
		super(reference);
	}
}

class TComponent: TPersistent
{
	T opCast(T)() {
        return new T(reference);
    }
	
	TComponent FindComponent(string AName)
	{
		int i = executeInstanceMethodReturnReferenceArgsString(this.reference, "FindComponent", AName);
		return (i == 0) ? null : new TComponent(i);
	}

	this(int reference)
	{
		super(reference);
	}
}

class TStrings: TPersistent
{
	mixin(GenStringProperty!("Text")); 
	
	this(int reference)
	{
		super(reference);
	}
	
	int Add(string value)
	{
		return executeInstanceMethodReturnIntArgsString(this.reference, "Add", value);
	}
	
	int AddObject(string value, TObject aObject)
	{
		return executeInstanceMethodReturnIntArgsStringReference(this.reference, "AddObject", value, aObject.reference);
	}
	
	void Clear()
	{
		executeInstanceMethodReturnNoneArgsNone(this.reference, "Clear");
	}
}

class TStringList: TStrings
{
	this(int reference)
	{
		super(reference);
	}	
}

class TPersistent: TObject
{
	this(int reference)
	{
		super(reference);
	}
}

class TObject
{
	protected int _reference;
	
	@property int reference()
	{
		return _reference;
	}

	T opCast(T)() {
        return new T(reference);
    }
	
	this(int reference)
	{
		_reference = reference;
	}
	
	void DisposeOf()
	{
		executeInstanceMethodReturnNoneArgsNone(this.reference, "DisposeOf");
	}
}

class TCollection: TPersistent
{
	this(int reference)
	{
		super(reference);
	}
	
	TCollectionItem add()
	{
		int i = executeInstanceMethodReturnReferenceArgsNone(this.reference, "Add");
		return new TCollectionItem(i);
	}
}

class TCollectionItem: TPersistent
{
	this(int reference)
	{
		super(reference);
	}
}